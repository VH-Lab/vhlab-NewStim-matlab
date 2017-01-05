function PCI6224Trig_StimTriggerReset

% PCI6224TRIG_STIMTRIGGERRESET - Call this function to reset PCI6224 trigger devices and force them to reopen

StimTriggerGlobals;

for i=1:length(StimTriggerList),
	if strcmp(StimTriggerList(i).TriggerType,'PCI6224Trig')
		pause(2); % this resets the device
		if isfield(StimTriggerList(i).parameters,'daq'),
			StimTriggerList(i).parameters = rmfield(StimTriggerList(i).parameters,'daq');
			try, StimTriggerList(i).parameters = rmfield(StimTriggerList(i).parameters,'line1'); end;
			try, StimTriggerList(i).parameters = rmfield(StimTriggerList(i).parameters,'line2'); end;
		end;
		PCI6224Trig_StimTriggerOpen(StimTriggerList(i));
	end;
end;
