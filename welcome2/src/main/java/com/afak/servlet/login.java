package com.afak.servlet;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

@WebServlet("/login")
public class login extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
            // Load the MySQL JDBC driver
            Class.forName("com.mysql.cj.jdbc.Driver");

            String username = request.getParameter("login-email");
            String password = request.getParameter("login-password");

            // Establish a database connection
            String url = "jdbc:mysql://localhost:3307/whatsapp";
            String dbUsername = "root";
            String dbPassword = "root";
            Connection connection = DriverManager.getConnection(url, dbUsername, dbPassword);

            // Query the database to check for a user
            String query = "SELECT * FROM users WHERE username = ? AND password = ?";
            PreparedStatement preparedStatement = connection.prepareStatement(query);
            preparedStatement.setString(1, username);
            preparedStatement.setString(2, password);

            ResultSet resultSet = preparedStatement.executeQuery();

            if (resultSet.next()) {
                // User authentication is successful
                // Store the username in a session attribute
                String uniqueId = resultSet.getString("unique_id");
                request.getSession().setAttribute("username", username);
                request.getSession().setAttribute("uniqueId", uniqueId);
                response.sendRedirect("whatsapp1");
            } else {
                response.sendRedirect("login.jsp?error=login_failed");
            }

            connection.close();
        } catch (SQLException | ClassNotFoundException e) {
            e.printStackTrace();
            response.sendRedirect("login.jsp?error=database_error");
        }
    }
}
