package com.roshka.bootcamp.beans;

import java.sql.*;

public class Conexion {
    final String url = "jdbc:postgresql://localhost:5432/bc_market";
    final String user = "postgres";
    final String pass = "hola123";

    Connection connection;

    public Conexion () {
        connection = null;
    }

    public void abrir() {
        try {
            Class.forName("org.postgresql.Driver");
            connection = DriverManager.getConnection(this.url, this.user, this.pass);
        } catch (Exception e) {
            e.printStackTrace();
            System.err.println(e.getClass().getName() + " : " + e.getMessage());
            System.exit(0);
        }
    }

    public boolean isOpen() {
        return connection != null;
    }

    public ResultSet consultar(String sql) {

        try {
            if(!isOpen()) {
                throw new Exception("No existe conexion");
            }

            ResultSet rs = null;
            Statement stmt = connection.createStatement();

            rs = stmt.executeQuery(sql);

            return rs;
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }

    public void cerrar() {
        if(connection != null) {
            try {
                connection.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
    }
}
