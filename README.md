# Xiaomi Redmi Note 15 4G (`spinel`) — Device Tree

**English** | [Español](README.es.md)

## Recovery Status

The recovery is functional and has been tested on the target device.

| Feature | Status |
|---|---|
| Recovery boot | Working |
| ADB | Working |
| Data decryption | Working |
| MTP | Needs Improvement |
| Display brightness control | Working |
| USB OTG | Not tested |

## Notable Fixes

## Display Brightness Fix

The stock panel driver forced the requested brightness level to `307` when running in recovery mode.

The issue was identified in `lcm_setbacklight_cmdq()` in the following panel module:

`panel-p7-41-02-0b-dsc-vdo.ko`

A binary patch replaces the instruction that assigns the fixed brightness value with an AArch64 `NOP` instruction, allowing the requested brightness level to be preserved.

The analysis and implementation of this patch were carried out with AI assistance.

### Build Integration

The patch is generated automatically during the build process. The original panel module is extracted from `prebuilt/stock_vendor_ramdisk.cpio.lz4` and patched by:

- `tools/patch-panel-brightness.py` — applies and validates the binary patch.
- `tools/prepare-platform-ramdisk.sh` — integrates the patched module into the generated platform ramdisk.
- `tools/build-system-compatible-vendor-boot.sh` — builds the custom `vendor_boot` v4 image.

The patching script validates the original module's SHA-256, the instruction bytes at the expected offset, and the resulting module's SHA-256. The build stops if these checks fail.

The patched module has been tested on the Xiaomi Redmi Note 15 4G (`spinel`), and display brightness adjustment works in OrangeFox.

**Note:** The patch targets a specific version of the proprietary panel module. A different firmware version may require a new analysis and patch.

## Disclaimer

This is an unofficial recovery. Use it at your own risk.
Always verify device and firmware compatibility before flashing.
