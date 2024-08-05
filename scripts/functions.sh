#!/bin/bash

# Definir colores
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # Sin color

# Función para mostrar un mensaje de error y salir
mostrar_error() {
  echo -e "${RED}$1${NC}"
  exit 1
}

# Función para mostrar el mensaje de ayuda
mostrar_ayuda() {
  echo -e "${YELLOW}Uso: $0 [opción]${NC}"
  echo -e "${YELLOW}Opciones:${NC}"
  echo -e "  ${BLUE}-h, --help${NC}                    Muestra este mensaje de ayuda."
  echo -e "  ${BLUE}-v, --version${NC}                 Muestra la versión del script."
  echo -e "  ${BLUE}-d, --directory [directorio]${NC}  Especifica el directorio para guardar las notas."
  echo -e "  ${BLUE}-r, --remove [tipo]${NC}           Eliminar una nota o un grupo."
  echo -e "  ${BLUE}-o, --open [tipo]${NC}             Abrir una nota o un grupo."
  echo -e ""
  echo -e "${YELLOW}Descripción:${NC}"
  echo -e "Este script permite gestionar notas organizadas en grupos."
  echo -e "Puedes crear notas, seleccionar grupos y gestionar la información."
}

# Función para seleccionar un grupo
seleccionar_grupo() {
  IFS=$'\n' grupos=($(find "$DIRECTORIO" -maxdepth 1 -mindepth 1 -type d -exec basename {} \;))
  unset IFS

  if [ ${#grupos[@]} -eq 0 ]; then
    echo -e "${RED}No hay grupos disponibles.${NC}"
    echo -e "${BLUE}Cree uno seleccionando la opción 'Nuevo Grupo' o seleccione 'Cancelar'.${NC}"
  fi

  echo -e "${YELLOW}\nSeleccione un grupo:${NC}"
  select grupo in "${grupos[@]}" "Nuevo Grupo" "Cancelar"; do
    case $grupo in
    "Cancelar")
      mostrar_error "Selección cancelada."
      ;;
    "Nuevo Grupo")
      crear_nuevo_grupo
      break
      ;;
    *)
      if es_grupo_valido "$grupo"; then
        break
      else
        echo -e "${RED}Opción inválida. Por favor, elige una opción válida.${NC}"
      fi
      ;;
    esac
  done
}

# Función para crear un nuevo grupo
crear_nuevo_grupo() {
  echo -e "\n${YELLOW}Escribe el nombre del nuevo grupo:${NC}"
  read -r nuevo_grupo
  if [ -n "$nuevo_grupo" ] && [[ ! " ${grupos[@]} " =~ " ${nuevo_grupo} " ]]; then
    mkdir -p "$DIRECTORIO/$nuevo_grupo"
    grupos+=("$nuevo_grupo")
    grupo="$nuevo_grupo"
    echo -e "${GREEN}Grupo $nuevo_grupo creado exitosamente.${NC}"
  else
    echo -e "${RED}El grupo ya existe o el nombre es inválido.${NC}"
  fi
}

# Función para verificar si un grupo es válido
es_grupo_valido() {
  for g in "${grupos[@]}"; do
    if [ "$g" == "$1" ]; then
      return 0
    fi
  done
  return 1
}

# Función para obtener el título del usuario
obtener_titulo() {
  echo -e "\n${YELLOW}Escribe el título de la nota:${NC}"
  read -r titulo
}

# Función para obtener el contenido usando vim
obtener_contenido() {
  temp_file=$(mktemp)
  echo -e "\n${YELLOW}Escribe el contenido de la nota (presiona Ctrl+S para guardar y salir de vim):${NC}"
  read -p "Presiona Enter para abrir vim..."
  echo ""
  vim -c 'set fillchars=fold:\ ,eob:\ ' -c 'startinsert' -c 'imap <C-S> <Esc>:wq<CR>' "$temp_file"
  contenido=$(<"$temp_file")
  rm "$temp_file"
}

# Función para guardar la nota
guardar_nota() {
  if [ -z "$grupo" ] || [ -z "$titulo" ] || [ -z "$contenido" ]; then
    mostrar_error "Todos los campos son obligatorios."
  fi

  if [ -z "$(find "$DIRECTORIO" -type d -name "$grupo")" ]; then
    mostrar_error "El grupo no existe."
  else
    echo "$contenido" >"$DIRECTORIO/$grupo/$titulo.txt"
    echo -e "\nNota creada $fecha_actual" >>"$DIRECTORIO/$grupo/$titulo.txt"
    echo -e "${GREEN}Nota guardada exitosamente en $DIRECTORIO/$grupo/$titulo.txt${NC}"
  fi
}

# Función para eliminar una nota o un grupo
eliminar_item() {
  if [ "$1" == "nota" ]; then
    # Buscar en todos los grupos
    for grupo in $(find "$DIRECTORIO" -maxdepth 1 -mindepth 1 -type d -exec basename {} \;); do
      nota="$DIRECTORIO/$grupo/$2"
      if [ -f "$nota" ]; then
        rm "$nota"
        echo -e "${GREEN}Nota eliminada exitosamente.${NC}"
        return
      fi
    done
    mostrar_error "La nota no existe en ningún grupo."
  elif [ "$1" == "grupo" ]; then
    if [ -d "$DIRECTORIO/$2" ]; then
      rm -r "$DIRECTORIO/$2"
      echo -e "${GREEN}Grupo eliminado exitosamente.${NC}"
    else
      mostrar_error "El grupo no existe."
    fi
  else
    mostrar_error "Tipo de eliminación no válido."
  fi
}

# Función para abrir una nota o un grupo
abrir_item() {
  if [ "$1" == "nota" ]; then
    # Buscar en todos los grupos
    for grupo in $(find "$DIRECTORIO" -maxdepth 1 -mindepth 1 -type d -exec basename {} \;); do
      nota="$DIRECTORIO/$grupo/$2"
      if [ -f "$nota" ]; then
        vim -c 'set fillchars=fold:\ ,eob:\ ' -c 'startinsert' -c 'imap <C-S> <Esc>:wq<CR>' "$nota"
        echo -e "${GREEN}Nota actualizada exitosamente en $nota...${NC}"
        return
      fi
    done
    mostrar_error "La nota no existe en ningún grupo."
  elif [ "$1" == "grupo" ]; then
    if [ -d "$DIRECTORIO/$2" ]; then
      echo -e "${GREEN}Abriendo el grupo $2...${NC}"
      ls -l "$DIRECTORIO/$2"
    else
      mostrar_error "El grupo no existe."
    fi
  else
    mostrar_error "Tipo de apertura no válido."
  fi
}
