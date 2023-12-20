<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Whatsapp Login</title>
  <script src="https://apis.google.com/js/platform.js" async defer></script>
    <meta name="google-signin-client_id" content="399554476663-ul9oo9s5vnn4uv86vbdci9fa9vbhuq34.apps.googleusercontent.com">
  <style>
  *, *::before, *::after {
	box-sizing: border-box;
}

body {
	margin: 0;
	font-family: Roboto, -apple-system, 'Helvetica Neue', 'Segoe UI', Arial, sans-serif;
	background: lightgrey;
}

.forms-section {
	display: flex;
	flex-direction: column;
	justify-content: center;
	align-items: center;
	


}

.section-title {
	font-size: 32px;
	letter-spacing: 1px;
	color: #fff;
	margin-bottom: 30px;
}

.forms {
	display: flex;
	align-items: flex-start;
	margin-top: 30px;
}

.form-wrapper {
	animation: hideLayer .3s ease-out forwards;
}

.form-wrapper.is-active {
	animation: showLayer .3s ease-in forwards;
}

@keyframes showLayer {
	50% {
		z-index: 1;
	}
	100% {
		z-index: 1;
	}
}

@keyframes hideLayer {
	0% {
		z-index: 1;
	}
	49.999% {
		z-index: 1;
	}
}

.switcher {
	position: relative;
	cursor: pointer;
	display: block;
	margin-right: auto;
	margin-left: auto;
	padding: 0;
	text-transform: uppercase;
	font-family: inherit;
	font-size: 16px;
	letter-spacing: .5px;
	color: #fff;
	background-color: transparent;
	border: none;
	outline: none;
	transform: translateX(0);
	transition: all .3s ease-out;
}

.form-wrapper.is-active .switcher-login {
	color: green;
	transform: translateX(90px);
}

.form-wrapper.is-active .switcher-signup {
	color: green;
	transform: translateX(-90px);
}

.underline {
	position: absolute;
	bottom: -5px;
	left: 0;
	overflow: hidden;
	pointer-events: none;
	width: 100%;
	height: 2px;
}

.underline::before {
	content: '';
	position: absolute;
	top: 0;
	left: inherit;
	display: block;
	width: inherit;
	height: inherit;
	background-color: currentColor;
	transition: transform .2s ease-out;
}

.switcher-login .underline::before {
	transform: translateX(101%);
}

.switcher-signup .underline::before {
	transform: translateX(-101%);
}

.form-wrapper.is-active .underline::before {
	transform: translateX(0);
}

.form {
	overflow: hidden;
	min-width: 260px;
	margin-top: 50px;
	padding: 30px 25px;
  border-radius: 5px;
	transform-origin: top;
  background-color: lightgreen;
}

.form-login {
	animation: hideLogin .3s ease-out forwards;
}

.form-wrapper.is-active .form-login {

	animation: showLogin .3s ease-in forwards;
}

@keyframes showLogin {
	0% {
		 background-image: linear-gradient(green, white, white);
		transform: translate(40%, 10px);
		
	}
	50% {
		transform: translate(0, 0);
	}
	100% {
		 background-image: linear-gradient(green, white, white);
		transform: translate(35%, -20px);
		
	}
}

@keyframes hideLogin {
	0% {
		background-color: lightgreen;
		transform: translate(35%, -20px);
	}
	50% {
		transform: translate(0, 0);
	}
	100% {
		background: lightgreen;
		transform: translate(40%, 10px);
	}
}

.form-signup {
	animation: hideSignup .3s ease-out forwards;
}

.form-wrapper.is-active .form-signup {
	animation: showSignup .3s ease-in forwards;
}

@keyframes showSignup {
	0% {
		 background-image: linear-gradient(green, white, white);
		transform: translate(-40%, 10px) scaleY(.8);
	}
	50% {
		transform: translate(0, 0) scaleY(.8);
	}
	100% {
		 background-image: linear-gradient(green, white, white);
		transform: translate(-35%, -20px) scaleY(1);
	}
}

@keyframes hideSignup {
	0% {
		background-color: lightgreen;
		transform: translate(-35%, -20px) scaleY(1);
	}
	50% {
		transform: translate(0, 0) scaleY(.8);
	}
	100% {
		background: lightgreen;
		transform: translate(-40%, 10px) scaleY(.8);
	}
}

.form fieldset {
	position: relative;
	opacity: 0;
	margin: 0;
	padding: 0;
	border: 0;
	transition: all .3s ease-out;
}

.form-login fieldset {
	transform: translateX(-50%);
}

.form-signup fieldset {
	transform: translateX(50%);
}

.form-wrapper.is-active fieldset {
	opacity: 1;
	transform: translateX(0);
	transition: opacity .4s ease-in, transform .35s ease-in;
}

.form legend {
	position: absolute;
	overflow: hidden;
	width: 1px;
	height: 1px;
	clip: rect(0 0 0 0);
}

.input-block {
	margin-bottom: 20px;
    
}

.input-block label {
	font-size: 14px;
	color: black;
}

.input-block input {
	display: block;
	width: 100%;
	margin-top: 8px;
	padding-right: 15px;
	padding-left: 15px;
	font-size: 16px;
	line-height: 40px;
	color: #fff;
	background: #666;
	border: 1px solid green;
	border-radius: 2px;
}

.form [type='submit'] {
	opacity: 0;
	display: block;
	min-width: 120px;
	margin: 30px auto 10px;
	font-size: 18px;
	line-height: 40px;
	border-radius: 25px;
	border: none;
	transition: all .3s ease-out;
}

.form-wrapper.is-active .form [type='submit'] {
	opacity: 1;
	transform: translateX(0);
	transition: all .4s ease-in;
}

.btn-login {
	color: white;
	background: green;
	transform: translateX(-30%);
	
}

.btn-signup {
	color: #444;
	background: green;
	box-shadow: inset 0 0 0 2px #444;
	transform: translateX(30%);
}

.form-login img {
      animation-fill-mode: forwards;
      /* Ensure the animation only runs once */
      animation-iteration-count: 1;
    }

    .profile-circle {
      margin-left:120px;
      top: 30px; /* Adjust the top position as needed */
      left: 50%;
      transform: translateX(-50%);
      background-color: #a7e245;
      width: 120px;
      height: 120px;
      border-radius: 50%;
      display: flex;
      justify-content: center;
      align-items: center;
      overflow: hidden;
    }

    /* Add styles for the profile image inside the circle */
    .profile-image {
      width: 100%;
      height: 100%;
      object-fit: cover;
    }

.background-green {
  position: absolute;
  top: 0;
  width: 100%;
  height: 20%;
  background-color: #009688;
}


  </style>
</head>
<body>
<div class="background-green"></div>
    <section class="forms-section">
    
        <div class="forms" >
          <div class="form-wrapper is-active">
          
            <button type="button" class="switcher switcher-login">
              Login
              <span class="underline"></span>
            </button>
            <form class="form form-login" method="post" action="login">
          <fieldset>
            <!-- Add the green circle wrapper here -->
            <div class="profile-circle">
              <img class="profile-image" src="profile1.gif" alt="Profile Image">
            </div>
            <!-- End of green circle wrapper -->

            <legend>Please, enter your email and password for login.</legend>
            <div class="input-block">
              <label for="login-email">E-mail</label>
              <input id="login-email" name="login-email" type="email" required>
            </div>
            <div class="input-block">
              <label for="login-password">Password</label>
              <input id="login-password" name="login-password" type="password" required>
            </div>
          </fieldset>
        
          <button  type="submit" class="btn-login"><div style="margin-top:5px; position:absolute"><img width="25" height="25"  src="whatsapp.png"/></div>Login</button>
           <div class="g-signin2" data-onsuccess="onSignIn"></div>
        </form>
          </div>
          <div class="form-wrapper">
            <button type="button" class="switcher switcher-signup">
              Sign Up
              <span class="underline"></span>
            </button>
            <form class="form form-signup" method="post" action="myapp"  enctype="multipart/form-data">
    <fieldset>
        <!-- Add the green circle wrapper here -->
        <div class="profile-circle">
            <img class="profile-image" src="profile1.gif" alt="Profile Image">
        </div>
        <!-- End of green circle wrapper -->

        <legend>Please, enter your email, password, and password confirmation for sign up.</legend>
        <div class="input-block">
    <label for="signup-first-name">First Name</label>
    <input id="signup-first-name" name="first_name" type="text" required>
</div>
<div class="input-block">
    <label for="signup-last-name">Last Name</label>
    <input id="signup-last-name" name="last_name" type="text" required>
</div>
<div class="input-block">
    <label for="signup-email">E-mail</label>
    <input id="signup-email" name="username" type="text" required>
</div>
<div class="input-block">
    <label for="signup-password">Password</label>
    <input id="signup-password" name="password" type="password" required>
</div>
<div class="input-block">
    <label for="signup-password-confirm">Confirm password</label>
    <input id="signup-password-confirm" name="confirm_password" type="password" required>
</div>
<div class="input-block">
    <label for="signup-image">Profile Image</label>
    <input id="signup-image" name="image" type="file" accept="image/*">
</div>

    </fieldset>
    <button type="submit" class="btn-signup" style="color:white">Continue</button>
</form>

          </div>
        </div>
      </section>
  <script>
    // Your JavaScript code here
    const switchers = [...document.querySelectorAll('.switcher')];

    switchers.forEach(item => {
      item.addEventListener('click', function() {
        switchers.forEach(item => item.parentElement.classList.remove('is-active'))
        this.parentElement.classList.add('is-active')
      });
    });

    const loginPasswordInput = document.getElementById('login-password');
    const signupPasswordInput = document.getElementById('signup-password');
    const profileImg = document.querySelector('.form-login img');

    let isFirstKeyTypedLogin = true;
    let isFirstKeyTypedSignup = true;
    let hasProfile1Changed = false;
    let hasProfile2Changed = false;

    // Function to change the profile image when the first key is typed
    function updateProfileImage(event) {
      if (this === loginPasswordInput && isFirstKeyTypedLogin) {
        if (!hasProfile1Changed) {
          profileImg.src = 'profile.gif';
          hasProfile1Changed = true;

          // Detect when the animation ends and set the image to profile2.gif
          profileImg.addEventListener('animationend', onAnimationEnd, false);
        }
      }

      if (this === signupPasswordInput && isFirstKeyTypedSignup) {
        if (!hasProfile1Changed) {
          profileImg.src = 'profile.gif';
          hasProfile1Changed = true;

          // Detect when the animation ends and set the image to profile2.gif
          profileImg.addEventListener('animationend', onAnimationEnd, false);
        }
      }
    }

    // Function to handle animationend event
    function onAnimationEnd() {
      // Remove the animationend event listener after the first animation
      profileImg.removeEventListener('animationend', onAnimationEnd, false);

      if (!hasProfile2Changed) {
        profileImg.src = 'profile2.gif';
        hasProfile2Changed = true;
      }
    }

    // Function to reset the profile image to profile1.gif when password is backspaced
    function handlePasswordInput(event) {
      if ((this === loginPasswordInput || this === signupPasswordInput) && this.value === '') {
        profileImg.src = 'profile1.gif';
        hasProfile1Changed = false;
        hasProfile2Changed = false;
      }
    }

    // Attach event listener to password fields for typing
    loginPasswordInput.addEventListener('input', updateProfileImage);
    signupPasswordInput.addEventListener('input', updateProfileImage);

    // Attach event listener to password fields for clearing
    loginPasswordInput.addEventListener('input', handlePasswordInput);
    signupPasswordInput.addEventListener('input', handlePasswordInput);
  </script>
  
  
  

    
   

</body>
</html>
