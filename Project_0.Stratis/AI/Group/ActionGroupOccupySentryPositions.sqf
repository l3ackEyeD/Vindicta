#define OOP_INFO
#define OOP_ERROR
#define OOP_WARNING
#include "..\..\OOP_Light\OOP_Light.h"
#include "..\..\Message\Message.hpp"
#include "..\Action\Action.hpp"
#include "..\..\MessageTypes.hpp"
#include "..\..\GlobalAssert.hpp"
#include "..\Stimulus\Stimulus.hpp"
#include "..\WorldFact\WorldFact.hpp"
#include "..\stimulusTypes.hpp"
#include "..\worldFactTypes.hpp"

/*
Class: ActionGroup.ActionGroupOccupySentryPositions
All members of this group will move to their assigned sentry positions.
*/

#define pr private

CLASS("ActionGroupOccupySentryPositions", "ActionGroup")
	
	// logic to run when the goal is activated
	METHOD("activate") {
		params [["_thisObject", "", [""]]];
		
		OOP_INFO_0("ACTIVATE");
		
		// Add goals to all units
		pr _group = GETV(T_GETV("AI"), "agent");
		pr _units = CALLM0(_group, "getUnits");
		{ // foreach units
			pr _unit = _x;
			pr _unitAI = CALLM0(_unit, "getAI");
			pr _sentryPos = CALLM0(_unitAI, "getSentryPos");
			
			// Remove similar external goals from this AI
			CALLM2(_unitAI, "deleteExternalGoal", "GoalUnitInfantryMove", _thisObject);
			
			if (count _sentryPos > 0) then {
				pr _parameters = [["position", _sentryPos]];
				CALLM4(_unitAI, "addExternalGoal", "GoalUnitInfantryMove", 0, _parameters, _thisObject);
			} else {
				pr _unitData = CALLM0(_unit, "getData");
				OOP_WARNING_2("SENTRY position not assigned for unit: %1, %2", _unit, _unitData);
			};
		} forEach _units;

		// Return ACTIVE state
		T_SETV("state", ACTION_STATE_ACTIVE);
		ACTION_STATE_ACTIVE
		
	} ENDMETHOD;
	
	// Logic to run each update-step
	METHOD("process") {
		params [["_thisObject", "", [""]]];
		
		pr _state = CALLM0(_thisObject, "activateIfInactive");
		
		/*
		Shout at subordinates
		
		if (random 100 < 4) then {
			radio "Johny, stop fucking around, move into this house!";
		};
		
		if (random 100 < 4) then {
			radio "For fucks sake, did you get stuck in the middle of nowhere again?!";
		}
		*/
		
		// It's NEVER OVER!
		_state
	} ENDMETHOD;
	
	METHOD("handleUnitRemoved") {
		params [["_thisObject", "", [""]], ["_unit", "", [""]]];
		//OOP_INFO_1("Unit removed: %1", _unit);
	} ENDMETHOD;
	
	// logic to run when the action is satisfied
	METHOD("terminate") {
		params [["_thisObject", "", [""]]];
		
		// Delete external goals
		pr _group = GETV(T_GETV("AI"), "agent");
		pr _units = CALLM0(_group, "getUnits");
		{ // foreach units
			pr _unit = _x;
			pr _unitAI = CALLM0(_unit, "getAI");

			if (_unitAI != "") then { // Sanity check
				// Remove similar external goals from this AI
				CALLM2(_unitAI, "deleteExternalGoal", "GoalUnitInfantryMove", "");
			};
		} forEach _units;
		
	} ENDMETHOD;

ENDCLASS;

/*
// Sentry
_unit = cursorObject; 
_goalClassName = "GoalGroupOccupySentryPositions"; 
_parameters = []; 
call compile preprocessFileLineNumbers "AI\Misc\testFunctions.sqf"; 
[_unit, _goalClassName, _parameters] call AI_misc_fnc_addGroupGoal;
*/