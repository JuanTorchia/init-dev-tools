# Init Dev Tools

InitDevTools es una colección de scripts diseñados para facilitar la configuración inicial de entornos de desarrollo en múltiples sistemas operativos. Este proyecto sigue principios de diseño como SOLID para garantizar scripts mantenibles y extensibles.

## Estructura de Directorios

- **/bin/**: Contiene scripts ejecutables autónomos para tareas como instalación de software y configuración de servicios.
- **/config/**: Almacena archivos de configuración, separando la configuración del código para mayor claridad.
- **/lib/**: Incluye bibliotecas o utilidades comunes que ayudan a evitar la duplicación y facilitan actualizaciones.
- **/logs/**: Directorio para archivos de registro, útil para seguimiento de operaciones y depuración de errores.
- **/scripts/**: Contiene scripts de alto nivel que coordinan múltiples tareas de instalación y configuración.

## Principios de Diseño Aplicados

- **Single Responsibility**: Cada script en `/bin/` se enfoca en una sola tarea. Por ejemplo, `install_git.sh` solo instala Git.
- **Open/Closed**: Los scripts en `/lib/` se pueden extender sin necesidad de modificar el código existente.
- **Dependency Inversion**: Los scripts en `/scripts/` dependen de abstracciones y no de implementaciones concretas, facilitando pruebas y reutilización.
- **Separation of Concerns**: La estructura separa configuración, utilidades y lógica de ejecución para permitir modificaciones independientes.

## Instalación y Uso

Clona el repositorio para comenzar a utilizar InitDevTools:

```bash
git clone https://github.com/usuario/InitDevTools.git
cd InitDevTools
./scripts/master_install.sh

