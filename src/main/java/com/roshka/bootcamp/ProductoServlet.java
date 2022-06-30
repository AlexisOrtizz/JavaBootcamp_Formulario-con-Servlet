package com.roshka.bootcamp;

import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletConfig;
import jakarta.servlet.ServletContext;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import javax.swing.plaf.nimbus.State;
import java.io.IOException;
import java.sql.*;

@WebServlet(urlPatterns = "/frmProducto")
public class ProductoServlet extends HttpServlet {
    Connection connection;

    public void init(ServletConfig config) {
        ServletContext context = config.getServletContext();

        try {
            Class.forName("org.postgresql.Driver");
            connection = DriverManager.
                    getConnection(context.getInitParameter("dbUrl"),
                            context.getInitParameter("dbUser"),
                            context.getInitParameter("dbPassword"));
        } catch (Exception e) {
            e.printStackTrace();
            System.err.println(e.getClass().getName() + ": " + e.getMessage());
            System.exit(0);
        }
    }

    @Override
    public void doGet(HttpServletRequest request, HttpServletResponse response) {
        try {
            Statement stmt = connection.createStatement();
            ResultSet rs = stmt.executeQuery("SELECT p.id, 'Producto: ' || p.nombre || '. Proveedor: ' || pv.nombre proveedor\n" +
                                                "FROM producto p\n" +
                                                "\tJOIN proveedor pv ON p.proveedor_id = pv.id\n" +
                                                "ORDER BY p.id;");

            request.setAttribute("proveedores", rs);

            RequestDispatcher dispatcher = request.getRequestDispatcher("frmProducto.jsp");
            dispatcher.forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    @Override
    public void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String operacion = request.getParameter("operacion");

        if(operacion.equals("agregar")) {
            System.out.println("Agregar elemento");

            try {
                Statement stmt = connection.createStatement();
                ResultSet rs = stmt.executeQuery("SELECT MAX(id) + 1 AS id FROM producto;");
                int id;

                if(rs.next()) {
                    id = rs.getInt("id");
                } else {
                    throw new IOException();
                }

                String nombre = request.getParameter("inputNombre");
                int precio = Integer.parseInt(request.getParameter("inputPrecio"));
                int proveedor = Integer.parseInt(request.getParameter("inputProveedor"));
                int costo = Integer.parseInt(request.getParameter("inputCosto"));

                String sql = "INSERT INTO producto (id, nombre, precio, proveedor_id, costo)" +
                        "\tVALUES (" + id + ",'" +nombre + "'," + precio + "," + proveedor + "," + costo + ");";

                System.out.println(sql);
                stmt.execute(sql);

                stmt.close();
                rs.close();

                RequestDispatcher dispatcher = request.getRequestDispatcher("/listaProductos");
                dispatcher.forward(request, response);
            } catch (Exception e) {
                e.printStackTrace();
                RequestDispatcher rd = request.getRequestDispatcher("mensajeError.html");
                rd.include(request, response);
            }
        } else if(operacion.equals("modificar")) {
            System.out.println("Modificar elemento");

            try {
                Statement stmt = connection.createStatement();

                int id = Integer.parseInt(request.getParameter("inputId"));
                String nombre = request.getParameter("inputNombre");
                int precio = Integer.parseInt(request.getParameter("inputPrecio"));
                int costo = Integer.parseInt(request.getParameter("inputCosto"));

                String sql = "UPDATE producto SET nombre = '" + nombre +
                            "', precio = " + precio + ", costo = " + costo + " WHERE id = " + id + ";";

                System.out.println(sql);
                stmt.execute(sql);

                stmt.close();

                RequestDispatcher dispatcher = request.getRequestDispatcher("/listaProductos");
                dispatcher.forward(request, response);
            } catch (Exception e) {
                e.printStackTrace();
                RequestDispatcher rd = request.getRequestDispatcher("mensajeError.html");
                rd.include(request, response);
            }
        } else if(operacion.equals("eliminar")) {
            System.out.println("Eliminar elemento");

            try {
                Statement stmt = connection.createStatement();

                int id = Integer.parseInt(request.getParameter("inputId"));

                String sql = "DELETE FROM producto WHERE id = " + id + ";";

                System.out.println(sql);
                stmt.execute(sql);

                stmt.close();

                RequestDispatcher dispatcher = request.getRequestDispatcher("/listaProductos");
                dispatcher.forward(request, response);
            } catch (Exception e) {
                e.printStackTrace();
                RequestDispatcher rd = request.getRequestDispatcher("mensajeError.html");
                rd.include(request, response);
            }
        } else {
            System.out.println("La operacion no tiene ningun valor");
        }
    }

    @Override
    public void destroy() {
        try {
            connection.close();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
}
