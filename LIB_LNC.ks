// Launch Library v1.0.0

FUNCTION TIMER
{	PARAMETER from.
	
	DECLARE t TO from.
	UNTIL t <= 0
	{
		HUDTEXT(t, 1, 2, 100, BLUE, false).
		WAIT 1.
		SET t TO t - 1.
	}
	HUDTEXT("Launching...", 5, 2, 100, BLUE, false).
}