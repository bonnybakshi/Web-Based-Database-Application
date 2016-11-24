<!DOCTYPE html>
<html>
    <head>
        <title>Manage services</title>
        <link href='https://fonts.googleapis.com/css?family=Allura' rel='stylesheet' type='text/css'>
        <cfinclude template = "mystyle.css">
        <cfinclude template = "tablesorter_blue/style.css">
        <script type="text/javascript" src="http://ajax.googleapis.com/ajax/libs/jquery/1/jquery.min.js"></script>
        <script type="text/javascript" src="js/jquery.tablesorter.min.js"></script>
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
    

  <cfparam name="URL.serviceId" default="AA" type="string">
  <cfparam name="Form.servicePrice" default="0.00" type="numeric">

<cfif URL.serviceId NEQ "AA"> 
<!--- ### Report Code Starts Here --->

<div class="home">
      <ul>
         <li><a href="index.cfm">Home</a></li>
         <li><a href="logout.cfm">Logout</a></li>
         <li><a href="manageservice.cfm">Back</a></li>
      </ul>
   </div>

   <cfquery name="getService"
            datasource="#Request.DSN#"
            username="#Request.username#"
            password="#Request.password#">
         select *
         from tbService
         where serviceId = <cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="#URL.serviceId#">
   </cfquery>

   <cfquery name="getRendered"
                 datasource="#Request.DSN#"
                 username="#Request.username#"
                 password="#Request.password#">
          select c.name, a.appointmentNo, to_char(a.visitDate,'MM/DD/YYYY') as visitDate, a.visitTime, a.status, a.clientId
             from tbService s, tbServiceRendered r,
             tbAppointment a, tbInvoice i, tbClient c
             where 
             s.serviceId = r.serviceId and
             a.appointmentNo = r.appointmentNo and
             i.invoiceNo(+) = r.invoiceNo and
             a.clientId = c.clientId and
             s.serviceId = <cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="#URL.serviceId#">
             order by 1
   </cfquery>

   
   <cfif getService.RecordCount IS 0>
      Invalid Service, please
      <a href="manageservice.cfm">try again</a>
   <cfelse>
      <h3>
         Service Type: <cfoutput>#getService.serviceType#</cfoutput>
      </h3>
      <h3>
         Service Description: <cfoutput>#getService.serviceDescr#</cfoutput>
      </h3>
      
   <h4>
      <cfif getRendered.RecordCount IS 0>
         Currently there are no appointments for this service
      <cfelseif getRendered.RecordCount IS 1>
         There is 1 appointment for this service
      <cfelse>
         There are
            <cfoutput>#getRendered.RecordCount#</cfoutput>
         appointments for this service
      </cfif>  <!--- ### getRendered.RecordCount IS 0 --->
   </h4>
      
   <!--- ###### Appointment reports ###### --->
   <cfif getRendered.RecordCount GT 0>
      <table id="myTable" class="tablesorter">
      <thead>
       <tr>
         <th>Client Name</th>
          <th>Visit Date</th>
          <th>Visit Time</th>
          <th>Appointment Status</th>
       </tr>
       </thead>
        <tbody>
       <cfoutput query="getRendered">
       <cfform action="manageservice.cfm" method="post">
       <tr>
        <td>#name#</td>
        <td>#visitDate#</td>
        <td>#visitTime#</td>
        <td>#status#</td>
        </tr>
        <input type="hidden" name="serviceId" value="#URL.serviceId#" />
        <input type="hidden" name="appointmentNo" value="#appointmentNo#" />
       </cfform>
       </cfoutput>
        <tbody>
      </table>

   </cfif>    <!--- ### getRendered.RecordCount GT 0 --->

   </cfif>  <!--- ### getService.RecordCount IS 0 --->
  
   <cfelse>   <!--- ###  ### else URL.serviceId NEQ "AA" --->
    
   <!--- ### Form Code Starts Here --->
    <div class="home">
      <ul>
         <li><a href="index.cfm">Home</a></li>
         <li><a href="logout.cfm">Logout</a></li>
      </ul>
   </div>
      <cfquery name="getServices"
             datasource="#Request.DSN#"
             username="#Request.username#"
             password="#Request.password#">
         select *
         from tbService
         order by 1
      </cfquery>
      <cfquery name="getActive"
             datasource="#Request.DSN#"
             username="#Request.username#"
             password="#Request.password#">
          SELECT s.serviceId, 
                s.serviceType, 
                s.serviceDescr,
                s.serviceDuration,
                s.servicePrice,
                COUNT (a.appointmentNo) as "aptCount"
          FROM tbAppointment a, 
             tbService s, tbServiceRendered sr
          WHERE a.appointmentNo = sr.appointmentNo
          and s.serviceId = sr.serviceId
          GROUP BY s.serviceId, s.serviceType, s.serviceDescr,s.serviceDuration,s.servicePrice
          ORDER BY 6 DESC
      </cfquery>
      
      <h2> Manage Services </h2>
      <h5>
         Click on Service Type to view Appointments
         <br/>
         (click on column headers to sort list)
      </h5> 
     
      <!--- ###### Active service list ###### --->
   <cfif getActive.RecordCount GT 0>
      <table id="myTable" class="tablesorter">
      <thead>
       <tr>
         <th>Service Type</th>
          <th>Service Description</th>
          <th>Service Duration</th>
          <th>Service Price</th>
          <th>Number of Appointments</th>
       </tr>
       </thead>
        <tbody>
       <cfoutput query="getActive">
       <cfform action="manageservice.cfm" method="post">
       <tr>
        <td><a href="manageservice.cfm?serviceId=#getActive.serviceId#">#serviceType#</a></td>
        <td>#serviceDescr#</td>
        <td>#serviceDuration#</td>
        <td>$ #servicePrice#</td>
        <td>#aptCount#</td>
        </tr>
        <input type="hidden" name="serviceId" value="#URL.serviceId#" />
       </cfform>
       </cfoutput>
        <tbody>
      </table>
   </cfif>    <!--- ### getActive.RecordCount GT 0 --->

    <br/>
    <br/>
    <!--- ### Service List--->
    <h3>List of Salon Services</h3>
    
    <!--- ### Link to enter new service --->
    <form action="addservice.cfm" method="post">
     <div>
      <cfoutput>
        <input type="hidden" name="serviceId" value="#URL.serviceId#" />
      </cfoutput>
        <input id="addservice" class="cursor_p" type="submit" name="addservice" value="ADD SERVICE" />
     </div>
    </form>

   <table id="myTable" class="tablesorter">
       <thead>
          <tr>
              <th>Service Number</th>
              <th>Service Type</th>
              <th>Service Description</th>
              <th>Service Duration</th>
              <th>Service Price </th>
          </tr>
        </thead>
        <tbody>
        <cfoutput query="getServices">
         <tr>
            <td>#getServices.serviceId#</td>
            <td >#serviceType#</td>
            <td >#serviceDescr#</td>
            <td >#serviceDuration#</td>
            <td >$ #servicePrice#</td>
          </tr>
        </cfoutput>
        </tbody>
       </table>
  
        
  </cfif>  <!---  ### URL.serviceId NEQ "AA" ---> 

    <cfinclude template = "footer.cfm">
  </cfif>
</body>
</html>