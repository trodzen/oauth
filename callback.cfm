<!--- Validate the result --->
<cfparam name="url.code" default="">
<cfparam name="url.state" default="">
<cfparam name="url.error" default="">

<!--- receive a one-time use code from original auth request --->
<cfparam name="variables.redirect_loginpage" default="login.cfm">
<cfparam name="variables.redirect_successpage" default="index.cfm">

<cfif listlen(url.state,"~") IS NOT 4>
	<cfinvoke component="#application.snip#" method="logerror">
	<cfinvokeargument name="argredirect_loginpage" value="#variables.redirect_loginpage#">
	<cfinvokeargument name="argerrormsg" value="2">
	<cfinvokeargument name="argadditional" value="Did not recieve valid url (state parameter.)">
	<cfinvokeargument name="argdata" value="#url.state#">
	</cfinvoke>
</cfif>

<cfset variables.redirect_loginpage=listgetat(url.state,2,"~")>
<cfset variables.redirect_successpage=listgetat(url.state,3,"~")>
<cfset variables.OAuthReturn=StructNew()>
<cfset variables.OAuthReturn.service=listgetat(url.state,1,"~")>
<cfset variables.OAuthReturn.success=false>

<cfif url.error IS "access_denied">
	<cfinvoke component="#application.snip#" method="logerror">
	<cfinvokeargument name="argredirect_loginpage" value="#variables.redirect_loginpage#">
	<cfinvokeargument name="argerrormsg" value="1">
	<cfinvokeargument name="argadditional" value="User clicked cancel on grant access page.">
	<cfinvokeargument name="argdata" value="#url.error#">
	</cfinvoke>
</cfif>

<cfif url.error IS NOT "">
	<cfinvoke component="#application.snip#" method="logerror">
	<cfinvokeargument name="argredirect_loginpage" value="#variables.redirect_loginpage#">
	<cfinvokeargument name="argerrormsg" value="2">
	<cfinvokeargument name="argadditional" value="Recieved error on callback request url.">
	<cfinvokeargument name="argdata" value="#url.error#">
	</cfinvoke>
</cfif>

<cfif listgetat(url.state,4,"~") IS NOT session.urltoken>
	<cfinvoke component="#application.snip#" method="logerror">
	<cfinvokeargument name="argredirect_loginpage" value="#variables.redirect_loginpage#">
	<cfinvokeargument name="argerrormsg" value="2">
	<cfinvokeargument name="argadditional" value="Client Cookie does not match OAuth request state.">
	<cfinvokeargument name="argdata" value="#url.state#">
	</cfinvoke>
</cfif>

<!--- immediately exchange code for token valid for 45mins --->
<cfset variables.OAuthReturn.token=application.oauth.gettoken(variables.OAuthReturn.service, url.code)>

<cfif isstruct(variables.OAuthReturn.token) IS false>
	<cfinvoke component="#application.snip#" method="logerror">
	<cfinvokeargument name="argredirect_loginpage" value="#variables.redirect_loginpage#">
	<cfinvokeargument name="argerrormsg" value="2">
	<cfinvokeargument name="argadditional" value="Return from gettoken is not a structure.">
	<cfinvokeargument name="argdata" value="#variables.OAuthReturn.token#">
	</cfinvoke>
</cfif>

<cfif structKeyExists(variables.OAuthReturn.token, "error")>
	<cfinvoke component="#application.snip#" method="logerror">
	<cfinvokeargument name="argredirect_loginpage" value="#variables.redirect_loginpage#">
	<cfinvokeargument name="argerrormsg" value="2">
	<cfinvokeargument name="argadditional" value="Return from gettoken contains an error message.">
	<cfinvokeargument name="argdata" value="#variables.OAuthReturn.token#">
	</cfinvoke>
</cfif>

<!--- got a valid token, get profile info --->
<cfset variables.OAuthProfile = application.oauth.getprofile(variables.OAuthReturn.service, OAuthReturn.token.access_token)>

<cfif structKeyExists(variables.OAuthProfile, "id") IS false>
	<cfinvoke component="#application.snip#" method="logerror">
	<cfinvokeargument name="argredirect_loginpage" value="#variables.redirect_loginpage#">
	<cfinvokeargument name="argerrormsg" value="2">
	<cfinvokeargument name="argadditional" value="Return from getprofile does not contain id.">
	<cfinvokeargument name="argdata" value="#variables.OAuthProfile#">
	</cfinvoke>
</cfif>

<!--- got a valid oauth profile, set db --->
<cfset setdb = application.db.login.setOAuthLogin(variables.OAuthReturn, variables.OAuthProfile)>

<cfif setdb.iscomplete IS false>
	<cfinvoke component="#application.snip#" method="logerror">
	<cfinvokeargument name="argredirect_loginpage" value="#variables.redirect_loginpage#">
	<cfinvokeargument name="argerrormsg" value="3">
	<cfinvokeargument name="argadditional" value="Database write error.">
	<cfinvokeargument name="argdata" value="#setdb#">
	</cfinvoke>
</cfif>

<cfset variables.OAuthReturn.success=true>
<cflock scope="session" type="exclusive" timeout="2" throwontimeout="true">
<cfset session.token=OAuthReturn.token>
<cfset session.loggedin=true>
</cflock>
<cflocation url="#variables.redirect_successpage#" addtoken="false">
