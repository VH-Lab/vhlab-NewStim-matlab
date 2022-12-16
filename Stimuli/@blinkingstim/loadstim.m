function [outstim] = loadstim(BLstim)
% LOADSTIM - Load a BLINKINGSTIM object for display

StimWindowGlobals;
NewStimGlobals;

 % no error handling yet

BLstim = unloadstim(BLstim);  % unload old version before loading
 
width  = BLstim.rect(3) - BLstim.rect(1);
height = BLstim.rect(4) - BLstim.rect(2);

  % set up grid
if (BLstim.pixSize(1)>=1),
	X = BLstim.pixSize(1);
else,
	X = (width*BLstim.pixSize(1)); 
end;

if (BLstim.pixSize(2)>=1),
	Y = BLstim.pixSize(2);
else,
	Y = (height*BLstim.pixSize(2)); 
end;

corner = zeros(Y,X); corner(1) = 1;
Ys=repmat(corner,height/Y,width/X).*repmat((1:height)',1,width);
Ys = Ys(find(Ys));
Xs=repmat(corner,height/Y,width/X).*repmat((1:width),height,1);
Xs = Xs(find(Xs));
rects =  [ Xs Ys Xs+X Ys+Y ]-1;
  
clut_bg = repmat(BLstim.BG,256,1);  
depth = 8;
clut_usage = [ 1 ones(1,1) zeros(1,255-1) ]';
clut = ([BLstim.BG;BLstim.value(1,:);repmat(BLstim.BG,255-1,1);]);

displayType = 'custom';
displayProc = 'blinkstim';

  % make an offscreen image for each color to show
offscreen = zeros(1,2);


if NS_PTBv<3,
	offscreen(1) = screen(-1,'OpenOffscreenWindow',255,[0 0 X Y]);
    image1 = repmat(uint8(1),X,Y);
    image2 = repmat(uint8(0),X,Y);
    screen(offscreen(1),'PutImage',image1,[0 0 X Y]);
	offscreen(2) = screen(-1,'OpenOffscreenWindow',255,[0 0 X Y]);
	screen(offscreen(2),'PutImage',image2,[0 0 X Y]);
else,
    image1 = cat(3,repmat(BLstim.value(1,1),X,Y),repmat(BLstim.value(1,2),X,Y),repmat(BLstim.value(1,3),X,Y));
    image2 = cat(3,repmat(BLstim.BG(1,1),X,Y),repmat(BLstim.BG(1,2),X,Y),repmat(BLstim.BG(1,3),X,Y));
	offscreen(1) = Screen('MakeTexture',StimWindow,image1);
	offscreen(2) = Screen('MakeTexture',StimWindow,image2);
end;

	% total number of frames to show
N = size(rects,1)*BLstim.repeat;

blinkList = repmat(1:size(rects,1),1,BLstim.repeat);
if (BLstim.random)
	rand('state',BLstim.randState);
	inds = randperm(length(blinkList));
	blinkList = blinkList(inds);
end;

df = struct(getdisplayprefs(BLstim));

specifyDisplayTimeByFrames = 1;
if BLstim.fps < 0,
	specifyDisplayTimeByFrames = 0;
end;

drawstim = struct('rects',rects,...
		'blinkList',blinkList,...
		'N',N, ...
		'frameLength',fix(StimWindowRefresh/df.fps),...
		'bgpause', BLstim.bgpause,...
		'specifyDisplayTimeByFrames',specifyDisplayTimeByFrames);

dS = {'displayType', displayType, 'displayProc', displayProc, ...
		'offscreen', offscreen, 'frames', N, 'depth', 8, ...
		'clut_usage',clut_usage,'clut_bg',clut_bg,'clut',clut, ...
		'userfield',drawstim};
  
outstim = BLstim;
outstim.stimulus = setdisplaystruct(outstim.stimulus,displaystruct(dS));
outstim.stimulus = loadstim(outstim.stimulus);

