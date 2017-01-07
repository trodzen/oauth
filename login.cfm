<cfset pagetitle="Log in">
<cfinvoke component="#application.snip#" method="header">
	<cfinvokeargument name="pagetitle" value="#pagetitle#">
	<cfinvokeargument name="additionalcss" value="login.css,buttons.css">
</cfinvoke>

<cfoutput>
<body>

#application.snip.topbar()#

	<div id="mid-section">

#application.snip.errormsg()#

	<div id="section-a">
		
	<div id="header-block">
		<a href="/index.cfm"><img src="/images/launch-icon_48hi.png" width="48" height="48" /></a>
		<div class="headers"><h1><a href="/index.cfm">#application.snip.title#</a></h1>
		<h2>Log in</h2></div>
	</div><!-- header block -->

	<div id="main-block"><form method="post"><p>Please log in.</p>
		<div class="row">
			<label for="email">Email</label>
			<input type="email" value="" name="email" id="email" placeholder="Email" />
		</div><!-- row -->
		<div class="row">
			<label for="password">Password</label>
			<input type="password" value="" name="password" id="password" placeholder="Password" />
		</div><!-- row -->
		<div class="row">
			<div class="col"><button class="blue button" type="submit">Log&##160;in</button></div>
			<div class="col minor-text">
				<input type="checkbox" name="rememberme" id="rememberme" value="true" checked="checked" class="checkbox" /> <label for="rememberme" class="checkbox">Remember me</label>
			</div><!-- col minor-text -->
		</div><!-- row -->
		<div class="row minor-text">Forgot your <a href="forgotpassword.cfm">Password</a> ?</div><!-- row minor-text -->
		<input type="hidden" name="redirect" value="" />
		</form>
	</div><!-- main-block -->
	</div><!-- section-a -->

	<div id="section-b">
		<div id="or-text"><p>or</p></div><!-- or-text -->
	</div><!-- section-b -->

	<div id="section-c">
#application.snip.loginbuttons("Log&##160;in")#
	</div><!-- section-c -->

	</div><!-- mid-section -->

#application.snip.bottombar()#

</body>
</cfoutput>