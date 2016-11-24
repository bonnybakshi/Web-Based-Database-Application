<!DOCTYPE html>
<html lang="en">
<head>
   <title>Manage Clients</title>
   <link href='https://fonts.googleapis.com/css?family=Allura' rel='stylesheet' type='text/css'>
   <cfinclude template = "tablesorter_blue/style.css">
   <script type="text/javascript" src="http://ajax.googleapis.com/ajax/libs/jquery/1/jquery.min.js"></script>
   <script type="text/javascript" src="js/jquery.tablesorter.min.js"></script>
   <cfinclude template = "mystyle.css">
   <script>
      $(document).ready(function() { 
          $("#myTable").tablesorter();
          $("table.tablesorter").tablesorter({widgets: ['zebra']}); 
          $("#myTable").tablesorter({sortList:[[0,0]]})
        }
      );
   </script>
</head>

<body>
    
  <cfif not IsDefined ("Cookie.userview")>
      <cflocation url="login.cfm">
   <cfelse>
    
   <cfinclude template = "header.cfm">


   <cfparam name="Form.clientId" default="AAAA" type="string">

   <cfif IsDefined("Form.delete")>
   <!--- ### Delete Action Code Starts Here --->

   <cftry>
      <cfquery name="deleteClient"
            datasource="#Request.DSN#"
            username="#Request.username#"
            password="#Request.password#">
         delete from tbClient
         where clientId = <cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="#Form.clientId#">
      </cfquery>

      <cfoutput>
        <cflocation url="manageclient.cfm">
      </cfoutput>

   <cfcatch type = "any">
		<cfoutput>
		   <h4>
		      There has been a type = #CFCATCH.TYPE# Error.<br />
		      <p>Please report to the following information to your System Administrator:  #cfcatch.message#</p>
         </h4>
		</cfoutput>
         <h4>
            <a href="manageclient.cfm"> Choose Another Client</a>  |
            <a href="index.cfm"> Back to Home Page</a>
         </h4>

	</cfcatch>
   </cftry>

   <cfelseif IsDefined ("URL.clientId")>

   <!--- ### Detail Form Code Starts Here --->

   <cfquery name="getAppointment"
         datasource="#Request.DSN#"
         username="#Request.username#"
         password="#Request.password#">
            select a.appointmentNo, c.name,  to_char(a.visitDate,'MM/DD/YYYY') as visitDate, 
                  a.visitTime, a.status, ser.serviceType, ser.serviceDescr  
            from tbClient c, 
              tbAppointment a,  
              tbServiceRendered sr,
              tbService ser
            where c.clientId = a.clientId 
            and a.appointmentNo = sr.appointmentNo
            and sr.serviceId = ser.serviceId
            and a.clientId = <cfqueryparam cfsqltype="CF_SQL_CHAR" value="#URL.clientId#">
            order by 1, 2
   </cfquery>

   <cfquery name="getClient"
         datasource="#Request.DSN#"
         username="#Request.username#"
         password="#Request.password#">
            select *
            from tbClient
            where clientId = <cfqueryparam cfsqltype="CF_SQL_CHAR" value="#URL.clientId#">
   </cfquery>

   <cfif getAppointment.RecordCount GT 0>
   <div class="home">
      <ul>
         <li><a href="index.cfm">Home</a></li>
         <li><a href="logout.cfm">Logout</a></li>
         <li><a href="manageclient.cfm">Back</a></li>
      </ul>
   </div>
      <h3>
         Appointment for <cfoutput>#getClient.name#</cfoutput>
      </h3>
      <cfform action="manageclient.cfm" method="POST">
         <table id="myTable" class="tablesorter">
         <thead>
            <tr>
                <th>Visit Date</th>
                <th>Visit Time</th>
                <th>Service Type</th>
                <th>Service Description</th>
                <th>Appointment Status</th>
            </tr>
         </thead>
         <tbody>
            <cfoutput query="getAppointment">
            <tr>
               <td >#visitDate#</td>
               <td >#visitTime#</td>
               <td >#serviceType#</td>
               <td >#serviceDescr#</td>
               <td >#status#</td>
            </tr>
            </cfoutput>
         </tbody>
         </table>
      </cfform>
   <cfelse>
      <h3>
         <cfoutput>#getClient.name#</cfoutput> has no  Appointment
      </h3>
   </cfif>

   <form action="manageclient.cfm" method="post">
      <cfoutput>
         <input type="hidden" name="clientId" value="#URL.clientId#">
      </cfoutput>
      <input class="cursor_p" type="submit" name="delete" value="Delete Client" style="color:red;"/> 
         <h4> Warning! Deleting will parmanently remove all information about this client.</h4>
   </form>

   <cfelse>

    <!--- ### Client List Form Code Starts Here --->
  <div class="home">
      <ul>
         <li><a href="index.cfm">Home</a></li>
         <li><a href="logout.cfm">Logout</a></li>
      </ul>
   </div>

   <cfquery name="getClients"
         datasource="#Request.DSN#"
         username="#Request.username#"
         password="#Request.password#">
         select *
         from tbClient
         order by 1
   </cfquery>
      <h2 class="pageheader">
         Manage Clients
      </h2>
      <h3>
         List of Clients
      </h3>
      <h5>
         Click on client's Name to view Appointment History
         <br/>
         (click on column headers to sort list)
      </h5> 

      <cfif getClients.RecordCount GT 0>
         <table id="myTable" class="tablesorter">
         <thead>
            <tr>
              <th>Client<br />ID</th>
              <th>Client Name</th>
              <th>Client Phone</th>
              <th>Client Email</th>
            </tr>
         <thead>
         <tbody>
            <cfoutput query="getClients">
            <tr>
              <td >#getClients.clientId#</td>
              <td><a href="manageclient.cfm?clientId=#getClients.clientId#">#getClients.name#</a></td>
              <td>#getClients.phone#</td>
              <td>#getClients.email#</td>
            </tr>
            </cfoutput>
         </tbody>
         </table>
      </cfif> <!--- ### getClients.RecordCount GT 0 --->

    </cfif> <!--- ### IsDefined("Form.delete") --->


    <cfinclude template = "footer.cfm">
   
    </cfif>
    </body>
</html>
