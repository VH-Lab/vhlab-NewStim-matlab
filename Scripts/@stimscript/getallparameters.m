function p = getallparameters(stimscript_object)
% GETALLPARAMETERS - return parameters from all stimuli in stimscript
%
% P = GETALLPARAMETERS(STIMSCRIPT_OBJECT)
%
% Returns the structure with all the parameters for the stimuli contained
% in STIMSCRIPT_OBJECT as a cell array of structures.
% 
% For example, P{i} is the structure with the parameters for stimulus i.
% 

n = numStims(stimscript_object);

p = {};

for i=1:n,
	p{end+1} = getparameters(get(stimscript_object,i));
end;


