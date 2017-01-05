function newms = set(thems, stim, index)

%  SET- Sets stimulus value in MULTISTIM object
%
%  NEWMS = SET(THEMS,STIMULUS,INDEX)
%
%  Sets the stimulus in the list of stimuli to be
%  combined at index INDEX to be STIMULUS.
%
%  See also:  MULTISTIM, MULTISTIM/GET, MULTISTIM/REMOVE
%             MULTISTIM/NUMSTIMS, MULTISTIM/INSERT
%

newms = thems;

if index > (1+numStims(newms)),
	error(['INDEX must be in 1..numStims+1.]);
end;

if isa(stim,'stimulus'),
	newms.stimlist = cat(2,newms.stimlist(1:index-1),{stim},newms.stimlist(index+1:end));
else, error(['STIMULUS must be an object of class ''stimulus''.']);
end;

