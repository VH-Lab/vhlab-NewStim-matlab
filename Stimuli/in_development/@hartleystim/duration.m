function t = duration(Hstim)

Hparams = struct(Hstim.Hparams);

StimWindowGlobals;
if ~haspsychtbox|isempty(StimWindowRefresh)|~isloaded(HSstim),
	t = (PSparams.nCycles*(loops+1)) / PSparams.tFrequency + duration(PSstim.stimulus);
else, % calculate exactly
    df = struct(getdisplayprefs(PSstim));
	pauseRefresh = zeros(1,length(df.frames));
    if df.roundFrames,
          pauseRefresh(:) = round(StimWindowRefresh / df.fps);
    else,
          pauseRefresh = diff(fix((1:(length(df.frames)+1)) * StimWindowRefresh / df.fps));
    end;
	t = sum(pauseRefresh)/StimWindowRefresh + duration(PSstim.stimulus);
end;
