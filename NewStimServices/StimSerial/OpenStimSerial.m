StimSerialGlobals;

if StimSerialSerialPort,

	if isempty(StimSerialScript),
		StimSerialScript=serial('Open',StimSerialScriptIn,StimSerialScriptOut,9600);
	end;

	if isempty(StimSerialStim),
		if strcmp(StimSerialScriptIn,StimSerialStimIn)&...
			strcmp(StimSerialScriptOut,StimSerialStimOut),
				StimSerialStim = StimSerialScript;
		else,
			StimSerialStim=serial('Open',StimSerialStimIn,StimSerialStimOut,9600);
		end;
	end;
end;
