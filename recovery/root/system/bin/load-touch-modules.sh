#!/sbin/sh

set +e

mod_dir="/vendor_dlkm/lib/modules"
modules=(
    "scp.ko"
    "xiaomi_touch.ko"
    "gt9916k.ko"
)

mount /vendor_dlkm
for module in "${modules[@]}"; do
    insmod "${mod_dir}/${module}"
done

setprop vendor.all.modules.ready 1

umount /vendor_dlkm
