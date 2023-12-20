package com.afak.servlet;

import java.io.IOException;
import java.io.PrintWriter;
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

@WebServlet("/GetMessageServlet")
public class GetMessageServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        PrintWriter out = response.getWriter();

        String outgoingId = request.getParameter("outgoing_id");
        String incomingId = request.getParameter("incoming_id");

        Connection connection = null;
        try {
            // Load the MySQL JDBC driver
            Class.forName("com.mysql.cj.jdbc.Driver");

            // Establish a database connection
            String url = "jdbc:mysql://localhost:3307/whatsapp"; // Update with your database URL
            String dbUsername = "root"; // Update with your database username
            String dbPassword = "root"; // Update with your database password
            connection = DriverManager.getConnection(url, dbUsername, dbPassword);

            // SQL query to retrieve messages
            String sql = "SELECT msg, outgoing_msg_id FROM messages WHERE " +
                         "(outgoing_msg_id = ? AND incoming_msg_id = ?) OR " +
                         "(outgoing_msg_id = ? AND incoming_msg_id = ?) ORDER BY msg_id";

            PreparedStatement preparedStatement = connection.prepareStatement(sql);
            preparedStatement.setString(1, outgoingId);
            preparedStatement.setString(2, incomingId);
            preparedStatement.setString(3, incomingId);
            preparedStatement.setString(4, outgoingId);

            ResultSet resultSet = preparedStatement.executeQuery();

          
            while (resultSet.next()) {
                String msg = resultSet.getString("msg");
                String senderId = resultSet.getString("outgoing_msg_id");
                if (msg != null && !msg.trim().isEmpty()) {
                // Apply formatting based on the sender (you can style this using CSS)
                if (senderId.equals(outgoingId)) {
                    // Format for the outgoing message
                    out.println("<div class='message-box my-message'>");
                    out.println("<p>" + msg + "</p>");
                } else {
                    // Format for the incoming message
                    out.println("<div class='message-box friend-message'>");
                    out.println("<p onclick='reloadAndRedirect()' id='link'>" + msg + "</p>");
                }
                
                out.println("</div>");
            }
        }} catch (ClassNotFoundException | SQLException e) {
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
    }
}
