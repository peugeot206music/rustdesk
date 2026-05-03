# Perfiles de cliente

Cada carpeta dentro de `projects/` representa un canal independiente de branding, updates y publicación.

## Uso

Build:

```bash
cd /home/ubuntu/rustdesk-custom
python3 build.py --flutter --custom-config projects/myanyrust/custom.json
```

Publicación:

```bash
cd /home/ubuntu/rustdesk-custom
sudo env CUSTOM_CONFIG=/home/ubuntu/rustdesk-custom/projects/myanyrust/custom.json ./publish_windows_installer.sh
```

## Convención

Cada `custom.json` puede incluir:

- configuración normal de RustDesk (`app-name`, `custom-rendezvous-server`, `key`, `custom-update-url`)
- metadatos de publicación (`installer-name`, `download-public-base-url`, `download-target-dir`)
