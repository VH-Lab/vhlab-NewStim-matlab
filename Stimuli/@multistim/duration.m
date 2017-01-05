function t = duration(ms)
% DURATION - Duration of MULTISTIM stim
%
%  T = DURATION(MYMULTISTIM)
%
%  Returns the expected duration of the MULTISTIM stimulus
%  MYMULTISTIM.
%
%  See also:  MULTISTIM, STIMULUS/DURATION


if numStims(ms)>0,
	t = duration(get(ms,1));  % duration is duration of first stimulus
else, t = 0;
end;

