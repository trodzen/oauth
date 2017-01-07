<cfcomponent extends="db_functions">

<cfscript>
	this.login = new templates.db_login();
</cfscript>

<cffunction name="init" access="public">
<cfreturn this>
</cffunction>

</cfcomponent>