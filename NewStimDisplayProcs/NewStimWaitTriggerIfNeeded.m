function b = NewStimWaitTriggerIfNeeded(force_error)
% NEWSTIMWAITTRIGGERIFNEEDED - Wait for a trigger for the next stimulus if needed
%
%  B = NEWSTIMWAITTRIGGERIFNEEDED(FORCE_ERROR)
%
%  Checks the NEWSTIMGLOBALS variable 'NewStimTriggeredStimPresentation'. If this
%  variable is 1, then the program waits for a trigger of the appopriate sign
%  before continuing. 
% 
%  If a trigger was obtained correctly, then B is 1. If there was a timeout instead,
%  then B is 0. If FORCE_ERROR is 1, then the function will produce an error if the
%  timeout is reached.
%
%  Typically, these variables are set in the NewStimConfiguration.m file:
%
% Variable:                                | Default value
% ----------------------------------------------------------------------------------
% NewStimTriggeredStimPresentation         | 0 -- don't use triggered stim presentation
% NewStimTriggeredStimPresentation_Sign    | 1 -- use low to high trigger
% NewStimTriggeredStimPresentation_timeout | 30 -- use 30 second timeout

NewStimGlobals;

if NewStimTriggeredStimPresentation,
	if NewStimTriggeredStimPresentation_Sign,
		[times,b] = StimTriggerAct('WaitLowHigh',NewStimTriggeredStimPresentation_timeout);
	else,
		[times,b] = StimTriggerAct('WaitHighLow',NewStimTriggeredStimPresentation_timeout);
	end;
else,
	b = 1;
end;

