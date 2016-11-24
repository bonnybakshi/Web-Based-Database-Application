<!DOCTYPE html>
<html lang="en">

  <head>
  <link href='https://fonts.googleapis.com/css?family=Allura' rel='stylesheet' type='text/css'>
  <title>Logout</title>
  <cfinclude template = "mystyle.css">
  </head>

  <body>
   <cfinclude template = "login.cfm">
   <cflogout>
   <cfcookie name="userview" expires="now">
  </body>
</html>