- Sistema de Control de Inventario – TecnoStock

Aplicación web desarrollada en PHP 8 (PDO), MySQL, HTML5, Bootstrap 5 y JavaScript sobre servidor local XAMPP, diseñada para centralizar el catálogo de productos y controlar los movimientos de existencias de TecnoStock.

-----

1. Análisis del Problema y Alcance

* Problemática actual: TecnoStock comercializa accesorios tecnológicos y registra su inventario manualmente en planillas, lo que genera códigos duplicados, inconsistencias en las cantidades disponibles y falta de visibilidad sobre el stock real.
* Solución propuesta: Sistema web local que centraliza el catálogo de productos, controla entradas y salidas de inventario mediante trazabilidad por usuario y alerta visualmente cuando un producto cae bajo su stock mínimo.
* Alcance del MVP: Sistema monousuario por sesión (sin frameworks externos) orientado a la gestión operativa del catálogo, control de existencias y desactivación lógica de artículos discontinuados.

2. Actor Principal

* Encargado de inventario: Usuario autenticado responsable de administrar categorías, registrar y editar productos, consultar existencias, desactivar productos sin vigencia y registrar movimientos de entrada y salida.

3. Requerimientos Funcionales (RF)

* RF-01 Autenticación: Iniciar y cerrar sesión mediante correo y contraseña encriptada.
* RF-02 Registro de productos: Crear productos con código único, nombre, categoría, descripción, precio, stock actual y stock mínimo.
* RF-03 Consulta y búsqueda: Visualizar el listado de productos y filtrar por código, nombre o categoría.
* RF-04 Edición de productos: Actualizar precio, descripción, categoría y parámetros de stock de un producto existente.
* RF-05 Desactivación lógica: Cambiar el estado de un producto a inactivo cuando deja de comercializarse, preservando su historial.
* RF-06 Registro de movimientos: Registrar entradas y salidas de inventario indicando cantidad y observación.
* RF-07 Actualización automática: Incrementar o descontar el stock actual automáticamente tras cada movimiento válido.
* RF-08 Alerta de stock bajo: Mostrar un indicador visual destacado cuando `stock_actual < stock_minimo`.

4. Reglas de Negocio (RN)

* RN-01 Unicidad de código: No se permiten dos productos con el mismo código (`UNIQUE`).
* RN-02 Valores no negativos: El precio, el stock actual, el stock mínimo y la cantidad de cada movimiento deben ser mayores o iguales a cero (y cantidad > 0 en movimientos).
* RN-03 Trazabilidad obligatoria: Todo movimiento registra automáticamente fecha/hora, tipo (`entrada` o `salida`), cantidad, producto afectado y usuario responsable de la sesión.
* RN-04 Protección contra stock negativo: El sistema impide registrar una salida si la cantidad solicitada supera el `stock_actual` disponible.
* RN-05 Integridad histórica (borrado lógico): Los productos con movimientos asociados no se eliminan físicamente (`DELETE`), sino que se desactivan (`estado = 0`).
* RN-06 Consistencia transaccional: La inserción de un movimiento y la actualización del stock del producto ocurren de forma atómica.

5. Estructura del Proyecto

* `base_datos.sql`: Script reproducible con creación de base de datos, tablas, restricciones y datos iniciales.
* `conexion.php`: Conexión segura a MySQL mediante PDO y consultas preparadas.
* `login.php` / `logout.php`: Control de acceso y gestión de sesiones.
* `productos.php`: Listado general, buscador multicriterio y alertas de stock bajo.
* `crear_producto.php` / `editar_producto.php`: Formularios con doble validación (JS + PHP).
* `cambiar_estado.php`: Desactivación y reactivación lógica de productos.
* `movimientos.php`: Registro e historial de entradas y salidas de inventario.