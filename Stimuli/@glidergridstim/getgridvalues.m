function [V] = getgridvalues(GGSstim)
%  GLIDERGRIDSTIM/GETGRIDVALUES - Return grid values for GLIDERGRIDSTIM
%
%  [V] = GETGRIDVALUES(GGSSTIM)
%
%  Returns the value of each grid point at each frame in an (X*Y)xT matrix,
%  where X and Y are the dimensions of the grid (see GETGRID) and T is the
%  number of frames.
%
%  The value is the color to be used (1 corresponds to parameter FG1, 
%  2 corresponds to parameter FG2).
%

GGSparams = GGSstim.GGSparams;

[X,Y] = getgrid(GGSstim);

XY = X*Y;

rand('state',GGSparams.randState);

% zero the output
V = zeros(XY,GGSparams.N);

% random seed
V(:,1) = -1+2*(rand(XY,1)>0.5);

for i=2:GGSparams.N,
	V_grid = reshape(V(:,i-1),Y,X);
	switch GGSparams.correlator_version,
		case 1
			V_grid = visual_stim_row_correlator1_embed(GGSstim, V_grid, GGSparams.correlator, GGSparams.correlator_sign);
	end;
	V(:,i) = V_grid(:);
end;

 % convert from [-1,1] to [1 2]

V = 1+(V+1)/2;

