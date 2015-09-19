// Manouver Library v1.0.0

SET fuel TO -1.
FUNCTION MNV_BURNOUT
{	PARAMETER autoStage.
	
	IF fuel = -1
	{
		IF STAGE:SOLIDFUEL > 0
		{
			LOCK fuel TO STAGE:SOLIDFUEL.
			PRINT("SOLID").
		}
		ELSE IF STAGE:LIQUIDFUEL > 0
		{
			LOCK fuel TO STAGE:LIQUIDFUEL.
			PRINT("LIQUID").
		}
	}
	ELSE IF fuel < 0.1
	{
		IF autoStage
		{
			LOCAL currentThrottle TO THROTTLE.
			LOCK THROTTLE TO 0.
			WAIT UNTIL THROTTLE = 0. WAIT UNTIL true. STAGE. 
			LOCK THROTTLE TO currentThrottle.
		}
		UNLOCK fuel.
		SET fuel TO -1.
		RETURN true.
	}
	RETURN false.
}