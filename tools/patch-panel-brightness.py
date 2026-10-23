#!/usr/bin/env python3
"""Patch the spinel panel driver to preserve requested recovery brightness."""

import hashlib
import pathlib
import sys

EXPECTED_SIZE = 361_512

EXPECTED_ORIGINAL_SHA256 = (
    "2050396b02144a7b8a1444dfbf97cba278139e2dfdf67caa6bebe40e9fa6bb99"
)

EXPECTED_PATCHED_SHA256 = (
    "1129f0c05b1525094ba94da46cae2f90bcad80c27188ba83e340ade461256907"
)

# File offset of the instruction inside this exact panel module.
FILE_OFFSET = 0x466D4

# mov w19, #0x133 (307) -> nop
ORIGINAL_INSTRUCTION = bytes.fromhex("73 26 80 52")
PATCHED_INSTRUCTION = bytes.fromhex("1f 20 03 d5")


def sha256(data: bytes) -> str:
    return hashlib.sha256(data).hexdigest()


def main() -> int:
    if len(sys.argv) != 3:
        print(
            f"Usage: {sys.argv[0]} ORIGINAL_MODULE OUTPUT_MODULE",
            file=sys.stderr,
        )
        return 2

    source = pathlib.Path(sys.argv[1]).resolve()
    destination = pathlib.Path(sys.argv[2]).resolve()

    if source == destination:
        print("ERROR: output must not overwrite the original.", file=sys.stderr)
        return 2

    try:
        data = bytearray(source.read_bytes())
    except OSError as exc:
        print(f"ERROR: cannot read original module: {exc}", file=sys.stderr)
        return 1

    original_hash = sha256(data)

    if len(data) != EXPECTED_SIZE or original_hash != EXPECTED_ORIGINAL_SHA256:
        print("ERROR: unexpected original panel module.", file=sys.stderr)
        print(f"Size:   {len(data)} bytes", file=sys.stderr)
        print(f"SHA256: {original_hash}", file=sys.stderr)
        print("No patch was applied.", file=sys.stderr)
        return 1

    actual_instruction = bytes(data[FILE_OFFSET:FILE_OFFSET + 4])

    if actual_instruction != ORIGINAL_INSTRUCTION:
        print(
            f"ERROR: unexpected instruction at 0x{FILE_OFFSET:x}: "
            f"{actual_instruction.hex(' ')}",
            file=sys.stderr,
        )
        print("No patch was applied.", file=sys.stderr)
        return 1

    data[FILE_OFFSET:FILE_OFFSET + 4] = PATCHED_INSTRUCTION
    patched_hash = sha256(data)

    if patched_hash != EXPECTED_PATCHED_SHA256:
        print("ERROR: patched output hash does not match.", file=sys.stderr)
        print(f"SHA256: {patched_hash}", file=sys.stderr)
        return 1

    try:
        destination.parent.mkdir(parents=True, exist_ok=True)
        destination.write_bytes(data)
    except OSError as exc:
        print(f"ERROR: cannot write patched module: {exc}", file=sys.stderr)
        return 1

    print(f"Original module: {source}")
    print(f"Patched module:  {destination}")
    print(f"Original SHA256: {original_hash}")
    print(f"Patched SHA256:  {patched_hash}")
    print(f"Patched instruction at file offset 0x{FILE_OFFSET:x}.")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
