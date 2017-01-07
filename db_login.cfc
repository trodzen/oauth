<cfcomponent extends="db_functions">

<cffunction name="init" access="public">
	<!---
	<cfset theLogin = EntityLoadByPK("accountaccess",4)/>
	<cfset EntityDelete(theLogin)/>
--->
<cfreturn this>
</cffunction>

<cffunction name="setOAuthLogin" access="public">
<cfargument name="argOAuthReturn">
<cfargument name="argOAuthProfile">

<cfset setdb = StructNew()>

<cftry>
<cftransaction>

<!--- new account & login --->
<cfset loginObj = new orm.login()>
<cfset accountObj = new orm.account()>
<cfset accountaccessObj = new orm.accountaccess()>
<cfset loginemailObj = new orm.loginemail()>
<cfset accountemailObj = new orm.accountemail()>
<cfset lastloginObj = new orm.lastlogin()>
<cfset loginoauthObj = new orm.loginoauth()>
<cfset loginprofileObj = new orm.loginprofile()>

<!--- does email already exist --->
<cfset emailverifiedObj = new orm.emailverified()>
<cfset emailObj = EntityLoad('email', {EmailAddress=argOAuthProfile.email}, "true")>
<cfif isNull(emailObj)>
	<cfset emailObj = new orm.email()>
	<cfset emailObj.setemailAddress(argOAuthProfile.email)>
<cfelse>
	<cfset emailObj.setemailAddress(argOAuthProfile.email)>
</cfif>
<cfif structKeyExists(argOAuthProfile, "verified_email")>
<cfset emailverifiedObj.setemail(emailObj)>
</cfif>
<cfif structKeyExists(argOAuthProfile, "verified")>
<cfset emailverifiedObj.setemail(emailObj)>
</cfif>
<cfset emailObj.setemailverified(emailverifiedObj)>
<cfset EntitySave(emailObj)><!--- also saves emailverified child --->

<!--- set field data --->
<cfif structKeyExists(argOAuthProfile, "given_name")>
<cfset loginObj.setLoginFirstName(argOAuthProfile.given_name)>
</cfif>
<cfif structKeyExists(argOAuthProfile, "first_name")>
<cfset loginObj.setLoginFirstName(argOAuthProfile.first_name)>
</cfif>
<cfif structKeyExists(argOAuthProfile, "family_name")>
<cfset loginObj.setLoginLastName(argOAuthProfile.family_name)>
</cfif>
<cfif structKeyExists(argOAuthProfile, "last_name")>
<cfset loginObj.setLoginLastName(argOAuthProfile.last_name)>
</cfif>
<cfset loginObj.setLoginisMale(IIF(argOAuthProfile.gender IS "male", true, false))>

<cfset accountObj.setAccountShortName("My Account")>
<cfset accountObj.setAccountBalance(0.00)>

<cfset loginoauthObj.setOAuthService(argOAuthReturn.service)>
<cfset loginoauthObj.setOAuthID(argOAuthProfile.ID)>
<cfif structKeyExists(argOAuthReturn.token, "id_token")>
<cfset loginoauthObj.setOAuthIDToken(argOAuthReturn.token.id_token)>
</cfif>
<cfif structKeyExists(argOAuthReturn.token, "access_token")>
<cfset loginoauthObj.setOAuthIDToken(argOAuthReturn.token.access_token)>
</cfif>

<cfset loginprofileObj.setProfileLink(argOAuthProfile.link)>
<cfif structKeyExists(argOAuthProfile, "picture")>
<cfset loginprofileObj.setProfilePicture(argOAuthProfile.picture)>
</cfif>
<cfset loginprofileObj.setProfileName(argOAuthProfile.name)>
<cfset loginprofileObj.setProfileLocale(argOAuthProfile.locale)>
<cfif structKeyExists(argOAuthProfile, "hd")>
<cfset loginprofileObj.setProfilehd(argOAuthProfile.hd)>
</cfif>

<cfset loginemailObj.setLoginEmailisPrimary(true)>

<!--- set link table relationship records --->
<cfset loginObj.addaccountaccess(accountaccessObj)>
<cfset accountObj.addaccountaccess(accountaccessObj)>
<cfset loginObj.addloginemail(loginemailObj)>
<cfset emailObj.addloginemail(loginemailObj)>
<cfset accountObj.addaccountemail(accountemailObj)>
<cfset emailObj.addaccountemail(accountemailObj)>
<cfset accountObj.setaccountaccess(accountaccessObj)>
<cfset loginObj.setloginemail(loginemailObj)>
<cfset accountObj.setaccountemail(accountemailObj)>

<cfset lastloginObj.setlogin(loginObj)>
<cfset loginoauthObj.setlogin(loginObj)>
<cfset loginprofileObj.setlogin(loginObj)>
<cfset loginObj.setlastlogin(lastloginObj)>
<cfset loginObj.setloginoauth(loginoauthObj)>
<cfset loginObj.setloginprofile(loginprofileObj)>

<cfset EntitySave(AccountObj)>
<cfset loginObj.setloginprimaryaccount(accountObj)>
<cfset EntitySave(loginObj)>


<!---
<cfset EntitySave(lastloginObj)>
<cfset EntitySave(loginoauthObj)>
<cfset EntitySave(loginprofileObj)>
<cfset EntitySave(loginemailObj)>
<cfset EntitySave(accountemailObj)>


<cfset emailObj.setlogin(loginObj)>
<cfset emailObj.setaccount(accountObj)>

<cfset loginObj.setLoginPrimaryAccountID(accountObj.getAccountID())>
<cfset loginObj.addemail(emailObj)>
<cfset accountObj.setemail(emailObj)>
--->

</cftransaction>
<cfset setdb.iscomplete=true>
<cfcatch>
<cfset setdb.iscomplete=false>
<cfset setdb.argOAuthReturn="#arguments.argOAuthReturn#">
<cfset setdb.argOAuthProfile="#arguments.argOAuthProfile#">
<cfset setdb.emailObj="#emailObj#">
<cfset setdb.loginObj="#loginObj#">
<cfset setdb.accountObj="#accountObj#">
<cfparam name="cfcatch" default="">
<cfset setdb.cfcatch="#cfcatch#">
</cfcatch>
</cftry>

<cfreturn setdb>
</cffunction>

</cfcomponent>