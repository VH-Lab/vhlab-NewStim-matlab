function NewStimInit;

cpustr = computer;

pwd = which('NewStimInit');

pi = find(pwd==filesep); pwd = [pwd(1:pi(end)-1) filesep];

addpath(pwd);
addpath([pwd 'Scripts']);
addpath([pwd 'NewStimProcs']);
addpath([pwd 'NewStimDisplayProcs']);
addpath([pwd 'NewStimServices']);
addpath([pwd 'NewStimUtilities']);
addpath([pwd 'NewStimUtilities' filesep 'NewStimConfigureInterviewHelpers']);
addpath([pwd 'NewStimServices' filesep 'StimScreen']);
addpath([pwd 'NewStimServices' filesep 'MonitorScreen']);
addpath([pwd 'NewStimServices' filesep 'GammaCorrectionTable']);
addpath([pwd 'NewStimServices' filesep 'StimTrigger']);
addpath([pwd 'NewStimServices' filesep 'FitzTrig']);
addpath([pwd 'NewStimServices' filesep 'PCI6224Trig']);
addpath([pwd 'NewStimServices' filesep 'PCI6224sTrig']);
addpath([pwd 'NewStimServices' filesep 'VHTrig']);
addpath([pwd 'NewStimServices' filesep 'PCI6224Trig']);
addpath([pwd 'NewStimServices' filesep 'StimSerial']);
addpath([pwd 'NewStimServices' filesep 'StimPCIDIO96']);
addpath([pwd 'NewStimServices' filesep 'StimScreenBlender']);
addpath([pwd 'NewStimEditor']);
addpath([pwd 'RemoteCommunication']);
addpath([pwd 'Stimuli']);
addpath([pwd 'Stimuli' filesep 'Display objs']);
addpath([pwd 'Stimuli' filesep 'CustomProcs']);
addpath([pwd 'NewStimTestProcs']);

eval(['NewStimGlobals;'])
NewStimStimList = {};
NewStimStimScriptList = {};

if ~isempty(which('NewStimConfiguration')),
	eval(['NewStimConfiguration;']);
end;

if isempty(which('NewStimConfiguration'))|~VerifyNewStimConfiguration, 
	vhlabtoolspath = fileparts(fileparts(fileparts(fileparts(pwd)))); % 4 levels up
	copyfile([pwd 'NewStimUtilities' filesep 'NewStimConfiguration_analysiscomputer.m'],...
		[vhlabtoolspath filesep 'configuration' filesep 'NewStimConfiguration.m']);
	warning(['No NewStimConfiguration.m file was detected;' ...
			' the program is now copying the default settings for a basic analysis computer. ' ...
			'If you need to use this computer to control stimulus computers, or if this itself ' ...
			'should be a stimulus computer, you will need to edit the file NewStimConfiguration.m ' ...
			'according to the instructions on the website.  If you want to use this computer for ' ...
			'analysis only, then no action is needed, you should be all set.']);
   warning(['Copying from ' pwd 'NewStimUtilities' filesep 'NewStimConfiguration_analysiscomputer.m' ' to ' [vhlabtoolspath filesep 'configuration' filesep 'NewStimConfiguration.m']]);
        copyfile([pwd 'NewStimUtilities' filesep 'NewStimConfiguration_analysiscomputer.m'],...
		[vhlabtoolspath filesep 'configuration' filesep 'NewStimConfiguration.m']);

        
        zz = which('NewStimConfiguration'); % force it to look again
	eval(['NewStimConfiguration;']);
end;

b = which('PsychtoolboxVersion');

if ~isempty(b),
    b = PsychtoolboxVersion;
    if isnumeric(b), NS_PTBv = b;
    else, NS_PTBv = eval(b(1)); end;
else,
    NS_PTBv = 0;
end;


if NS_PTBv,
	eval(['ShowStimScreen']);
	eval(['CloseStimScreen']);
end;

eval(['NewStimObjectInit']);

if isempty(NSMaxStimsPerStimScript),
    NSMaxStimsPerStimScript = 255;
end;

clear cpustr;
