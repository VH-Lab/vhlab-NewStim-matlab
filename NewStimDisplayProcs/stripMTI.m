function newMTI = stripMTI(MTI)

for i=1:length(MTI),
	MTI{i}.ds = [];
	MTI{i}.df = [];
	MTI{i}.MovieParams = [];
	MTI{i}.ClipRgnParams = [];
end;

newMTI = MTI;
