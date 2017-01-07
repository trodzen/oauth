component
{
this.name = hash(getCurrentTemplatePath());
this.sessionmanagement = true;
this.sessiontimeout = "#createtimespan(0,0,40,0)#";
this.applicationtimeout = "#createtimespan(5,0,0,0)#";
this.domaincookies = true;
this.datasource = "Mydb";

this.ormEnabled = true;
this.ormSettings = {
	dbcreate = "none",
	useDBForMapping = false,
	cfclocation = expandPath("/orm"),
	autogenmap = true,
	flushAtRequestEnd = true, 
	logsql = true,
	skipCFCWithError = true};

if (!isNull(url.dbrebuild))
{
	this.ormSettings.dbCreate = "dropcreate";
	} // if dbrebuild
	
if	(!isNull(url.dbupdate))
	{
	this.ormSettings.dbCreate = "update";
	} // if dbupdate

public boolean function onApplicationStart()
{ 
setApplicationVariables();
return true;
} // onApplicationStart

private function setApplicationVariables()
{
application.oauth = new templates.oauth();
application.snip = new templates.application_snip();
application.db = new templates.application_db();
} // setApplicationVariables
public function onSessionStart()
{
session.loggedin = false;
} // onSessionStart

public boolean function onRequestStart(targetPage)
{
setApplicationVariables();

if (!isNull(url.dbrebuild) ||
!isNull(url.dbupdate))
{
	ORMReload();
} // if dbrebuild or dbupdate
application.orms=this.ormsettings;
return true;
} // onRequestStart

}