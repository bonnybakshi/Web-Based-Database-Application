<!DOCTYPE html>
<html lang="en">
<head>
   <title>Manage Invoice</title>
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
    
   <cfparam name="URL.clientId" default="AA" type="string">
    

   <cfif URL.clientId NEQ "AA"> 
   <!--- ### Report Code Starts Here --->
   <div class="home">
      <ul>
         <li><a href="index.cfm">Home</a></li>
         <li><a href="logout.cfm">Logout</a></li>
         <li><a href="manageinvoice.cfm">Back</a></li>
      </ul>
   </div>
   <cfquery name="getClient"
            datasource="#Request.DSN#"
            username="#Request.username#"
            password="#Request.password#">
         select *
         from tbClient
         where clientId = <cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="#URL.clientId#">
   </cfquery>

   <cfquery name="getInvoice"
                 datasource="#Request.DSN#"
                 username="#Request.username#"
                 password="#Request.password#">
          select i.invoiceNo, 
                to_char(i.paymentDate,'MM/DD/YYYY') as paymentDate,
                i.paymentAmt,
                i.paymentMethod,
                s.serviceType,
                s.serviceDescr,
                to_char(a.visitDate,'MM/DD/YYYY') as visitDate
             from tbService s, tbServiceRendered r,
             tbAppointment a, tbInvoice i, tbClient c
             where 
             s.serviceId = r.serviceId and
             a.appointmentNo = r.appointmentNo and
             i.invoiceNo(+) = r.invoiceNo and
             i.clientId = c.clientId and
             c.clientId = <cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="#URL.clientId#">
             order by 1
   </cfquery>

   <cfif getClient.RecordCount IS 0>
           Invalid Client, please
           <a href="manageservice.cfm">try again</a>
   <cfelse>
      <h3>
         Client ID: <cfoutput>#getClient.clientId#</cfoutput>
      </h3>
      <h3>
         Client Name: <cfoutput>#getClient.name#</cfoutput>
      </h3>
            
      <h4>
      <cfif getInvoice.RecordCount IS 0>
         Currently there are no Invoice for this client
      <cfelseif getInvoice.RecordCount IS 1>
         There is 1 Invoice for this client
      <cfelse>
         There are
         <cfoutput>#getInvoice.RecordCount#</cfoutput>
         Invoices for this client
      </cfif>  <!--- ### getInvoice.RecordCount IS  0 --->
      </h4>
      
      <!--- ###### Invoice reports ###### --->
           <cfif getInvoice.RecordCount GT 0>
            <table id="myTable" class="tablesorter">
            <thead>
             <tr>
               <th>Invoice Number</th>
               <th>Payment Date</th>
                <th>Payment Amount</th>
                <th>Payment Method</th>
                <th>Service Type</th>
                <th>Service Description</th>
                <th>Visit Date</th>
             </tr>
             </thead>
              <tbody>
             <cfoutput query="getInvoice">
             <cfform action="manageinvoice.cfm" method="post">
             <tr>
              <td style="text-align: center">#invoiceNo#</td>
              <td style="text-align: center">#paymentDate#</td>
              <td style="text-align: center">$ #paymentAmt#</td>
              <td style="text-align: center">#paymentMethod#</td>
              <td style="text-align: center">#serviceType#</td>
              <td style="text-align: center">#serviceDescr#</td>
               <td style="text-align: center">#visitDate#</td>
              </tr>
              <input type="hidden" name="clientId" value="#URL.clientId#" />
              <input type="hidden" name="invoice" value="#invoiceNo#" />
             </cfform>
             </cfoutput>
              <tbody>
            </table>

        </cfif>    <!--- ### getRendered.RecordCount GT 0 --->

    </cfif>  <!--- ### getService.RecordCount IS 0 --->
  
  <cfelse>   <!--- ###  ### else URL.serviceId NEQ "AA" --->
    

   
   
   <cfif IsDefined("Form.amount")>
   <cftry>
   <!--- ### Amount Action Code Starts Here --->
   <div class="home">
      <ul>
         <li><a href="index.cfm">Home</a></li>
         <li><a href="logout.cfm">Logout</a></li>
         <li><a href="manageinvoice.cfm">Back</a></li>
      </ul>
   </div>
   
      <cfquery name="selectAmount"
            datasource="#Request.DSN#"
            username="#Request.username#"
            password="#Request.password#">
          SELECT c.name, i.paymentMethod ,i.paymentAmt 
          FROM tbClient c, tbInvoice i
          WHERE c.clientId = i.clientId
          and i.paymentAmt > #Form.paymentAmt#
      </cfquery>

      <cfif selectAmount.RecordCount IS 0>
        <h3> There are no clients who spend more than $
        <cfoutput>#Form.paymentAmt#</cfoutput></h3>
      <cfelse>
      <h3> List of all clients who spend more than $
      <cfoutput>#Form.paymentAmt#</cfoutput> </h3>
       
       <table id="myTable" class="tablesorter">
            <thead>
            <tr>
              <th>Client Name</th>
              <th>Payment Method</th>
              <th>paymentAmt</th>
            </tr>
             </thead>
             <cfoutput query="selectAmount"> 
             <tbody>
            <tr>
              <td >#name#</td>
              <td>#paymentMethod#</td>
              <td>#paymentAmt#</td>
            </tr>
             <tbody>
            </cfoutput>
            </table>
      </cfif><!--- ### selectAmount.RecordCount IS 0--->
  <cfcatch type = "any">
    <cfoutput>
       <h4>
          There has been a type = #CFCATCH.TYPE# Error.<br />
          <p>Please report to the following information to your System Administrator:  #cfcatch.message#</p>
         </h4>
    </cfoutput>
         <h4>
            <a href="manageinvoice.cfm"> Choose Another Client</a>  |
            <a href="index.cfm"> Back to Home Page</a>
         </h4>

  </cfcatch>
  </cftry>
  
  <cfelse> <!--- ### else Amount Action Code Starts Here --->
  

  <!--- ### Clients page --->
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
      <h2>
         Manage Client Invoice
      </h2>
      <h3>
         List of Clients
      </h3>
      <h5>
         Click on clients Name to view Invoice
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
             </thead>
             <tbody>
             <cfoutput query="getClients">
            <tr>
              <td >#getClients.clientId#</td>
              <td><a href="manageinvoice.cfm?clientId=#getClients.clientId#">#getClients.name#</a></td>
              <td>#getClients.phone#</td>
              <td>#getClients.email#</td>
            </tr>
             </cfoutput>
             <tbody>
            </table>
         </cfif>

         <!---  ### Select Amount Form ---> 
      <cfform action="manageinvoice.cfm" method="POST">
      <h4> Show all clients who spend more than the Entered Amount </h4>
         <label style="color:#C13A2C;" for="paymentAmt">
            Enter Amount:
         </label>             
        <cfinput name="paymentAmt" type="text"
                 size="4"
                 maxlength="10" range="0,10000"
                 required="yes" validate="float"
                 message="Please enter Service Price (Price between 0 and 10000)">
            <br/>
            <br/>
            <input class="cursor_p" name="amount" type="submit" value="Show Client">
              
            <input class="cursor_p" name="reset" type="reset" value="Clear">      
         </cfform>
        
        <!---  ### End Select Amount Form --->
  
  </cfif> <!---  ### IsDefined("Form.amount") ---> 
  
  </cfif>  <!---  ### URL.clientId NEQ "AA" ---> 

    <cfinclude template = "footer.cfm">
  </cfif>
</body>
</html>