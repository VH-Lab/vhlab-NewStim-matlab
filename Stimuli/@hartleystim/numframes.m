function n = numframes(HSstim)
% NUMFRAMES - compute the number of frames in a Hartley stimulus
%
% N = NUMFRAMES(HSSTIM)
%
% Returns the number of frames to be shown by this Hartley stimulus.
% 


Hp = getparameters(HSstim);

s = hartleyrange(HSstim);

n = Hp.reps * numel(s);


