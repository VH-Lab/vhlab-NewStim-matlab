function [outstim] = loadstimPTB3(PSstim)

PSstim = unloadstim(PSstim);

StimWindowGlobals;

  % create a clipping region

 % SPATIAL PARAMETERS %%%%%%%%%
[spatialphase, pixelIncrement, wLeng, destination_rect, width_offscreen, height_offscreen] = spatial_phase(PSstim);
 % END OF SPATIAL PARAMETERS %%%%%%%%%%

 %%%%%%%% animation parameters

[img, frames, ds_userfield] = animate(PSstim);

 % contrast/color parameters

colors = pscolors(PSstim);

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

dp_stim = {'fps',StimWindowRefresh,'rect',destination_rect,'frames',frames,PSstim.PSparams.dispprefs{:} };
DP_stim = displayprefs(dp_stim);
dS_stim = { 'displayType', 'Movie', 'displayProc', 'standard', ...
         'offscreen', gratingtex, 'frames', frames, 'clut_usage', clut_usage, 'depth', 8, ...
		 'clut_bg', clut_bg, 'clut', clut, 'clipRect', [] , 'makeClip', 0,'userfield',ds_userfield };
DS_stim = displaystruct(dS_stim);

ds_userfield = MovieParams2MTI(DS_stim,DP_stim);

ps_add_tex = [];

if isfield(PSstim.PSparams,'ps_add'),
	[ps_add_image,ps_add_destrect,ds_adduserfield] = make_ps_add(PSstim.PSparams.ps_add);
	ps_add_tex = Screen('MakeTexture',StimWindow,ps_add_image);
	dS_add = {'displayType','Movie','displayProc','standard',...
		'offscreen',ps_add_tex,'frames',frames,'clut_usage',clut_usage,'depth',8,...
		'clut_bg',clut_bg,'clut',clut,'clipRect',[],'makeClip',0,'userfield',ds_adduserfield};
	DS_add = displaystruct(dS_add);
	dp_add = {'fps',StimWindowRefresh,'rect',ps_add_destrect,'frames',frames,PSstim.PSparams.dispprefs{:}};
	DP_add = displayprefs(dp_add);
	moviefields_add = MovieParams2MTI(DS_add,DP_add);
	ds_userfield = MovieParamsCat(ds_userfield,moviefields_add);
end;

clip_tex = [];

if PSstim.PSparams.windowShape>-1,
	[clip_image,clip_dest_rect,ds_clipuserfield] = makeclippingrgn(PSstim);
	clip_tex = Screen('MakeTexture',StimWindow,clip_image);
	dS_clip = { 'displayType', 'Movie', 'displayProc', 'standard', ...
	         'offscreen', clip_tex, 'frames', frames, 'clut_usage', clut_usage, 'depth', 8, ...
			 'clut_bg', clut_bg, 'clut', clut, 'clipRect', [] , 'makeClip', 0,'userfield',ds_clipuserfield };
	DS_clip = displaystruct(dS_clip);
	dp_clip = {'fps',StimWindowRefresh,'rect',clip_dest_rect,'frames',frames,PSstim.PSparams.dispprefs{:} };
	DP_clip = displayprefs(dp_clip);
	moviefields_clip = MovieParams2MTI(DS_clip,DP_clip);
	ds_userfield = MovieParamsCat(ds_userfield,moviefields_clip);
end;

ps_mask_tex = [];

if isfield(PSstim.PSparams,'ps_mask'),
	[ps_mask_image,ps_mask_destrect,ds_maskuserfield] = make_ps_mask(PSstim.PSparams.ps_mask);
	ps_mask_tex = Screen('MakeTexture',StimWindow,ps_mask_image);
	dS_mask = {'displayType','Movie','displayProc','standard',...
		'offscreen',ps_mask_tex,'frames',frames,'clut_usage',clut_usage,'depth',8,...
		'clut_bg',clut_bg,'clut',clut,'clipRect',[],'makeClip',0,'userfield',ds_maskuserfield};
	DS_mask = displaystruct(dS_mask);
	dp_mask = {'fps',StimWindowRefresh,'rect',ps_mask_destrect,'frames',frames,PSstim.PSparams.dispprefs{:}};
	DP_mask = displayprefs(dp_mask);
	moviefields_mask = MovieParams2MTI(DS_mask,DP_mask);
	ds_userfield = MovieParamsCat(ds_userfield,moviefields_mask);
end;

ps_overlay_tex = [];
overlay_clip_tex = [];
displayProc = 'standard';

if isfield(PSstim.PSparams,'ps_overlay'),
	[ps_overlay_image,ps_overlay_destrect,ps_overlay_dsuserfield] = make_ps_overlay(PSstim.PSparams.ps_overlay);
	ps_overlay_tex = Screen('MakeTexture',StimWindow,ps_overlay_image);
	dS_overlay = {'displayType','Movie','displayProc','standard',...
		'offscreen',ps_overlay_tex,'frames',frames,'clut_usage',clut_usage,'depth',8,...
		'clut_bg',clut_bg,'clut',clut,'clipRect',[],'makeClip',0,'userfield',ps_overlay_dsuserfield};
	DS_overlay = displaystruct(dS_overlay);
	dp_overlay = {'fps',StimWindowRefresh,'rect',ps_overlay_destrect,'frames',frames,PSstim.PSparams.dispprefs{:}};
	DP_overlay = displayprefs(dp_overlay);
	moviefields_overlay = MovieParams2MTI(DS_overlay,DP_overlay);

	ds_userfield = MovieParamsCat(ds_userfield,moviefields_overlay);
	displayProc = 'customdraw';

	[overlay_clip_image,overlay_clip_dest_rect,overlay_ds_clipuserfield] = makeclippingrgn(PSstim.PSparams.ps_overlay);
	overlay_clip_image(:,:,4) = 255-overlay_clip_image(:,:,4); % reverse this
	overlay_clip_tex = Screen('MakeTexture',StimWindow,overlay_clip_image);
	dS_overlay_clip = { 'displayType', 'Movie', 'displayProc', 'standard', ...
		         'offscreen', overlay_clip_tex, 'frames', frames, 'clut_usage', clut_usage, 'depth', 8, ...
				 'clut_bg', clut_bg, 'clut', clut, 'clipRect', [] , 'makeClip', 0,'userfield',overlay_ds_clipuserfield };
	DS_overlay_clip = displaystruct(dS_overlay_clip);
	dp_overlay_clip = {'fps',StimWindowRefresh,'rect',overlay_clip_dest_rect,'frames',frames,PSstim.PSparams.dispprefs{:} };
	DP_overlay_clip = displayprefs(dp_overlay_clip);
	moviefields_overlay_clip = MovieParams2MTI(DS_overlay_clip,DP_overlay_clip);
	ds_userfield = MovieParamsCat(ds_userfield,moviefields_overlay_clip);
end;


dS = { 'displayType', 'Movie', 'displayProc', displayProc, ...
         'offscreen', [gratingtex ps_add_tex clip_tex ps_mask_tex ps_overlay_tex overlay_clip_tex], 'frames', frames, 'clut_usage', clut_usage, 'depth', 8, ...
	 'clut_bg', clut_bg, 'clut', clut, 'clipRect', [] , 'makeClip', 0,'userfield',ds_userfield };

PSstim = setdisplayprefs(PSstim,DP_stim);
 
outstim = PSstim;
outstim.stimulus = setdisplaystruct(outstim.stimulus,displaystruct(dS));
outstim.stimulus = loadstim(outstim.stimulus);


return;

