# Assets de MyAnyRust

Coloca aca los archivos opcionales que queres aplicar al cliente custom.

Nombres soportados hoy por `build.py`:

- `icon.ico`
- `app_icon.ico`
- `tray-icon.ico`
- `icon.png`
- `icon.svg`
- `logo.png`
- `client_background.png`
- `mac-icon.png`

Cuando el build corre con:

```bash
python3 build.py --flutter --custom-config projects/myanyrust/custom.json
```

esos assets se copian automaticamente a las rutas que usa RustDesk antes de compilar.
