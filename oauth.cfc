<cfcomponent>

<cfscript>
this.buttons = ["Google", "Facebook", "Stripe"];
this.oauths = StructNew();
this.oauths.Google.name = "Google";
this.oauths.Google.buttoncolor = "red";
this.oauths.Google.logo = "googlelogo.png";
this.oauths.Google.clientid = "899833289448-gghqg19jm41ambpbab52i29c26usi6d2.apps.googleusercontent.com";
this.oauths.Google.clientsecret = "JevOCofp0KBXxcgQYWgXCni1";
this.oauths.Google.callback = "http://start.hestiacruises.com/callback.cfm";
this.oauths.Google.authurl = "https://accounts.google.com/o/oauth2/auth?" & 
	"client_id=#urlEncodedFormat(this.oauths.Google.clientid)#" & 
 "&redirect_uri=#urlEncodedFormat(this.oauths.Google.callback)#" & 
 "&scope=email+https://www.googleapis.com/auth/userinfo.profile&response_type=code" & 
	"&state=Google~%loginpage%~%redirectpage%~%cfurltoken%";
this.oauths.Google.tokenurl = "https://accounts.google.com/o/oauth2/token";
this.oauths.Google.profileurl = "https://www.googleapis.com/oauth2/v1/userinfo";
this.oauths.Facebook.name = "Facebook";
this.oauths.Facebook.buttoncolor = "blue";
this.oauths.Facebook.logo = "facebooklogo.png";
this.oauths.Facebook.clientid = "128982870449751";
this.oauths.Facebook.clientsecret = "68e6e61479e435ada86b3d86061c6f73";
this.oauths.Facebook.clienttoken = "a38591bff32cfe9ea8345235da398497";
this.oauths.Facebook.callback = "http://start.hestiacruises.com/callback.cfm";
this.oauths.Facebook.authurl = "https://www.facebook.com/dialog/oauth?" &
 "client_id=#urlEncodedFormat(this.oauths.Facebook.clientid)#" &
 "&redirect_uri=#urlEncodedFormat(this.oauths.Facebook.callback)#" &
 "&state=Facebook~%loginpage%~%redirectpage%~%cfurltoken%" &
 "&scope=email";
this.oauths.Facebook.tokenurl = "https://graph.facebook.com/oauth/access_token";
this.oauths.Facebook.profileurl = "https://graph.facebook.com/me?access_token=%accesstoken%";
this.oauths.Stripe.name = "Stripe";
this.oauths.Stripe.buttoncolor = "lightblue";
this.oauths.Stripe.logo = "stripelogo.png";
</cfscript>
   
<cffunction name="init" access="public">
<cfreturn this>
</cffunction>

<cffunction name="generateAuthURL" access="public" returntype="string">
<cfargument name="oname" type="string" required="true"/>
<cfargument name="argcfurltoken" type="string" required="true"/>
<cfargument name="argloginpage" type="string" required="true"/>
<cfargument name="argredirectpage" type="string" required="true"/>

	<cfif StructKeyExists(application.oauth.oauths[oname], "authurl")>
		<cfset variables.authurl = application.oauth.oauths[oname]["authurl"]>
		<cfset variables.authurl = replace(authurl,"%loginpage%",urlEncodedFormat(arguments.argloginpage))>
		<cfset variables.authurl = replace(authurl,"%redirectpage%",urlEncodedFormat(arguments.argredirectpage))>
		<cfset variables.authurl = replace(authurl,"%cfurltoken%",urlEncodedFormat(arguments.argcfurltoken))>
	<cfelse>
		<cfset authurl = "">
	</cfif>

<cfreturn authurl>
</cffunction>
	
<cffunction name="gettoken" access="public">
<cfargument name="oname" type="string" required="true"/>
<cfargument name="code" type="string" required=true/>

	<cfset var postBody = "code=" & UrlEncodedFormat(arguments.code) & "&">
 <cfset var postBody = postBody & "client_id=" & UrlEncodedFormat(application.oauth.oauths[oname]["clientid"]) & "&">
 <cfset var postBody = postBody & "client_secret=" & UrlEncodedFormat(application.oauth.oauths[oname]["clientsecret"]) & "&">
 <cfset var postBody = postBody & "redirect_uri=" & UrlEncodedFormat(application.oauth.oauths[oname]["callback"]) & "&">
 <cfset var postBody = postBody & "grant_type=authorization_code">

 <cfset var h = new com.adobe.coldfusion.http()>
 <cfset h.setURL("#application.oauth.oauths[oname]["tokenurl"]#")>
 <cfset h.setMethod("post")>
 <cfset h.addParam(type="header",name="Content-Type",value="application/x-www-form-urlencoded")>
 <cfset h.addParam(type="body",value="#postBody#")>
 <cfset h.setResolveURL(true)>
 <cfset var result = h.send().getPrefix()>
 
<cfif isjson(result.filecontent.toString())>
	<cfset mystr = deserializeJSON(result.filecontent.toString(), false)>
<cfelse>
	<cfif oname IS "Facebook">
		<cfset mystr = StructNew()>
		<cfloop list="#result.filecontent.toString()#" index="i" delimiters="&">
			<cfif listlen(i, "=") IS 2>
				<cfset ikey="#listgetat(i,1,"=")#">
				<cfset ival="#listgetat(i,2,"=")#">
				<cfset mystr["#ikey#"]="#ival#">
			</cfif>
		</cfloop>
	</cfif>
</cfif>
<cfreturn mystr>
</cffunction>

<cffunction name="getprofile" access="public" returntype="struct">
<cfargument name="oname" type="string" required="true"/>
<cfargument name="accesstoken" type="string" required=true/>
	<cfset h = new com.adobe.coldfusion.http()>
	<cfset variables.prurl = application.oauth.oauths[oname]["profileurl"]>
	<cfset variables.prurl = replace(prurl,"%accesstoken%",urlEncodedFormat(arguments.accesstoken))>
 <cfset h.setURL("#prurl#")>
 <cfset h.setMethod("get")>
 <cfset h.addParam(type="header",name="Authorization",value="OAuth #arguments.accesstoken#")>
 <cfset h.addParam(type="header",name="GData-Version",value="3")>
 <cfset h.setResolveURL(true)>
 <cfset var result = h.send().getPrefix()>

<cfif isjson(result.filecontent.toString())>
	<cfset mystr = deserializeJSON(result.filecontent.toString(), false)>
<cfelse>
	<cfif oname IS "Facebook">
		<cfset mystr = StructNew()>
		<cfloop list="#result.filecontent.toString()#" index="i" delimiters="&">
			<cfif listlen(i, "=") IS 2>
				<cfset ikey="#listgetat(i,1,"=")#">
				<cfset ival="#listgetat(i,2,"=")#">
				<cfset mystr["#ikey#"]="#ival#">
			</cfif>
		</cfloop>
	</cfif>
</cfif>

<cfreturn mystr>
</cffunction>

</cfcomponent>