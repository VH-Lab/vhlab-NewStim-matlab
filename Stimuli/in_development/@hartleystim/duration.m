function t = duration(Hstim)

Hparams = struct(Hstim.Hparams);

dp = getdisplayprefs(Hstim);
dp = struct(dp);

StimWindowGlobals;
if ~haspsychtbox|isempty(StimWindowRefresh)|~isloaded(HSstim),
        t = Hparams.N / dp.fps + duration(sgs.stimulus);
else, % calculate more exact estimate based on refresh rate and display prefs
	N = 100;
        pauseRefresh = zeros(1,length(dp.frames));
        if dp.roundFrames,
            pauseRefresh(:) = round(StimWindowRefresh / dp.fps);
        else,
            pauseRefresh = diff(fix((1:(length(dp.frames)+1)) * StimWindowRefresh / dp.fps));
        end;
        t = sum(pauseRefresh)/StimWindowRefresh + duration(Hstim.stimulus);
end;

