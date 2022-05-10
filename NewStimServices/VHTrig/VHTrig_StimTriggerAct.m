function [thetime,thecode]=VHTrig_StimTriggerAct(myDev,theaction,code,code2)

% VHTrig_STIMTRIGGERACTION Performs triggering action on Mac OSX with USB-1208FS
%
%  Performs triggering action for Van Hooser lab, Mac OS X with USB-1208FS
%
%    Port 0 is stimid, 0..255
%    Port 1 is stimtrigger (low bit, probably channel 30),
%              frame trigger (channel 31)
%              pre-time trigger (channel 32)
%

daq = myDev.parameters.daq;
thetime = []; thecode = [];

if isfield(myDev.parameters,'STIM_ONSET_HIGH'),
	stimonset = myDev.parameters.STIM_ONSET_HIGH;
else,
	stimonset = 0;
end;

switch theaction,
	case 'Stim_beforeframe_trigger',
		DaqDOut(daq,1,0+stimonset);
	case 'Stim_afterframe_trigger',
		DaqDOut(daq,1,2+stimonset);
	case 'Stim_ONSET_trigger',
		DaqDOut(daq,1,stimonset);
	case 'Stim_BGpre_trigger',
		DaqDOut(daq,0,code);
		DaqDOut(daq,1,4+(1-stimonset));  % the 4 sets the intrinsic trigger high
	case 'Stim_BGpost_trigger',
		DaqDOut(daq,1,1-stimonset);
	case 'Stim_OFFSET_trigger',
		DaqDOut(daq,1,1-stimonset);
		DaqDOut(daq,0,0); % don't edit the stimulus number until AFTER the stim trigger is set or Micro1401 might get confused
	case 'Script_Start_trigger',
		DaqDOut(daq,1,1-stimonset);
		DaqDOut(daq,0,0);
	case 'Script_Stop_trigger',
	case 'Trigger_Initialize',
		DaqDOut(daq,1,1-stimonset);
		DaqDOut(daq,0,0);
	case 'Pin35On',
		DaqDOut(daq,1,8); % turns on Pin 35 and all other pins on port 1 are 0
	case 'Pin35Off',
		DaqDOut(daq,1,0); % turns off Pin 35 and all other pins on port 1 are 0
	case 'WaitLowHigh', % waits for a low to high transition on B, bit 3 (pin 34)
		t0 = GetSecs;
		v=DaqDIn(daq,2);
		while (bitget(v(2),3)<1 & (GetSecs-t0)<code),
			v=DaqDIn(daq,2),
		end;
		thetime = GetSecs;
		thecode = bitget(v(2),3);
	case 'WaitHighLow', % waits for a high to low transition on port B, bit 3 (pin 34 overall)
		t0 = GetSecs;
		v=DaqDIn(daq,2);
		while (bitget(v(2),3)>0 & (GetSecs-t0)<code),
			v=DaqDIn(daq,2);
		end;
		thetime = GetSecs;
		thecode = ~bitget(v(2),3);
    	case 'WaitActionCode',
		 [thetime_1,thecode_1]=VHTrig_StimTriggerAct(myDev,'WaitHighLow');
		if thecode, % it's good, strobe the other pin
			thetime = GetSecs;
			thecode = DaqDIn(daq,2);
			thecode = thecode(1); % get the stimid
		end;
	otherwise,
end;

thetime = GetSecs;

function DaqDOut(daq,port,code)
PsychHID('SetReport',daq,2,4,uint8([0 port code]));
