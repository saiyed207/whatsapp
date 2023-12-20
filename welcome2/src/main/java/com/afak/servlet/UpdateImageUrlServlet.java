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

@WebServlet("/UpdateImageUrlServlet")
public class UpdateImageUrlServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html");
        PrintWriter out = response.getWriter();

        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;

        try {
            // Load the JDBC driver
            Class.forName("com.mysql.cj.jdbc.Driver");

            // Connect to the database
            String jdbcUrl = "jdbc:mysql://localhost:3307/whatsapp";
            String username = "root";
            String password = "root";
            conn = DriverManager.getConnection(jdbcUrl, username, password);

            // Prepare and execute the SQL query
            String sql = "SELECT image, first_name FROM users";
            stmt = conn.prepareStatement(sql);
            rs = stmt.executeQuery();

            // Display the results
            out.println("<html>");
            out.println("<head>");
            out.println("<title>User Images</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h2>User Images</h2>");

            while (rs.next()) {
                String image = rs.getString("image");
                String firstName = rs.getString("first_name");

                out.println("<p>First Name: " + firstName + "</p>");
                out.println("<img src='" + image + "' alt='User Image'><br><br>");
            }

            out.println("</body>");
            out.println("</html>");
        } catch (ClassNotFoundException | SQLException e) {
            e.printStackTrace();
            out.println("Error: " + e.getMessage());
        } finally {
            // Close resources in the reverse order of their creation
            try {
                if (rs != null) rs.close();
                if (stmt != null) stmt.close();
                if (conn != null) conn.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
    }
}
