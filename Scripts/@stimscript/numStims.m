function n = numStims(S)
% NUMSTIMS Return the number of stimuli contained within a STIMSCRIPT object
%
%   N = NUMSTIMS(S)
%
% Returns the number of stimuli in the STIMSCRIPT object S.
%
% See also: STIMSCRIPT, GETDISPLAYORDER, SETDISPLAYMETHOD
%
n = length(S.Stims);

