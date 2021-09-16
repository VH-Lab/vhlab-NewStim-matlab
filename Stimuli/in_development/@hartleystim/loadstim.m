function [outstim] = loadstim(Hstim)

% LOADSTIM - load a Hartley stim into memory
%
% OUTSTIM = LOADSTIM(HSTIM)
%

if ~(NS_PTBv>=3),
	error(['Requires PsychToolbox 3.0 or greater.']);
end;

Hstim = unloadstim(Hstim);

Hp = getparameters(Hstim);

M = Hp.M;

StimWindowGlobals;

[s,kxv,kyv] = hartleyrange(Hstim);

N = numel(s); % number of stimuli in 1 rep

F = sqrt(kxv(1:N/2).^2+kyv(1:N/2).^2)/M;
phase_center = mod(2*pi*(1/M)*(kxv*(M-1)/2)+kyv*(M-1)/2, 2*pi);

offscreen = 


 % SPATIAL PARAMETERS %%%%%%%%%
[spatialphase, pixelIncrement, wLeng, destination_rect, width_offscreen, height_offscreen] = spatial_phase(Hstim);
 % END OF SPATIAL PARAMETERS %%%%%%%%%%

 %%%%%%%% animation parameters

[img, frames, ds_userfield] = animate(Hstim);

 % contrast/color parameters

colors = pscolors(Hstim);

%1 goes to max deflection above background bg + (chromehigh-chromelow)*light
%-1 goes to min deflection below background + (chromhigh-chromelow)*dark
%0 goes to background (chromlow+(chromehigh-chromelow)*background

img_colorized = cat(3,rescale(img,[-1 1],[colors.low_rgb(1) colors.high_rgb(1)]),...
	rescale(img,[-1 1],[colors.low_rgb(2) colors.high_rgb(2)]),...
	rescale(img,[-1 1],[colors.low_rgb(3) colors.high_rgb(3)]));


gratingtex = Screen('MakeTexture',StimWindow,img_colorized);

 % make color tables

offClut = ones(256,1)*colors.backdropRGB;
clut_bg = offClut;
clut_usage = ones(size(clut_bg)); % we'll claim we'll use all slots
clut = StimWindowPreviousCLUT; % we no longer need anything special here
clut(1,:) = colors.backdropRGB;

dp_stim = {'fps',StimWindowRefresh,'rect',destination_rect,'frames',frames,Hstim.PSparams.dispprefs{:} };
DP_stim = displayprefs(dp_stim);
dS_stim = { 'displayType', 'Movie', 'displayProc', 'standard', ...
         'offscreen', gratingtex, 'frames', frames, 'clut_usage', clut_usage, 'depth', 8, ...
		 'clut_bg', clut_bg, 'clut', clut, 'clipRect', [] , 'makeClip', 0,'userfield',ds_userfield };
DS_stim = displaystruct(dS_stim);

ds_userfield = MovieParams2MTI(DS_stim,DP_stim);

clip_tex = [];

if Hstim.PSparams.windowShape>-1,
	[clip_image,clip_dest_rect,ds_clipuserfield] = makeclippingrgn(Hstim);
	clip_tex = Screen('MakeTexture',StimWindow,clip_image);
	dS_clip = { 'displayType', 'Movie', 'displayProc', 'standard', ...
	         'offscreen', clip_tex, 'frames', frames, 'clut_usage', clut_usage, 'depth', 8, ...
			 'clut_bg', clut_bg, 'clut', clut, 'clipRect', [] , 'makeClip', 0,'userfield',ds_clipuserfield };
	DS_clip = displaystruct(dS_clip);
	dp_clip = {'fps',StimWindowRefresh,'rect',clip_dest_rect,'frames',frames,Hstim.PSparams.dispprefs{:} };
	DP_clip = displayprefs(dp_clip);
	moviefields_clip = MovieParams2MTI(DS_clip,DP_clip);
	ds_userfield = MovieParamsCat(ds_userfield,moviefields_clip);
end;

displayProc = 'standard';

dS = { 'displayType', 'Movie', 'displayProc', displayProc, ...
         'offscreen', [gratingtex clip_tex ], 'frames', frames, 'clut_usage', clut_usage, 'depth', 8, ...
	 'clut_bg', clut_bg, 'clut', clut, 'clipRect', [] , 'makeClip', 0,'userfield',ds_userfield };

Hstim = setdisplayprefs(Hstim,DP_stim);
 
outstim = Hstim;
outstim.stimulus = setdisplaystruct(outstim.stimulus,displaystruct(dS));
outstim.stimulus = loadstim(outstim.stimulus);

