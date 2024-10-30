# Etapa de construção
FROM maven:3.8.7-openjdk-17 AS build

# Define o diretório de trabalho
WORKDIR /app

# Copia o arquivo pom.xml e faz o download das dependências
COPY pom.xml .
RUN mvn dependency:go-offline

# Copia o código-fonte e compila o projeto
COPY src ./src
RUN mvn package -DskipTests

# Verificação do arquivo JAR gerado
RUN ls target/

# Etapa final
FROM openjdk:17-jdk-slim

# Define o diretório de trabalho
WORKDIR /app

# Copia o JAR gerado na etapa de build para o contêiner final
COPY --from=build /app/target/*.jar app.jar

# Define a porta exposta
EXPOSE 8080

# Comando para executar a aplicação
ENTRYPOINT ["java", "-jar", "app.jar"]
