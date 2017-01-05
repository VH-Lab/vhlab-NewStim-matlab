function [done,stamp,info]=blinkstim(info,StimScreen,dispstruct,dispprefs);
% BLINKSTIM - Custom drawing routine for the BLINKINGSTIM stimulus class
%
%  [DONE,STAMP,INFO_OUT] = BLINKSTIM(INFO,STIMSCREEN,DISPSTRUCT,DISPPREFS)
%
%  This is the 'CustomProc' draw routine for the BLINKINGSTIM stimulus class.
%  It is specified as the 'displayProc' in the DISPLAYSTRUCT record for the
%  stimulus, and 'displayType' should be set to 'custom'.
%  During normal drawing, this function is called by the routine DISPLAYSTIMULUS.
%
%  OUTPUTS:
%    DONE -       0/1 is the stimulus all done (finished)
%    STAMP -      0/1 should DISPLAYSTIMULUS record the time?
%    INFO_OUT -       whatever, it is passed again
%
%  INPUT - 
%      INFO should either be empty (if it is the first time the routine is
%          called for a given stimulus) or should be the previous output
%          INFO_OUT
%          if info not a structure, then it is just loading in memory
%      STIMSCREEN - The stimulus screen where drawing should occur
%      DISPSTRUCT - The display structure of the stimulus
%      DISPPREFS - The display prefs of the stimulus
% 
%  See also: BLINKINGSTIM


NewStimGlobals;
StimWindowGlobals;

done = 0; stamp = 0; 

if ~isstruct(info)&~isempty(info),
	dispstruct.userfield; % make sure we're in memory, don't do anything
elseif isempty(info),
	% this is our first run through, so set the color table
	if NS_PTBv<3,
		screen(StimScreen,'SetClut',dispstruct.clut);
	else,
		Screen('LoadNormalizedGammaTable',StimScreen,dispstruct.clut);
	end;
	Screen(StimScreen,'FillRect',0);

	% now set up our 'info' structure to pass back to the program next time
	rectshift = [dispprefs.rect(1) dispprefs.rect(2) ...
				dispprefs.rect(1) dispprefs.rect(2)];
	frameLength = dispstruct.userfield.frameLength - 1;
	if (frameLength<1), frameLength = 1; end;
	info=struct(...
		'frame',0,...
		'bgcount',0,...
		'rectshift',rectshift, ...
		'frameLength',frameLength,...
		'lastvbl',Screen('Flip',StimScreen),...
		'specifyDisplayTimeByFrames',dispstruct.userfield.specifyDisplayTimeByFrames);
	done=0;
	stamp=0;
else, % info has our info, start drawing frames

	% step 1: if necessary, clean up the mess from the last frame
	if info.frame>0&info.frame~=dispstruct.userfield.N,
		if NS_PTBv<3, % not necessary in PTB3
			Screen(StimScreen,'WaitBlanking',dispstruct.userfield.frameLength);
			Screen('CopyWindow',dispstruct.offscreen(2),StimScreen, ...
       		            dispstruct.userfield.rects(1,:), ...
       		            info.rectshift+dispstruct.userfield.rects( ...
       		                     dispstruct.userfield.blinkList(info.frame),:), ...
							'srcCopyQuickly');
		end;
	end;

	% step 2: make sure we aren't done; probably we never hit this condition but just in case

	if info.frame>dispstruct.userfield.N,
		done = 1;
		stamp=0;
		return;
	end;

	% step 3: draw the next frame
	if eqlen(info.bgcount,0) | (NS_PTBv==3), % draw the frame
		stamp = 1;
		if NS_PTBv<3,
			%    if PTB2, wait until waitblanking, do our drawing
			screen('CopyWindow',dispstruct.offscreen(1),StimScreen, ...
				dispstruct.userfield.rects(1,:), ...
				info.rectshift+dispstruct.userfield.rects( ...
				dispstruct.userfield.blinkList(info.frame+1),:), ...
				'srcCopyQuickly');
		else, % PTBv3
			%    if PTB3, do our drawing, flip the page at waitblanking
			if info.specifyDisplayTimeByFrames,
				if dispstruct.userfield.bgpause~=0,
					info.lastvbl = Screen('Flip',StimScreen,info.lastvbl+(dispstruct.userfield.frameLength-0.5)/StimWindowRefresh);
				end;
				if info.frame~=dispstruct.userfield.N, % draw next frame for all but when frame==N
					Screen('DrawTexture',StimScreen,dispstruct.offscreen(1),dispstruct.userfield.rects(1,:),...
						info.rectshift+dispstruct.userfield.rects(dispstruct.userfield.blinkList(info.frame+1),:));
				else,
					done = 1;
					stamp=0;
				end;
				info.lastvbl = Screen('Flip',StimScreen,info.lastvbl+(dispstruct.userfield.frameLength*(1+dispstruct.userfield.bgpause)-0.5)/StimWindowRefresh);
			else, % bgpause specifies frame on time and background pause
				% if we need to pause between data frames, do it
				mylastvbl = info.lastvbl;
				if info.frame>0 & dispstruct.userfield.bgpause(2)~=0, 
					mylastvbl = Screen('Flip',StimScreen,info.lastvbl+dispstruct.userfield.bgpause(1));
				end;
				% if we need to draw the next data frame, do it
				if info.frame~=dispstruct.userfield.N, % draw next frame for all but when frame==N
					Screen('DrawTexture',StimScreen,dispstruct.offscreen(1),dispstruct.userfield.rects(1,:),...
						info.rectshift+dispstruct.userfield.rects(dispstruct.userfield.blinkList(info.frame+1),:));
				else,
					done = 1;
					stamp=0;
				end;
				info.lastvbl = Screen('Flip',StimScreen,info.lastvbl+sum(dispstruct.userfield.bgpause));
			end;
		end;
		info.bgcount = dispstruct.userfield.bgpause;
		info.frame = info.frame + 1;
	else,
		info.bgcount = info.bgcount - 1;
	end;
end;  % handle non-empty info
