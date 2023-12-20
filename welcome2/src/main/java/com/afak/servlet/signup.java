package com.afak.servlet;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.SQLException;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet("/signup")
public class signup extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/plain");
        PrintWriter out = response.getWriter();

        String fname = request.getParameter("fname");
        String lname = request.getParameter("lname");
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        String image ="https://photos.app.goo.gl/NcRaJnxpHYfDreWR9";

        if (isEmpty(fname) || isEmpty(lname) || isEmpty(email) || isEmpty(password)) {
            out.write("All input fields are required!");
            return;
        }

        if (!isValidEmail(email)) {
            out.write(email + " is not a valid email!");
            return;
        }

        if (isEmailExists(email)) {
            out.write(email + " - This email already exists!");
            return;
        }

        Connection conn = null;
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            conn = DriverManager.getConnection("jdbc:mysql://localhost:3307/chatapp", "root", "root");
            String query = "INSERT INTO users (fname, lname, email, password, image) VALUES (?, ?, ?, ?, ?)";
            PreparedStatement preparedStatement = conn.prepareStatement(query);
            preparedStatement.setString(1, fname);
            preparedStatement.setString(2, lname);
            preparedStatement.setString(3, email);
            preparedStatement.setString(4, password);
            preparedStatement.setString(5, image);
            preparedStatement.executeUpdate();
            out.write("success");
        } catch (Exception e) {
            e.printStackTrace();
            out.write("Something went wrong. Please try again!");
        } finally {
            try {
                if (conn != null) {
                    conn.close();
                }
            } catch (SQLException ex) {
                ex.printStackTrace();
            }
        }
    }

    private boolean isEmpty(String str) {
        return str == null || str.trim().isEmpty();
    }

    private boolean isValidEmail(String email) {
        return email.matches("[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}");
    }

    private boolean isEmailExists(String email) {
        // Check if the email already exists in the database
        // You need to implement this based on your database setup
        return false; // Replace with your database query logic
    }
}



