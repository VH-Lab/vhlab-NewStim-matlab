function [kxv,kyv] = hartleyrange(HSstim)
% HARTLEYRANGE - return the values of KX, KY to be run for this stimulus
%
% [KXV, KYV] = HARTLEYRANGE(HSSTIM)
%
% Return the values of KX and KY that will be run for this Hartley stimulus.
%
% The unconstrained range is every combination of -M:M for KXV and 
% -M:M for KXY.  
% 
