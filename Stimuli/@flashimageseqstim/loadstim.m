function [outstim] = loadstim(fis)

StimWindowGlobals;
NewStimGlobals;

p = getparameters(fis);

if isfield(p,'intensity'),
	intensity = p.intensity;
else,
	intensity = 1;
end;

[images_used, dataframedurations] = frame_sequence(fis);

%disp('past frame sequence');

num_images = size(images_used,1);
frames = 1:size(images_used,2);

offClut = repmat(p.BG,256,1);
clut_bg = offClut;
clut_usage = ones(size(clut_bg)); % we'll claim we'll use all slots
clut = StimWindowPreviousCLUT; % we no longer need anything special here
clut(1,:) = p.BG;

%disp('past color table stuff');

d = dir(p.dirname);
incl = [];
for i=1:length(d), %remove those annoying directories
	if d(i).name(1)~='.',
		incl(end+1) = i;
	end;
end;
d = d(incl);

imgs = {};

offscreens = [];

ds_userfield = [];
%disp('ready to read images');

for i=0:num_images,
	if i==0,
		imgs{i+1} = intensity * cat(3,p.BG(1),p.BG(2),p.BG(3));
	else,
		if length(d)<i,
			error(['Not enough images in directory.']);
		end;
		imgs{i+1} = imread([p.dirname filesep d(i).name]);
	end;
	offscreens(i+1) = Screen('MakeTexture',StimWindow,imgs{i+1});
	dp_here = {'fps',StimWindowRefresh,'rect',p.rect,'frames',frames,p.dispprefs{:}};
	DP_here = displayprefs(dp_here);
	dS_here =  { 'displayType', 'Movie', 'displayProc', 'standard', ...
	         'offscreen', offscreens(i+1), 'frames', frames, 'clut_usage', clut_usage, 'depth', 8, ...
                 'clut_bg', clut_bg, 'clut', clut, 'clipRect', [] , 'makeClip', 0,'userfield',[]};
	DS_here = displaystruct(dS_here);
	my_ds_userfield = MovieParams2MTI(DS_here,DP_here);
	if isempty(ds_userfield),
		ds_userfield = my_ds_userfield;
	else,
		ds_userfield = MovieParamsCat(ds_userfield,my_ds_userfield);
	end;
end;


Movie_textures = {};

for i=1:size(images_used,2),
	mytextures = 1+find(images_used(:,i));
	if isempty(mytextures), mytextures = 1; end;
	Movie_textures{i} = mytextures;
end;

ds_userfield.Movie_textures = Movie_textures;
ds_userfield.pauseRefresh = dataframedurations;

dp_here = {'fps',StimWindowRefresh,'rect',p.rect,'frames',frames,p.dispprefs{:}};
DP_here = displayprefs(dp_here);

dS = { 'displayType', 'Movie', 'displayProc', 'standard', ...
         'offscreen', offscreens, 'frames', frames, 'clut_usage', clut_usage, 'depth', 8, ...
         'clut_bg', clut_bg, 'clut', clut, 'clipRect', [] , 'makeClip', 0,'userfield',ds_userfield };

outstim = setdisplayprefs(fis,DP_here);
outstim.stimulus = setdisplaystruct(outstim.stimulus,displaystruct(dS));
outstim.stimulus = loadstim(outstim.stimulus);

%disp('stim loaded');
