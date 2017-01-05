StimSerialGlobals

if StimSerialSerialPort,

	if ~isempty(StimSerialScript)&~isempty(StimSerialStim),
		if StimSerialScript==StimSerialStim,
			serial('close',StimSerialScript);
			StimSerialScript=[];StimSerialStim=[];
		end;
	end;

	if ~isempty(StimSerialScript),
		serial('close',StimSerialScript); StimSerialScript=[];
	end;

	if ~isempty(StimSerialStim),
	    serial('close',StimSerialStim); StimSerialStim=[];
	end;

end;
