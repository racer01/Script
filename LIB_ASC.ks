// Ascent Library v1.0.0

// REQUIRE("LIB_MNV.ks").
FUNCTION ASC_DOSTEP
{
	PARAMETER direction.
	PARAMETER minAlt.
	PARAMETER newAngle.
	PARAMETER newThrust.
	
	SET prevThrust TO MAXTHRUST.
	
	UNTIL false
	{
		MNV_BURNOUT(true).
		
		IF ALTITUDE > minAlt
		{
			LOCK STEERING TO HEADING(direction, newAngle).
			IF APOAPSIS < 90000
			{
				LOCK THROTTLE TO newThrust.
			}
			BREAK.
		}
		IF APOAPSIS > 90000
		{
			LOCK THROTTLE TO 0.
		}

		WAIT UNTIL 0.1.
	}
}

FUNCTION ASC_DOPROFILE
{	PARAMETER direction.
	PARAMETER profile.
	
	SET step TO 0.
	UNTIL step >= profile:length-1
	{
		ASC_DOSTEP(direction, profile[step], profile[step+1], profile[step+2]).
		SET step TO step + 3.
		
	}
}