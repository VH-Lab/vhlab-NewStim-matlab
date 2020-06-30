function ShowStimScreen

StimWindowGlobals
NewStimGlobals

if ~StimComputer, return; end;

if ~exist('StimWindowFlip','var'),  % relatively new setting
	StimWindowFlip = 0;
	StimWindowFlipHorizontal = 0;
	StimWindowFlipVertical = 0;
end;

  % check for an undefined window or a broken window and (re)open it in either case
A = isempty(StimWindow);
if ~A,
	try,
		r = Screen(StimWindow,'rect');
		A = isempty(r);
	catch,
		A = 1;
	end;
end; % now, A is 1 if we need to make a new window; 0 otherwise

if NS_PTBv>=3,
	Screen('Preference', 'EmulateOldPTB',0);
end;

if A,
	CloseStimScreen;
end;  % call anything that needs to be called if window is closed

if A,
	screens = Screen('Screens');
	if ~any(StimWindowMonitor==screens),
		error(['Available screens are ' ...
			mat2str(screens) ' but StimWindowMonitor is ' ...
			int2str(StimWindowMonitor) '.']);
	end;
	if NS_PTBv<3,
	        StimWindow = Screen(StimWindowMonitor,'OpenWindow',0);
		% ask for a certain pixel depth
		Screen(StimWindow,'PixelSize',8,1);
	else,	% we may not ask for a pixel depth, it just is what it is
		StimWindowPreviousCLUT = Screen('ReadNormalizedGammaTable',StimWindowMonitor);
		if StimWindowUseCLUTMapping&~isempty(which('PsychHelperCreateRemapCLUT')),
			PsychImaging('PrepareConfiguration');
			PsychImaging('AddTask', 'AllViews', 'EnableCLUTMapping');
			StimWindow = PsychImaging('OpenWindow', StimWindowMonitor, 128);
		elseif StimWindowFlip,
			PsychImaging('PrepareConfiguration');
			if StimWindowFlipHorizontal,
				PsychImaging('AddTask', 'AllViews', 'FlipHorizontal');
			end;
			if StimWindowFlipVertical,
				PsychImaging('AddTask', 'AllViews', 'FlipVertical');
			end;
			StimWindow = PsychImaging('OpenWindow', StimWindowMonitor, 128);
		else,
			StimWindow = Screen(StimWindowMonitor,'OpenWindow',128);
		end;
	end;
	StimWindowDepth = Screen(StimWindow,'PixelSize');
	StimWindowRect = Screen(StimWindow,'Rect');
	StimWindowRefresh = Screen(StimWindow,'FrameRate',[]);
	if StimWindowRefresh==0,
		StimWindowRefresh = 60;
	end; % fix for some LCDs
	Screen('BlendFunction',StimWindow,GL_SRC_ALPHA,GL_ONE_MINUS_SRC_ALPHA);
end;

