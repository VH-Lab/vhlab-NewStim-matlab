function [outstim] = loadstim(ms)
%  LOADSTIM - Loads the MULTISTIM stimulus
%
%  NEWMS = LOADSTIM(MYMULTISTIM);
%
%  Loads MYMULTISTIM stimulus into memory.
%
%  See also: MULTISTIM, STIMULUS/LOADSTIM

p = getparameters(ms);

NewStimGlobals;
StimWindowGlobals;

l = numStims(ms);
for i=1:l,
	if ~isloaded(ms.stimlist{i}),
		ms.stimlist{i} = loadstim(ms.stimlist{i});
		dss{i} = getdisplaystruct(ms.stimlist{i});
		dsss{i} = struct(dss{i});
	end;
end;

width = diff(p.rect([1 3])); height = diff(p.rect([2 4]));

df = struct(getdisplayprefs(ms.stimlist{1}));
df.rect = p.rect;

ds.displayProc = 'standard';
ds.displayType = 'MultiMovie';
ds.frames = df.frames;
ds.offscreen = {}; % fill in later
ds.clut = dsss{1}.clut;
ds.clut_usage = dsss{1}.clut_usage;
ds.clut_bg = dsss{1}.clut_bg;
ds.depth = dsss{1}.depth;
ds.makeClip = dsss{1}.makeClip;
ds.clipRect = dsss{1}.clipRect;
ds.userfield = {};

for i=1:l,
	ds.offscreen{i} = dsss{i}.offscreen;
	%properly set up the userfield for each stimulus
	uf = MovieParams2MTI(dss{i},getdisplayprefs(ms.stimlist{i}));
	uf2 = ClipRgnParams2MTI(dss{i},getdisplayprefs(ms.stimlist{i}));
	fn2 = fieldnames(uf2);
	for j=1:length(fn2),
		uf = setfield(uf,fn2{j},getfield(uf2,fn2{j}));
	end;
	ds.userfield{i} = uf;
end;

 % now, have to switch userfield to not be a cell, but to have individual entries that are cells

fn = fieldnames(ds.userfield{1});
for j=1:length(fn),
	eval(['newuf.' fn{j} '={};']);
	for i=1:l,
		eval(['newuf.' fn{j} '{i} = ds.userfield{i}.' fn{j} ';']);
	end;
end;

ds.userfield = newuf;

df = rmfield(df,'defaults'); % this is a field that is added by displayprefs, can't be included

outstim = setdisplayprefs(ms,displayprefs(struct2namevaluepair(df)));
outstim = setdisplaystruct(outstim,displaystruct(struct2namevaluepair(ds)));
outstim.stimulus = loadstim(outstim.stimulus);

