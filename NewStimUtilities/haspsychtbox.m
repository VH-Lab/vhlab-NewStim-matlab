function b = haspsychtbox
% HASPSYCHTBOX Returns 0/1 if Psychophysics toolbox is installed, 0 otherwise
%
% B = HASPSYCHTBOX
%
%  Returns 1 if the Psychophysics toolbox is installed, and 0 otherwise.


NewStimGlobals;

b = NS_PTBv;

return;

 % should superceed what is below

b = 0;
cpustr = computer;
if strcmp(cpustr,'MAC2')&exist('screen')&exist('serial'), b = 1; end;

