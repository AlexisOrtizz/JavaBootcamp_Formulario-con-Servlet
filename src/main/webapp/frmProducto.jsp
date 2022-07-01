<%@page import="java.sql.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Bootstrap</title>
    <!-- Bootstrap js-->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/js/bootstrap.bundle.min.js" integrity="sha384-MrcW6ZMFYlzcLA8Nl+NtUVF0sA7MsXsP1UyJoMp4YLEuNSfAP+JcXn/tWtIaxVXM" crossorigin="anonymous"></script>    <!-- CSS only -->
    <!-- Boostrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.0-beta1/dist/css/bootstrap.min.css"
        rel="stylesheet"
        integrity="sha384-0evHe/X+R7YkIZDRvuzKMRqM+OrBnVFBL6DOitfPri4tjfHxaWutUpFmBp4vmVor"
        crossorigin="anonymous">
    <!-- COSTUM CSS -->
    <link rel="stylesheet" href="style.css">
    <!-- Pagina de gradientes: https://uigradients.com/#ManofSteel -->
</head>
<body>
    <%
        Connection connection = null;
        Statement stmt = null;
        ResultSet rs = null;

        try {
            Class.forName("org.postgresql.Driver");
            connection = DriverManager.getConnection("jdbc:postgresql://localhost:5432/bc_market",
                                                     "postgres", "hola123");
            stmt = connection.createStatement();
            rs = stmt.executeQuery("SELECT id, id || '. ' || nombre AS proveedor FROM proveedor ORDER BY id;");
        } catch(Exception e) {
            e.printStackTrace();
            System.err.println(e.getClass().getName() + " : " + e.getMessage());
            System.exit(0);
        }
    %>
    <nav class="navbar navbar-expand-lg navbar-dark bg-dark">
        <div class="container-fluid">
          <a class="navbar-brand" href="./">Inicio</a>
          <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav" aria-controls="navbarNav" aria-expanded="false" aria-label="Toggle navigation">
            <span class="navbar-toggler-icon"></span>
          </button>
          <div class="collapse navbar-collapse" id="navbarNav">
            <ul class="navbar-nav ms-auto">
                <li class="nav-item">
                    <a class="nav-link" href="./frmCliente.html">Clientes</a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" href="./frmMoneda.html">Monedas</a>
                </li>
                <li class="nav-item">
                    <a class="nav-link active" aria-current="page" href="./frmProducto">Productos</a>
                </li>
            </ul>
          </div>
        </div>
      </nav>
    <div class="container my-3"> <!-- my: margin eje y || py: padding eje y -->
        <div class="row">
            <div class="col-sm-12 col-md-4 col-lg-4 col-xl-4 bg-while py-4">
                <h2>Agregar producto</h2>
                <form method="post" action="frmProducto">
                    <div class="mb-3"> <!-- margen button -->
                        <label for="inputNombre1" class="form-label">Producto</label>
                        <input type="text" class="form-control" id="inputNombre1" name="inputNombre" placeholder="Introduzca nombre del producto" autofocus>
                    </div>
                    <div class="mb-3"> <!-- margen button -->
                        <label for="inputPrecio1" class="form-label">Precio</label>
                        <input type="text" class="form-control" id="inputPrecio1" name="inputPrecio" placeholder="Introduzca su precio">
                    </div>
                    <div class="mb-3"> <!-- margen button -->
                        <label for="inputProveedor1" class="form-label">Proveedor</label>
                        <select id="inputProveedor1" class="form-select" size="3" aria-label="size 3 select example" name="inputProveedor">
                            <option selected>Seleccione el proveedor</option>
                            <%
                                while(rs.next()) {
                            %>
                                <option value=<%= String.valueOf("\"" + rs.getInt("id") + "\"") %>><%= rs.getString("proveedor") %></option>
                            <%
                                }
                            %>
                        </select>
                    </div>
                    <div class="mb-3"> <!-- margen button -->
                        <label for="inputCosto1" class="form-label">Costo</label>
                        <input type="text" class="form-control" id="inputCosto1" name="inputCosto" placeholder="Introduzca su moneda">
                    </div>
                    <input type="text" name="operacion" value="agregar" style="visibility:hidden">
                    <div class="d-grid gap-2">
                        <button class="btn btn-success">Agregar Producto</button>
                    </div>
                </form>
            </div>
            <div class="col-sm-12 col-md-4 col-lg-4 col-xl-4 bg-while py-4">
                <h2>Modificar producto</h2>
                <form method="post" action="frmProducto">
                    <div class="mb-3"> <!-- margen button -->
                        <label for="inputId2" class="form-label">ID</label>
                        <input type="number" class="form-control" id="inputId2" name="inputId" placeholder="Id producto">
                    </div>
                    <div class="mb-3"> <!-- margen button -->
                        <label for="inputNombre2" class="form-label">Producto</label>
                        <input type="text" class="form-control" id="inputNombre2" name="inputNombre" placeholder="Introduzca nombre del producto" autofocus>
                    </div>
                    <div class="mb-3"> <!-- margen button -->
                        <label for="inputPrecio2" class="form-label">Precio</label>
                        <input type="text" class="form-control" id="inputPrecio2" name="inputPrecio" placeholder="Introduzca su precio">
                    </div>
                    <div class="mb-3"> <!-- margen button -->
                        <label for="inputCosto2" class="form-label">Costo</label>
                        <input type="text" class="form-control" id="inputCosto2" name="inputCosto" placeholder="Introduzca su costo">
                    </div>
                    <input type="text" name="operacion" value="modificar" style="visibility:hidden">
                    <div class="d-grid gap-2">
                        <button class="btn btn-warning">Modificar Producto</button>
                    </div>
                </form>
            </div>
            <div class="col-sm-12 col-md-4 col-lg-4 col-xl-4 bg-while py-4">
                <h2>Eliminar producto</h2>
                <form method="post" action="frmProducto">
                    <div class="mb-3"> <!-- margen button -->
                        <label for="inputId3" class="form-label">ID</label>
                        <input type="number" class="form-control" id="inputId3" name="inputId" placeholder="Id producto">
                    </div>
                    <input type="text" name="operacion" value="eliminar" style="visibility:hidden">
                    <div class="d-grid gap-2">
                        <button class="btn btn-danger">Eliminar Producto</button>
                    </div>
                </form>
            </div>
        </div>
    </div>
    <%
        try {
            rs.close();
            stmt.close();
            connection.close();
        } catch (Exception e) {
            e.printStackTrace();
        }
    %>
</body>
</html>