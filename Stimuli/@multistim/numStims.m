function n = numStims(ms)
%  NUMSTIMS - Number of stims in list of a MULTISTIM stim object
%
%  N = NUMSTIMS(THEMS)
% 
%  Returns number of stims in the list of stimuli to be composed in a 
%  MULTISTIM object THEMS.
%
%  See also:  MULTISTIM, MULTISTIM/SET, MULTISTIM/GET,
%  MULTISTIM/REMOVE, MULTISTIM/APPEND

n = length(ms.stimlist);
