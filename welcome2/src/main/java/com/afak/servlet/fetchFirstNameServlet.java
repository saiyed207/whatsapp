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

@WebServlet("/fetchFirstNameServlet")
public class fetchFirstNameServlet extends HttpServlet {
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String uniqueId = request.getParameter("uniqueId");

        // Fetch first_name, unique_id, and image URL from the database using uniqueId
        UserInfo userInfo = fetchUserInfoFromDatabase(uniqueId);

        // Create a JSON response
        String jsonResponse = "{\"firstName\": \"" + userInfo.getFirstName() +
                "\", \"uniqueId\": \"" + userInfo.getUniqueId() +
                "\", \"imageUrl\": \"" + userInfo.getImageUrl() + "\"}";

        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        response.getWriter().write(jsonResponse);
    }

    private UserInfo fetchUserInfoFromDatabase(String uniqueId) {
        UserInfo userInfo = new UserInfo(); // Create a class to hold user info (firstName, uniqueId, and imageUrl)
        Connection connection = null;

        try {
            // Load the MySQL JDBC driver (Make sure to have the MySQL JDBC driver JAR in your project)
            Class.forName("com.mysql.cj.jdbc.Driver");

            // Establish a database connection
            String url = "jdbc:mysql://localhost:3307/whatsapp"; // Update with your database URL
            String dbUsername = "root"; // Update with your database username
            String dbPassword = "root"; // Update with your database password
            connection = DriverManager.getConnection(url, dbUsername, dbPassword);

            // Query the database to fetch the first_name, unique_id, and image URL based on uniqueId
            String query = "SELECT first_name, unique_id, image FROM users WHERE unique_id = ?";
            PreparedStatement preparedStatement = connection.prepareStatement(query);
            preparedStatement.setString(1, uniqueId);

            ResultSet resultSet = preparedStatement.executeQuery();

            if (resultSet.next()) {
                userInfo.setFirstName(resultSet.getString("first_name"));
                userInfo.setUniqueId(resultSet.getString("unique_id"));
                userInfo.setImageUrl(resultSet.getString("image"));
            }

        } catch (ClassNotFoundException | SQLException e) {
            e.printStackTrace();
            // Handle exceptions, log errors, or return an error message as needed
        } finally {
            try {
                if (connection != null) {
                    connection.close();
                }
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }

        return userInfo;
    }
}
