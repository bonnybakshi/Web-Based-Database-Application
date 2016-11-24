<!DOCTYPE html>
<html lang="en">
<head>
<title>Home Page</title>
<link href='https://fonts.googleapis.com/css?family=Allura' rel='stylesheet' type='text/css'>
<cfinclude template = "mystyle.css">
</head>
<body>
<cfinclude template = "header.cfm">

    <cfquery name="getUser"
            datasource="#APPLICATION.dataSource#"
             password="#APPLICATION.password#"
             username="#APPLICATION.username#">
          select *
          from tblogin
   </cfquery>

   <cfif not IsDefined ("Cookie.userview")>
         <cflocation url="login.cfm">
   <cfelse>
    <cfif getUser.userview eq "all" >

     <div class="home">
        <ul>
          <li><a href="index.cfm">Home</a></li>
          <li><a href="logout.cfm">Logout</a></li>
        </ul>
      </div>
    
    <p id="welcomemsg">Welcome <cfoutput>#getUser.fname#</cfoutput> </p>
    <div class="home">
        <ul>
          <li>
            <a href="manageclient.cfm"> 
               Manage Client
            </a>
          </li>
          <li>
            <a href="manageappointment.cfm"> 
            Manage Appointment
            </a>
          </li> 
           <li>
            <a href="manageservice.cfm">
            Manage Services
            </a>
          </li>
           <li>
            <a href="manageinvoice.cfm">
            Manage Invoice
            </a>
          </li>
        </ul>    
     </div>
     
   </cfif>
  </cfif>
<cfinclude template = "footer.cfm">

</body>
</html>
