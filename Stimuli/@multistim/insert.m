function nms = insert(ms, stim, ind)
% INSERT - Insert a stim into MULTISTIM 
%
%  NEWMS = INSERT(THEMS, STIMULUS, INDEX)
%
%  Inserts the stim STIMULUS into the list of stimuli to be
%  composed after the location INDEX.  Note that 0 is a valid
%  INDEX and this means the stimulus will be inserted at the
%  first location.
%
%  See also:  MULTISTIM, MULTISTIM/SET, MULTISTIM/GET
%   MULTISTIM/NUMSTIMS, MULTISTIM/REMOVE
% 

l = numStims(ms);

if ind<0|ind>l, error(['INDEX must be in 0..numStims.']); end;

if isa(stim,'stimulus'),
	ms.stimlist = cat(2,ms.stimlist(1:ind),{stim},ms.stimlist(ind+1:end));
else, error(['Stimulus must be of class ''stimulus'' .']);
end;

nms = ms;
