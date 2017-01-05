function b=PCI6224Trig_StimTriggerOpen(dev)

StimTriggerGlobals;

b = 0;

A = isfield(dev.parameters,'daq');
B = 1;
if A,
	B = ~isempty(dev.parameters.daq);
end;

if ~A | ~B,
	for i=1:length(StimTriggerList),
		if eqlen(dev,StimTriggerList(i)),
			dev.parameters.daq = digitalio('nidaq','Dev2');
			dev.parameters.line1 = addline(dev.parameters.daq,0:7,'Out');
			dev.parameters.line2 = addline(dev.parameters.daq,8+[0:7],'Out');
			StimTriggerList(i) = dev;
			b = 1;
		end;
	end;
	if b,
		putvalue(dev.parameters.line1,0); % set all values to 0
		putvalue(dev.parameters.line2,0); % set all values to 0
	else,
		error(['Could not configure PCI6224Trig; could not locate DAQ device.']);
	end;
else, b = 1; % already initialized
end;

