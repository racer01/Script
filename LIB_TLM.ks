// Ship's delta-v
FUNCTION TLM_DELTAV
{
	LIST ENGINES IN shipEngines.
	SET dryMass TO SHIP:MASS - ((SHIP:LIQUIDFUEL + SHIP:OXIDIZER) * 0.005).
	RETURN shipEngines[0]:ISP * 9.81 * LN(SHIP:MASS / dryMass).
}

// Solar Panels auto-toggle (kOS-Utils)
SET panelsOpen TO false.
FUNCTION TLM_PANELS
{
	// Only performs the checks within if the panels aren't already open
	IF NOT panelsOpen
	{
		// Checks if we're out of the atmosphere
		IF SHIP:ALTITUDE > BODY:ATM:HEIGHT
		{
			// Opens the panels
			PANELS ON.
			// Changes the variable so we can track the status of the panels
			SET panelsOpen TO true.
		}
		
		// Checks if we're landed and stationary
		IF SHIP:STATUS = "Landed" AND SHIP:VELOCITY:SURFACE:MAG < 0.01
		{
			// Opens the panels
			PANELS ON.
			// Changes the variable so we can track the status
			SET panelsOpen TO true.
		}
	}
	ELSE IF panelsOpen
	{
		// Checks to see if we're in the atmosphere; doesn't close the panels if we're
		//stationary to prevent it and the stationary check from fighting for control of
		//the panels.
		IF SHIP:ALTITUDE < BODY:ATM:HEIGHT AND SHIP:VELOCITY:SURFACE:MAG >= 0.01
		{
			// Closes the panels
			PANELS OFF.
			// Changes the variable so we can track the status of the panels
			SET panelsOpen TO false.
		}
	}
}

// Time to impact
FUNCTION TLM_TTI
{	PARAMETER margin.
	
	LOCAL d IS ALT:RADAR - margin.
	LOCAL v IS -SHIP:VERTICALSPEED.
	LOCAL g IS SHIP:BODY:MU / SHIP:BODY:RADIUS^2.
	
	RETURN (SQRT(v^2 + 2 * g * d) - v) / g.
}