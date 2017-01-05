function [Xo,Yo,rect,width, height, inds, grid] = getgrid(GGSstim)
%  GLIDERGRIDSTIM/GETGRID - Return the dimensions of the grid for a GLIDERGRIDSTIM
%
%  [X,Y,RECT,WIDTH,HEIGHT,INDS,GRID] = GETGRID(GGSSTIM)
%
%  Returns the dimensions of the grid associated with GLIDERGRIDSTIM
%  GGSSTIM in X and Y, and also the rectangle on the screen where the
%  GGSSTIM is to be drawn.  It also returns a matrix INDS which contains
%  in each column i the indicies of grid point i in a matrix image of size
%  RECT.  The grid points are numbered from 1 to X*Y going down each
%  column and then over each row.

GGSparams = GGSstim.GGSparams;

width  = GGSparams.rect(3) - GGSparams.rect(1);
height = GGSparams.rect(4) - GGSparams.rect(2);

% set up grid
if (GGSparams.pixSize(1)>=1),
	X = GGSparams.pixSize(1);
else, X = (width*GGSparams.pixSize(1)); 
end;

if (GGSparams.pixSize(2)>=1),
	Y = GGSparams.pixSize(2);
else, Y = (height*GGSparams.pixSize(2)); 
end;

i = 1:width;
x = fix((i-1)/X)+1;
i = 1:height;
y = fix((i-1)/Y)+1;
XY = x(end)*y(end);

Xo = x(end); Yo = y(end);
rect = GGSparams.rect;

if nargout>=6,
	grid = ([(x-1)*y(end)]'*ones(1,length(y))+ones(1,length(x))'*y)';
	g = reshape(1:width*height,height,width);
	corner = zeros(Y,X); corner(1) = 1;
	cc=reshape(repmat(corner,height/Y,width/X).*g,width*height,1);
	corners = cc(find(cc))';
	footprint = reshape(g(1:Y,1:X),X*Y,1)-1;
	inds=ones(1,X*Y)'*corners+footprint*ones(1,XY);
end;
