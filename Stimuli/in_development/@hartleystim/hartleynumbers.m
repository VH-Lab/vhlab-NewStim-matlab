function [s,kx,ky] = hartleynumbers(HSstim)
% HARTLEYNUMBERS - calculate Hartley numbers for a Hartley stimulus
%
% [S,KX,KY] = HARTLEYNUMBERS(HSSTIM)
%
% Given the stimulus parameters and the random seed, calculate the full
% list of Hartley numbers to be shown (or that were shown).
%
% The random seed is set but returned to the value it had at the beginning of this
% function call.
%
% S, KX, and KY are column vectors, with one entry per Hartley frame.
%
% S is the sign of each frame (+/- 1)
% KX is the X number of each frame 
% KY is the Y number of frame
% 

[KX_values,KY_values] = hartleyrange(HSstim);

Hp = getparameters(HSstim);

[KXmesh,KYmesh] = meshgrid(KX_values,KY_values);
KXmesh = KXmesh(:);
KYmesh = KYmesh(:);
not_origin = find( ~(KXmesh==0 & KYmesh==0));
KXmesh = KXmesh(not_origin);
KYmesh = KYmesh(not_origin);

num_of_stims = numel(KXmesh)*2; % number of stims, and one for each sign

currentState = rand('state');
rand('state',Hp.randState);
order = vlt.stats.pseudorandomorder(num_of_stims,Hp.reps);
rand('state',currentState); % restore state

s = 2*(mod(order,2)-0.5,2);
value = mod(order,numel(KXmesh));
value(find(value==0)) = numel(KXmesh);

kx = KXmesh(value);
ky = KYmesh(value);

s = s(:);
kx = kx(:);
ky = ky(:);

