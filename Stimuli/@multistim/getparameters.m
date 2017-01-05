function p = getparameters(ms)

   %  see help getparameters for documentation

p = ms.MSP;

stimparams = {};

for i=1:length(ms.stimlist),
	stimparams{i} = getparameters(ms.stimlist{i});
end;

p.stimparameters = stimparams;
