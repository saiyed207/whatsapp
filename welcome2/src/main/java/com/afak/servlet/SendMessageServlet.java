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
import java.sql.SQLException;

@WebServlet("/SendMessageServlet")
public class SendMessageServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String message = request.getParameter("message");
        String outgoingId = request.getParameter("outgoingId");
        String incommingId = request.getParameter("incommingId");
        
        
        if (message == null || message.trim().isEmpty() || outgoingId == null || outgoingId.trim().isEmpty() || incommingId == null || incommingId.trim().isEmpty()) {
            response.getWriter().write("Message, outgoingId, or incomingId is empty.");
            return; // Do not proceed if any parameter is empty
        }

        // Insert the message into the database
        boolean success = insertMessageIntoDatabase(message, outgoingId, incommingId);

        if (success) {
            response.getWriter().write("Message sent successfully.");
        } else {
            response.getWriter().write("Failed to send the message.");
        }
    }

    private boolean insertMessageIntoDatabase(String message, String outgoingId, String incommingId) {
        Connection connection = null;

        try {
            // Load the MySQL JDBC driver (Make sure to have the MySQL JDBC driver JAR in your project)
            Class.forName("com.mysql.cj.jdbc.Driver");

            // Establish a database connection
            String url = "jdbc:mysql://localhost:3307/whatsapp"; // Update with your database URL
            String dbUsername = "root"; // Update with your database username
            String dbPassword = "root"; // Update with your database password
            connection = DriverManager.getConnection(url, dbUsername, dbPassword);
            
            
            // Query to insert the message into the database
           
            String query = "INSERT INTO messages (outgoing_msg_id, incoming_msg_id, msg) VALUES (?, ?, ?)";
           
            PreparedStatement preparedStatement = connection.prepareStatement(query);
            preparedStatement.setString(1, outgoingId);
            preparedStatement.setString(2, incommingId);
            preparedStatement.setString(3, message);
           
            // Execute the query
            int rowsAffected = preparedStatement.executeUpdate();

            return rowsAffected > 0; // Return true if the message was successfully inserted
        } catch (ClassNotFoundException | SQLException e) {
            e.printStackTrace();
            // Handle exceptions, log errors, or return false to indicate failure
            return false;
        } finally {
            try {
                if (connection != null) {
                    connection.close();
                }
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
    }
}
