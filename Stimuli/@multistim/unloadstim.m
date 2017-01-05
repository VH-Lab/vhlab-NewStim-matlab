function [outstim] = unloadstim(ms)

if isloaded(ms)==1,
	ds = getdisplaystruct(ms);
	for i=1:numStims(ms), ms.stimlist{i} = unloadstim(ms.stimlist{i}); end;
	ms.stimulus = setdisplaystruct(ms.stimulus,[]);
	ms.stimulus = unloadstim(ms.stimulus);
end;

outstim = ms;
