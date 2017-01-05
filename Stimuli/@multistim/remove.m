function newms = remove(ms,index)

%  REMOVE - removes stimuli from MULTISTIM stimulus object
%
%  NEWMS = REMOVE(THEMS, INDEX)
%
%  Removes the stimulus at index INDEX from the list of stimuli
%  to be composed in the MULTISTIM stimulus THEMS.
%
%  See also: MULTISTIM, MULTISTIM/SET, MULTISTIM/GET,
%            MULTISTIM/NUMSTIMS
%

l = numStims(ms);
if index<1|index>l,error('Error: index must be in 1..numStims.'); end;

 % to make sure we don't leave hanging window pointers, unload stims to be deleted
for i=1:length(index), ms.stimlist{i} = unloadstim(ms.stimlist{i}); end;

 % now do the removal
ms.stimlist = ms.stimlist(setdiff(1:l,index));

newms = ms;

