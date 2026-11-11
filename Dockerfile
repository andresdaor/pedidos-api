# DOCKER: Etapa 1 - construcción con Maven + JDK 21
FROM eclipse-temurin:21-jdk-alpine AS build

WORKDIR /app

# DOCKER: copia primero el pom.xml para aprovechar la cache de capas
COPY pom.xml ./
COPY mvnw ./
COPY .mvn ./.mvn
RUN chmod +x mvnw

# DOCKER: pre-descarga dependencias (esta capa se cachea si pom.xml no cambia)
RUN ./mvnw dependency:go-offline -B

# DOCKER: ahora sí copia el código y compila
COPY src ./src
RUN ./mvnw clean package -DskipTests -B

# --------------------------------------------------------------------
# DOCKER: Etapa 2 - imagen final, solo JRE, sin Maven ni código fuente
FROM eclipse-temurin:21-jre-alpine AS runtime

WORKDIR /app

# DOCKER: corremos como usuario no-root (seguridad: nunca root en producción)
RUN addgroup -S spring && adduser -S spring -G spring
USER spring:spring

# DOCKER: copia el JAR desde la etapa de build
COPY --from=build /app/target/*.jar app.jar

# DOCKER: healthcheck para que orquestadores (K8s, ECS) sepan si la app vive
HEALTHCHECK --interval=30s --timeout=3s --start-period=40s --retries=3 \
  CMD wget --quiet --tries=1 --spider http://localhost:8080/actuator/health || exit 1

EXPOSE 8080

# DOCKER: configuración JVM para containers (respeta límites del cgroup)
ENV JAVA_OPTS="-XX:MaxRAMPercentage=75.0 -XX:+UseG1GC"

ENTRYPOINT ["sh", "-c", "java $JAVA_OPTS -jar app.jar"]
