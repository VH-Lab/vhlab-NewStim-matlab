function [MTI,MTI2]=NSLoadAndRunTest(stimclass)
% NSLOADANDRUNTEST - Run a test stimulus for the NewStim library
%
%  [MTI,MTI2] = NSLOADANDRUNTEST(STIMCLASS)
%
%  Loads and runs a test stimulus using the NewStim environment
%
%  Inputs:
%    STIMCLASS - Either a STIMULUS object, a STIMSCRIPT object
%                   or a string containing the classname to run.
%                If the value is a STIMULUS object, then a STIMSCRIPT
%                   is created with the STIMULUS as its only stimulus
%                   element and the script is loaded and run.
%                If the value is a STIMSCRIPT object, then that
%                   STIMSCRIPT is loaded and run.
%                If the value is a string, then the user is prompted
%                   to graphically input the parameters for a stimulus
%                   of that type, and it is added to a single element 
%                   STIMSCRIPT, loaded and run.
%
%  Outputs:
%    MTI         The "Measured Timing Info" computed before the stim is run
%    MTI2        The "Measured Timing Info" computed during stimulus presentation
%
%
%  See also: STIMULUS, STIMSCRIPT

NewStimGlobals;
StimWindowGlobals;

global MTItest;

if NS_PTBv==3,
	currLut = Screen('ReadNormalizedGammaTable', StimWindowMonitor);
	mypriority = 9;
	if ispc, mypriority = 1; end;
else,
	mypriority = 1;
end;

success = 0;

try,
	% get our stim lists
	
	if isa(stimclass,'stimscript'),
		myscript = stimclass;
	elseif isa(stimclass,'stimulus'),
		myscript = append(stimscript(0),stimclass);
	else,
		mystim = NSGetTestStim(stimclass);
		if iscell(mystim)|isa(mystim,'stimulus'),
			myscript = stimscript(0);
			if iscell(mystim),
				for i=1:length(mystim), myscript = append(myscript,mystim{i}); end;
			else, myscript = append(myscript,mystim);
			end;
		else,
			myscript = mystim;
		end;
	end;

	ShowStimScreen;
	disp('Got past ShowStimScreen');
	myscript = loadStimScript(myscript);
	disp('Got past loading');
	MTI = DisplayTiming(myscript);
	disp('Got past DisplayTiming');
	MTItest = MTI;
	tic,
	[MTI2,start] = DisplayStimScript(myscript,MTI,mypriority,1);
	toc,
	myscript = unloadStimScript(myscript);
    
    % one more time
    if 0,
	disp('Got past ShowStimScreen');
	myscript = loadStimScript(myscript);
	disp('Got past loading');
	MTI = DisplayTiming(myscript);
	disp('Got past DisplayTiming');
	tic,
	[MTI2,start] = DisplayStimScript(myscript,MTI,mypriority,1);
	toc,
	myscript = unloadStimScript(myscript);    
    end; % if 0
    
	CloseStimScreen;
	success = 1;
catch,
	disp([lasterr]);
	CloseStimScreen;
	Screen('CloseAll');
	Screen('CloseAll');
end;

if NS_PTBv==3, Screen('LoadNormalizedGammaTable', StimWindowMonitor, currLut); end;

if success,
	StimWindowGlobals;
	figure;
	plot(diff(MTI2{1}.frameTimes));
	hold on;
	plot(1:length(MTI2{1}.frameTimes)-1,ones(1,length(MTI2{1}.frameTimes)-1)*mean(diff(MTI2{1}.frameTimes))+1/StimWindowRefresh,'g--');
	plot(1:length(MTI2{1}.frameTimes)-1,ones(1,length(MTI2{1}.frameTimes)-1)*mean(diff(MTI2{1}.frameTimes))-1/StimWindowRefresh,'g--');

end;
