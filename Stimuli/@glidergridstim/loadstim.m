function [outstim] = loadstim(GGSstim)
% GLIDERGRIDSTIM/LOADSTIM - Load a GLIDERGRIDSTIM
%
%  LOADEDSTIM = LOADSTIM(GGSTIM)
%
%  Loads a GLIDERGRIDSTIM into memory for display.
%
%  See also: STIMULUS/LOADSTIM
%

NewStimGlobals;
StimWindowGlobals;

use_customdraw = 1;
conserve_mem_custom = 1;

% no error handling yet

GGSstim = unloadstim(GGSstim);  % unload old version before loading
 
GGSparams = GGSstim.GGSparams;

if isfield(GGSparams,'angle'),
	rotationangle = GGSparams.angle;
else,
	rotationangle = 0;
end;

[Xo,Yo,rect,width,height,inds,grid] = getgrid(GGSstim);
XY = Xo * Yo;
z = 1:XY;

clut_bg = repmat(GGSparams.BG,256,1);  
depth = 8;
l = 2;
clut_usage = [ 1 ones(1,l) zeros(1,255-l) ]';

colorvalues = [GGSparams.FG1;GGSparams.FG2];

V = getgridvalues(GGSstim);

dP = getdisplayprefs(GGSstim.stimulus);
dPs = struct(dP);
if ((XY<253)&(~dPs.forceMovie))&~use_customdraw, % use one image and array of CLUTs, one frame per column
	displayType = 'CLUTanim';
	displayProc = 'standard';
	clut = cell(GGSparams.N,1);
	for i=1:GGSparams.N,
		clut{i} = ([ GGSparams.BG ; colorvalues(V(i,:),:); repmat(GGSparams.BG,255-XY,1);]);
	end;
	if NS_PTBv < 3,
		error(['PTB less than version 3 not supported here.']);
	else,  % this is out of date, better to use movie feature
		if rotationangle~=0,
			grid = imrotate(grid,rotationangle,'nearest','crop');
		end;
		offscreen = Screen('MakeTexture',StimWindow,grid);
	end;
else, % use 'Movie' mode, one CLUT and many images
	displayType = 'Movie';
	displayProc = 'standard';
	clut = ([ GGSparams.BG; GGSparams.FG1; GGSparams.FG2; repmat(GGSparams.BG,255-l,1);]);
	offscreen = zeros(1,GGSparams.N);
	Je = ones(1,size(inds,1));
	I = 1:XY;
	for i=1:GGSparams.N,
		if i==1|~conserve_mem_custom,
			for I=1:XY,
				image = repmat(uint8(1),size(grid));
				image(inds(:,I)) = V(I,i);
			end;
		end;
		if NS_PTBv < 3,
			error(['PTB less than version 3 not supported here.']);
		else,
			if rotationangle~=0&~use_customdraw,
				image = imrotate(image, rotationangle,'nearest','crop');
			end;
			if ~conserve_mem_custom|i==1,
				rgb = ind2rgb(image,clut);
				offscreen(i) = Screen('MakeTexture',StimWindow,rgb);
			end;
		end;
	 end;
	if use_customdraw, displayProc = 'customdraw'; end;
end;
 
dS = {'displayType', displayType, 'displayProc', displayProc, ...
              'offscreen', offscreen, 'frames', GGSparams.N, 'depth', 8, ...
			  'clut_usage', clut_usage, 'clut_bg', clut_bg, 'clut', clut};
  
outstim = GGSstim;
outstim.stimulus = setdisplaystruct(outstim.stimulus,displaystruct(dS));
outstim.stimulus = loadstim(outstim.stimulus);
 
