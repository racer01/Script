// Generalized Boot Script v1.0.0
// rcr

// The ship will use updateScript to check for new commands from KSC.
SET SHIP:CONTROL:PILOTMAINTHROTTLE TO 0.

// NOTIFY, HAS_FILE, DELETEFROM, DOWNLOAD, UPLOAD, REQUIRE
FUNCTION NOTIFY // Display a message
{	PARAMETER message.
	
	HUDTEXT("kOS: " + message, 5, 2, 50, YELLOW, false).
}

FUNCTION HAS_FILE // Detect whether a file exists on the specified volume
{	PARAMETER name.
	PARAMETER vol.
	
	SWITCH TO vol.
	LIST FILES IN allFiles.
	FOR file IN allFiles
	{
		IF file:NAME = name
		{
			SWITCH TO 1.
			RETURN true.
		}
	}
	
	SWITCH TO 1.
	RETURN false.
}

FUNCTION DELETEFROM // Deletes a file on a specified drive
{	PARAMETER name.
	PARAMETER vol.
	
	IF HAS_FILE(name, vol)
	{
		SWITCH TO vol. 
		DELETE name.
		SWITCH TO 1.
		RETURN 1.
	}
	ELSE
	{
		RETURN 0.
	}
}

FUNCTION DOWNLOAD // Get a file from KSC.
{	PARAMETER name.
	
	IF HAS_FILE(name, 0)
	{
		IF HAS_FILE(name, 1)
		{
			DELETE name.
		}
		COPY name FROM 0.
		RETURN 1.
	}
	ELSE
	{
		RETURN 0.
	}
}

FUNCTION UPLOAD // Upload a file to KSC
{	PARAMETER name.
	
	IF HAS_FILE(name, 1)
	{
		DELETEFROM(name, 0).
		COPY name TO 0.
		RETURN 1.
	}
	ELSE
	{
		RETURN 0.
	}
}

FUNCTION REQUIRE // Run a library, download from KSC if necessary
{	PARAMETER name.
	
	IF NOT HAS_FILE(name, 1) { DOWNLOAD(name). }
	RENAME name TO "tmp.exec.ks".
	RUN tmp.exec.ks.
	RENAME "tmp.exec.ks" TO name.
}

// -----------------------------
// | THE ACTUAL BOOTUP PROCESS |
// -----------------------------
SET launchScript TO SHIP:NAME + ".launch.ks".
SET updateScript TO SHIP:NAME + ".update.ks".

// Pre-Launch configuration
IF STATUS = "PRELAUNCH"
{
	IF HAS_FILE(launchScript, 0)
	{
		DELETEFROM("launch.ks", 1).
		DOWNLOAD(launchScript).
		RENAME launchScript TO "launch.ks".
		RUN launch.ks.
	}
}

// If we have a connection, see if there are new instructions.
// If so, download and run them.
IF HAS_FILE(updateScript, 0)
{
	DOWNLOAD(updateScript).
	DELETEFROM(updateScript, 0).
	DELETEFROM(updateScript, 1).
	RENAME updateScript TO "update.ks".
	RUN update.ks.
	DELETE update.ks.
}

// If a startup.ks file exists on disk, run that.
IF HAS_FILE("startup.ks", 1)
{ RUN startup.ks. }
ELSE
{
	WAIT 10.
	REBOOT.
}