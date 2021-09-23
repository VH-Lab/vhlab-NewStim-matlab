function [img_rgba, destrect, ds_userfields] = makeclippingrgn(Hstim)
% MAKECLIPPINGRGN - Make a clipping region for a Hartley stimulus
%
%  [CLIP_IMAGE, DEST_RECT, DS_USERFIELD] = MAKECLIPPINGRGN(HSTIM)
%
%  This function returns the elements necessary for the clipping region
%  (that is, mask region) that LOADSTIM can use for its displaystruct
%  object.  See 'help hartleystim' for the meanings of the windowShape
%  parameter.
%
%  See also: HARTLEYSTIM/LOADSTIM, DISPLAYSTRUCT

Hp = getparameters(Hstim);
rect = Hp.rect;  % this is the rect requested by the user
width=rect(3)-rect(1); height=rect(4)-rect(2);

width_offscreen = 3*width;
height_offscreen =3*height;

destrect = CenterRect([0 0 width_offscreen height_offscreen],rect);

[s_] = hartleynumbers(Hstim);
frames = ones(numel(s_),1);

[X,Y] = meshgrid( [1:width_offscreen]-width_offscreen/2 , [1:height_offscreen]-height_offscreen/2);

colors = pscolors(Hstim);

img_rgba = [];

img_rgba = cat(3,repmat(uint8(colors.backdropRGB(1)),width_offscreen,height_offscreen),...
	repmat(uint8(colors.backdropRGB(2)),width_offscreen,height_offscreen),...
	repmat(uint8(colors.backdropRGB(3)),width_offscreen,height_offscreen));

switch (Hp.windowShape),
	case {0}, % rectangle
		img_rgba(:,:,4) = uint8( 255*(1-(abs(X)<=height/2 & abs(Y)<=width/2)));
	case {1}, % oval
		img_rgba(:,:,4) = uint8( 255*(1-(((X.^2)/((height/2)^2) + (Y.^2)/((width/2)^2) ) <=1 )));
end;

 % angles
switch (Hp.windowShape),
	case {0,1}, % oriented with screen
		ds_userfields.Movie_angles = repmat(90,1,length(frames));
	otherwise,
		error(['Unknown windowShape ' int2str(Hp.windowShape) '.']);
end;

