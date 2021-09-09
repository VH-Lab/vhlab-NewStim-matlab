function [s,kxv,kyv] = hartleynumbers(HSstim)
% HARTLEYNUMBERS - calculate Hartley numbers for a Hartley stimulus
%
% [S,KXV,KYV] = HARTLEYNUMBERS(HSSTIM)
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

[s, kxv, kyv] = hartleyrange(HSstim);
N = numel(s); % number of stims without reps

Hp = getparameters(HSstim);

currentState = rand('state');
rand('state',Hp.randState);
order = vlt.stats.pseudorandomorder(N,Hp.reps);
rand('state',currentState); % restore state

s = s(order(:));
kxv = kxv(order(:));
kyv = kyv(order(:));

