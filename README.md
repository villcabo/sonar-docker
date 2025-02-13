# sonar-docker

Este proyecto configura y ejecuta SonarQube en un contenedor Docker.

## Requisitos

- Docker
- Docker Compose

## Uso

1. Clona el repositorio:
```sh
git clone https://github.com/tu-usuario/sonar-docker.git
cd sonar-docker
```

## Variables de entorno

Las siguientes variables de entorno deben ser configuradas en el archivo .env:  

```dotenv
SONARQUBE_VERSION=Versión de SonarQube.
SONARQUBE_JDBC_URL=URL de conexión JDBC de la base de datos.
SONARQUBE_JDBC_USERNAME=Nombre de usuario de la base de datos.
SONARQUBE_JDBC_PASSWORD=Contraseña de la base de datos.
```