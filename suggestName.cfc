<cfcomponent output="false">
    
    <cffunction name="getService" access="remote" returntype="array" >
        <cfargument name="suggestvalue" required="true" />
        
        <cfquery name="getServiceType" 
              datasource="#Request.DSN#" 
              username="#Request.username#" 
              password="#Request.password#">
              SELECT DISTINCT serviceType 
              FROM tbService
              WHERE serviceType LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#Arguments.SuggestValue#%" >
        </cfquery>

        <cfset returnArray = [] />
        <cfloop query="getServiceType">
            <cfset ArrayAppend(returnArray, serviceType)>
        </cfloop>
        <cfreturn returnArray>
    </cffunction>    
 </cfcomponent>