function NewStimInit;

NewStimPath = which('NewStimInit');

pi = find(NewStimPath==filesep);

NewStimPath = [NewStimPath(1:pi(end)) ];


eval(['NewStimGlobals;'])
NewStimStimList = {};
NewStimStimScriptList = {};

if ~isempty(which('NewStimConfiguration')),
	eval(['NewStimConfiguration;']);
end;

if isempty(which('NewStimConfiguration'))|~VerifyNewStimConfiguration, 
	configpath = config_dirname;
	copyfile([NewStimPath 'NewStimUtilities' filesep 'NewStimConfiguration_analysiscomputer.m'],...
		[configpath filesep 'NewStimConfiguration.m']);
	warning(['No NewStimConfiguration.m file was detected;' ...
			' the program is now copying the default settings for a basic analysis computer. ' ...
			'If you need to use this computer to control stimulus computers, or if this itself ' ...
			'should be a stimulus computer, you will need to edit the file NewStimConfiguration.m ' ...
			'according to the instructions on the website.  If you want to use this computer for ' ...
			'analysis only, then no action is needed, you should be all set.']);
	warning(['Copying from ' NewStimPath filesep 'NewStimUtilities' filesep 'NewStimConfiguration_analysiscomputer.m' ' to ' [configpath filesep 'configuration' filesep 'NewStimConfiguration.m']]);
	copyfile([NewStimPath 'NewStimUtilities' filesep 'NewStimConfiguration_analysiscomputer.m'],...
		[configpath filesep 'NewStimConfiguration.m']);

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

