function [MTI,startTrig] = DisplayStimScript(stimScript, MTI, priorit,abtable)
%
%  [MTI,STARTRIG] = DISPLAYSTIMSCRIPT (STIMSCRIPT, MTI, PRIORIT, ABORTABLE)
%
%  DisplayStimScript draws the stimScript to the screen, and gives the record of stimulus
%  presentation times in MTI.  The time of the first frame is given in STARTTRIG.  It
%  takes as arguments the STIMSCRIPT to be displayed, and also a precomputed MTI record.
%
%  If PRIORIT is specified and is not empty, drawing is run with that priority.
%  Otherwise, the priority is determined automatically.
%
%  If ABORTABLE is not given or is 1, then the script can be aborted by pressing any key
%  on the stimulus computer keyboard.  IF ABORTABLE is 0 the script is not abortable.  One may
%  want to run without the possibility of an abort to ensure the most reliable timing between
%  stimuli.
%
%  Bugs:  The system will hang if one tries to show a stimulus with clipping on the first
%  run after booting at max priority.  As a work-around, either first run a script without
%  any clipping or run the stimulus through one time at priority 0.
%  I do not know why this happens.
%
%  Sound sometimes has errors if it is not run at priority 0.


NewStimGlobals;
StimWindowGlobals;
StimTriggerOpen;

if nargin<2, MTI = DisplayTiming(stimScript); end;
	
if isempty(MTI), MTI = DisplayTiming(stimScript); end;

prioritylevel = MaxPriority(StimWindowMonitor,'WaitBlanking','SetClut','GetSecs'); % PD

if nargin>=3,
	if ~isempty(priorit),
		prioritylevel = priorit;
	else, % set priority level more carefully if sound is going to be played
		for i=1:length(MTI),
			if strcmp(MTI{i}.ds.displayType,'Sound'),prioritylevel=0; end;
		end;
	end;
end;

abortable = 1;

if nargin>=4, abortable = abtable; end;

numstims = numStims(stimScript);

if ~isloaded(stimScript), error(['Cannot display unloaded stimuli']); end;

 % now get ready to display

StimTriggerAct('Trigger_Initialize');

HideCursor;
ShowStimScreen;  % make sure screen is up

Screen('screens'); try, Snd('open'); snd('close'); end;  % warm up these functions, try to get them in memory

Screen(StimWindow,'WaitBlanking');
startTrig = StimTriggerAct('Script_Start_trigger');
Screen(StimWindow,'WaitBlanking');

NewStimCheckRushAndTrigger; 

i = 1;

l = length(MTI);

if ~abortable,

	
	if NewStimUseRushForDisplay==0,
		eval('for i=1:l, NewStimWaitTriggerIfNeeded(1); [MTI{i}.startStopTimes,ft] = DisplayStimulus(MTI{i},get(stimScript,MTI{i}.stimid)); MTI{i}.frameTimes = ft; end; Screen(StimWindow,''FillRect'',0);');
	else,
		Rush('for i=1:l, NewStimWaitTriggerIfNeeded(1); [MTI{i}.startStopTimes,ft] = DisplayStimulus(MTI{i},get(stimScript,MTI{i}.stimid)); MTI{i}.frameTimes = ft; end; Screen(StimWindow,''FillRect'',0);', prioritylevel);
	end;

else,
	if StimDisplayOrderRemote,
		abort = 0;
		while ~abort,
			[thetime,i] = StimTriggerAct('WaitActionCode');
			if i<1|i>numStims, error(['Requested stimulus ' int2str(i) ' out of range.']); end;
			if NewStimUseRushForDisplay==0,
				eval('DisplayStimulus(MTI{i});',prioritylevel);
			else,
				Rush('DisplayStimulus(MTI{i});',prioritylevel);
			end;
			abort = KbCheck;
		end;
	else,
		for i=1:l,
			if NewStimUseRushForDisplay==0,
				eval('NewStimWaitTriggerIfNeeded(1); [MTI{i}.startStopTimes,ft]=DisplayStimulus(MTI{i},get(stimScript,MTI{i}.stimid));MTI{i}.frameTimes=ft;');
			else,
				Rush('NewStimWaitTriggerIfNeeded(1); [MTI{i}.startStopTimes,ft]=DisplayStimulus(MTI{i},get(stimScript,MTI{i}.stimid));MTI{i}.frameTimes=ft;',prioritylevel);
			end;
			if KbCheck, break; end; % abort if keyboard press

			% print status
			if mod(i,20)==0,
				fprintf(['Just finished stim ' int2str(i) ' of ' int2str(l) '.\n']);
			end;
                        if mod(i,numstims)==0,
				fprintf(['Just finished trial ' int2str(i/numstims) ' of ' int2str(l/numstims) '.\n']);
			end;
		end;
		Screen(StimWindow,'FillRect',0);
	end;
end;

 % clean up

ShowCursor;
