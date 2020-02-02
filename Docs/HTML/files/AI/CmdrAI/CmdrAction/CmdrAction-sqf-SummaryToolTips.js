NDSummary.OnToolTipsLoaded("File:AI/CmdrAI/CmdrAction/CmdrAction.sqf",{168:"<div class=\"NDToolTip TClass LSQF\"><div class=\"TTSummary\">The base class for all commander actions. An Action is defined as any behaviour the commander can choose whether to perform.&nbsp; In general the actions are parameterized and scored based on relevance and the commanders current strategy.&nbsp; The scoring can be a complex as required, but in the end is reduced down to a single number that can be used in comparison between actions of the same type, and other types of the same priority level (see CmdrAI for how this works).&nbsp; The behaviour of the action is defined by a state machine, defined by a set of ActionStateTransitions and a set of associated variables (kind of like a blackboard system).&nbsp; Usually one or more pieces of intel will be associated with a CmdrAction to allow them to be discoverable by other commanders.</div></div>",170:"<div class=\"NDToolTip TFunction LSQF\"><div class=\"TTSummary\">Unpacks a score array (4 element number vector) into the individual scoring properties.</div></div>",171:"<div class=\"NDToolTip TFunction LSQF\"><div class=\"TTSummary\">Create the ASTs for the action and assign them to the transitions member variable.&nbsp; We do NOT do this in the constructor, because it is only required for actions that will definiely be used, and the vast majority of actions that are created are just speculative (they are scored and then discarded if the score is too low).</div></div>",172:"<div class=\"NDToolTip TFunction LSQF\"><div class=\"TTSummary\">Registers a garrison that has this action assigned to it, so we can automatically unassign this action from it when it is finished (helps with cleanup).</div></div>",173:"<div class=\"NDToolTip TFunction LSQF\"><div class=\"TTSummary\">Remove a garrison from the list for which we will automatically an assign this action when it is finished.</div></div>",174:"<div class=\"NDToolTip TFunction LSQF\"><div class=\"TTSummary\">Add the intel object of this action to a specific garrison.</div></div>",175:"<div class=\"NDToolTip TFunction LSQF\"><div class=\"TTSummary\">Add the intel object of this action to garrisons in an area specified.</div></div>",176:"<div class=\"NDToolTip TFunction LSQF\"><div class=\"TTSummary\">Called by AI.CmdrAI.CmdrAI when evaluating potential actions. It should use the world states and settings this action was initialized with to evaluate its subjective value, and then set the score* member variables appropriately.</div></div>",132:"<div class=\"NDToolTip TFunction LSQF\"><div class=\"TTSummary\">Creates and registers an AST_VAR variable for use with this actions ASTs. The registration ensures that the value of the variable is saved and restored when performing simulations using this action. It is only required if the value can be changed by any of the ASTs themselves. If it can\'t then you can just directly create an AST_VAR without calling this function.</div></div>",133:"<div class=\"NDToolTip TFunction LSQF\"><div class=\"TTSummary\">Apply applicable ASTs to the specified world sim. What is applicable depends on current state, the type of world and the behaviour of the ASTs. Future world sims can have all ASTs applied until END state is reached, as ASTs should implement simulation of their final results. Now world sims can only have instantaneous AST results applied (e.g. allocating resources, splitting a Garrison, assigning an action), so will usually not transition to END state.</div></div>",134:"<div class=\"NDToolTip TFunction LSQF\"><div class=\"TTSummary\">Attempt to progress with this action in a real world model.</div></div>",135:"<div class=\"NDToolTip TFunction LSQF\"><div class=\"TTSummary\">Is this action complete? i.e. reached state CMDR_ACTION_STATE.CMDR_ACTION_STATE_END Returns: Boolean, true if the action is complete.</div></div>",136:"<div class=\"NDToolTip TFunction LSQF\"><div class=\"TTSummary\">Implement to update intel object.</div></div>",137:"<div class=\"NDToolTip TFunction LSQF\"><div class=\"TTSummary\">Implement to generate debug label for map marker for this action.</div></div>",183:"<div class=\"NDToolTip TFunction LSQF\"><div class=\"TTSummary\">Implement to perform debug drawing (e.g. update a marker).</div></div>",138:"<div class=\"NDToolTip TFunction LSQF\"><div class=\"TTSummary\">Get a value that falls off from 1 to 0 with distance, scaled by k.&nbsp; 0m = 1, 2000m = 0.5, 4000m = 0.25, 6000m = 0.2, 10000m = 0.0385 See https://&#8203;www&#8203;.desmos&#8203;.com&#8203;/calculator&#8203;/59i3cltsfr</div></div>"});