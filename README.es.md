# OrangeFox R12.0 Unofficial - Redmi Note 15 4G (`spinel` / Helio G100)

## Información del Dispositivo

| Propiedad | Valor |
| :--- | :--- |
| **Modelo** | Redmi Note 15 4G |
| **Código** | `spinel` |
| **SoC** | MediaTek Helio G100 |
| **Estado** | Estable |

## Características y Estado

### Funcionando
* **Desencriptación:** Soporte completo de desencriptación de `/data`.
* **Seguridad:** AVB 2.0 validado.
* **Conectividad:** ADB y MTP funcionando.
* **Pantalla:** Drivers de pantalla funcionando con módulos de brillo de panel patcheados.
* **Pantalla táctil:** Módulos táctiles stock conservados (`xiaomi_touch.ko`, `gt9916k.ko`).

### Pendientes / Mejoras Futuras
* Refinar los triggers USB de ADB/MTP en futuras iteraciones.

## Proceso de Construcción

Ejecuta los siguientes scripts secuencialmente desde el directorio raíz:

1. **Preparar ramdisk de plataforma**
   ```bash
   ./tools/prepare-platform-ramdisk.sh
   ```

2. **Patchear módulo de brillo de panel**
   ```bash
   python3 tools/patch-panel-brightness.py
   ```

3. **Preparar recovery root**
   ```bash
   ./tools/prepare-recovery-root.sh
   ```

4. **Generar imagen `vendor_boot` final**
   ```bash
   ./tools/build-system-compatible-vendor-boot.sh
   ```

## Agradecimientos

* **OrangeFox Team**
* [orangefox_twrp_device_xiaomi_rodin](https://github.com/woshimaniubi8/orangefox_twrp_device_xiaomi_rodin)
* [twrp_device_xiaomi_klee](https://github.com/xiaomi-klee-devs/twrp_device_xiaomi_klee)

Un agradecimiento por las referencias de código fuente, scripts y la implementación de estos para crear la imagen final.
