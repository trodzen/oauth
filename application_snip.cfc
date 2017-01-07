<cfcomponent extends="snip_functions">

<cfscript>
this.title="Hestia Cruises";
this.account_title="Ensign Card";
this.account_title2="Ensign&##160;Card<sup>&reg</sup> Account";
this.account_title3="an Ensign&##160;Card&reg Account";
this.errmsg={
	1:"Could not log in with the requested service. You must grant access.",
	2:"Could not log in with the requested service. Please try again or use another method.",
	3:"Unable to update the data base with log in information. Please try again or use another log in method."};
</cfscript>

<cffunction name="init" access="public">
<cfreturn this>
</cffunction>

<cffunction name="logerror" access="public">
<cfargument name="argredirect_loginpage" type="string" required=true />
<cfargument name="argerrormsg" type="string" required=true />
<cfargument name="argadditional" required=true />
<cfargument name="argdata" required=false default="" />
<cfset session.dumpdata=argdata>
<cflocation url="#argredirect_loginpage#?err=#argerrormsg#&#urlEncodedFormat(argadditional)#" addtoken="false">
<cfreturn>
</cffunction>

<cffunction name="errormsg" access="public" returntype="string">

	<cfparam name="url.err" default="">

 <cfif structKeyExists(application.snip.errmsg, url.err)>
		<cfoutput>
		<div id="error-msg">&##187; #application.snip.errmsg[url.err]#</div>
		</cfoutput>
	</cfif>
<cfreturn>
</cffunction>

<cffunction name="topbar" access="public" returntype="string">
<cfoutput>
	<cfif session.loggedin>
		<div id="topbar">
		<div class="rcol">Welcome!</div>
		<div class="rcol"><a href="logout.cfm" class="grey button minor-text">Log&##160;Out</a></div>
	</div><!-- topbar -->
	<cfelseif cgi.script_name IS "/login.cfm">
	<div id="topbar">
		<div class="rcol">New user?</div>
		<div class="rcol"><a href="signup.cfm" class="grey button ">Sign&##160;Up</a></div>
	</div><!-- topbar -->
	<cfelse>
		<div id="topbar">
		<div class="rcol">Already have #application.snip.account_title3# ?</div>
		<div class="rcol"><a href="login.cfm" class="grey button">Log&##160;in</a></div>
	</div><!-- topbar -->
	</cfif>
</cfoutput>
<cfreturn>
</cffunction>


<cffunction name="header" access="public" returntype="string">
<cfargument name="pagetitle" type="string" required=true />
<cfargument name="additionalcss" required=true />
<!doctype html>
<cfoutput>
<head>
	<meta content="text/html; charset=UTF-8" http-equiv="content-type" />
	<meta content="/images/google_favicon_128.png" itemprop="image" />
	<title>#application.snip.title# #arguments.pagetitle#</title>
	<link href="application.css" rel="stylesheet" type="text/css" />
	<cfloop index="i" list="#arguments.additionalcss#"><link href="#i#" rel="stylesheet" type="text/css" /></cfloop>
	<meta name="viewport" content="initial-scale=1" />
</head>
</cfoutput>
<cfreturn>
</cffunction>

<cffunction name="bottombar" access="public" returntype="string">
<cfoutput>
	<div id="bottombar">
	<div class="rcol">
		<ul class="landscape">
			<li><img src="/images/visamastercardamex.png" width="213" height="50" /></li>
			<li><img src="/images/madeinusa.png" width="92" height="50" /></li>
			<li>&copy #year(now())# #application.snip.title#. All Rights Reserved.</li>
		</ul>
	</div>
</div><!-- bottombar -->
</cfoutput>
<cfreturn>
</cffunction>

<cffunction name="loginbuttons" access="public" returntype="string">
<cfargument name="buttontext" type="string" required=true/>

<cfparam name="url.rurl" default="/index.cfm">

<cfoutput>
	<ul class="buttons">
	<cfloop array="#application.oauth["buttons"]#" index="i">
		<li><a href="#application.oauth.generateAuthUrl(i, session.urltoken, cgi.script_name, url.rurl)#" class="#application.oauth.oauths[i]["buttoncolor"]# button fullwide"><img src="/images/#application.oauth.oauths[i]["logo"]#" width="30" height="30" /><div>#arguments.buttontext# with #application.oauth.oauths[i]["name"]#</div></a></li>
	</cfloop>
	</ul>
</cfoutput>
<cfreturn>
</cffunction>

</cfcomponent>