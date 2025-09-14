# RA1 · Programación multiproceso
**Módulo Profesional:** Programación de Servicios y Procesos (0490)  
**ECTS:** 5 · **Duración del módulo:** 40 h · **Lenguaje:** Java 17+

---

## Resultado de Aprendizaje (RA1)
**Desarrolla aplicaciones compuestas por varios procesos reconociendo y aplicando principios de programación paralela.**

### Criterios de Evaluación (BOE)
a) Se han reconocido las características de la programación concurrente y sus ámbitos de aplicación.  
b) Se han identificado las diferencias entre programación paralela y distribuida, sus ventajas e inconvenientes.  
c) Se han analizado las características de los procesos y de su ejecución por el sistema operativo.  
d) Se han caracterizado los hilos de ejecución y descrito su relación con los procesos.  
e) Se han utilizado clases para programar aplicaciones que crean subprocesos.  
f) Se han utilizado mecanismos para compartir información con los subprocesos iniciados.  
g) Se han utilizado mecanismos para sincronizar y obtener el valor devuelto por los subprocesos iniciados.  
h) Se han desarrollado aplicaciones que gestionen y utilicen procesos para la ejecución de varias tareas en paralelo.  
i) Se han depurado y documentado las aplicaciones desarrolladas.  

---

## Reto 1.1 — «Orquestando procesos» (Evidencia)
Implementa y prueba una **CLI** que:
1) Lanza **N subprocesos** (\*CE e, h).  
2) Se comunica con ellos por **IPC** usando `stdout`/`stdin` con un protocolo de **1 línea** (\*CE f).  
3) **Sincroniza** la finalización y agrega resultados (\*CE g).  
4) Compara **paralelo local** vs **distribuido** (visión) y registra **métricas** (\*CE b, g, h, i).

**Entrega:** Informe (PDF/MD) + código en `psp-dam2/ud1/`.

---

## Teoría mínima para el reto
### Procesos, concurrencia y paralelismo (CE a, c)
- **Proceso**: programa en ejecución con su propio espacio de direcciones y recursos. El SO planifica su CPU.  
- **Concurrencia**: varias tareas *en progreso al mismo tiempo* (intercalado).  
- **Paralelismo**: ejecución *real* al mismo tiempo (varios núcleos).  
- **Comunicación entre procesos (IPC)**: tuberías, ficheros, sockets, memoria compartida… En este reto, usamos **tuberías** implícitas de `ProcessBuilder` → `stdout` del hijo.

### Paralelo vs distribuido (CE b)
- **Paralelo local**: múltiples procesos/hilos en la misma máquina (poca latencia, alto ancho de banda).  
- **Distribuido**: múltiples máquinas conectadas en red (latencias y fallos de red, pero escalabilidad horizontal).

### Subprocesos en Java (CE e)
- `ProcessBuilder` permite lanzar otros **programas Java** como subprocesos y redirigir su I/O.

### Sincronización y recolección de resultados (CE g)
- El padre usa `Process.waitFor()` o futuros para esperar a todos, leer **una línea de salida** por proceso y agregar resultados.

---

## Código base (listo para copiar)
### `Orchestrator.java`
```java
import java.io.*;
import java.nio.charset.StandardCharsets;
import java.time.Duration;
import java.time.Instant;
import java.util.*;
import java.util.concurrent.*;
import java.util.stream.*;

public class Orchestrator {
  public static void main(String[] args) throws Exception {
    Map<String,String> cfg = Arrays.stream(args)
      .filter(s->s.startsWith("--"))
      .map(s->s.substring(2).split("=",2))
      .collect(Collectors.toMap(a->a[0], a->a.length>1?a[1]:""));

    int n = Integer.parseInt(cfg.getOrDefault("n","4"));
    long from = Long.parseLong(cfg.getOrDefault("from","1"));
    long to   = Long.parseLong(cfg.getOrDefault("to","2000000"));
    boolean csv = Boolean.parseBoolean(cfg.getOrDefault("csv","true"));

    List<long[]> chunks = splitRange(from, to, n);
    ExecutorService pool = Executors.newFixedThreadPool(n);
    List<CompletableFuture<Result>> futures = new ArrayList<>();
    Instant t0 = Instant.now();

    for (int i=0; i<n; i++) {
      long a=chunks.get(i)[0], b=chunks.get(i)[1]; int idx=i;
      futures.add(CompletableFuture.supplyAsync(() -> runWorker(idx, a, b), pool));
    }

    List<Result> results = futures.stream().map(CompletableFuture::join).toList();
    Instant t1 = Instant.now();

    long hashes = results.stream().mapToLong(r->r.count).sum();
    String agg = xorHex(results.stream().map(r->r.digest).toList());
    Duration wall = Duration.between(t0, t1);
    double seconds = wall.toMillis()/1000.0;
    double thr = hashes / seconds;

    if (!csv) {
      System.out.printf("OK local-parallel; n=%d; range=[%d..%d]; time=%.3fs; hashes=%d; thr=%.1f hash/s; agg=%s%n",
        n, from, to, seconds, hashes, thr, agg);
      results.forEach(System.out::println);
    } else {
      System.out.println("mode,n,from,to,ms,hashes,hash_per_sec,agg");
      System.out.printf(Locale.US,"local,%d,%d,%d,%d,%d,%.2f,%s%n",
        n, from, to, wall.toMillis(), hashes, thr, agg);
    }
    pool.shutdown();
  }

  static class Result {
    int idx; long count; String digest; long ms;
    public String toString(){ return String.format("worker=%d count=%d ms=%d digest=%s",idx,count,ms,digest); }
  }

  static Result runWorker(int idx, long from, long to) {
    try {
      ProcessBuilder pb = new ProcessBuilder("java","-cp",".","Worker","--from="+from,"--to="+to);
      pb.redirectErrorStream(true);
      Process p = pb.start();
      try (BufferedReader br = new BufferedReader(new InputStreamReader(p.getInputStream(), StandardCharsets.UTF_8))) {
        String line = br.readLine();
        int exit = p.waitFor();
        if (exit!=0 || line==null) throw new RuntimeException("worker "+idx+" failed");
        Result r = new Result(); r.idx = idx;
        for (String kv : line.split(";")) {
          if (kv.startsWith("count=")) r.count = Long.parseLong(kv.substring(6));
          else if (kv.startsWith("ms=")) r.ms = Long.parseLong(kv.substring(3));
          else if (kv.startsWith("digest=")) r.digest = kv.substring(7);
        }
        return r;
      }
    } catch (Exception ex) { throw new RuntimeException(ex); }
  }

  static List<long[]> splitRange(long a, long b, int n){
    long total = (b - a + 1), size = total / n, rem  = total % n;
    List<long[]> chunks = new ArrayList<>(); long cur=a;
    for (int i=0;i<n;i++){
      long len = size + (i<rem?1:0);
      long start=cur, end=cur+len-1;
      chunks.add(new long[]{start,end}); cur=end+1;
    }
    return chunks;
  }

  static String xorHex(List<String> digests){
    int L = 64; int[] acc = new int[L];
    for (String d: digests) for (int i=0;i<L;i++) acc[i]^=Integer.parseInt(""+d.charAt(i),16);
    StringBuilder sb=new StringBuilder(L);
    for (int i=0;i<L;i++) sb.append(Integer.toHexString(acc[i]));
    return sb.toString();
  }
}
```

### `Worker.java`
```java
import java.security.*;
import java.time.*;

public class Worker {
  static String hex(byte[] b){
    StringBuilder sb=new StringBuilder(b.length*2);
    for (byte x : b) sb.append(String.format("%02x", x));
    return sb.toString();
  }
  public static void main(String[] args) throws Exception {
    long from=1,to=1000;
    for (String a: args){
      if (a.startsWith("--from=")) from=Long.parseLong(a.substring(7));
      if (a.startsWith("--to="))   to=Long.parseLong(a.substring(5));
    }
    MessageDigest md = MessageDigest.getInstance("SHA-256");
    Instant t0=Instant.now(); long c=0;
    for (long i=from;i<=to;i++){
      md.update(longToBytes(i));
      md.digest(); // carga CPU
      c++;
    }
    long ms = Duration.between(t0, Instant.now()).toMillis();
    String digest = hex(md.digest((from+".."+to).getBytes()));
    System.out.printf("OK;count=%d;ms=%d;digest=%s%n", c, ms, digest);
  }
  static byte[] longToBytes(long v){
    return new byte[]{
      (byte)(v>>>56),(byte)(v>>>48),(byte)(v>>>40),(byte)(v>>>32),
      (byte)(v>>>24),(byte)(v>>>16),(byte)(v>>>8),(byte)v
    };
  }
}
```

---

## Cómo testear (paso a paso)
> Carpeta sugerida: `psp-dam2/ud1/`

1. **Compilar**
```bash
javac Orchestrator.java Worker.java
```
2. **Ejecutar (prueba rápida)**
```bash
java Orchestrator --n=2 --from=1 --to=200000 --csv=false
```
3. **Ejecutar (métricas CSV)**
```bash
java Orchestrator --n=4 --from=1 --to=2000000 --csv=true > local.csv
```
4. **Interpretar la salida**
- Modo texto: `OK local-parallel; ... thr=XXXXX hash/s`  
- CSV: primera línea cabecera, segunda línea datos → importa a hoja de cálculo.

5. **Evidencias / capturas (CE i)**
- `htop`/`top`: verás varios procesos `java` hijos.  
- `time -p java Orchestrator ...`: tiempos reales.  
- `jcmd <pid> VM.version` o `jstack <pid>` (opcional) para contexto del proceso.  

---

## Depuración y errores frecuentes
- *No imprime nada*: asegúrate de no quitar el `printf` del `Worker`.  
- *`worker X failed`*: suele ser por cortar la línea o por finalizar anómalamente. Revisa argumentos `--from/--to`.  
- *Rendimiento flojo*: sube `--n` hasta el nº de núcleos (o un poco más) y aumenta `--to`.

---

## Mapa RA→CE cubiertos por la evidencia
- **a** (concurrencia/ámbitos): introducción y justificación en el informe.  
- **b** (paralelo vs distribuido): sección de comparación y discusión.  
- **c** (procesos/SO): explicación de planificación y herramientas usadas para observar procesos.  
- **d** (hilos y relación con procesos): breve encaje teórico en el informe (aunque el reto es multiproceso).  
- **e**: `ProcessBuilder` crea subprocesos.  
- **f**: IPC por `stdout` (protocolo 1 línea).  
- **g**: `waitFor()` + `CompletableFuture.join()` agregan y sincronizan.  
- **h**: orquestación de **N** tareas en paralelo.  
- **i**: sección de **depuración** + **documentación** (informe con métricas y capturas).

---

## Extensiones (opcionales, para subir nota)
- Añade verificación del digest agregado (`xorHex`).  
- Registro JSONL por proceso.  
- Script (Python/Matplotlib) para graficar `hashes/s` vs `n`.

---

## Checklist de entrega (rápido)
- [ ] Código compila y ejecuta con parámetros.  
- [ ] CSV con métricas adjunto.  
- [ ] Informe con capturas `top/htop` y explicación IPC.  
- [ ] Conclusión clara sobre escalado al variar **N**.  
