function img = grid2screenimage(bs, gridpos, screensize)
% GRID2SCREENIMAGE - Return the image of a grid position on the screen
%
%   IMG = GRID2SCREENIMAGE(BS, GRIDPOS, SCREENSIZE)
%
%   Inputs:  BS         - A blinkingstim object
%            GRIDPOS    - The grid position number to highlight
%            SCREENSIZE - The screen size [width height]
%
%   Outputs: IMG        - An image WIDTHxHEIGHT with 1's where
%                         the grid location is, and 0 otherwise.
   

img = zeros(screensize(1),screensize(2));

[x,y,rect,inds]= getgrid(bs);

width  = bs.rect(3) - bs.rect(1);
height = bs.rect(4) - bs.rect(2);

myimg = zeros(width,height);
myimg(inds(:,gridpos)) = 1;

img(rect(1)+1:rect(3),rect(2)+1:rect(4)) = myimg;

img = img';
