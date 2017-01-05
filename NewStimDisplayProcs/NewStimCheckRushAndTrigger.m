function NewStimCheckRushAndTrigger
% NEWSTIMCHECKRUSHANDTRIGGER - Check the "rush" and "trigger" flags to make sure they exist
%
% NEWSTIMCHECKRUSHANDTRIGGER
%
% This function will check the following variables defined in NEWSTIMGLOBALS for existence
% and also set them to default values if they aren't defined.
%
% Variable:                                | Default value
% ----------------------------------------------------------------------------------
% NewStimUseRushDisplay                    | 1 -- use the command 'Rush' when displaying stims  
% NewStimTriggeredStimPresentation         | 0 -- don't use triggered stim presentation
% NewStimTriggeredStimPresentation_sign    | 1 -- use low to high trigger
% NewStimTriggeredStimPresentation_timeout | 30 -- use 30 second timeout

NewStimGlobals;

varnames = {'NewStimUseRushDisplay','NewStimTriggeredStimPresentation',...
		'NewStimTriggeredStimPresentation_Sign','NewStimTriggeredStimPresentation_timeout'};

values = {1, 0, 1, 30};

for i=1:length(varnames),
	eval(['b = isempty(''' varnames{i} ''');']);
	if b,
		eval([varnames{i} ' = values{i};']);
	end;
end;
