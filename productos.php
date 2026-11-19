<?php
// productos.php (vista temporal para verificar sesión)
require_once 'verificar_sesion.php';
?>
<!doctype html>
<html lang="es">
<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Inventario - TecnoStock</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body class="bg-light">
    <nav class="navbar navbar-dark bg-dark">
        <div class="container">
            <span class="navbar-brand mb-0 h1">TecnoStock · Inventario</span>
            <div class="d-flex align-items-center gap-3 text-white">
                <span class="small">Hola, <?= htmlspecialchars($_SESSION['nombre_usuario'], ENT_QUOTES, 'UTF-8') ?></span>
                <a href="logout.php" class="btn btn-outline-light btn-sm">Cerrar sesión</a>
            </div>
        </div>
    </nav>

    <main class="container py-4">
        <div class="alert alert-success">
            Conexión a MySQL e inicio de sesión funcionando correctamente.
        </div>
    </main>
</body>
</html>