// CLS_twr.ks - A library of functions specific to calculating twr / throttle in the CLS (Common Launch Script)
// Copyright © 2021 Qwarkk6
// Lic. CC-BY-SA-4.0 

// Creates new log file for flight data
Function logInitialise {
	parameter tgtApoapsis.
	parameter tgtPeriapsis.
	parameter tgtInclination.
	local year is (time:year):tostring().
	local day is (time:day):tostring().
	local hour is (time:hour):tostring().
	local minute is (time:minute):tostring().
	local vesselName is ship:name.
	local realTime is realWorldTime():tostring().
	if hour:length < 2 {
		set hour to "0" + hour.
	}
	if minute:length < 2 {
		set minute to "0" + minute.
	}
	local logname is "Y"+year+" "+"D"+day+" "+hour+"."+minute+" "+vesselName+" ("+realTime+")".
	global logpath is path("0:/CLS_lib/logs/" + logname + ".csv").
	Log ("Apoapsis,"+(tgtApoapsis/1000)+"km,"+"Periapsis,"+(tgtPeriapsis/1000)+"km"+",Inc,"+round(tgtInclination,2)) + ",Vessel," + vesselName to logPath.
	Log (" ") to logPath.
	Log ("MET,vehicleConfig,dV,TWR,Throttle,Pitch,ProgradePitch,Heading,Azimuth,Steering Error,Q,Alt,Apoapsis,Eta:Apo,Periapsis,Eta:Peri,Stage,Staging,PayloadProtection,Runmode,Expected Parts,Detected Parts,Time") to logPath.
}

// example use - log_data(LIST(newTime,newAlt,newVel:MAG,newDynamicP,dragForce,newAtmPressure,atmDencity*1000,dragCoef,thermalMassIsh,atmTemp,mach)).
// Logs data from list to log file specified
function log_data {
	Parameter logData is list(missionElapsedTime,vehicleConfig,dvRemaining,vesTWR,throttle,trajectorypitch,pitch_for_vector(Ship:srfprograde:forevector),heading_for(),launchazimuth,Vang(Ship:facing:vector, steering:vector),ship:q,ship:altitude,ship:apoapsis,eta:apoapsis,ship:periapsis,eta:periapsis,currentstagenum,staginginprogress,PayloadProtection,runmode,numparts,Ship:parts:length,realWorldTime():tostring()).
	if missionElapsedTime > missionTimeLog {
		Log logData:join(",") TO logpath.
		set missionTimeLog to missionElapsedTime+0.5.
	}
}

function log_abort {
	Parameter logData is list(missionElapsedTime,vehicleConfig,dvRemaining,vesTWR,ship:verticalspeed,throttle,trajectorypitch,pitch_for_vector(Ship:srfprograde:forevector),heading_for(),launchazimuth,Vang(Ship:facing:vector, steering:vector),ship:q,ship:altitude,ship:apoapsis,eta:apoapsis,ship:periapsis,eta:periapsis,currentstagenum,round(ship:electriccharge/BatteryCapacity,2)*100,staginginprogress,PayloadProtection,runmode,numparts,Ship:parts:length,realWorldTime():tostring()).
	local year is (time:year):tostring().
	local day is (time:day):tostring().
	local hour is (time:hour):tostring().
	local minute is (time:minute):tostring().
	local vesselName is ship:name.
	local realTime is realWorldTime():tostring().
	if hour:length < 2 {
		set hour to "0" + hour.
	}
	if minute:length < 2 {
		set minute to "0" + minute.
	}
	local logname is "Y"+year+" "+"D"+day+" "+hour+"."+minute+" "+vesselName+" (Abort "+realTime+")".
	global logpath is path("0:/CLS_lib/logs/" + logname + ".csv").
	Log ("Altitude,"+(round(ship:altitude,2)/1000)+"km,"+"MET,"+missionElapsedTime + ",Vessel," + vesselName + ",AbortReason," + abortReason) to logPath.
	Log (" ") to logPath.
	Log ("MET,vehicleConfig,dV,TWR,VerticalSpeed,Throttle,Pitch,ProgradePitch,Heading,Azimuth,Steering Error,Q,Alt,Apoapsis,Eta:Apo,Periapsis,Eta:Peri,Stage,EC,Staging,PayloadProtection,Runmode,Expected Parts,Detected Parts,Time") to logPath.
	Log logData:join(",") TO logpath.
	Log (" ") to logPath. Log ("Ship Parts:") to logPath.
	for p in ship:parts {
		log p:title to logPath.
	}
	Log (" ") to logpath. Log ("Ascent Events") to logpath.
	for printline in printqueue {
		Log printline to logPath.
	}
}