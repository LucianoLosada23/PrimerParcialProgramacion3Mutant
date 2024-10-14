# Etapa 1: Construir la aplicación usando Gradle
FROM gradle:8.10.0-jdk21 AS build

# Configurar el directorio de trabajo dentro del contenedor
WORKDIR /app

# Copiar archivos de Gradle y el código fuente
COPY build.gradle settings.gradle gradlew ./
COPY gradle ./gradle
COPY src ./src

# Asegurar que el archivo gradlew tenga permisos de ejecución
RUN chmod +x ./gradlew

# Construir el proyecto
RUN ./gradlew build -x test

# Etapa 2: Crear la imagen final para ejecución
FROM eclipse-temurin:21-jdk-alpine

# Configurar el directorio de trabajo dentro del contenedor
WORKDIR /app

# Copiar el archivo .jar generado en la etapa de build
COPY --from=build /app/build/libs/*.jar app.jar

# Exponer el puerto 8080
EXPOSE 8080

# Comando de inicio
ENTRYPOINT ["java", "-jar", "/app/app.jar"]
