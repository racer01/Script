// B-S-2 controller script v0.2.0
REQUIRE("LIB_MNV.ks").

LOCK STEERING TO HEADING(90, 90).

STAGE.

UNTIL (STAGE:NUMBER > 0)
{
	MNV_BURNOUT(true).
}



LOCK STEERING TO RETROGRADE.
WAIT UNTIL (ALT:RADAR < 250) OR (ALTITUDE < 1000).
STAGE. 
