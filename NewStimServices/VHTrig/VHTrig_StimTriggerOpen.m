function b=VHTrig_StimTriggerOpen(dev)

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
			dev.parameters.daq = DaqDeviceIndex([],0);
			StimTriggerList(i) = dev;
			b = 1;
		end;
	end;
	if b,
		c = isfield(dev.parameters,'output');
		if c,
			output = dev.parameters.output;
		else,
			output = 0;
		end;

		if ~output,
			DaqDConfigPort(dev.parameters.daq,0,0); % initialize port 0 for digital output
			DaqDConfigPort(dev.parameters.daq,1,0); % initialize port 1 for digital output
			DaqDOut(dev.parameters.daq,0,0); % set all values to 0
			DaqDOut(dev.parameters.daq,1,0); % set all values to 0
		else,
			DaqDConfigPort(dev.parameters.daq,0,1); % initialize port 0 for digital output
			DaqDConfigPort(dev.parameters.daq,1,1); % initialize port 1 for digital output
		end;
	else,
		error(['Could not configure VHTrig; could not locate DAQ device.']);
	end;
else, b = 1; % already initialized
end;

