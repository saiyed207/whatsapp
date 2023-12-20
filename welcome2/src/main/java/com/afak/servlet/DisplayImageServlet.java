package com.afak.servlet;

import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet("/DisplayImageServlet")
public class DisplayImageServlet extends HttpServlet {

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Handle GET requests (if needed)
        // You can add logic to display the image or perform other actions for GET requests.
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Retrieve image source from request parameters
        String imageSrc = request.getParameter("imageSrc");

        // Retrieve unique_id from the session or request, adjust accordingly
        String uniqueId = (String) request.getSession().getAttribute("uniqueId");

        // Store the image link in the database
        boolean success = storeImageLink(uniqueId, imageSrc);

        // Send a response based on the success of storing the image link
        if (success) {
            response.getWriter().write("Image link stored successfully in the database");
        } else {
            response.getWriter().write("Failed to store image link in the database");
        }
    }

    private boolean storeImageLink(String uniqueId, String imageSrc) {
        // JDBC database connection parameters
        String jdbcUrl = "jdbc:mysql://localhost:3307/whatsapp";
        String dbUser = "root";
        String dbPassword = "root";

        try {
            // Load the JDBC driver
            Class.forName("com.mysql.cj.jdbc.Driver");

            // Establish the database connection
            try (Connection connection = DriverManager.getConnection(jdbcUrl, dbUser, dbPassword)) {
                // Check if the unique_id already exists in the database
                if (isUniqueIdExists(connection, uniqueId)) {
                    // If exists, update the image link
                    return updateImageLink(connection, uniqueId, imageSrc);
                } else {
                    // If not exists, insert a new record
                    return insertImageLink(connection, uniqueId, imageSrc);
                }
            }
        } catch (ClassNotFoundException | SQLException e) {
            e.printStackTrace();
        }

        return false;
    }

    private boolean isUniqueIdExists(Connection connection, String uniqueId) throws SQLException {
        // Check if the unique_id already exists in the database
        String query = "SELECT * FROM users WHERE unique_id = ?";
        try (PreparedStatement preparedStatement = connection.prepareStatement(query)) {
            preparedStatement.setString(1, uniqueId);
            try (ResultSet resultSet = preparedStatement.executeQuery()) {
                return resultSet.next();
            }
        }
    }

    private boolean insertImageLink(Connection connection, String uniqueId, String imageSrc) throws SQLException {
        // Insert a new record with the image link
        String insertQuery = "INSERT INTO users (unique_id, image) VALUES (?, ?)";
        try (PreparedStatement preparedStatement = connection.prepareStatement(insertQuery)) {
            preparedStatement.setString(1, uniqueId);
            preparedStatement.setString(2, imageSrc);
            int rowsAffected = preparedStatement.executeUpdate();
            return rowsAffected > 0;
        }
    }

    private boolean updateImageLink(Connection connection, String uniqueId, String imageSrc) throws SQLException {
        // Update the existing record with the new image link
        String updateQuery = "UPDATE users SET image = ? WHERE unique_id = ?";
        try (PreparedStatement preparedStatement = connection.prepareStatement(updateQuery)) {
            preparedStatement.setString(1, imageSrc);
            preparedStatement.setString(2, uniqueId);
            int rowsAffected = preparedStatement.executeUpdate();
            return rowsAffected > 0;
        }
    }
}
