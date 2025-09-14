# Olivo de procesos (metáfora pedagógica en Linux)

**Leyenda**
- 🌳 = **Tronco (PID 1)**: `systemd`/`init`, antepasado de todo.
- 🌿 = **Rama**: servicio/daemon que “sostiene” otros procesos.
- 🫒 = **Aceituna**: **proceso** (con su `PID`).
- 🔁 = *workers* o procesos hijo que hacen el trabajo.
- 💤 = estado en **espera** (S), ⚙️ = **ejecutando** (R), ⛔ = **zombi** (Z, sin limpiar).
- (PPID=…) indica el **padre**.

```
🌳 systemd (PID 1) [S]
│
├─ 🌿 sshd (PID 720) [S] (PPID=1)
│   ├─ 🫒 sshd: [priv] (PID 1180) [S] (PPID=720)
│   └─ 🫒 sshd: user@pts/0 (PID 1181) [S] (PPID=1180)
│       └─ 🫒 bash (PID 1203) [S] (PPID=1181)
│           ├─ 🫒 vim notas.txt (PID 1277) [R] (PPID=1203)
│           └─ 🫒 python tarea.py (PID 1290) [S] (PPID=1203)
│
├─ 🌿 getty@tty1 (PID 650) [S] (PPID=1)
│   └─ 🫒 login (PID 910) [S] (PPID=650)
│       └─ 🫒 bash (PID 935) [S] (PPID=910)
│           └─ 🫒 top (PID 1010) [R] (PPID=935)
│
├─ 🌿 nginx: master (PID 840) [S] (PPID=1)
│   ├─ 🔁 nginx: worker (PID 1042) [S] (PPID=840)
│   └─ 🔁 nginx: worker (PID 1043) [S] (PPID=840)
│
├─ 🌿 postgres (PID 900) [S] (PPID=1)
│   ├─ 🔁 postmaster logger (PID 901) [S] (PPID=900)
│   ├─ 🔁 checkpointer (PID 902) [S] (PPID=900)
│   ├─ 🔁 writer (PID 903) [S] (PPID=900)
│   └─ 🔁 backend: app (PID 1210) [S] (PPID=900)
│
└─ 🌿 cron (PID 700) [S] (PPID=1)
    └─ 🫒 sh -c /etc/cron.daily/… (PID 1320) [S] (PPID=700)
        └─ 🫒 script.sh (PID 1321) [⛔ Z] (PPID=1320)  ← zombi esperando que su padre haga wait()
```

## Puntos clave para el alumnado
- **PID**: identificador único de cada 🫒 proceso.  
- **PPID**: quién lo “sostiene” (su rama/padre).  
- **Estados** típicos (columna `STAT`):
  - **R** (⚙️): ejecutándose.
  - **S** (💤): dormido/esperando E/S.
  - **D**: espera ininterrumpible (normalmente E/S de disco).
  - **T**: detenido (señal `SIGSTOP`/`SIGTSTP`).
  - **Z** (⛔): zombi (ya terminó, falta `wait()` del padre).
- **Daemons/Servicios** (🌿) suelen nacer de `systemd` (🌳) y generar **workers** (🔁).
- Si “cortas” una rama (matas el padre), los hijos **se re-adoptan** por `PID 1` o pueden morir según el caso.

## Cómo ver tu olivo real en Linux
- Vista jerárquica con estados:
  ```bash
  ps -e --forest -o pid,ppid,stat,cmd
  ```
- Árbol compacto:
  ```bash
  pstree -ap
  ```
- Filtrar por una rama (por ejemplo, nginx):
  ```bash
  pstree -ap | grep -i nginx -A2
  ```

## Señales: podando el olivo
- **Terminar con elegancia**:
  ```bash
  kill -TERM <PID>     # pide cierre limpio
  ```
- **Reiniciar un servicio systemd**:
  ```bash
  sudo systemctl restart nginx
  ```
- **Forzar (último recurso)**:
  ```bash
  kill -KILL <PID>     # SIGKILL: sin limpieza
  ```

## Mini-actividades rápidas
1. **Identifica zombis**: ejecuta `ps aux | grep ' Z '` y explica por qué aparecen y cómo “hereda” `PID 1`.  
2. **Traza tu shell**: desde `bash`, lanza `sleep 1000 &` y usa `ps --forest` para localizarlo y su `PPID`.  
3. **Dibuja tu propio olivo**: con `pstree -ap > mi_olivo.txt`, anota 3 daemons, sus workers y qué pasaría si el padre termina.
