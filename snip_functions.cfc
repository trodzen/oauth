<cfcomponent output="false">
	
<!---
sample
	<cfproperty name="prop" type="any" default="defval" />
	<cffunction name="getProp" access="public" output="false" returntype="any">
		<cfreturn prop />
	</cffunction>
	<cffunction name="setProp" access="public" output="false" returntype="void">
		<cfargument name="argProp" type="any" required="true" />
		<cfset prop=argProp />
	</cffunction>
--->

<cffunction name="EncodeKey" access="public" output="false" returntype="string">>
<cfargument name="Key" required="yes">
<cfargument name="isDecode" type="boolean" default="false">
<cfif isDecode>
	<!--- decode key --->
	<cfif FindOneOf("013568",arguments.key)>
		<!--- contains invalid numbers --->
		<cfset tkey=0>
	<cfelse>
		<cfset tkey=ReplaceList(arguments.key,"X,R,2,C,4,L,P,7,Y,9","0,1,2,3,4,5,6,7,8,9")>
	</cfif>
<cfelse>
	<!--- encode key --->
	<cfset tkey=numberformat(arguments.key,"000")>
	<cfset tkey=ReplaceList(tkey,"0,1,2,3,4,5,6,7,8,9","X,R,2,C,4,L,P,7,Y,9")>
</cfif>
<cfreturn tkey>
</cffunction>

<cffunction name="TrimList" access="public" output="false" returntype="string">
<cfargument name="list" required="yes">
<cfif len(arguments.list) IS 2 AND left(arguments.list,1) IS "," AND right(arguments.list,1) IS ",">
	<cfset trimlist="">
<cfelseif len(arguments.list) GT 2 AND left(arguments.list,1) IS "," AND right(arguments.list,1) IS ",">
	<cfset trimlist=mid(arguments.list,2,len(arguments.list)-2)>
<cfelse>
	<cfset trimlist=arguments.list>
</cfif>
<cfreturn trimlist>
</cffunction>

<cffunction name="getKLocs" access="public" output="false" returntype="integer">
	<!-- find out how many KLocs - Thousands Line of Code --->
	<cfif isdefined("application.kloc") AND isdefined("url.reset") IS false>
		<cfset tempcount=application.kloc>
	<cfelse>
		<cfset tempcount=0>
		<cfloop list="cfm,cfc,css,js" index="i">
			<cfdirectory action="list" directory="#Application.applicationfilepath#" filter="*.#i#" name="dirqry" recurse="yes">
			<cfloop query="dirqry">
				<cffile action="read" file="#dirqry.directory#\#dirqry.name#" variable="tempfile">
				<cfset tempcount=tempcount+listlen(tempfile,chr(13))>
			</cfloop>
		</cfloop>
	</cfif>
	<cfset application.kloc=tempcount>
	<cfset tempcount=numberformat(tempcount / 1000, "9.9")>
<cfreturn tempcount>
</cffunction>

<!--- find out if string contains bad stuff --->
<cffunction name="ismystring" access="public" output="false" returntype="string">
<cfargument name="data" type="string" required="yes">
<cfset myreply=false>
<cfif len(trim(arguments.data)) GT 0 AND arguments.data DOES NOT CONTAIN "''">
	<cfset myreply=true>
</cfif>
<cfreturn myreply>
</cffunction>

	<!--- find out if string contains bad stuff --->
<cffunction name="escapemystring" access="public" output="false" returntype="string">
<cfargument name="data" type="string" required="yes">
<cfset data=replacelist(data,"'","''")>
<cfreturn data>
</cffunction>

<!--- strip bad stuff from string --->
<cffunction name="stripmystring" access="public" output="false" returntype="string">
<cfargument name="data" type="string" required="yes">
<cfargument name="type" type="string">
<cfif isdefined("arguments.type") AND arguments.type IS "email">
<cfset data=replacelist(data," ,+,/,',""","")>
<cfelseif isdefined("arguments.type") AND arguments.type IS "groupon">
<cfset data=replacelist(data," ,+,.,_,##,/,',""","")>
<cfelse>
<cfset data=replacelist(data," ,+,.,_,-,/,',""","")>
</cfif>
<cfreturn data>
</cffunction>

</cfcomponent>