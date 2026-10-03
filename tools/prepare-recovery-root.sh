#!/bin/bash
# ============================================================================
# prepare-recovery-root.sh - OrangeFox BOARD_RECOVERY_IMAGE_PREPARE hook (spinel)
# ============================================================================
set -e

ramdisk="$1"
phase="$2"
terminfo="$ramdisk/system/etc/terminfo"

if [ "$phase" != "--first-call" ]; then
    exit 0
fi

product_out="$(dirname "$(dirname "$ramdisk")")"
minuitwrp_src="$product_out/system/lib64/libminuitwrp.so"
minuitwrp_dst="$ramdisk/system/lib64/libminuitwrp.so"
if [ -f "$minuitwrp_src" ]; then
    echo "-- Refreshing recovery libminuitwrp.so from current build output"
    cp -fp "$minuitwrp_src" "$minuitwrp_dst"
fi

# 1. Conservar ÚNICAMENTE los módulos táctiles de spinel
if [ -d "$ramdisk/lib/modules" ]; then
    find "$ramdisk/lib/modules" -maxdepth 1 -type f -name '*.ko' -print0 |
        while IFS= read -r -d '' module; do
            case "$(basename "$module")" in
                xiaomi_touch.ko|gt9916k.ko)
                    ;;
                *)
                    rm -f "$module"
                    ;;
            esac
        done
fi

# 2. Mantener únicamente la fuente MiSans / Noto
if [ -d "$ramdisk/twres/fonts" ]; then
    find "$ramdisk/twres" -type f -name '*.xml' -print0 |
        xargs -0 sed -Ei 's/filename="[^"]+\.(ttf|otf|ttc)"/filename="MiSans.ttf"/g'
    find "$ramdisk/twres/fonts" -maxdepth 1 -type f \
        ! -iname 'MiSans.ttf' \
        ! -iname '*Noto*.ttf' \
        ! -iname '*Noto*.otf' \
        ! -iname '*Noto*.ttc' \
        -delete
fi

# 3. Eliminar servicios de diagnóstico/lpdump innecesarios
rm -f \
    "$ramdisk/system/bin/lpdump" \
    "$ramdisk/system/bin/lpdumpd" \
    "$ramdisk/system/etc/init/lpdumpd.rc" \
    "$ramdisk/system/lib64/liblpdump.so" \
    "$ramdisk/system/lib64/liblpdump_interface-cpp.so" \
    "$ramdisk/system/lib64/libprotobuf-cpp-full.so" \
    "$ramdisk/system/lib64/libsnapshot.so"

# 4. Remover secciones de depuración .gnu_debugdata de todos los ELF
objcopy_bin="prebuilts/clang/host/linux-x86/clang-r510928/bin/llvm-objcopy"
readelf_bin="prebuilts/clang/host/linux-x86/clang-r510928/bin/llvm-readelf"
if [ ! -x "$objcopy_bin" ] || [ ! -x "$readelf_bin" ]; then
    echo "missing LLVM ELF tools" >&2
    exit 1
fi
while IFS= read -r -d '' binary; do
    if file "$binary" | grep -q ELF && \
            "$readelf_bin" -SW "$binary" 2>/dev/null | grep -q '\.gnu_debugdata'; then
        "$objcopy_bin" --remove-section=.gnu_debugdata "$binary"
    fi
done < <(find "$ramdisk/system" -type f -print0)

# 5. Comprimir con UPX los binarios presentes en el árbol de spinel
upx_bin="vendor/recovery/tools/upx"
if [ ! -x "$upx_bin" ]; then
    echo "missing UPX: $upx_bin" >&2
    exit 1
fi

upx_binaries=(
    avbctl awk bc bootctl bu charger dump_image e2fsck
    e2fsdroid erase_image exfat-fuse fastbootd fatlabel flash_image fsck.exfat
    fsck.f2fs fsck.fat grep keystore2 logcat
    logd lzma make_f2fs minadbd mke2fs mkexfatfs mkfs.fat nano
    pigz reboot recovery resetprop resize2fs
    sgdisk simg2img sload_f2fs tune2fs twrp vold_prepare_subdirs
    watchdogd ziptool
)

for name in "${upx_binaries[@]}"; do
    binary="$ramdisk/system/bin/$name"
    if [ ! -f "$binary" ]; then
        echo "missing selected UPX binary: $binary" >&2
        exit 1
    fi
    chmod 0755 "$binary"
    "$upx_bin" -q --lzma "$binary" >/dev/null
    "$upx_bin" -q -t "$binary" >/dev/null
done

# 6. Mover duplicados de /sbin a /system/bin y enlazarlos
while IFS= read -r -d '' source; do
    name="$(basename "$source")"
    target="$ramdisk/system/bin/$name"
    if [ "$name" = nano ] && [ -f "$target" ]; then
        rm -f "$source"
    else
        rm -f "$target"
        mv "$source" "$target"
    fi
    ln -s "/system/bin/$name" "$source"
done < <(find "$ramdisk/sbin" -maxdepth 1 -type f -print0)

# 7. Reducir terminfo
if [ -d "$terminfo" ]; then
    keep_dir=$(mktemp -d)
    trap 'rm -rf "$keep_dir"' EXIT

    for entry in a/ansi l/linux v/vt100 x/xterm x/xterm-256color; do
        if [ -f "$terminfo/$entry" ]; then
            mkdir -p "$keep_dir/$(dirname "$entry")"
            cp -p "$terminfo/$entry" "$keep_dir/$entry"
        fi
    done

    rm -rf "$terminfo"
    mv "$keep_dir" "$terminfo"
    trap - EXIT
fi

rm -f "$ramdisk/ramdisk-files.txt" "$ramdisk/ramdisk-files.sha256sum"
