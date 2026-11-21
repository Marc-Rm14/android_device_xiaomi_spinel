# OrangeFox R12.0 Unofficial - Redmi Note 15 4G (`spinel` / Helio G100)

## Device Information

| Property | Value |
| :--- | :--- |
| **Model** | Redmi Note 15 4G |
| **Codename** | `spinel` |
| **SoC** | MediaTek Helio G100 |
| **Status** | Stable |

## Features & Status

### Working
* **Decryption:** Full `/data` decryption support.
* **Security:** AVB 2.0 verified.
* **Connectivity:** ADB and MTP working.
* **Display:** Working display drivers with patched panel brightness modules.
* **Touchscreen:** Preserved stock touch modules (`xiaomi_touch.ko`, `gt9916k.ko`).

### TODO / Known Issues
* Refine ADB/MTP USB triggers in future iterations.

## Build Process

Run the following scripts sequentially from the root directory:

1. **Prepare platform ramdisk**
   ```bash
   ./tools/prepare-platform-ramdisk.sh
   ```

2. **Patch panel brightness module**
   ```bash
   python3 tools/patch-panel-brightness.py
   ```

3. **Prepare recovery root**
   ```bash
   ./tools/prepare-recovery-root.sh
   ```

4. **Build final `vendor_boot` image**
   ```bash
   ./tools/build-system-compatible-vendor-boot.sh
   ```

## Credits

* **OrangeFox Team**
* [orangefox_twrp_device_xiaomi_rodin](https://github.com/woshimaniubi8/orangefox_twrp_device_xiaomi_rodin)
* [twrp_device_xiaomi_klee](https://github.com/xiaomi-klee-devs/twrp_device_xiaomi_klee)

Special thanks for the source code references, scripts, and their implementation to create the final image.
