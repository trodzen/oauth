<cfset pagetitle="Forgot Password">
<cfinvoke component="#application.snip#" method="header">
	<cfinvokeargument name="pagetitle" value="#pagetitle#">
	<cfinvokeargument name="additionalcss" value="login.css,buttons.css">
</cfinvoke>

<cfoutput>
<body>
	<div id="topbar">
		<div class="rcol">Already have #application.snip.account_title3# ?</div>
		<div class="rcol"><a href="login.cfm" class="grey button">Log in</a></div>
	</div><!-- topbar -->

	<div id="mid-section">
	
	#application.snip.errormsg()#

	<div id="header-block">
		<div class="col"><a href="/index.cfm"><img src="/images/launch-icon_48hi.png" width="48" height="48" /></a></div>
		<div class="col"><h1><a href="/index.cfm">#application.snip.title#</a></h1>
		<h2>Forgot Password</h2></div>
	</div><!-- header block -->

	<div id="main-block"><form method="post"><p>Please enter your email.</p>
		<div class="row">
			<label for="email">Email</label>
			<input type="email" value="" name="email" id="email" placeholder="Email" />
		</div><!-- row -->
		<div class="row">
			<button class="blue button" type="submit">Send me my Password</button>
		</div><!-- row -->
		<div class="row minor-text"><p>If you already have #application.snip.account_title3#, we sent your log in password to your email when you originally signed up.</p>
		<p>If you logged in to your #application.snip.account_title2# with Google, Facebook, or Twitter, you may simply <a href="login.cfm">log in</a> with that same account.</p></div><!-- or-text -->

		<input type="hidden" name="redirect" value="" />
		</form>
	</div><!-- main-block -->

	</div><!-- mid-section -->

#application.snip.bottombar()#
	</body>
</cfoutput>