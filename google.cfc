<cfcomponent>

<cffunction name="init" access="public">
  <cfargument name="clientid" type="string" required=true/>
  <cfargument name="clientsecret" type="string" required=true/>
    <cfset variables.clientid=arguments.clientid>
    <cfset variables.clientsecret=arguments.clientsecret>
   <cfreturn this>
</cffunction>

<cffunction name="generateAuthURL" access="public" returntype="string">
  <cfargument name="callback" type="string" required="true"/>
  <cfargument name="cfurltoken" type="string" required="true"/>
  <cfset AuthURL="https://accounts.google.com/o/oauth2/auth?" & 
	"client_id=#urlEncodedFormat(variables.clientid)#" & 
  "&redirect_uri=#urlEncodedFormat(arguments.callback)#" & 
  "&scope=email+https://www.googleapis.com/auth/userinfo.profile&response_type=code" & 
	"&state=#urlEncodedFormat(arguments.cfurltoken)#">
  <cfreturn AuthURL>
</cffunction>

<cffunction name="getProfile" access="public" returntype="struct">
  <cfargument name="accesstoken" type="string" required=true/>
  <cfset var h=new com.adobe.coldfusion.http()>
  <cfset h.setURL("https://www.googleapis.com/oauth2/v1/userinfo")>
  <cfset h.setMethod("get")>
  <cfset h.addParam(type="header",name="Authorization",value="OAuth #arguments.accesstoken#")>
  <cfset h.addParam(type="header",name="GData-Version",value="3")>
  <cfset h.setResolveURL(true)>
  <cfset var result = h.send().getPrefix()>
  <cfreturn deserializeJSON(result.filecontent.toString())>
</cffunction>

<cffunction name="validateResult" access="public" returntype="struct">
  <cfargument name="code" type="string" required=true/>
  <cfargument name="error" type="string" required=true/>
  <cfargument name="remoteState" type="string" required=true/>
  <cfargument name="clientState" type="string" required=true/>
	<cfset var result=StructNew()>
  <cfif error IS NOT "">
    <cfset result.status=false>
    <cfset result.message=arguments.error>
    <cfreturn result>
  </cfif>
  <cfif remoteState IS NOT clientState>
    <cfset result.status=false>
    <cfset result.message="State values did not match.">
    <cfreturn result>
  </cfif>
  <cfset var token=getGoogleToken(code)>
  <cfif structKeyExists(token, "error")>
    <cfset result.status=false>
    <cfset result.message=token.error>
    <cfreturn result>
  </cfif>
  <cfset result.status=true>
  <cfset result.token=token>
  <cfreturn result>
</cffunction>

<cffunction name="getGoogleToken" access="private" returntype="struct">
  <cfargument name="code" type="string" required=true/>
  <cfset var postBody = "code=" & UrlEncodedFormat(arguments.code) & "&">
  <cfset var postBody = postBody & "client_id=" & UrlEncodedFormat(application.clientid) & "&">
  <cfset var postBody = postBody & "client_secret=" & UrlEncodedFormat(application.clientsecret) & "&">
  <cfset var postBody = postBody & "redirect_uri=" & UrlEncodedFormat(application.callback) & "&">
  <cfset var postBody = postBody & "grant_type=authorization_code">
  <cfset var h = new com.adobe.coldfusion.http()>
  <cfset h.setURL("https://accounts.google.com/o/oauth2/token")>
  <cfset h.setMethod("post")>
  <cfset h.addParam(type="header",name="Content-Type",value="application/x-www-form-urlencoded")>
  <cfset h.addParam(type="body",value="#postBody#")>
  <cfset h.setResolveURL(true)>
  <cfset var result = h.send().getPrefix()>
  <cfreturn deserializeJSON(result.filecontent.toString())>
</cffunction>

</cfcomponent>