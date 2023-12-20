package com.afak.servlet;
import java.io.IOException;
import java.io.InputStream;

import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.Part;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import java.sql.Types;
import java.util.UUID;

import java.security.SecureRandom;




@WebServlet("/myapp")
@MultipartConfig
public class myapp extends HttpServlet {
	
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
	    String firstName = request.getParameter("first_name");
	    String lastName = request.getParameter("last_name");
	    String username = request.getParameter("username");
	    String password = request.getParameter("password");
	    String confirmPassword = request.getParameter("confirm_password");
	    

	    if (!password.equals(confirmPassword)) {
	        response.sendRedirect("registration.jsp?error=password_mismatch");
	        return;
	    }

	    try {
	        // Load the MySQL JDBC driver
	        Class.forName("com.mysql.cj.jdbc.Driver");

	        // Establish a database connection
	        String url = "jdbc:mysql://localhost:3307/whatsapp";
	        String dbUsername = "root";
	        String dbPassword = "root";
	        Connection connection = DriverManager.getConnection(url, dbUsername, dbPassword);

	        // Generate a short unique ID for the user
	        String uniqueId = generateShortUniqueId();

	        // Insert user data into the database
	        String insertQuery = "INSERT INTO users (unique_id, first_name, last_name, username, password, image) VALUES (?, ?, ?, ?, ?, ?)";
	        PreparedStatement preparedStatement = connection.prepareStatement(insertQuery);
	        preparedStatement.setString(1, uniqueId);
	        preparedStatement.setString(2, firstName);
	        preparedStatement.setString(3, lastName);
	        preparedStatement.setString(4, username);
	        preparedStatement.setString(5, password);
	        preparedStatement.setString(6, "https://lh3.googleusercontent.com/a/ACg8ocKXwg0vSE5OZ3YtcdJdb9snX2DGsQwwkMeEJZfmwDNvmQ=s96-c");
	       

	        int rowsAffected = preparedStatement.executeUpdate();

	        if (rowsAffected > 0) {
	            response.sendRedirect("index.jsp?registration=success");
	        } else {
	            response.sendRedirect("registration.jsp?error=registration_failed");
	        }

	        connection.close();
	    } catch (SQLException | ClassNotFoundException e) {
	        e.printStackTrace();
	        response.sendRedirect("registration.jsp?error=database_error");
	    }
	}

	// Function to generate a short unique ID
	private String generateShortUniqueId() {
	    String characters = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789";
	    SecureRandom random = new SecureRandom();
	    StringBuilder uniqueId = new StringBuilder(8);

	    for (int i = 0; i < 8; i++) {
	        uniqueId.append(characters.charAt(random.nextInt(characters.length())));
	    }

	    return uniqueId.toString();
	}

}

