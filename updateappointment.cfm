<!DOCTYPE html>
<html lang="en">
  <head>
    <title>Update Appointment</title>
    <link href='https://fonts.googleapis.com/css?family=Allura' rel='stylesheet' type='text/css'>
    <cfinclude template = "mystyle.css">
  </head>

  <body>
    <cfif not IsDefined ("Form.clientId")>
       <h4>
            <p>Please Choose a client to manage his/her Appointment</p>
            <a href="manageappointment.cfm"> Choose A Client</a>  |
            <a href="index.cfm"> Back to Home Page</a>
         </h4>
   <cfelse>

    <cfinclude template = "header.cfm">
    <div class="home">
      <ul>
         <li><a href="index.cfm">Home</a></li>
         <li><a href="logout.cfm">Logout</a></li>
         <li><a href="manageappointment.cfm?clientId=<cfoutput>#Form.clientId#</cfoutput>">Back</a></li>
      </ul>
   </div>

    <cfparam name="Form.clientId" default="AA" type="string">
    <cfparam name="Form.appointmentNo" default ="AAAA" type="string">
    <cfparam name="Form.status" default ="AAAAAA" type="string">
    

   <cfif IsDefined("Form.update")>
   <!--- ### Update Action Code Starts Here --->
   <cftransaction>
   <cftry>
         <cfquery name="updateAppointment"
                 datasource="#Request.DSN#"
                 username="#Request.username#"
                 password="#Request.password#">
              update tbAppointment
              set
                status ='#Form.status#'
              where appointmentNo = <cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="#Form.appointmentNo#"> 
              and clientId = <cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="#Form.clientId#">
            </cfquery>
            <cftransaction action="commit" /> 
        <cfoutput>
            <cflocation url="manageappointment.cfm?clientId=#Form.clientId#">
        </cfoutput>
    
    <cfcatch type = "any">
    <cftransaction action="rollback" /> 
    <cfoutput>
       <h4>
          There has been a type = #CFCATCH.TYPE# Error.<br />
          <p>Please report to the following information to your System Administrator:  #cfcatch.message#</p>
         </h4>
    </cfoutput>
         <h4>
            <a href="manageappointment.cfm"> Choose Another Client</a>  |
            <a href="index.cfm"> Back to Home Page</a>
         </h4>

  </cfcatch>
   </cftry>
    </cftransaction>


   <cfelse>

    <!--- ### Form Code Starts Here --->
   <cfquery name="getStatus"
         datasource="#Request.DSN#"
         username="#Request.username#"
         password="#Request.password#">
         select c.name, a.appointmentNo, to_char(a.visitDate,'MM/DD/YYYY') as visitDate, a.visitTime, a.status, a.clientId
            from tbAppointment a, tbClient c
            where c.clientId = a.clientId 
            and a.clientId = <cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="#Form.clientId#"> 
            and a.appointmentNo = <cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="#Form.appointmentNo#">
   </cfquery>
        
     <h2>
         Client Name:
         <cfoutput>
         #getStatus.name#
         </cfoutput>
      </h2>
      <h4>Visit Date:  <cfoutput>#getStatus.visitDate#</cfoutput></h4>
      <h4>Visit Time:  <cfoutput>#getStatus.visitTime#</cfoutput></h4>

   <cfif getStatus.RecordCount IS 1>
         <cfform action="updateappointment.cfm" method="POST">
         <label style="color:#C13A2C;" for="status">
            Update Appointment Status:
         </label> 
         <cfselect name="status">
            <cfoutput query="getStatus">
                <option value="pending"
                  <cfif #getStatus.status# EQ "pending"> selected = "selected"
                  </cfif>>
                  pending
               </option>

               <option value="complete"
                  <cfif #getStatus.status# EQ "complete"> selected = "selected"
                  </cfif>>
                  complete
               </option>
                      
               <option value="missed"
                  <cfif #getStatus.status# EQ "missed"> selected = "selected"
                  </cfif>>
                  missed 
               </option>
               </cfoutput>
         </cfselect>
                   
        <cfoutput>
          <input type="hidden" name="clientId" value="#Form.clientId#">
          <input type="hidden" name="appointmentNo" value="#Form.appointmentNo#">
        </cfoutput>
        <br/>
        <br/>
         <input  name="update" type="submit" value="Update Status">
         <br/>
         <br/>     
         <input  name="reset" type="reset" value="Reset Values">      
      </cfform>
   </cfif>

      <h4>
          <a href="manageappointment.cfm">
             Choose another Client</a>
      </h4>

    </cfif> <!--- ### IsDefined("Form.update") --->

    <cfinclude template = "footer.cfm">
    </cfif>
    </body>

</html>
