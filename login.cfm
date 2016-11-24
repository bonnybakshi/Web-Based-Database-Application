<!DOCTYPE html>
<html lang="en">
<head>
<title>Login Page</title>
<link href='https://fonts.googleapis.com/css?family=Allura' rel='stylesheet' type='text/css'>
<cfinclude template = "mystyle.css">
</head>

  <!--- Place cursor in "User Name" field when page loads--->

<body onLoad="document.login.userLogin.focus();">  
  <cfset myaction="forceUserLogin.cfm">
<!--- login Form starts here --->
    <cfform action="#myaction#" name="login" method="post" preservedata="yes">
    
      <div class="login-block">
          <img  src="images/logo3.png" alt="site logo" width="320">
          <h1>Login</h1>
          <label for="userLogin">
            User Name
          </label>
          <cfinput id="username" type="text" name="userLogin" size="20" value=""
                        maxlength="100" required="yes"
                        message="Please enter your USERNAME">
          <input type="hidden" name="userLogin_required">
          <label for="userPassword">
            Password
          </label>
          <cfinput id="password" type="password" name="userPassword" size="20" value=""
                         maxlength="100" required="yes"
                         message="Please enter your PASSWORD">
          <input type="hidden" name="userPassword_required">
          <input id="submitbtn" type="submit" name="login" value="Login" />
      </div>
    </cfform>

    <cfinclude template = "footer.cfm">

  </body>
</html>
