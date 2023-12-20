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
  <title>Whatsapp</title>
  <style>
  #signOutButton {
    background-color: red; /* Change the background color as needed */
    color: white;
    border: none;
    padding: 5px 10px;
    border-radius: 5px;
    cursor:pointer;
}

#signOutButton i {
    margin-left: 5px;
    cursor:pointer; /* Add some space between the text and the icon */
}

.chat-list {
  position: relative;
  height:calc(100% - 250px);
  overflow-y: auto;
}
  
  
  #overlay {
            display: none;
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background-color: rgba(0, 0, 0, 0.5);
            z-index: 1;
        }

        #modal {
            display: none;
            position: fixed;
            left: 35%;
            top: 13%;
            width: 51%;
  			height: 75%;  /*60+60*/
            
            overflow-y: auto;
            padding: 20px;
            background: linear-gradient(to bottom, #6ac6ff, #007bff);
            opacity: 1;
            z-index: 2;
            border-radius: 8px;
            box-shadow: 0 0 10px rgba(0, 0, 0, 0.4);
        }
        
        

        #closeButton {
            position: absolute;
            top: 5px;
            right: 10px;
            cursor: pointer;
            color: white;
            font-size: 18px;
            z-index:100;
        }
        .video {
        cursor:pointer;
        }
        
         #modal img {
            width: 100%;
            max-width: 70px; /* Adjust the maximum width as needed */
            height: auto;
            opacity: 1;
            display: block;
            margin-top:15%;
            margin-left:70%;
            z-index:5;
        }
        
         body {
            font-family: 'Arial', sans-serif;
            margin: 0;
            padding: 0;
            display: flex;
            justify-content: center;
            align-items: center;
            height: 100vh;
            background-color: #f4f4f4;
        }

.primary-video{
  position: absolute;
  width: 100%;
  height: 88%;
  object-fit: cover;
  background-color: black;
  right:4px;

}

.secondary-video{
  position: absolute;
  width: 30%;
  height: 30%;
  margin: 16px;
  border:2px solid lightblue;
  border-radius: 16px;
  object-fit: cover;
  background-color: grey;
  z-index:1;
}



        
  </style>
</head>
<body>
  <div class="background-green"></div>

  <div class="main-container">
    <div class="left-container">

      <!-- Header -->
      <div class="header">
        <div class="user-img">
        <div id="userData">
          <img class="dp"  src="https://lh3.googleusercontent.com/a/ACg8ocKXwg0vSE5OZ3YtcdJdb9snX2DGsQwwkMeEJZfmwDNvmQ=s96-c" alt="">
        </div>
        </div>
        
        <div class="nav-icons">
          <li><i class="fa-solid fa-users"></i></li>
          <li><i class="fa-solid fa-message"></i></li>
          <li><i class="fa-solid fa-ellipsis-vertical"></i></li>
        </div>
      </div>

      <%-- Display the logged-in user's username --%>
      
     
      
       <% String username = (String) request.getSession().getAttribute("username"); %>
                <div class="user-email" id="userEmail">
                    <p style="margin-left: 10px;"><%= username %></p>
                </div>
                
         <% if (request.getSession().getAttribute("username") != null) { %>
    <div class="user-email" id="userEmail">
        <button id="signOutButton" onclick="signOut()">
            Sign Out <i class="fas fa-sign-out-alt"></i>
        </button>
    </div>
<% } %>

 
          <script>
        // Retrieve user data from session storage
        var userData = sessionStorage.getItem('userData');

        if (userData) {
            // Parse the JSON data
            var userDataObj = JSON.parse(userData);

            // Display the user email
            var userEmailHtml = userDataObj.email;

            document.getElementById('userEmail').innerHTML = userEmailHtml;
        }
    </script>
        
       
      
      <!-- Include jQuery library -->
<script src="https://code.jquery.com/jquery-3.6.4.min.js"></script>

 <script>
        // Retrieve user data from session storage
        var userData = sessionStorage.getItem('userData');

        if (userData) {
            // Parse the JSON data
            var userDataObj = JSON.parse(userData);

            // Display the user image
            var userDataHtml = '<img src="' + userDataObj.picture + '" />';

            document.getElementById('userData').innerHTML = userDataHtml;

            // Send the image data to DisplayImageServlet
            $.ajax({
                type: 'POST',
                url: '/welcome2/DisplayImageServlet', // Adjust the path accordingly
                data: { imageSrc: userDataObj.picture },
                success: function(response) {
                    console.log('Image sent successfully');
                    console.log('Response:', response);
                    
                },
                error: function(error) {
                    console.error('Error sending image:', error);
                }
            });
        }
    </script>



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
       
     <c:forEach var="user" items="${userList}">
     
     <div class="chat-box" data-uniqueId="${user.uniqueId}"  class="chat-box-click">

    <div class="img-box">
       <img class="img-cover" src="${not empty user.getImageUrl() ? user.getImageUrl() : 'https://lh3.googleusercontent.com/a/ACg8ocKXwg0vSE5OZ3YtcdJdb9snX2DGsQwwkMeEJZfmwDNvmQ=s96-c'}" alt="pro.jpg">

    </div>
    <div class="chat-details">
      <div class="text-head">
        <h4 >${user.firstName}</h4>
        <p class="time unread">11:49</p>
      </div>
      <div class="text-message">
        <p style="display:none">${user.uniqueId}</p>
        <p style="display:none"><c:out value="${uniqueId}" /></p>
        <p>How are you</p>
        <b>1</b>
      </div>
    </div>
  </div>
</c:forEach>





        <!-- Display the list of users here -->
        
        
      </div>
    </div>
    

    <div class="right-container">
<!--header -->
    <div class="header">
  <div class="img-text">
    <div class="user-img">
      <img class="dp" id="userImage" src="https://lh3.googleusercontent.com/a/ACg8ocKXwg0vSE5OZ3YtcdJdb9snX2DGsQwwkMeEJZfmwDNvmQ=s96-c"  id="profileImage">
    </div>
    <h4 id="chatUsername"><br><span>Online</span></h4>
  </div>
  
  
 
 <div class="nav-icons">
 <div style="  cursor:pointer "><img class="video" src="videocall.png" onclick="openModal()"/></div>
    <li><i class="fa-solid fa-magnifying-glass"></i></li>
    <li><i class="fa-solid fa-ellipsis-vertical"></i></li>
  </div>
</div>


 <script>
 function closeModal() {
     document.getElementById('overlay').style.display = 'none';
     document.getElementById('modal').style.display = 'none';
 }
 function openModal() {
	 
	 
	    // You can set the input value with the stored link here
	    var storedLink = "http://localhost:8084/welcome2/whatsapp1#" + roomHash;

	    // Format the link as HTML with an anchor tag
	    var formattedLink = '<a href="' + storedLink + '" style="color: blue;" target="_self" onclick=reloadAndRedirect()="reloadAndRedirect()" >' + storedLink + '</a>';

	    // Set the value of the textarea with the formatted link
	    $("#messageInput").val(formattedLink);
	    

	    document.getElementById('overlay').style.display = 'block';
	    document.getElementById('modal').style.display = 'block';

	    // Open the link in the same tab
	    window.location.href = storedLink;
	}




</script>



<script>
function reloadAndRedirect() {
    // Reload the page
    window.location.href = '/welcome2/whatsapp1#' + roomHash;

   
    setTimeout(function () {
        openModal2();
    }, 2000);
}

function openModal2() {
    document.getElementById('overlay').style.display = 'block';
    document.getElementById('modal').style.display = 'block';
}


</script>






<div id="overlay"></div>

<div id="modal">
    <span id="closeButton" onclick="closeModal()">&times;</span>
      
    <img style="text-align:center; margin-top:-5%; margin-left:60% ;"  src="dot.gif"/>
     <div id="video-container">
            <video class="secondary-video" id="localVideo" autoplay playsinline muted></video>
            <video class="primary-video" id="remoteVideo" autoplay playsinline>

            </video>
            <img class="dp" id="userImage1" style="margin-top:4%; width:40px; margin-left:47%; border-radius:50% " src="https://lh3.googleusercontent.com/a/ACg8ocKXwg0vSE5OZ3YtcdJdb9snX2DGsQwwkMeEJZfmwDNvmQ=s96-c"  id="profileImage">
            <p class="dp" id="chatUsername1" style="color:darkred; text-align:center">saiyed12</p>
            <img class="dp" style="margin-top:330px; width:40px; margin-left:65%; border-radius:50%; cursor: pointer;" src="call.gif" id="profileImage" onclick="declineCall()">
            <img class="dp" style="margin-top:330px; width:40px; margin-left:45%; border-radius:50%; cursor: pointer;" src="decline.png" id="profileImage" onclick="stopMedia();">
        </div>
    
</div>

 
      

<!--chat-container -->
      <div class="chat-container"  id="chatContainer">
        <div class="message-box my-message">
          <p><br><span>07:43</span></p>
        </div>
        <div class="message-box friend-message">
          <p onclick="openModal()"><br><span>07:45</span></p>
        </div>
      
      </div>
      
   


 
    
      
      
      

<!--input-bottom -->
    <div class="chatbox-input">
    <i class="fa-regular fa-face-grin"></i>
    <i class="fa-sharp fa-solid fa-paperclip"></i>
    <input type="text" id="messageInput" placeholder="Type a message">
    
    <!-- You can keep the outgoing_id hidden in a <p> element -->
    <p  id="outgoing_id" name="outgoing_id" style="display:none"> <c:out value="${uniqueId}" /></p>
    
    <!-- Incomming_id should be displayed in a visible paragraph for this purpose -->
    <p name="incomming_id" id="incomming_id" style="display:none"> <span id="uniqueIdParagraph"></span></p>
    
    <!-- Add an event listener to the "fas fa-paper-plane" icon to send the message -->
    <i class="fas fa-paper-plane" id="sendButton"></i>
</div>

    </div>

  </div>
  


<script>
function signOut() {
    // Clear user data from session storage
    sessionStorage.removeItem('userData');

    // Redirect to a URL
    window.location.href = 'http://localhost:8084/welcome2/chat.jsp'; // Modify the URL as needed
}
</script>


  
 
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>



<script>
$(".chat-box").on("click", function() {
    $("#sendButton").click();
    var uniqueId = $(this).attr("data-uniqueId");
    var outgoingId = $("#outgoing_id").text();

    function fetchAndAppendChatMessages(outgoingId, incomingId) {
        $.ajax({
            type: "POST",
            url: "GetMessageServlet", // Replace with the actual URL of your servlet for fetching messages
            data: {
                incoming_id: incomingId,
                outgoing_id: outgoingId // Include outgoing_id in the request
            },
            success: function(response) {
                // Append the received messages to the chat container
                $("#chatContainer").html(response);
            },
            error: function() {
                // Handle errors if the request fails
                console.log("Failed to fetch chat messages.");
            }
        });
    }

    // Send an AJAX request to fetch the firstName, uniqueId, and imageUrl for this chat
    $.ajax({
        type: "GET",
        url: "fetchFirstNameServlet?uniqueId=" + uniqueId, // Replace with the actual URL of your Servlet
        success: function(response) {
            // Handle the response from the server, which should contain the firstName, uniqueId, and imageUrl
            var firstName = response.firstName;
            var uniqueId = response.uniqueId;
            var imageUrl = response.imageUrl; // Assuming the image URL is included in the response

            // Update the HTML to display the fetched information
            $("#chatUsername").html(firstName + "<br><span>Online</span>");
            $("#chatUsername1").html(firstName);

            // Display the unique_id in a <p> element
            $("#uniqueIdParagraph").text(uniqueId);

            // Display the fetched image
            
            	$("#userImage").attr("src", imageUrl !== null ? imageUrl : "https://lh3.googleusercontent.com/a/ACg8ocKXwg0vSE5OZ3YtcdJdb9snX2DGsQwwkMeEJZfmwDNvmQ=s96-c").attr("alt", imageUrl !== null ? (firstName + "'s Image") : "Profile Image");
            	$("#userImage1").attr("src", imageUrl !== null ? imageUrl : "https://lh3.googleusercontent.com/a/ACg8ocKXwg0vSE5OZ3YtcdJdb9snX2DGsQwwkMeEJZfmwDNvmQ=s96-c").attr("alt", imageUrl !== null ? (firstName + "'s Image") : "Profile Image");


            // Fetch and display chat messages for this chat
            fetchAndAppendChatMessages(outgoingId, uniqueId);
        },
        error: function() {
            // Handle errors if the request fails
            alert("Failed to fetch first name, unique ID, and image");
        }
    });
});
</script>

<script>
setInterval(() => {
    let xhr = new XMLHttpRequest();
    xhr.open("POST", "GetMessageServlet", true);

    xhr.onload = () => {
        if (xhr.readyState === 4 && xhr.status === 200) {
            let data = xhr.responseText;
            chatBox.innerHTML = data;
            if (!chatBox.classList.contains("active")) {
                scrollToBottom();
            }
        }
    };

    let params = "incoming_id=" + incoming_id + "&outgoing_id=" + outgoing_id;
    xhr.setRequestHeader("Content-type", "application/x-www-form-urlencoded");
    xhr.send(params);
}, 500);

</script>

<script>
$(document).ready(function() {
    var isTyping = false; // Flag to track user typing

    // Function to fetch and append chat messages
    function fetchAndAppendChatMessages(outgoingId, incommingId) {
        $.ajax({
            type: "POST",
            url: "GetMessageServlet", // Replace with the actual URL of your servlet for fetching messages
            data: {
                incoming_id: incommingId,
                outgoing_id: outgoingId // Include outgoing_id in the request
            },
            success: function(response) {
                // Append the received messages to the chat container
                $("#chatContainer").html(response);
            },
            error: function() {
                // Handle errors if the request fails
                console.log("Failed to fetch chat messages.");
            }
        });
    }

    // Add an event listener to the "fas fa-paper-plane" icon to send the message
    $("#sendButton").on("click", function() {
        var message = $("#messageInput").val();
        var outgoingId = $("#outgoing_id").text(); // Get the outgoing ID from the HTML element
        var incommingId = $("#incomming_id").text();

        // Check if the user is actively typing (do not click if typing)
        if (!isTyping) {
            // Check if the incoming ID is not empty
            if (incommingId.trim() === "" || outgoingId.trim() === "") {
   
                return; // Stop further execution if the incoming or outgoing ID is empty
            }

            // Determine if the user is a sender or receiver
            var isSender = (outgoingId === incommingId);

            // Send an AJAX request to send the message to the server
            $.ajax({
                type: "POST",
                url: "SendMessageServlet", // Replace with the actual URL of your servlet
                data: {
                    message: message,
                    outgoingId: outgoingId,
                    incommingId: incommingId,
                    isSender: isSender // Pass the isSender flag to the server
                },
                success: function(response) {
                    // Handle success response from the server if needed
                    console.log("Message sent successfully.");

                    // Clear the input field after sending the message
                    $("#messageInput").val("");

                    // Fetch and append new chat messages
                    fetchAndAppendChatMessages(outgoingId, incommingId);
                },
                error: function() {
                    // Handle errors if the request fails
                    alert("Failed to send the message.");
                }
            });
        }
    });

    // Initial load of chat messages
    var initialOutgoingId = $("#outgoing_id").text();
    var initialIncommingId = $("#incomming_id").text();
    fetchAndAppendChatMessages(initialOutgoingId, initialIncommingId);

    // Timer to periodically click the button (without typing)
    setInterval(function() {
        // Check if the user is actively typing
        isTyping = $("#messageInput").is(":focus");
        if (!isTyping) {
            $("#sendButton").click();
        }
    }, 2000); // 1000 milliseconds (1 second)
});


</script>

    <script src='https://cdn.scaledrone.com/scaledrone.min.js' type='text/javascript'></script>
    <!-- Your existing HTML code -->



<script>
    if (!location.hash) {
        location.hash = Math.floor(Math.random() * 0xFFFFFF).toString(16);
    }

    const roomHash = location.hash.substring(1);

    const drone = new Scaledrone('PPNvkBI8mkDF2AcB'); // Replace with your Scaledrone channel ID
    const roomName = 'observable-' + roomHash;
    const configuration = {
        iceServers: [{
            urls: 'stun:stun.1.google.com:19302'
        }]
    };
    let room;
    let pc;
    let localStream;

    function onSuccess() { }
    function onError(error) {
        console.error(error);
    }

    drone.on('open', error => {
        if (error) {
            return console.error(error);
        }
        room = drone.subscribe(roomName);
        room.on('open', error => {
            if (error) {
                onError(error);
            }
        });

        room.on('members', members => {
            console.log('MEMBERS', members);
            const isOfferer = members.length === 2;
            startWebRTC(isOfferer);
        });
    });

    function sendMessage(message) {
        drone.publish({
            room: roomName,
            message
        });
    }

    function startWebRTC(isOfferer) {
        pc = new RTCPeerConnection(configuration);

        pc.onicecandidate = event => {
            if (event.candidate) {
                sendMessage({ 'candidate': event.candidate });
            }
        };

        pc.ontrack = event => {
            remoteVideo.srcObject = event.streams[0];
        };

        if (isOfferer) {
            pc.onnegotiationneeded = () => {
                pc.createOffer().then(localDescCreated).catch(onError);
            }
        }

        navigator.mediaDevices.getUserMedia({
            audio: true,
            video: true,
        }).then(stream => {
            localVideo.srcObject = stream;
            localStream = stream; // Store the local stream
            stream.getTracks().forEach(track => pc.addTrack(track, stream));
        }, onError);

        room.on('data', (message, client) => {
            if (client.id === drone.clientId) {
                return;
            }

            if (message.sdp) {
                pc.setRemoteDescription(new RTCSessionDescription(message.sdp))
                    .then(() => {
                        if (pc.remoteDescription.type === 'offer') {
                            return pc.createAnswer().then(localDescCreated).catch(onError);
                        }
                    })
                    .catch(onError);
            } else if (message.candidate) {
                pc.addIceCandidate(new RTCIceCandidate(message.candidate))
                    .then(onSuccess)
                    .catch(onError);
            } else if (message.callDeclined) {
                // Call has been declined, close the RTCPeerConnection and stop the local stream
                closeConnection();
            }
        });
    }

    function localDescCreated(desc) {
        pc.setLocalDescription(
            desc,
            () => sendMessage({ 'sdp': pc.localDescription }),
            onError
        );
    }

    function declineCall() {
        // Close the RTCPeerConnection and stop the local media stream
        closeConnection();
        

        setTimeout(function () {
            location.reload();
        }, 2000);
    }

    function closeConnection() {
        if (pc) {
            pc.close();
        }

        if (localStream) {
            const tracks = localStream.getTracks();
            tracks.forEach(track => track.stop());
        }
    }
   
    window.onload = function() {
        // Your code to display the overlay and modal
        document.getElementById('overlay').style.display = 'block';
        document.getElementById('modal').style.display = 'block';
    };


    function stopMedia() {
        // Stop the camera and microphone without closing the connection
        if (localStream) {
            const tracks = localStream.getTracks();
            tracks.forEach(track => track.stop());
        }
        
        closeModal();
        // You can also close the popup here if needed
    }
</script>


  
</body>



</html>


