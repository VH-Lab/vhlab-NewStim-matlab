function pos = getgridpositions(sgs)
% GETGRIDPOSITIONS - Return the position of each grid number for a STOCHASTICGRIDSTIM
%
%  POS = GETGRIDPOSITIONS(SGS)
%
%  For a STOCHASTICGRIDSTIM SGS, returns the position of each grid number. Grids are numbered
%  from the upper left, going down the columns, and then across in rows. POS has the same number of 
%  rows as the number of grid locations, and each row contains the row and column position of the grid location.
%

[X,Y]=getgrid(sgs);

pos = [ 1+floor( ((1:X*Y)'-1)/Y )   1+mod((1:X*Y)'-1,Y)];


