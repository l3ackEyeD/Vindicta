#include "common.hpp"

/*
Class: GarrisonServer
Singleton server-only class.
Collects garrisons which have changed their state and sends periodic updates about garrisons to clients which need the data.

When garrison data updates (composition, etc) many times in a short period of time we don't want to send new data on each update,
but we want to send new data at a specific rate.

Author: Sparker 23 August 2019
*/

#define pr private

CLASS("GarrisonServer", "MessageReceiverEx")

	// Array with garrisons which have just been created
	VARIABLE("createdObjects");

	// Array with garrisons for which update events will be broadcasted at next update cycle
	VARIABLE("outdatedObjects");
	
	// Array with garrisons for which destroyed events will be broadcasted at next update cycle
	VARIABLE("destroyedObjects");

	METHOD("new") {
		params [P_THISOBJECT];

		T_SETV("outdatedObjects", []);
		T_SETV("destroyedObjects", []);
		T_SETV("createdObjects", []);

		private _msg = MESSAGE_NEW();
		_msg set [MESSAGE_ID_DESTINATION, _thisObject];
		_msg set [MESSAGE_ID_SOURCE, ""];
		_msg set [MESSAGE_ID_DATA, 0];
		_msg set [MESSAGE_ID_TYPE, GARRISON_SERVER_MESSAGE_PROCESS];
		pr _processInterval = 1;
		private _args = [_thisObject, _processInterval, _msg, gTimerServiceMain]; // message receiver, interval, message, timer service
		private _timer = NEW("Timer", _args);
		SETV(_thisObject, "timer", _timer);
	} ENDMETHOD;

	// We only receive messages from timer now, so we don't care about the message type
	// - - - - Processing of garrisons - - - - -
	METHOD("handleMessageEx") {
		params [P_THISOBJECT];

		// Broadcast update messages
		// This also corresponds to just created garrisons as they are outdated
		pr _outdatedGarrisons = T_GETV("outdatedObjects") + T_GETV("createdObjects");
		{
			pr _gar = _x;
			if (IS_OOP_OBJECT(_gar)) then {
				if (CALLM0(_gar, "isAlive")) then { // We only serve update events here
					// Create a GarrisonRecord to serialize it (to deserialize it at the client machine)
					pr _tempRecord = NEW("GarrisonRecord", [_gar]);
					CALLM1(_tempRecord, "initFromGarrison", _tempRecord);
					pr _serArray = SERIALIZE(_tempRecord);
					DELETE(_tempRecord);

					// Now we can send the serialized array
					pr _side = GETV(_gar, "side");
					REMOTE_EXEC_CALL_STATIC_METHOD("GarrisonDatabaseClient", "update", [_serArray], _side, false); // classNameStr, methodNameStr, extraParams, targets, JIP
				};
			};
		} forEach _outdatedGarrisons;

		// Broadcast destroyed events
		pr _destroyedGarrisons = T_GETV("destroyedGarrisons");
		// Just send data to everyone, those who don't care about these objects will just ignore them
		{
			REMOTE_EXEC_CALL_STATIC_METHOD("GarrisonDatabaseClient", "destroy", [_x], [EAST, WEST, INDEPENDENT, CIVILIAN], false); // Execute on all machines with interface
		} forEach _destroyedGarrisons;

		// Reset the arrays of garrisons to broadcast
		T_SETV("outdatedObjects", []);
		T_SETV("destroyedObjects", []);
		T_SETV("createdObjects", []);

	} ENDMETHOD;

	// - - - - Methods to be called by garrison on various events - - - - 

	// Marks the garrison as just created
	METHOD("onGarrisonCreated") {
		params [P_THISOBJECT, P_OOP_OBJECT("_gar")];

		T_GETV("createdObjects") pushBackUnique _gar;
	} ENDMETHOD;

	// Marks the garrison requiring an update broadcast
	METHOD("onGarrisonOutdated") {
		params [P_THISOBJECT, P_OOP_OBJECT("_gar")];

		T_GETV("outdatedObjects") pushBackUnique _gar;
	} ENDMETHOD;

	// Marks the garrison requiring a destroyed event broadcast
	METHOD("onGarrisonDestroyed") {
		params [P_THISOBJECT, P_OOP_OBJECT("_gar")];

		T_GETV("destroyedObjects") pushBackUnique _gar;

		// Make sure we don't send an update event about it any more
		pr _outdatedObjects = T_GETV("outdatedObjects");
		_outdatedObjects deleteAt (_outdatedObjects find _gar);
	} ENDMETHOD;

	// GarrisonServer is attached to the main message loop
	METHOD("getMessageLoop") {
		gMsgLoopMain
	} ENDMETHOD;

ENDCLASS;