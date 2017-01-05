function t = duration(ggs)
% GLIDERGRIDSTIM/DURATION - Compute expected duration of GLIDERGRIDSTIM
%
%  T = DURATION(GGSTIM)
%
%  Returns the expected duration of the GLIDERGRIDSTIM GGSTIM.
%
%  See also: STIMULUS/DURATION


ggsparams = ggs.SGSparams;
dp = getdisplayprefs(ggs);
if isempty(dp),
        error('Empty displayprefs in stochasticgridstim.  Should not happen.');
end;
dp = struct(dp);
StimWindowGlobals;
if ~haspsychtbox|isempty(StimWindowRefresh), % provide best estimate
	t = ggsparams.N / dp.fps + duration(ggs.stimulus);
else, % provide more exact estimate based on refresh rate & display prefs
	pauseRefresh = zeros(1,length(dp.frames));
	if dp.roundFrames,
            pauseRefresh(:) = round(StimWindowRefresh / dp.fps);
        else,
            pauseRefresh = diff(fix((1:(length(dp.frames)+1)) * StimWindowRefresh / dp.fps));
        end;
        t = sum(pauseRefresh)/StimWindowRefresh + duration(ggs.stimulus);
end;
