package com.afak.servlet;

import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;


@WebServlet("/userData")
public class data extends HttpServlet {
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        List<User> userList = new ArrayList<>();
        Connection connection = null;

        try {
            // Load the MySQL JDBC driver
            Class.forName("com.mysql.cj.jdbc.Driver");

            // Establish a database connection
            String url = "jdbc:mysql://localhost:3307/whatsapp";
            String dbUsername = "root";
            String dbPassword = "root";
            connection = DriverManager.getConnection(url, dbUsername, dbPassword);

            // Query the database to fetch all users
            String query = "SELECT * FROM users";
            PreparedStatement preparedStatement = connection.prepareStatement(query);
            ResultSet resultSet = preparedStatement.executeQuery();

            while (resultSet.next()) {
                String firstName = resultSet.getString("first_name");
                String uniqueId = resultSet.getString("unique_id");
                String imageUrl = resultSet.getString("image");

                // Create a User object and add it to the list
                User user = new User(firstName, uniqueId, imageUrl);
                userList.add(user);
            }

        } catch (ClassNotFoundException | SQLException e) {
            e.printStackTrace();
        } finally {
           
            try {
                if (connection != null) {
                    connection.close();
                }
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }

        request.setAttribute("userList", userList);
        request.getRequestDispatcher("whatsapp2.jsp").forward(request, response);
    }
}
