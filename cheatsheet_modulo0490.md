# 📘 Cheat Sheet – Programación de Servicios y Procesos (Java)

## 🔹 Concurrencia (RA1 & RA2)

### Clases básicas
- `Thread` → crear hilos manualmente.
- `Runnable` / `Callable` → definir tareas.
- `ExecutorService` → gestionar pool de hilos.
- `Future` → resultado de una tarea.
- `CompletableFuture` → programación asíncrona fluida.
- Sincronización: `Semaphore`, `CountDownLatch`, `CyclicBarrier`, `ReentrantLock`.

### Ejemplo rápido
```java
ExecutorService pool = Executors.newFixedThreadPool(2);
Future<Integer> f = pool.submit(() -> 40 + 2);
System.out.println(f.get()); // 42
pool.shutdown();
```

📎 Recursos:  
- [Java Concurrency Cheatsheet – Java Code Geeks](https://www.javacodegeeks.com/java-concurrency-cheatsheet.html)  
- [Core Java Concurrency – Refcard DZone (PDF)](https://dzone.com/refcardz/core-java-concurrency)  

---

## 🔹 Sockets y comunicación en red (RA3)

### Clases clave
- `ServerSocket` → escucha conexiones.
- `Socket` → cliente.
- `HttpClient` (JDK 11+) → peticiones HTTP.

### Ejemplo rápido
```java
// Servidor
try (ServerSocket server = new ServerSocket(8080)) {
    Socket client = server.accept();
    PrintWriter out = new PrintWriter(client.getOutputStream(), true);
    out.println("Hola cliente");
}
```

📎 Recursos:  
- [Java Networking – Oracle Docs](https://docs.oracle.com/javase/tutorial/networking/)  

---

## 🔹 I/O y NIO2 (RA1 y RA4)

### Clases clave
- `Path`, `Files` (crear, leer, escribir).
- `BufferedReader`, `BufferedWriter`.
- `ByteBuffer`, `Channels` (I/O eficiente).

### Ejemplo rápido
```java
Path p = Path.of("data.txt");
Files.writeString(p, "Hola mundo");
System.out.println(Files.readString(p));
```

📎 Recursos:  
- [Java NIO File API – Oracle](https://docs.oracle.com/javase/tutorial/essential/io/fileio.html)  

---

## 🔹 JSON (RA4)

### Librerías recomendadas
- **Jackson** (principal).
- Alternativas: Gson, Json-B.

### Ejemplo rápido con Jackson
```java
ObjectMapper mapper = new ObjectMapper();
String json = mapper.writeValueAsString(Map.of("ok", true));
Map<?,?> map = mapper.readValue(json, Map.class);
```

📎 Recursos:  
- [Jackson Documentation](https://github.com/FasterXML/jackson)  

---

## 🔹 Logging (RA1–RA5)

### Librerías
- Básico: `java.util.logging`.
- Profesional: **SLF4J + Logback**.

### Ejemplo rápido
```java
private static final Logger log = LoggerFactory.getLogger(App.class);
log.info("Hola {}", "mundo");
```

📎 Recursos:  
- [SLF4J](http://www.slf4j.org/)  
- [Logback](http://logback.qos.ch/)  

---

## 🔹 Testing (RA1–RA5)

### Librerías
- **JUnit 5** → testing estándar.
- **Mockito** → mocks y dobles de prueba.

### Ejemplo rápido
```java
@Test
void suma() {
    assertEquals(5, 2+3);
}
```

📎 Recursos:  
- [JUnit 5 User Guide](https://junit.org/junit5/docs/current/user-guide/)  
- [Mockito](https://site.mockito.org/)  

---

## 🔹 Servicios en red (RA4)

### Librerías
- `HttpServer` (básico en JDK).
- **Spring Boot (starter-web)** → REST.

### Ejemplo rápido con HttpServer
```java
HttpServer server = HttpServer.create(new InetSocketAddress(8000), 0);
server.createContext("/hola", ex -> {
    String resp = "Hola mundo";
    ex.sendResponseHeaders(200, resp.length());
    ex.getResponseBody().write(resp.getBytes());
    ex.close();
});
server.start();
```

📎 Recursos:  
- [Spring Boot Docs](https://spring.io/projects/spring-boot)  

---

## 🔹 Seguridad y criptografía (RA5)

### Clases clave
- `MessageDigest` (hashes).
- `Cipher`, `SecretKeySpec` (cifrado).
- `SSLContext` (TLS).
- **Spring Security** (roles, auth).

### Ejemplo rápido (hash SHA-256)
```java
var md = MessageDigest.getInstance("SHA-256");
byte[] hash = md.digest("secret".getBytes());
System.out.println(HexFormat.of().formatHex(hash));
```

📎 Recursos:  
- [Java Cryptography Architecture (JCA)](https://docs.oracle.com/en/java/javase/17/security/java-cryptography-architecture-jca-reference-guide.html)  

---

## 🔹 Configuración

### Librerías
- **Typesafe Config** (HOCON, JSON).
- O simple: `Properties`.

### Ejemplo rápido
```java
Properties p = new Properties();
p.load(Files.newBufferedReader(Path.of("app.properties")));
System.out.println(p.getProperty("db.user"));
```

📎 Recursos:  
- [Typesafe Config](https://github.com/lightbend/config)  

---

## 🔹 BBDD (si aplica)

### Librerías
- **JDBC** (JDK estándar).
- **HikariCP** (pool).
- **JPA / Hibernate** (ORM).

### Ejemplo rápido (JDBC)
```java
try (Connection con = DriverManager.getConnection(url, user, pass);
     Statement st = con.createStatement()) {
    ResultSet rs = st.executeQuery("SELECT 1");
    while (rs.next()) System.out.println(rs.getInt(1));
}
```

📎 Recursos:  
- [HikariCP](https://github.com/brettwooldridge/HikariCP)  
- [Hibernate ORM](https://hibernate.org/)  

---

# ✅ Resumen mínimo para el módulo (0490)

1. **Concurrencia JDK** → Thread, ExecutorService, CompletableFuture, Semaphore.  
2. **Sockets/HTTP** → ServerSocket, Socket, HttpClient.  
3. **I/O y NIO2** → Files, Path, ByteBuffer.  
4. **JSON** → Jackson.  
5. **Logging** → SLF4J + Logback.  
6. **Testing** → JUnit 5 + Mockito.  
7. **Servicios** → Spring Boot o HttpServer.  
8. **Seguridad** → javax.crypto, TLS, Spring Security.  
9. **Config** → Typesafe Config.  
10. **BBDD** → JDBC + Hikari / JPA.  
