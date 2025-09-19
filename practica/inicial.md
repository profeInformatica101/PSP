# 🖥️ Práctica 1: Configuración inicial y primeros comandos en Linux Lite

## 🎯 Objetivos
- Configurar y arrancar una máquina virtual con Linux Lite en VirtualBox.
- Conocer el hardware del equipo anfitrión (Windows) y de la máquina virtual (Linux).
- Ejecutar comandos básicos relacionados con procesos y concurrencia (RA1).
- Observar cómo cambian los recursos al modificar parámetros en VirtualBox.

---

## 1️⃣ Preparación del entorno
1. Abrir **VirtualBox** en Windows.
2. Crear una nueva máquina virtual:
   - Nombre: `LinuxLite-RA1`
   - Tipo: Linux
   - Memoria: 2 GB (mínimo)
   - Disco: 20 GB (dinámico)
3. Montar la ISO de **Linux Lite** y arrancar.
4. Durante la instalación:
   - Usuario: `alumno`
   - Contraseña: `alumno123`

---

## 2️⃣ Conocer el hardware del host (Windows)
Ejecuta en el **cmd** de Windows:

```powershell
wmic cpu get name
systeminfo | find "Total Physical Memory"
systeminfo | findstr /B /C:"OS Name" /C:"OS Version"
```

👉 Esto te muestra procesador, memoria y versión del sistema operativo.

---

## 3️⃣ Conocer el hardware de la VM (Linux Lite)
Ejecuta en la terminal de Linux:

```bash
lscpu           # Información de la CPU
free -h         # Memoria disponible
lsblk           # Discos y particiones
uname -a        # Información del kernel
cat /etc/os-release   # Versión de la distribución
```

👉 Compara estos resultados con los de Windows. ¿Qué diferencias ves?

---

## 4️⃣ Procesos en Linux (RA1)

- Ver procesos activos:
  ```bash
  ps -ef
  ```

- Monitorizar procesos en tiempo real:
  ```bash
  top
  htop   # (si está instalado)
  ```

- Crear un proceso en **segundo plano**:
  ```bash
  sleep 60 &
  jobs
  ```

- Traer proceso al primer plano:
  ```bash
  fg %1
  ```

- Matar un proceso:
  ```bash
  kill -9 <PID>
  ```

---

## 5️⃣ Monitorización de recursos

- Ver uso de CPU y memoria:
  ```bash
  vmstat 2 5
  ```

- Ver puertos abiertos:
  ```bash
  ss -tulnp
  ```

---

## 6️⃣ Cambiar parámetros en VirtualBox y comprobar

1. Apaga la VM.
2. En VirtualBox → Configuración:
   - Cambia **núcleos de CPU** (ej. de 1 a 2).
   - Cambia **RAM** (ej. de 2 GB a 4 GB).
3. Vuelve a arrancar Linux Lite y revisa:
   ```bash
   lscpu
   free -h
   ```

👉 Anota las diferencias detectadas.

---

## 7️⃣ Concurrencia en acción

Ejecuta varios procesos que consuman CPU:

```bash
yes > /dev/null &
yes > /dev/null &
yes > /dev/null &
```

Luego abre `top` o `htop` y observa:
- ¿Cuántos procesos están activos?
- ¿Cómo se reparten entre los núcleos?

---

## 📌 Conclusión
Un **programa** se convierte en **proceso** al ser cargado en la CPU y gestionado por el sistema operativo.  
Con estos comandos puedes ver:
- Los recursos asignados por VirtualBox.
- Cómo Linux gestiona procesos y concurrencia.
