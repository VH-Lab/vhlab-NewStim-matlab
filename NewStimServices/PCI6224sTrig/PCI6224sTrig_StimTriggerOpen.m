function b=PCI6224sTrig_StimTriggerOpen(dev)

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
			dev.parameters.daq = daq.createSession('ni');
			dev.parameters.daq.addDigitalChannel('Dev2','Port0/Line0:7','OutputOnly')
			dev.parameters.daq.addDigitalChannel('Dev2','Port1/Line0:7','OutputOnly')
			StimTriggerList(i) = dev;
			b = 1;
		end;
	end;
	if b,
		dev.parameters.daq.outputSingleScan(decimalToBinaryVector(0,16));
			% set all values to 0
	else,
		error(['Could not configure PCI6224sTrig; could not locate DAQ device.']);
	end;
else, b = 1; % already initialized
end;

