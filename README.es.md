# Xiaomi Redmi Note 15 4G (`spinel`) — Device Tree

[English](README.md) | **Español**

## Estado del recovery

El recovery funciona y ha sido probado en el dispositivo objetivo.

| Función | Estado |
|---|---|
| Arranque del recovery | Funcional |
| ADB | Funcional |
| Desencriptación de datos | Funcional |
| MTP | Necesita mejoras |
| Control del brillo de pantalla | Funcional |
| USB OTG | Sin probar |

## Correcciones destacadas

## Corrección del brillo de pantalla

El controlador original del panel forzaba el nivel de brillo solicitado a `307` cuando se ejecutaba en modo recovery.

El problema se identificó en la función `lcm_setbacklight_cmdq()` del siguiente módulo:

`panel-p7-41-02-0b-dsc-vdo.ko`

Se aplica un parche binario que sustituye la instrucción que asigna el valor fijo de brillo por una instrucción `NOP` de AArch64, permitiendo conservar el nivel solicitado.

El análisis y la implementación de este parche se realizaron con asistencia de inteligencia artificial.

### Integración en la compilación

El parche se genera automáticamente durante el proceso de compilación. El módulo original se extrae de `prebuilt/stock_vendor_ramdisk.cpio.lz4` y se modifica mediante estos scripts:

- `tools/patch-panel-brightness.py`: aplica y valida el parche binario.
- `tools/prepare-platform-ramdisk.sh`: incorpora el módulo parcheado al ramdisk de plataforma generado.
- `tools/build-system-compatible-vendor-boot.sh`: construye la imagen personalizada de `vendor_boot` v4.

El script de parcheo comprueba el SHA-256 del módulo original, los bytes de la instrucción en el desplazamiento esperado y el SHA-256 del resultado. La compilación se detiene si alguna comprobación falla.

El parche se ha probado en el Xiaomi Redmi Note 15 4G (`spinel`) y el ajuste del brillo funciona en OrangeFox.

**Nota:** El parche está diseñado para una versión específica del módulo propietario del panel. Otras versiones del firmware pueden requerir un nuevo análisis y un parche diferente.

## Aviso

Este recovery no es oficial. Úsalo bajo tu responsabilidad.
Comprueba siempre la compatibilidad del dispositivo y del
firmware antes de flashearlo.
