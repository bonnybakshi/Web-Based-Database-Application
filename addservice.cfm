<!DOCTYPE html>
<html>
    <head>
        <title>Add Services</title>
        <link href='https://fonts.googleapis.com/css?family=Allura' rel='stylesheet' type='text/css'>
        <cfinclude template = "mystyle.css">
        <script type="text/javascript">
          var changeSlider = function(slider, serviceDuration){
          Ext.get('serviceDuration').set({value: serviceDuration});
          }
        </script>   
    </head>

  <body>
   <cfif not IsDefined ("Cookie.userview")>
      <cflocation url="login.cfm">
   <cfelse>

    <cfinclude template = "header.cfm">
    <div id="addnav"class="home">
      <ul>
         <li><a href="index.cfm">Home</a></li>
         <li><a href="logout.cfm">Logout</a></li>
         <li><a href="manageservice.cfm">Back</a></li>
      </ul>
   </div>
   
    <cfparam name="Form.serviceId" default="AA" type="string">
    <cfparam name="Form.serviceType" default =" " type="string">
    <cfparam name="Form.serviceDescr" default ="   " type="string">
    <cfparam name="Form.serviceDuration" default = "0"  type="numeric">
    <cfparam name="Form.servicePrice" default ="0.00" type="float">
    
   <cfif IsDefined("Form.add")>

  <!--- ### Action Code Starts Here --->
   <cftry>
      <cfquery name="addService"
            datasource="#Request.DSN#"
            username="#Request.username#"
            password="#Request.password#">
         insert into tbService values (
            <cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="#Form.serviceId#">,
            <cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="#Form.serviceType#">,
            <cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="#Form.serviceDescr# ">,
            <cfif #Form.serviceDuration# EQ 0>
                  Null,
            <cfelse>
               <cfqueryparam cfsqltype="CF_SQL_NUMERIC" value="#Form.serviceDuration#">,
            </cfif>
            <cfqueryparam cfsqltype="CF_SQL_FLOAT" value="#Form.servicePrice#">)
      </cfquery>

      <cfoutput>
        <cflocation url="manageservice.cfm?serviceId=#Form.serviceId#">
      </cfoutput>

   <cfcatch type = "any">
      <cfoutput>
         <h4>
            There has been a type = #CFCATCH.TYPE# Error.<br />
            <p>Please report to the following information to your System Administrator:  #cfcatch.message#</p>
         </h4>
      </cfoutput>
         <h4>
            <a href="manageservice.cfm">
             Back to Manage Services</a> 
         </h4>
   </cfcatch>
   </cftry>

   <cfelse>

    <!--- ### Form Code Starts Here --->

      <cfquery name="getService"
                 datasource="#Request.DSN#"
                 username="#Request.username#"
                 password="#Request.password#">
              select *
              from tbService
              order by serviceId

      </cfquery>

      <cfif (getService.RecordCount GT 99) >
          <h4>Sorry, No more services are allowed</h4>
      <cfelse>
      
      <cfform id="addform" action="addservice.cfm" method="POST">
      <h2> Add a new Service </h2>
      <br/>
         <label for="serviceType">
            Service Type:
         </label>
         <br/>
         <cfinput type="text"
                  name="serviceType"
                  width="10" 
                  required = "yes"
                  message="Please enter the type of service"
                  autosuggest="cfc:suggestName.getService({cfautosuggestvalue})"/>

         <br/>
         <br/>
         <label for="serviceDescr">
            Service Description:
         </label> 
         <br/>      
         <cfinput type="text"
                  name="serviceDescr"
                  width="10" 
                  required = "yes"
                  message="Please enter a Service Description"/>

         <br/>
         <br/>
         <label for="serviceDuration">
            Service Duration:
         </label>
        <cfinput type="text" name="serviceDuration" 
                  value="#FORM.serviceDuration#"
                  size="4"
                  maxlength="4" range="0,190"
                  required="yes" validate="integer"
                  message="Invalid Service Duration.( Please enter 0 incase of no duration)"
                  readonly/>
                  minutes
        <cfslider format="html" 
                value="#FORM.serviceDuration#"
                name="serviceDuration" 
                vertical="false" 
                min="0" max="190" 
                increment="5" 
                clicktochange="true" 
                onchange="changeSlider" /> 
        
         <br/>
         <label for="servicePrice">
            Service Price:
         </label>             
        <cfinput name="servicePrice" type="text"
                 size="4"
                 maxlength="10" range="0,10000"
                 required="yes" validate="float"
                 message="Please enter Service Price (Price between 0 and 10000)">
              
         <cfoutput>
            <input type="hidden" name="serviceId" value="#Form.serviceId#">
         </cfoutput>
            <br/>
            <br/>
            <input class="cursor_p" name="add" type="submit" value="Add Service">
              
            <input class="cursor_p" name="reset" type="reset" value="Clear">      
         </cfform>
         </cfif>
         <br/>
         <br/>
        

    </cfif> <!--- ### IsDefined("Form.add") --->
    <cfinclude template = "footer.cfm">
    </cfif>
    </body>
</html>
