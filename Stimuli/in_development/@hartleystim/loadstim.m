function [outstim] = loadstim(Hstim)
% LOADSTIM - load a Hartley stim into memory
%
% OUTSTIM = LOADSTIM(HSTIM)
%

NewStimGlobals;
if ~(NS_PTBv>=3),
	error(['Requires PsychToolbox 3.0 or greater.']);
end;

Hstim = unloadstim(Hstim);

Hp = getparameters(Hstim);

M = Hp.M;

StimWindowGlobals;

[s,kxv,kyv] = hartleyrange(Hstim);

N = numel(s); % number of stimuli in 1 rep, always even because s takes -/+ 1 

F = sqrt(kxv(1:N/2).^2+kyv(1:N/2).^2)/M;  
phase_center = mod(2*pi*(1/M)*(kxv(1:N/2)*(M-1)/2)+kyv(1:N/2)*(M-1)/2, 2*pi);

if mod(M,2)==0,
        pixel_coords = (-M-1):(2*M)-1+1;
else,
        pixel_coords = ((-M+1)/2):(M+(M-1)/2);
end;

if mod(M,2)==0, % even
        pixel_coords = (-2*M+1):(2*M);
else,
        pixel_coords = (-2*M):(2*M);
end;

[offX_mesh,offF_mesh] = meshgrid(pixel_coords,F);
off_phase = repmat(phase_center(:),1,numel(pixel_coords));
im_offscreen = cas(2*pi*offF_mesh.*offX_mesh+off_phase)/(sqrt(2)); % divide by square root of 2 to make output in [-1..1]

 % contrast/color parameters

colors = pscolors(Hstim);

%1 goes to max deflection above background bg + (chromehigh-chromelow)*light
%-1 goes to min deflection below background + (chromhigh-chromelow)*dark
%0 goes to background (chromlow+(chromehigh-chromelow)*background

img_colorized = cat(3,vlt.math.rescale(im_offscreen,[-1 1],[colors.low_rgb(1) colors.high_rgb(1)]),...
	vlt.math.rescale(im_offscreen,[-1 1],[colors.low_rgb(2) colors.high_rgb(2)]),...
	vlt.math.rescale(im_offscreen,[-1 1],[colors.low_rgb(3) colors.high_rgb(3)]));

[s_,kxv_,kyv_, order_] = hartleynumbers(Hstim);
stimnum = mod(order_,N/2);
stimnum(stimnum==0) = N/2;

selection = [ (-(M-1)) (M+1) ];

frames = ones(numel(s_),1); % the same offscreen image provides all of the stimulus images

 % now build the ds_userfield

 % this shows how we build the source rect on a frame-by-frame basis, and then it is done in
 % a vectorized form without a for loop below. They are byte-for-byte equal.
%sourcerect_ = [];
%for i=1:numel(s_),
%	center = floor(size(im_offscreen,2)/2);
%	if s_(i)==-1,
%		center = center+round(1/(2*(sqrt(kxv_(i).^2+kyv_(i).^2)/M)))-1;
%	end;
%	sourcerect = [center+selection(1)-1 stimnum(i)-1 center+selection(2)-1 stimnum(i)-1]; % -1 because psychtoolbox is 0 based
%	sourcerect_(end+1,1:4) = sourcerect;
%end;

eps = 0.0001;

center_default = floor(size(im_offscreen,2)/2) + zeros(numel(stimnum),1);
center_shift = round(1./(2*sqrt((kxv_(:)).^2+(kyv_(:)).^2)/M))-1;
sourcerect_ = [center_default+selection(1)-1-0*eps stimnum(:)-1 center_default+selection(2)-1 stimnum(:)-1+eps]  + ...
	(s_==-1).*[center_shift zeros(numel(stimnum),1) center_shift zeros(numel(stimnum),1)];

ds_userfield.Movie_angles = 90+vlt.data.rowvec(vlt.math.rad2deg(atan2(kyv_,kxv_)));
ds_userfield.Movie_sourcerects = sourcerect_'; % must be 4xN frames

% calculate destination rectangle - we will draw a bigger rectangle but then clip out all but the viewing region below
rect = Hp.rect;
width = rect(3)-rect(1);
height = rect(4)-rect(2);
width_destrect = 2*max(width,height); % we will draw a square, clipped
height_destrect = 2*max(width,height);
destination_rect = CenterRect([0 0 width_destrect height_destrect],rect);

hartley_tex = Screen('MakeTexture',StimWindow,img_colorized);

 % make color tables

offClut = ones(256,1)*colors.backdropRGB;
clut_bg = offClut;
clut_usage = ones(size(clut_bg)); % we'll claim we'll use all slots
clut = StimWindowPreviousCLUT; % we no longer need anything special here
clut(1,:) = colors.backdropRGB;

dp_stim = {'fps',Hp.fps,'rect',destination_rect,'frames',frames,Hp.dispprefs{:} };
DP_stim = displayprefs(dp_stim);
dS_stim = { 'displayType', 'Movie', 'displayProc', 'standard', ...
         'offscreen', hartley_tex, 'frames', frames, 'clut_usage', clut_usage, 'depth', 8, ...
		 'clut_bg', clut_bg, 'clut', clut, 'clipRect', [] , 'makeClip', 0,'userfield',ds_userfield };
DS_stim = displaystruct(dS_stim);
ds_userfield = MovieParams2MTI(DS_stim,DP_stim); % to add to the next 


disp('now on to clipping')
clip_tex = [];

if Hp.windowShape>-1,
	[clip_image,clip_dest_rect,ds_clipuserfield] = makeclippingrgn(Hstim);
	clip_tex = Screen('MakeTexture',StimWindow,clip_image);
	dS_clip = { 'displayType', 'Movie', 'displayProc', 'standard', ...
	         'offscreen', clip_tex, 'frames', frames, 'clut_usage', clut_usage, 'depth', 8, ...
			 'clut_bg', clut_bg, 'clut', clut, 'clipRect', [] , 'makeClip', 0,'userfield',ds_clipuserfield };
	DS_clip = displaystruct(dS_clip);
	dp_clip = {'fps',Hp.fps,'rect',clip_dest_rect,'frames',frames,Hp.dispprefs{:} };
	DP_clip = displayprefs(dp_clip);
	moviefields_clip = MovieParams2MTI(DS_clip,DP_clip);
	disp('now to cat userfields')
	ds_userfield = MovieParamsCat(ds_userfield,moviefields_clip);
end;

displayProc = 'standard';

dS = { 'displayType', 'Movie', 'displayProc', displayProc, ...
         'offscreen', [hartley_tex clip_tex ], 'frames', frames, 'clut_usage', clut_usage, 'depth', 8, ...
	 'clut_bg', clut_bg, 'clut', clut, 'clipRect', [] , 'makeClip', 0,'userfield',ds_userfield };

disp('about to set display prefs')
Hstim = setdisplayprefs(Hstim,DP_stim);

ds_userfield.Movie_sourcerects(:,1,:)
ds_userfield.Movie_destrects(:,1,:)

%keyboard
 
outstim = Hstim;
outstim.stimulus = setdisplaystruct(outstim.stimulus,displaystruct(dS));
outstim.stimulus = loadstim(outstim.stimulus);

