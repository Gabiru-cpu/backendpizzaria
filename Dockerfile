# Etapa de construção
FROM maven:3.8.7-openjdk-17 AS build

# Define o diretório de trabalho
WORKDIR /app

# Copia o arquivo pom.xml e as dependências para o cache do Docker
COPY pom.xml .
RUN mvn dependency:go-offline

# Copia o código-fonte para o contêiner
COPY src ./src

# Compila o projeto
RUN mvn package -DskipTests

# Etapa final
FROM openjdk:17-jdk-slim

# Define o diretório de trabalho
WORKDIR /app

# Copia o JAR gerado na etapa de build para o contêiner final
COPY --from=build /app/target/backend-0.0.1-SNAPSHOT.jar app.jar

# Define a porta que será exposta (ajuste para a porta usada pela sua aplicação, se diferente)
EXPOSE 8080

# Comando para executar a aplicação
ENTRYPOINT ["java", "-jar", "app.jar"]
