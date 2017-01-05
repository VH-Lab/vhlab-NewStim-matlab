function [thetime,thecode]=PCI6224sTrig_StimTriggerAct(myDev,theaction,code,code2)

% PCI6224sTrig_STIMTRIGGERACTION Performs triggering action on PC with PCI6224
%
%  Performs triggering action for Van Hooser lab, PC with PCI6224, using DAQ Sessions
%
%    Port 1 is stimid, 0..255
%    Port 0 is stimtrigger (low bit, probably channel 30),
%              frame trigger (channel 31)
%              pre-time trigger (channel 32)
%

daq = myDev.parameters.daq;
thetime = []; thecode = [];

switch theaction,
	case 'Stim_beforeframe_trigger',
		%DaqDOut(daq,1,0);
		%putvalue(line2,0);
		daq.outputSingleScan([decimal2BinaryVector([0],8,'LSBFirst') decimal2BinaryVector([0],8,'LSBFirst')]);
	case 'Stim_afterframe_trigger',
		%DaqDOut(daq,1,2);
		daq.outputSingleScan([decimal2BinaryVector([2],8,'LSBFirst') decimal2BinaryVector([0],8,'LSBFirst')]);
		%putvalue(line2,2);
	case 'Stim_ONSET_trigger',
		%DaqDOut(daq,1,0);
		daq.outputSingleScan([decimal2BinaryVector([0],8,'LSBFirst') decimal2BinaryVector([0],8,'LSBFirst')]);
		%putvalue(line2,0);
	case 'Stim_BGpre_trigger',
		%DaqDOut(daq,0,code);
		%DaqDOut(daq,1,4+1);  % the 4 sets the intrinsic trigger high
		%putvalue(line1,code);
		%putvalue(line2,4+1);  % the 4 sets the intrinsic trigger high
		daq.outputSingleScan([decimal2BinaryVector([4+1],8,'LSBFirst') decimal2BinaryVector([code],8,'LSBFirst')]);
	case 'Stim_BGpost_trigger',
		%DaqDOut(daq,1,1);
		%putvalue(line2,1);
		daq.outputSingleScan([decimal2BinaryVector([1],8,'LSBFirst') decimal2BinaryVector([0],8,'LSBFirst')]);
	case 'Stim_OFFSET_trigger',
		%DaqDOut(daq,0,0);
		%DaqDOut(daq,1,1);
		%putvalue(line1,0);
		%putvalue(line2,1);
		daq.outputSingleScan([decimal2BinaryVector([1],8,'LSBFirst') decimal2BinaryVector([0],8,'LSBFirst')]);
	case 'Script_Start_trigger',
		%DaqDOut(daq,1,1);
		%DaqDOut(daq,0,0);
		%putvalue(line2,1);
		%putvalue(line1,0);
		daq.outputSingleScan([decimal2BinaryVector([1],8,'LSBFirst') decimal2BinaryVector([0],8,'LSBFirst')]);
	case 'Script_Stop_trigger',
	case 'Trigger_Initialize',
		%DaqDOut(daq,1,1);
		%DaqDOut(daq,0,0);
		%putvalue(line2,1);
		%putvalue(line1,0);
		daq.outputSingleScan([decimal2BinaryVector([1],8,'LSBFirst') decimal2BinaryVector([0],8,'LSBFirst')]);
    case 'Pin35On',
        %DaqDOut(daq,1,8,'LSBFirst'); % turns on Pin 35 and all other pins on port 1 are 0
        %putvalue(line2,8,'LSBFirst'); % turns on Pin 35 and all other pins on port 1 are 0
	daq.outputSingleScan([decimal2BinaryVector([8],8,'LSBFirst') decimal2BinaryVector([0],8,'LSBFirst')]);
    case 'Pin35Off',
        %DaqDOut(daq,1,0); % turns off Pin 35 and all other pins on port 1 are 0
        %putvalue(line1,0); % turns off Pin 35 and all other pins on port 1 are 0
	%daq.outputSingleScan([decimal2BinaryVector([1],8,'LSBFirst') decimal2BinaryVector([0],8,'LSBFirst')]);
	daq.outputSingleScan([decimal2BinaryVector([0],8,'LSBFirst') decimal2BinaryVector([0],8,'LSBFirst')]);
    case 'WaitActionCode',
	otherwise,
end;

thetime = GetSecs;

%function DaqDOut(daq,port,code)
%PsychHID('SetReport',daq,2,4,uint8([0 port code]));
