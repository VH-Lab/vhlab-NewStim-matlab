function [s,kxv,kyv] = hartleyrange(HSstim)
% HARTLEYRANGE - return the values of S,KX, KY to be run for this stimulus
%
% [S, KXV, KYV] = HARTLEYRANGE(HSSTIM)
%
% Return the values of S, KX, and KY that will be run for this Hartley stimulus.
%
% The unconstrained range is every combination of -M:M for KXV and 
% -M:M for KXY.  This is further limited by calculating the spatial frequency
% of each stimulus, and rejecting any that have a spatial frequency less than
% HSstim.HSparams.sfmax.
%

Hp = getparameters(HSstim);

kxv = -Hp.K_absmax:Hp.K_absmax;
kyv = -Hp.L_absmax:Hp.L_absmax;

[kx_mesh,ky_mesh] = meshgrid(kxv,kyv);

F = sqrt(kx_mesh.^2+ky_mesh.^2)/Hp.M; % frequency in terms of cycles per pixel

NewStimGlobals;

pixels_per_degree = pixels_per_cm * Hp.distance * tan(vlt.math.deg2rad(1));

F_ = F*pixels_per_degree; % convert to cycles per degree of visual angle

[I,J] = find(F_<=Hp.sfmax & F_>0);

kxv = kxv(J);
kyv = kyv(I);

kxv = [kxv(:) ; kxv(:)];
kyv = [kyv(:) ; kyv(:)];
s = [-ones(numel(I),1);ones(numel(I),1)];


