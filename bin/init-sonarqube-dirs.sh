#!/bin/bash

set -e

# Colores para la salida
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# Función para mostrar mensajes de error
function error_exit {
    echo -e "${RED}❌ Error: $1${NC}" >&2
    exit 1
}

# Función para mostrar mensajes informativos
function info {
    echo -e "${GREEN}ℹ️  $1${NC}"
}

# Función para extraer valores por defecto de docker-compose.yml
function get_docker_compose_default() {
    local var_name=$1
    local default_value=$2
    
    # Buscar en docker-compose.yml
    if [ -f docker-compose.yml ]; then
        # Extraer la línea que contiene el valor por defecto
        local line
        line=$(grep -oP "${var_name}:-[^}]*" docker-compose.yml 2>/dev/null | head -1 || echo "")
        
        # Extraer solo el valor por defecto (lo que está después de ':-' y antes de '}')
        if [[ "$line" =~ :-([^}]+) ]]; then
            echo "${BASH_REMATCH[1]}"
            return 0
        fi
    fi
    
    # Si no se encontró en docker-compose.yml, usar el valor por defecto
    echo "$default_value"
}

# Cargar variables desde .env si existe
if [ -f .env ]; then
    info "Cargando variables de entorno desde .env..."
    export $(grep -v '^#' .env | xargs) || error_exit "Error al cargar el archivo .env"
else
    info "No se encontró el archivo .env, usando valores por defecto de docker-compose.yml..."
    # Obtener valores por defecto de docker-compose.yml
    SONAR_DIR_DEFAULT="./sonar-data"
    SONAR_DIR=$(get_docker_compose_default "SONAR_DIR" "$SONAR_DIR_DEFAULT")
    
    # Mostrar valores que se están utilizando
    info "Usando configuración por defecto:"
    echo "  - SONAR_DIR=${SONAR_DIR}"
fi

# Validar variables requeridas
required_vars=("SONAR_DIR")
for var in "${required_vars[@]}"; do
    if [ -z "${!var}" ]; then
        error_exit "La variable $var no está definida. Por favor, defínela en .env o en las variables de entorno."
    fi
done

# Definir rutas de directorios
SONAR_DATA_DIR="${SONAR_DIR}/data"
SONAR_LOGS_DIR="${SONAR_DIR}/logs"
SONAR_EXTENSIONS_DIR="${SONAR_DIR}/extensions"

info "📂 Creando directorios requeridos..."
for dir in "$SONAR_DATA_DIR" "$SONAR_LOGS_DIR" "$SONAR_EXTENSIONS_DIR"; do
    if [ ! -d "$dir" ]; then
        echo "  - Creando directorio: $dir"
        mkdir -p "$dir" || error_exit "No se pudo crear el directorio $dir"
    else
        echo "  - El directorio ya existe: $dir"
    fi
done

info "🔐 Ajustando permisos y propietario..."
# Aplicar propietario 1000:1000 (usuario por defecto de SonarQube en el contenedor)
if command -v sudo >/dev/null 2>&1; then
    sudo chown -R 1000:1000 "$SONAR_DIR" || error_exit "Error al cambiar el propietario de los directorios"
else
    chown -R 1000:1000 "$SONAR_DIR" 2>/dev/null || \
        echo -e "${YELLOW}⚠️  Advertencia: No se pudo cambiar el propietario. Es posible que necesites ejecutar con sudo.${NC}"
fi

# Aplicar permisos 700
chmod -R 700 "$SONAR_DIR" || error_exit "Error al ajustar permisos"

# Verificar que los directorios tienen los permisos correctos
for dir in "$SONAR_DATA_DIR" "$SONAR_LOGS_DIR" "$SONAR_EXTENSIONS_DIR"; do
    if [ ! -w "$dir" ]; then
        echo -e "${YELLOW}⚠️  Advertencia: No se tienen permisos de escritura en $dir${NC}"
    fi
done

info "✅ Configuración completada correctamente."
echo "   - Directorio de datos: $SONAR_DATA_DIR"
echo "   - Directorio de logs: $SONAR_LOGS_DIR"
echo "   - Directorio de extensiones: $SONAR_EXTENSIONS_DIR"
