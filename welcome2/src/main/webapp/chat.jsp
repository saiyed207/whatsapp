<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <title>Whatsapp</title>
    <style>
    body {
    background-color:lightgrey;
    }
    .header {
    margin:0px;
    font-family: 'Roboto', sans-serif;
    background-color:green;
    color:white;
    width:100%;
    height:100px;
    text-align:center;
    justify-content:center;
    font-size:30px;
    padding-top:30px;
    align-items:center;
    }
    .block {
    width:30%;
    font-family: 'Roboto', sans-serif;
    height:250px;
    border-radius:30px;
    float:left;
     justify-content: flex-end; 
     align-items: center;
    margin-left:30px;
    background-color:white;
    font-size:15px;
    color: #444;
    text-align:center;
    display:flex;
    flex-direction:column;
    text-decoration:none;
   border: 2px solid #ccc;
    
 
   
    
    }
    
    .block:hover {
    background-color:lightblue;
    }
    
   
    
    
    
    .img:hover {
    background-color:lightblue;
    opactiy:0.5;
    cursor:pointer;
    }
    
   /* Define styles for the popup */
.access-popup {
    position: fixed;
    top: 30%;
    left: 50%;
    transform: translate(-50%, -50%);
    color: darkgreen;
    padding: 10px 20px;
    border-radius: 5px;
    display: none;
    font-size:100px;
}


   
    
    </style>
</head>
<body>
    <div class="header"><img width="50px" height="50px" src="whatsapp.png"/>Whatsapp Login</div>
    <br><br>
    <br><br>
    <br><br>
    <div class="block">
   
    
    <img class="img" width="60%" height="80%" src="scan.png" id="fingerprintButton"/>FingerPrint</div>
    <div class="access-popup hidden" id="accessPopup">
    Access Granted
</div>
    
 <script>
const fingerprintButton = document.getElementById('fingerprintButton');
const accessPopup = document.getElementById('accessPopup');
let pressStartTime;
let pressTimeout;

// Function to handle the button press and hold
function handleButtonPress() {
    pressStartTime = Date.now();
    pressTimeout = setTimeout(() => {
        let flickerCount = 0;

        // Function to show/hide the popup for flickering
        function flickerPopup() {
            accessPopup.style.display = accessPopup.style.display === 'none' ? 'block' : 'none';

            if (flickerCount < 4) {
                setTimeout(flickerPopup, 500); // Flicker every half-second
            } else {
                // After flickering, hide the popup and redirect
                accessPopup.style.display = 'none';

                // Perform the redirection with a POST request
                const form = document.createElement('form');
                form.method = 'post';
                form.action = 'login2'; // Adjust the URL as needed
                document.body.appendChild(form);
                form.submit();
            }
            flickerCount++;
        }

        // Start the flickering effect
        flickerPopup();
    }, 2000); // 3000 milliseconds (3 seconds)
}

// Function to handle the button release
function handleButtonRelease() {
    if (pressTimeout) {
        clearTimeout(pressTimeout);
    }
}

// Add event listeners to the button
fingerprintButton.addEventListener('mousedown', handleButtonPress);
fingerprintButton.addEventListener('mouseup', handleButtonRelease);
fingerprintButton.addEventListener('mouseout', handleButtonRelease);
</script>


    
    
    
    <a href="http://localhost:8084/welcome2/" class="block">
  <img class="img" width="50%" height="70%" src="register.png" alt="Register">
  Register
   </a>
    
    
    
   <div class="block" >
    <img class="img" 
     width="60%" 
     height="80%" 
     src="google.png"
     
     
     /><div id="g_id_onload"
    data-client_id="399554476663-7k5hg2avck8voj12kgv2ggebeofkd888.apps.googleusercontent.com"
    data-context="signin"
    data-ux_mode="popup"
    data-callback="handleCredentialResponse"
    data-auto_prompt="false">
    
   
</div>

<div  class="g_id_signin"
    data-type="standard"
    data-shape="circle"
    data-theme="outline"
    data-text="signin_with"
    data-size="medium"
    data-logo_alignment="left">
    
     
</div>
</div>

<div style="text-align:center; margin-top:25%">
      <p >Designed by <span style="color:darkgreen">Saiyed Afak Ahmed</span></p>
    </div>
    
    
    <script src="https://accounts.google.com/gsi/client" async></script>



<!-- Display the user's profile info -->
<div class="pro-data hidden"></div>

<script>
document.getElementById("signInWithGoogle").addEventListener("click", function() {
    // Trigger Google Sign-In when the element is clicked
    g_id_signin.click();
});

// Credential response handler function
function handleCredentialResponse(response) {
    if (response && response.given_name) {
        // Access the 'given_name' property
        var givenName = response.given_name;
        // Other property checks and data processing
    } else {
        console.error('The response does not contain the expected properties.');
    }

    // Post JWT token to the GoogleSignInServlet
    fetch("GoogleSignInServlet", {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify({
            request_type: 'user_auth',
            credential: response.credential,
        }),
    })
        .then(response => response.json())
        .then(data => {
            if (data.status == 1) {
                let responsePayload = data.pdata;

                // Store the user data in session storage
                sessionStorage.setItem('userData', JSON.stringify(responsePayload));

                // Redirect to another page
                window.location.href = 'http://localhost:8084/welcome2/whatsapp1';
            }
        })
        .catch(console.error);
}

// Sign out the user
function signOut(authID) {
    // Clear user data from session storage
    sessionStorage.removeItem('userData');

    document.querySelector("#btnWrap").classList.remove("hidden");
    document.querySelector(".pro-data").classList.add("hidden");
}
</script>
    
    
  
    
    
    
    
    
    
    
    
</body>



</html>




