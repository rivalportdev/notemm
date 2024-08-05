#!/bin/bash

# Incluir el archivo de funciones
source ./functions.sh

# Definir variables específicas del script
DIRECTORIO="../notes"
fecha_actual=$(date +"%Y-%m-%d")

# Procesar opciones de línea de comandos
while [[ "$1" != "" ]]; do
  case $1 in
  -h | --help)
    mostrar_ayuda
    exit 0
    ;;
  -v | --version)
    echo -e "${YELLOW}Versión 1.0${NC}"
    exit 0
    ;;
  -d | --directory)
    shift
    DIRECTORIO="$1"
    ;;
  -r | --remove)
    shift
    tipo="$1"
    read -p "Especifique el nombre del grupo o nota a eliminar: " nombre
    eliminar_item "$tipo" "$nombre"
    exit 0
    ;;
  -o | --open)
    shift
    tipo="$1"
    read -p "Especifique el nombre del grupo o nota a abrir: " nombre
    abrir_item "$tipo" "$nombre"
    exit 0
    ;;
  *)
    echo -e "${RED}Opción inválida: $1${NC}"
    mostrar_ayuda
    exit 1
    ;;
  esac
  shift
done

# Asegurarse de que el archivo de funciones está incluido
if [ ! -f ./functions.sh ]; then
  echo -e "${RED}El archivo de funciones no se encuentra en ./functions.sh${NC}"
  exit 1
fi

# Flujo principal del script
obtener_titulo
obtener_contenido
seleccionar_grupo
guardar_nota
