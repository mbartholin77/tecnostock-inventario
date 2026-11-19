<?php
// login.php
session_start();

if (isset($_SESSION['id_usuario'])) {
    header('Location: productos.php');
    exit;
}

require_once 'conexion.php';

$error = '';
$correoIngresado = '';

if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    $correoIngresado = trim($_POST['correo'] ?? '');
    $claveIngresada = $_POST['clave'] ?? '';

    if (!filter_var($correoIngresado, FILTER_VALIDATE_EMAIL) || $claveIngresada === '') {
        $error = 'Ingrese un correo válido y su contraseña.';
    } else {
        try {
            $sql = 'SELECT id_usuario, nombre, correo, clave, estado 
                    FROM usuarios 
                    WHERE correo = :correo 
                    LIMIT 1';
            $sentencia = $pdo->prepare($sql);
            $sentencia->execute([':correo' => $correoIngresado]);
            $usuario = $sentencia->fetch();

            if ($usuario && (int)$usuario['estado'] === 1 && password_verify($claveIngresada, $usuario['clave'])) {
                session_regenerate_id(true);
                $_SESSION['id_usuario'] = (int)$usuario['id_usuario'];
                $_SESSION['nombre_usuario'] = $usuario['nombre'];
                $_SESSION['correo_usuario'] = $usuario['correo'];

                header('Location: productos.php');
                exit;
            } else {
                $error = 'Credenciales incorrectas o usuario inactivo.';
            }
        } catch (PDOException $e) {
            $error = 'Error al procesar el inicio de sesión.';
        }
    }
}
?>
<!doctype html>
<html lang="es">
<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Iniciar Sesión - TecnoStock</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body class="bg-light d-flex align-items-center min-vh-100">
    <main class="container">
        <div class="card shadow-sm mx-auto" style="max-width: 420px;">
            <div class="card-body p-4">
                <h1 class="h4 text-center mb-1">TecnoStock</h1>
                <p class="text-secondary text-center small mb-4">Control de Inventario · Acceso al Sistema</p>

                <?php if ($error !== ''): ?>
                    <div class="alert alert-danger py-2" role="alert">
                        <?= htmlspecialchars($error, ENT_QUOTES, 'UTF-8') ?>
                    </div>
                <?php endif; ?>

                <?php if (isset($_GET['cerrada'])): ?>
                    <div class="alert alert-info py-2" role="alert">
                        Sesión cerrada correctamente.
                    </div>
                <?php endif; ?>

                <form id="formLogin" action="login.php" method="post" novalidate>
                    <div class="mb-3">
                        <label for="correo" class="form-label">Correo electrónico</label>
                        <input type="email"
                               class="form-control"
                               id="correo"
                               name="correo"
                               value="<?= htmlspecialchars($correoIngresado, ENT_QUOTES, 'UTF-8') ?>"
                               placeholder="encargado@tecnostock.cl"
                               required>
                        <div class="invalid-feedback">Ingrese un correo electrónico válido.</div>
                    </div>

                    <div class="mb-4">
                        <label for="clave" class="form-label">Contraseña</label>
                        <input type="password"
                               class="form-control"
                               id="clave"
                               name="clave"
                               minlength="4"
                               required>
                        <div class="invalid-feedback">Ingrese su contraseña.</div>
                    </div>

                    <button type="submit" class="btn btn-primary w-100">Ingresar</button>
                </form>

                <hr class="my-3">
                <p class="text-muted small mb-0 text-center">
                    Usuario de prueba: <strong>encargado@tecnostock.cl</strong><br>
                    Contraseña: <strong>password</strong>
                </p>
            </div>
        </div>
    </main>

    <script>
        document.getElementById('formLogin').addEventListener('submit', function (evento) {
            if (!this.checkValidity()) {
                evento.preventDefault();
                evento.stopPropagation();
            }
            this.classList.add('was-validated');
        });
    </script>
</body>
</html>