 // U-S-2 Iridium Launch Script v1.0.0

REQUIRE("LIB_MNV.ks").
REQUIRE("LIB_ASC.ks").

SET ascentProfile TO LIST(
  // Altitude,  Angle,  Thrust
  0,            90,     1,
  500,          80,     1,
  1000,         75,     1,
  1500,         70,     1,
  5000,         60,     1,
  10000,        55,     1,
  15000,        50,     0.8,
  20000,        45,     0.5,
  25000,        35,     0.5,
  30000,        25,     0.5,
  35000,        20,     1,
  40000,        15,     1,
  45000,        15,     1,
  50000,        15,     1,
  60000,        10,     1,
  70000,        0,      0
).


LOCK THROTTLE TO 1. WAIT 1. STAGE. WAIT 1. 
//\\
RUN LIB_ASC.ks.
////
ASC_DOPROFILE(90, ascentProfile).

UNTIL STAGE:NUMBER <= 3
{
	STAGE.
	WAIT 1.
}

WAIT UNTIL ETA:APOAPSIS < 19.2.
LOCK THROTTLE TO 1.

WAIT UNTIL PERIAPSIS > 90000.
LOCK THROTTLE TO 0. 
NOTIFY("YAY").