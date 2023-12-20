package com.afak.servlet;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.Base64;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import java.sql.SQLException;

@WebServlet("/GoogleSignInServlet")
public class GoogleSignInServlet extends HttpServlet {

    private final String dbURL = "jdbc:mysql://localhost:3307/whatsapp";
    private final String dbUsername = "root";
    private final String dbPassword = "root";

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws IOException {
        response.setContentType("application/json");
        PrintWriter out = response.getWriter();

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
        } catch (ClassNotFoundException e) {
            e.printStackTrace();
            out.print("{\"error\": \"MySQL driver not found\"}");
            return;
        }

        try (BufferedReader reader = request.getReader()) {
            StringBuilder jsonStr = new StringBuilder();
            String line;
            while ((line = reader.readLine()) != null) {
                jsonStr.append(line);
            }

            String jsonString = jsonStr.toString();

            if (jsonString.contains("\"request_type\":\"user_auth\"")) {
                // Parse JSON data manually
                int start = jsonString.indexOf("\"credential\":\"") + 14;
                int end = jsonString.indexOf("\"}", start) + 1;
                String credential = jsonString.substring(start, end);

                // Decode response payload from JWT token
                String[] tokenParts = credential.split("\\.");
                if (tokenParts.length == 3) {
                    String payloadBase64 = tokenParts[1];
                    String payload = new String(Base64.getDecoder().decode(payloadBase64));

                    // Parse the payload manually
                    String unique_id = null;
                    String firstName = null;
                    String lastName = null;
                    String email = null;
                    String picture = null;
                    String password = "password123";

                    for (String part : payload.split(",")) {
                        if (part.contains("\"sub\":")) {
                            unique_id = part.split(":")[1].replaceAll("\"", "");
                        } else if (part.contains("\"given_name\":")) {
                            firstName = part.split(":")[1].replaceAll("\"", "");
                        } else if (part.contains("\"family_name\":")) {
                            lastName = part.split(":")[1].replaceAll("\"", "");
                        } else if (part.contains("\"email\":")) {
                            email = part.split(":")[1].replaceAll("\"", "");
                        } else if (part.contains("\"picture\":")) {
                            picture = part.split(":")[1].replaceAll("\"", "");
                        }
                    }

                    if (unique_id != null) {
                        // Check whether the user data already exists in the database
                        Connection connection = null;
                        PreparedStatement preparedStatement = null;
                        ResultSet resultSet = null;

                        try {
                            connection = DriverManager.getConnection(dbURL, dbUsername, dbPassword);

                            String selectQuery = "SELECT * FROM users WHERE unique_id = ?";
                            preparedStatement = connection.prepareStatement(selectQuery);
                            preparedStatement.setString(1, unique_id);
                            resultSet = preparedStatement.executeQuery();

                            if (resultSet.next()) {
                                // Update user data if already exists
                                String updateQuery = "UPDATE users SET first_name = ?, last_name = ?, username = ?, password = ? WHERE unique_id = ?";
                                preparedStatement = connection.prepareStatement(updateQuery);
                                preparedStatement.setString(1, firstName);
                                preparedStatement.setString(2, lastName);
                                preparedStatement.setString(3, email);
                                preparedStatement.setString(4, password);
                                
                                preparedStatement.setString(5, unique_id);
                                preparedStatement.executeUpdate();

                                // User authentication is successful
                                // Store the username in a session attribute
                                String username = resultSet.getString("username");
                                String uniqueId = resultSet.getString("unique_id");
                                HttpSession session = request.getSession();
                                session.setAttribute("username", username);
                                session.setAttribute("uniqueId", uniqueId);
                               
                            } else {
                                // Insert user data
                                String insertQuery = "INSERT INTO users (unique_id, first_name, last_name, username, password) VALUES (?, ?, ?, ?, ?)";
                                preparedStatement = connection.prepareStatement(insertQuery);
                                preparedStatement.setString(1, unique_id);
                                preparedStatement.setString(2, firstName);
                                preparedStatement.setString(3, lastName);
                                preparedStatement.setString(4, email);
                                preparedStatement.setString(5, password);
                               
                                preparedStatement.executeUpdate();

                                // User authentication is successful
                                // Store the username in a session attribute
                                String username = email; // or any other appropriate variable
                                HttpSession session = request.getSession();
                                session.setAttribute("username", username);
                                session.setAttribute("uniqueId", unique_id);
                                
                            }

                            // Prepare the response JSON
                            String responseJSON = "{\"status\": 1, \"msg\": \"Account data inserted successfully!\", \"pdata\": " + payload + "}";
                            out.print(responseJSON);
                        } catch (SQLException e) {
                            e.printStackTrace();
                            String errorJSON = "{\"error\": \"Database error\"}";
                            out.print(errorJSON);
                        } finally {
                            try {
                                if (resultSet != null) resultSet.close();
                                if (preparedStatement != null) preparedStatement.close();
                                if (connection != null) connection.close();
                            } catch (SQLException e) {
                                e.printStackTrace();
                            }
                        }
                    } else {
                        String errorJSON = "{\"error\": \"Account data is not available!\"}";
                        out.print(errorJSON);
                    }
                }
            }
        }
        out.flush();
    }
}
