function simulate_stimdio_easydaq(devname, command, varargin)
% SIMULTATE_STIMDIO_EASYDAQ - simulate NewStim trigger signals w/ EasyDaq device
%
%   SIMULATE_STIMDIO_EASYDAQ(DEVNAME, COMMAND)
%
%   Simulates the digital triggers that are run during a real experiment with
%   an EasyDAQ device. This is useful if a spare computer with an actual
%   triggering device is unavailable.
%
%   This sends system commands to the serial terminal device DEVNAME.
%   It is necessary to install the FTDI Virtual Com Port chipset drivers
%   for your OS (available for MacOS X and Linux).
%
%   COMMAND:             | Description
%   -------------------------------------------------------------
%   'ConfigureForWriting'  | Configure all channels for writing
%   'Write1-8'             | Write a number to channels 1-8. This requires
%                          |   an additional input argument NUMBER, which specifies
%                          |   the number to be written.
%   'Write9-16'            | Write a number to channels 9-16. This requires
%                          |   an additional input argument NUMBER, which specifies
%                          |   the number to be written.
%   'Write17-24'           | Write a number to channels 17-24. This requires
%                          |   an additional input argument NUMBER, which specifies
%                          |   the number to be written.
%   'SimulateStimScript'   | Simulate a stimscript that runs in order from 1 to NUMBER
%                          |   where NUMBER is provided as an additional input argument.
%                          |   The stimuli last appxoximately (but not exactly) 5 seconds.
%                          |   Channel 1 is the StimTrigger, Channel 2 is the PreStimTrigger,
%                          |   which is activated 0.5 seconds before the StimTrigger.
%                          |   The StimID is coded in bits 9-16. The stim duration is 2 seconds.
%
%
%   Example (assuming your device is at /dev/cu.usbserial-0000203A):
%   simulate_stimdio_easydaq('/dev/cu.usbserial-0000203A','ConfigureForWriting');
%   simulate_stimdio_easydaq('/dev/cu.usbserial-0000203A','Write1-8', 3);
%

switch command,
	case 'ConfigureForWriting',
		[status,result]=system(['echo -e "B\x00" > ' devname]); % bits 1-8
		[status,result]=system(['echo -e "D\x00" > ' devname]); % bits 9-16
		[status,result]=system(['echo -e "H\x00" > ' devname]); % bits 17-24
	case 'Write1-8',
		system(['echo -e "C\x' dec2hex(varargin{1},2) '" > ' devname]);
	case 'Write9-16',
		system(['echo -e "F\x' dec2hex(varargin{1},2) '" > ' devname]);
	case 'Write17-24',
		system(['echo -e "J\x' dec2hex(varargin{1},2) '" > ' devname]);

	case 'SimulateStimScript',
		simulate_stimdio_easydaq(devname,'ConfigureForWriting');
		stim_ids = 1:varargin{1}; 
		isi = 5;
		prestimperiod = 0.5;
		stimduration = 2;
		stimonset = 0;

		simulate_stimdio_easydaq(devname,'Write1-8',1-stimonset);

		for i=1:length(stim_ids),
			pause(isi);
			% write prestim
			simulate_stimdio_easydaq(devname,'Write9-16',stim_ids(i));
			simulate_stimdio_easydaq(devname,'Write1-8',[4]+(1-stimonset)); % pretrigger
			pause(0.5);
			simulate_stimdio_easydaq(devname,'Write1-8',stimonset);
			pause(stimduration);
			simulate_stimdio_easydaq(devname,'Write1-8',1-stimonset);
		end;
end;
