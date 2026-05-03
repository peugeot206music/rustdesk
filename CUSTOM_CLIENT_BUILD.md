# Cliente custom RustDesk

## Estado actual

Este repo quedó preparado para manejar varios proyectos de branding sin compartir el mismo `custom.json`.

Hoy tenés:

- perfil por defecto: [`custom.json`](/home/ubuntu/rustdesk-custom/custom.json) -> `InvSecure`
- perfil separado: [`projects/myanyrust/custom.json`](/home/ubuntu/rustdesk-custom/projects/myanyrust/custom.json) -> `MyAnyRust`

La `key` del servidor quedó corregida contra la pública real de `hbbs`.

## Campos extra por proyecto

Además de los campos normales de RustDesk, cada perfil puede definir:

- `installer-name`
- `download-public-base-url`
- `download-target-dir`

Esos campos los usa `publish_windows_installer.sh` para publicar sin mezclar canales.

## Build Windows

El build sigue siendo en Windows con Rust + Flutter + Visual Studio Build Tools.

Ejemplos:

```bash
cd /home/ubuntu/rustdesk-custom
python build.py --flutter
```

Eso usa el perfil por defecto (`InvSecure`).

```bash
cd /home/ubuntu/rustdesk-custom
python build.py --flutter --custom-config projects/myanyrust/custom.json
```

Eso genera el instalador del proyecto `MyAnyRust`.

## Publicación

El script ahora puede leer destino y URL pública desde el perfil.

Perfil por defecto:

```bash
cd /home/ubuntu/rustdesk-custom
sudo bash ./publish_windows_installer.sh
```

Perfil `MyAnyRust`:

```bash
cd /home/ubuntu/rustdesk-custom
sudo env CUSTOM_CONFIG=/home/ubuntu/rustdesk-custom/projects/myanyrust/custom.json ./publish_windows_installer.sh
```

También podés sobreescribir manualmente el destino:

```bash
sudo env CUSTOM_CONFIG=/home/ubuntu/rustdesk-custom/projects/myanyrust/custom.json \
  PUBLIC_BASE_URL=https://myanyrust.duckdns.org/downloads \
  TARGET_DIR=/var/www/certbot/myanyrust-downloads \
  ./publish_windows_installer.sh
```

## Siguiente paso para `myanyrust.duckdns.org`

Para que ese canal quede realmente independiente faltan dos cosas del lado servidor:

1. crear `myanyrust` en tu cuenta de DuckDNS
2. publicar una ruta web propia, por ejemplo `https://myanyrust.duckdns.org/downloads/`

El perfil ya quedó apuntando a esa URL.
