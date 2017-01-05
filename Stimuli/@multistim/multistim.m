function [ms] = multistim(MSP,OLDSTIM)

% NewStim package:  MULTISTIM  - Compose color table animation based stims
%
%  THEMS = MULTISTIM(PARAMETERS)
%
%  A stim that allows compositions of color table animation-based stimuli.
%  One can add stimuli to the MULTISTIM object to be composed, and these
%  stimuli are displayed on the rectangle provided as a parameter to
%  the MULTISTIM object. 
%  
%  Note that only stimuli that use 'Movie' display mode and the standard 'Movie'
%  display procedure can be composed. 
%
%  PARAMETERS can either be the string 'graphical' (which will prompt the user
%  to enter all of the parameter values), the string 'default' (which will use
%  default parameter values), or a structure.  When using 'graphical', one may
%  also use
%
%  THEMS = MULTISTIM('graphical',OLDMS)
%
%  where THEMS is a previously created MULTISTIM object.  This will set the
%  default parameter values to those of OLDMS.
%
%  If passing a structure, the structure should have the following fields:
%  (dimensions of parameters are given as [M N]; fields are case-sensitive):
%
%  [1x4] rect           - Location of the stimulus on background window
%                         [top_x top_y bottom_x bottom_y]
%                         (This should be be big enough to cover the
%                          'rect' fields of the stimuli to be composed
%                          or they won't show up)
% [cell] dispprefs      - Sets displayprefs fields, or use {} for defaults.
%
%  See also:  PERIODICSTIM, STIMULUS

NewStimListAdd('multistim');

if nargin==0,
	ms = multistim('default');
	return;
end;

   default_p = struct('rect',[0 0 800 600]);
   default_p.dispprefs = {};

ms = [];
finish = 1;

if nargin==1, oldstim=[]; else, oldstim = OLDSTIM; end;

if ischar(MSP),
	if strcmp(MSP,'graphical'),
		if isempty(oldstim),
			finish = 0;
			[ms,cancelled] = edit_graphical(multistim('default'));
			if cancelled, ms = []; end;
		else,
			[ms,cancelled] = edit_graphical(oldstim);
			if cancelled, ms = oldstim; end;
		end;
	elseif strcmp(MSP,'default')|strcmp(MSP,''),
		MSP = [];
	else,
		error('Unknown string input to multistim.');
	end;
else,  % they are parameters
end;

if finish,
	s = stimulus(5);
	ms = class(struct('MSP',[],'stimlist',[]),'multistim',s);
	ms = setparameters(ms,MSP);
end;
