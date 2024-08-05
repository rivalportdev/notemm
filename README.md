# Notas Master Manager (notemm)

`notemm` (Notas Master Manager) es una herramienta de línea de comandos para gestionar notas y grupos de notas. Permite crear, leer, y eliminar notas, así como gestionar grupos de notas en un directorio específico.

## Tabla de Contenidos

- [Notas Master Manager (notemm)](#notas-master-manager-notemm)
  - [Tabla de Contenidos](#tabla-de-contenidos)
  - [Instalación](#instalación)
  - [Uso Global](#uso-global)
  - [Uso](#uso)
    - [Opciones](#opciones)
    - [Ejemplos](#ejemplos)
  - [Contribución](#contribución)
  - [Licencia](#licencia)

## Instalación

1. **Clona el repositorio**:

   ```bash
   git clone https://github.com/rivalportdev/notemm.git
   ```

2. **Accede al directorio del script**:

   ```bash
   cd ./scripts
   ```

3. **Haz el script ejecutable**:

   ```bash
   chmod +x notemm.sh
   ```

4. **Ejecuta el script**:

   ```bash
   ./notemm.sh
   ```

## Uso Global

Para ejecutar el programa globalmente, sigue estos pasos:

1. **Mueve el script al directorio binario para un acceso global**:

   ```bash
   sudo mv notemm.sh /usr/local/bin/notemm
   ```

2. **Cambia la dirección del archivo de las funciones**:

   Abre el archivo `notemm` (anteriormente `notemm.sh`) en un editor de texto y actualiza la línea que incluye `functions.sh`:

   ```bash
   source /ruta/a/tu/functions.sh
   ```

   Reemplaza `/ruta/a/tu/` con la ruta real donde se encuentra `functions.sh`.

3. **(Opcional) Crear un alias** en tu archivo de configuración del shell (`~/.bashrc`, `~/.zshrc`, etc.):

   ```bash
   alias notemm='/usr/local/bin/notemm'
   ```

   Luego, recarga el archivo de configuración:

   ```bash
   source ~/.bashrc  # o ~/.zshrc
   ```

Para ejecutar el programa, usa el comando `notemm` seguido de las opciones y argumentos necesarios.

## Uso

Para ejecutar el programa, usa el comando `notemm` si lo configuraste globalmente, o ejecuta el script directamente desde su ubicación con `./notemm.sh` seguido de las opciones y argumentos necesarios.

### Opciones

- `-h`, `--help`  
  Muestra la ayuda sobre el uso del programa.

- `-v`, `--version`  
  Muestra la versión del programa.

- `-d`, `--directory <directorio>`  
  Especifica el directorio donde se encuentran los grupos de notas.

- `-r`, `--remove <tipo>`  
  Elimina un grupo o una nota. Debes proporcionar el nombre del grupo o nota a eliminar.

- `-o`, `--open <tipo>`  
  Abre una nota para su visualización y edición. Debes especificar si es una nota o un grupo y el nombre correspondiente.

### Ejemplos

1. **Crear una nota**:

   ```bash
   notemm # o ejecuta el script ./notemm.sh
   ```

   Sigue las instrucciones para ingresar el título y el contenido de la nota. Selecciona un grupo existente o crea uno nuevo.

2. **Eliminar una nota**:

   ```bash
   notemm -r file
   ```

   Luego ingresa el nombre de la nota a eliminar.

3. **Abrir una nota para editarla**:

   ```bash
   notemm -o file
   ```

   Luego ingresa el nombre de la nota que deseas abrir.

## Contribución

Si deseas contribuir al desarrollo de `notemm`, por favor sigue estos pasos:

1. Haz un fork del repositorio.
2. Crea una rama para tu funcionalidad o corrección de errores.
3. Realiza tus cambios y haz un commit.
4. Envía un pull request con una descripción detallada de los cambios.

## Licencia

Este proyecto está licenciado bajo la Licencia MIT - consulta el archivo [LICENSE](LICENSE) para más detalles.

---

¡Gracias por usar Notas Master Manager!
