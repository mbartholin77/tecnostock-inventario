<?php
// index.php
session_start();

if (isset($_SESSION['id_usuario'])) {
    header('Location: productos.php');
} else {
    header('Location: login.php');
}
exit;