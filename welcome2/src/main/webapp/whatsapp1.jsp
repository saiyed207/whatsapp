<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta http-equiv="X-UA-Compatible" content="IE=edge">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <script src="https://kit.fontawesome.com/391827d54c.js" crossorigin="anonymous"></script>
  <link rel="stylesheet" href="styles.css">
  <title>Whatsapp Clone</title>
</head>
<body>
  <div class="background-green"></div>

  <div class="main-container">
    <div class="left-container">

      <!-- Header -->
      <div class="header">
        <div class="user-img">
          <img class="dp" src="https://www.codewithfaraz.com/InstaPic.png" alt="">
        </div>
        <div class="nav-icons">
          <li><i class="fa-solid fa-users"></i></li>
          <li><i class="fa-solid fa-message"></i></li>
          <li><i class="fa-solid fa-ellipsis-vertical"></i></li>
        </div>
      </div>

      <%-- Display the logged-in user's username --%>
       <% String username = (String) request.getSession().getAttribute("username"); %>
                <div class="user-email">
                    <p style="margin-left: 10px;"><%= username %></p>
                </div>
      

      <!-- Notification -->
      <div class="notif-box">
        <i class="fa-solid fa-bell-slash"></i>
        <div class="notif-text">
          <p>Get Notified of New Messages</p>
          <a href="#">Turn on Desktop Notifications ›</a>
        </div>
        <i class="fa-solid fa-xmark"></i>
      </div>

      <!-- Search Container -->
      <div class="search-container">
        <div class="input">
          <i class="fa-solid fa-magnifying-glass"></i>
          <input type="text" placeholder="Search or start new chat">
        </div>
        <i class="fa-sharp fa-solid fa-bars-filter"></i>
      </div>

      <!-- Chats -->
      <div class="chat-list">
        <!-- Example chat box, you can customize this or add more dynamically -->
        <div class="chat-box">
          <div class="img-box">
            <img class="img-cover" src="https://lh5.googleusercontent.com/-7ssjf_mDE1Q/AAAAAAAAAAI/AAAAAAAAASo/tioYx2oklWEHoo5nAEyCT-KeLxYqE5PuQCLcDEAE/s100-c-k-no-mo/photo.jpg" alt="">
          </div>
          <div class="chat-details">
            <div class="text-head">
              <h4>Nowfal</h4>
              <p class="time unread">11:49</p>
            </div>
            <div class="text-message">
              <p>“How are you?”</p>
              <b>1</b>
            </div>
          </div>
        </div>

        <!-- Display the list of users here -->
        <c:forEach var="user" items="${userList}">
          <div class="chat-box">
            <div class="img-box">
              <!-- You can add user avatars here if available -->
            </div>
            <div class="chat-details">
              <div class="text-head">
                <h4>${user.username}</h4>
                <!-- You can add last message time if available -->
              </div>
              <div class="text-message">
                <!-- You can add last message content if available -->
              </div>
            </div>
          </div>
        </c:forEach>
      </div>
    </div>

    <div class="right-container">
      <!-- Rest of your right container content here -->
    </div>
  </div>
</body>
</html>
