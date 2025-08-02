# SonarQube in Docker

This project sets up and runs SonarQube in a Docker container with a production-ready configuration.

## 🚀 Features

- Optimized configuration for development and production
- Automatic directory initialization with proper permissions
- Easy configuration through environment variables
- Clear and concise documentation

## 📋 Requirements

- Docker 20.10.0 or higher
- Docker Compose 2.0.0 or higher
- Minimum 4GB RAM (8GB recommended)
- Minimum 2 vCPUs

## 🚀 Quick Start

1. Clone the repository:
   ```bash
   git clone https://github.com/villcabo/sonar-docker.git
   cd sonar-docker
   ```

2. Initialize required directories:
   ```bash
   chmod +x bin/init-sonarqube-dirs.sh
   ./bin/init-sonarqube-dirs.sh
   ```

3. (Optional) Create an `.env` file to customize the configuration:
   ```bash
   cp .env.example .env
   # Edit the .env file as needed
   ```

4. Start the services:
   ```bash
   docker compose up -d
   ```

5. Access SonarQube in your browser:
   ```
   http://localhost:9000
   ```
   - Default username: admin
   - Default password: admin

## 🔧 Configuration

### Environment Variables

You can configure SonarQube using the following environment variables in the `.env` file:

```dotenv
# SonarQube version
SONAR_VERSION=latest

# Directory configuration (default values)
SONAR_DIR=./sonar-data

# Database configuration
SONAR_JDBC_URL=jdbc:postgresql://db:5432/sonar
SONAR_JDBC_USERNAME=sonar
SONAR_JDBC_PASSWORD=sonar

# SonarQube configuration
SONAR_WEB_JAVAOPTS=-Xmx512m -Xms128m -XX:+HeapDumpOnOutOfMemoryError
SONAR_SEARCH_JAVAOPTS=-Xmx512m -Xms512m -XX:+HeapDumpOnOutOfMemoryError
```

### Directory Structure

The initialization script creates the following directory structure:
```
sonar-data/
├── data/       # SonarQube data
├── logs/       # Log files
└── extensions/ # Custom extensions
```

## 🛠️ Maintenance

### Restart services
```bash
docker compose restart
```

### Stop services
```bash
docker compose down
```

### View logs
```bash
docker compose logs -f
```

## 🔒 Security

- Change default credentials on first login
- Do not expose port 9000 to the internet without additional security configuration
- Configure HTTPS for production use

## 📄 License

MIT