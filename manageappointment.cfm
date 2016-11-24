<!DOCTYPE html>
  <head>
      <title>Manage Appointment</title>
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


  <cfparam name="URL.clientId" default="AAAA" type="string">
  <cfparam name="Form.visitDate" default="AAAA" type="string">


  <cfif URL.clientId NEQ "AAAA">

  <!--- ### Report Code Starts Here --->
  <div class="home">
        <ul>
          <li><a href="index.cfm">Home</a></li>
          <li><a href="logout.cfm">Logout</a></li>
          <li><a href="manageappointment.cfm">Back</a></li>
        </ul>
    </div>

    <cfquery name="getClient"
          datasource="#Request.DSN#"
          username="#Request.username#"
          password="#Request.password#">
              Select *
              from tbClient
              where clientId = <cfqueryparam cfsqltype="CF_SQL_CHAR" value="#URL.clientId#">
    </cfquery>
    

   <cfquery name="getAppointment"
          datasource="#Request.DSN#"
          username="#Request.username#"
          password="#Request.password#">
              select  a.appointmentNo, 
                      c.name, 
                      to_char(a.visitDate,'MM/DD/YYYY') as visitDate, 
                      a.visitTime, 
                      a.status
              from tbClient c, tbAppointment a
              where c.clientId = a.clientId 
              and a.clientId = <cfqueryparam cfsqltype="CF_SQL_CHAR" value="#URL.clientId#">
              order by 1, 2
    </cfquery>

  <cfif getClient.RecordCount IS 0>
        Invalid Client, please select a Client
        <a href="manageappointment.cfm">Try Again</a>
    <cfelse>
        <h2>
            Client: <cfoutput>#getClient.name#</cfoutput>
        </h2>
        <h4>
        <cfif getAppointment.RecordCount IS 0>
            There are no Appointments for this client
        <cfelseif getAppointment.RecordCount IS 1>
              This client has only 1 appointment.
        <cfelse>
            This Client has 
            <cfoutput>#getAppointment.RecordCount#</cfoutput>
            Appointments
        </cfif>  <!--- ### getAppointment.RecordCount IS 0 --->
            </h4>
      
    <!--- ### Form to Update Appointment status--->

      <cfif getAppointment.RecordCount GT 0>
        <table id="myTable" class="tablesorter">
            <tr height="20">
              <th>Visit Date</th>
              <th>Visit Time</th>
              <th>Appointment Status</th>
              <th>Update appointment </th>
            </tr>
        <tbody>
            <cfoutput query="getAppointment">
            <cfform action="updateappointment.cfm" method="post">
            <tr <cfif CurrentRow MOD  2 IS 1>style="background-color: ##D5DBDD"</cfif>>
              <td >#getAppointment.visitDate#</td>
              <td >#getAppointment.visitTime#</td>
              <td >#getAppointment.status#</td>
              <td>
                <input type="hidden" name="clientId" value="#URL.clientId#" />
                <input type="hidden" name="appointmentNo" value="#appointmentNo#" />
                <input type="submit" value="Update" />
              </td>
             </tr>
            </cfform>
            </tbody>
            </cfoutput>

        </table>
    </cfif>    <!--- ### getAppointment.RecordCount GT 0 --->

  </cfif> <!--- ### getClient.RecordCount IS 0 --->

    <cfelse>

  <!--- ### Form Code Starts Here --->
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
         Manage Client Appointments
      </h2>
    <h3>
        List of Clients
    </h3>
    <h4>Click on client's name to manage Appointment
    <br/>
    (click on column headers to sort list)
    </h4>
       <table id="myTable" class="tablesorter">
       <thead>
         <tr>
          <th>Client<br />ID</th>
          <th>Client Name</th>
          <th>Client Phone</th>
          <th>Client Email</th>
         </tr>
      </thead>
      <tbody>
        <cfoutput query="getClients">
         <tr>
          <td>#getClients.clientId#</td>
          <td><a href="manageappointment.cfm?clientId=#getClients.clientId#">#getClients.name#</a></td>
          <td>#getClients.phone#</td>
          <td>#getClients.email#</td>
          </tr>
        </cfoutput>
        </tbody>
      </table>

    </cfif> <!--- ### URL.clientId NEQ "AAAA" --->

    <cfinclude template = "footer.cfm">
    </cfif>
    </body>
</html>