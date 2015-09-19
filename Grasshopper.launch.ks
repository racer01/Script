// Grasshopper.Launch v2.0.0

REQUIRE("LIB_PID.KS").

TOGGLE AG10.

//LOCK STEERING TO HEADING(90, 90).

WAIT 5.

SET pidThrottle TO 0.
SET shouldHover TO true.
SET landedAlt TO ALT:RADAR.

LOCK THROTTLE TO pidThrottle.
STAGE.

SET hoverPID TO PID_INIT(0.05, 0.01, 0.1, 0, 1).

WHEN ALT:RADAR > landedAlt + 5 THEN { GEAR OFF. }
WHEN STAGE:LIQUIDFUEL < 10 THEN { SET shouldHover TO false.}
ON AG1 { SET landedAlt to landedAlt -10. PRESERVE. }.
ON AG2 { SET landedAlt to landedAlt +10. PRESERVE. }.
UNTIL NOT shouldHover
{
	SET pidThrottle TO PID_SEEK(hoverPID, landedAlt + 10, ALT:RADAR).
	WAIT 0.001.
}

GEAR ON.

UNTIL SHIP:STATUS = "Landed"
{
	SET pidThrottle TO PID_SEEK(hoverPID, LandedAlt, ALT:RADAR).
	WAIT 0.001.
}

SET pidThrottle TO 0.