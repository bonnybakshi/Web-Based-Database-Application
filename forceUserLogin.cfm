
<!--- Force the user to log in --->
<cflogin>

 <!--- If the user hasn't gotten the login form yet, display it --->
 <cfif not (isDefined("FORM.userLogin") and isDefined("FORM.userPassword"))>
    <cfinclude template="login.cfm">
    <cfabort>


 <cfelse>

   <!--- Find record with this Username/Password --->
   <!--- If no rows returned, password not valid --->
   <cfquery name="getUser"
            datasource="#APPLICATION.dataSource#"
             password="#APPLICATION.password#"
             username="#APPLICATION.username#">
              select *
              from tblogin
       where uname = <cfqueryparam cfsqltype="CF_SQL_VARCHAR"
             value="#Form.userLogin#">
             and pwd = <cfqueryparam cfsqltype="CF_SQL_VARCHAR"
                 value="#Form.userPassword#">
   </cfquery>

   <!--- If the username and password are correct. --->
   <cfif getUser.recordCount EQ 1>
     <cfloginuser
     name="#getUser.fname#"
     password="#FORM.userPassword#"
     roles="#getUser.userview#">

     <cfcookie name="userview" value="#getUser.userview#">
      <cflocation url="index.cfm">

   <!--- Otherwise, re-prompt for a valid username and password --->
   <cfelse>
     <div class="error">Sorry, the username and password combination are not recognized.<br />
     Please try again.</div>
     <cfinclude template="login.cfm">
     
     <cfabort>
   </cfif>
 </cfif>
</cflogin>

