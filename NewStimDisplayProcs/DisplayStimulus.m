function [startStopTimes,frameTimes] = DisplayStimulus(MTI, thestim)


% DISPLAYSTIMULUS
%
%   [startStopTimes,frameTimes] = DISPLAYSTIMULUS(MTI, STIM)
%
%  Displays a stimulus STIM using data in the Measured Timing Index variable MTI.  Returns
%  timestamp entries startStopTimes and frameTimes.

if nargin<2, stim = []; else, stim = thestim; end;

StimWindowGlobals;
NewStimGlobals;

 % fill variables for speed, if it matters
startStopTimes = MTI.startStopTimes;
frameTimes = MTI.frameTimes;

if NS_PTBv<3,
	Screen(StimWindow,'FillRect',0);
else,
	ngt = Screen('ReadNormalizedGammaTable',StimWindow);
	if ~eqlen(ngt,StimWindowPreviousCLUT),
		Screen('LoadNormalizedGammaTable', StimWindow, StimWindowPreviousCLUT,1); % set background colors 
	end;
	Screen('FillRect',StimWindow,round(255*MTI.ds.clut_bg(1,:))); % fill back buffer with background color
	Screen('Flip',StimWindow,0,1,2); % Flip buffers
	Screen('Flip',StimWindow,0,0,2); % clear 2nd buffer on next refresh
	WaitSecs(0.02);
end;

masktexture = -1;

if MTI.ds.makeClip, % make a clipping region
	if NS_PTBv<3,  %use clipping region, can call routine directly
		Screen(StimWindow,'SetDrawingRegion',MTI.ds.clipRect,MTI.ds.makeClip-1);
	else, % make a clipping region or use the one provided
	        if MTI.ds.makeClip==4|MTI.ds.makeClip==5, 
			masktexture = MTI.ds.clipRect;
	        end;
	end;
end;

if strcmp(MTI.ds.displayType,'Sound'), Snd('Open'); end;

if MTI.preBGframes>0,
	if NS_PTBv<3,
		Screen(StimWindow,'SetClut',MTI.ds.clut_bg); % also does waitblanking
		startStopTimes(1) = StimTriggerAct('Stim_BGpre_trigger',MTI.stimid);
		Screen(StimWindow,'WaitBlanking',MTI.preBGframes);
	else,
		vbl = Screen('Flip', StimWindow, 0, 0);
		startStopTimes(1) = StimTriggerAct('Stim_BGpre_trigger',MTI.stimid);
		Screen(StimWindow,'FillRect',round(255*MTI.ds.clut_bg(1,:,:))); % make sure background is in 2nd buffer
		Screen('Flip', StimWindow, vbl + (MTI.preBGframes-0.5)/StimWindowRefresh);
	end;
else,
	startStopTimes(1) = StimTriggerAct('Stim_BGpre_trigger',MTI.stimid);
	Screen('FillRect',StimWindow,round(255*MTI.ds.clut_bg(1,:,:)));
	%if NS_PTBv>=3&strcmp(MTI.ds.displayType,'Movie')&strcmp(MTI.ds.displayProc,'standard'),
		%Screen('LoadNormalizedGammaTable',StimWindow,StimWindowPreviousCLUT,1);       
		%Screen('FillRect',StimWindow,round(255*MTI.ds.clut_bg(1,:,:)));
		%Screen('Flip',StimWindow,0); % need to flip beccause LoadNormalizedGammaTable needs a frame to rest apparently
	%end;
end;

if strcmp(MTI.ds.displayType,'CLUTanim')&strcmp(MTI.ds.displayProc,'standard'),
	s0 = GetSecs();
	startStopTimes(2) = StimTriggerAct('Stim_ONSET_trigger',MTI.stimid);
	rect = Screen(MTI.ds.offscreen(1),'Rect');
	if NS_PTBv<3,
		Screen('CopyWindow',MTI.ds.offscreen(1),StimWindow,rect,MTI.df.rect,'srcCopy');
		Screen(StimWindow, 'SetClut', MTI.ds.clut{MTI.df.frames(1)}); % does waitblanking
		frameTimes(1) = StimTriggerAct('Stim_afterframe_trigger',MTI.stimid,1);
		for frameNum=2:length(MTI.df.frames),
			Screen(StimWindow,'WaitBlanking',MTI.pauseRefresh(frameNum-1));
			StimTriggerAct('Stim_beforeframe_trigger',MTI.stimid,frameNum);
			Screen(StimWindow,'SetClut',MTI.ds.clut{MTI.df.frames(frameNum)});
			frameTimes(frameNum) = StimTriggerAct('Stim_afterframe_trigger',MTI.stimid,frameNum);
		end;
		Screen(StimWindow,'WaitBlanking',MTI.pauseRefresh(end));
	else,
		Screen('DrawTexture',StimWindow,MTI.ds.offscreen(1),rect,MTI.df.rect);
		% mask if necessary
		%if MTI.ds.makeClip==4, Screen('DrawTexture',StimWindow,masktexture); elseif MTI.ds.makeClip==5, Screen('DrawTexture',StimWindow,masktexture,[],MTI.df.rect); end;
	        Screen('LoadNormalizedGammaTable',StimWindow, MTI.ds.clut{MTI.df.frames(1)},1);
		vbl=Screen('Flip',StimWindow,0,2); % waits for waitblanking, does not clear buffer
		frameTimes(1) = StimTriggerAct('Stim_afterframe_trigger',MTI.stimid,1);
		Screen(StimWindow,'FillRect',0); % paint background color in the 2nd buffer
		Screen('DrawTexture',StimWindow,MTI.ds.offscreen(1),rect,MTI.df.rect); % draw in the 2nd buffer
		%if MTI.ds.makeClip==4, Screen('DrawTexture',StimWindow,masktexture); elseif MTI.ds.makeClip==5, Screen('DrawTexture',StimWindow,masktexture,[],MTI.df.rect); end;
		StimTriggerAct('Stim_beforeframe_trigger',MTI.stimid,1);
		for frameNum=2:length(MTI.df.frames),
			% this should really be measured from each interval for most accurate "local" display
			Screen('LoadNormalizedGammaTable',StimWindow, MTI.ds.clut{MTI.df.frames(frameNum)},1);			
			vbl=Screen('Flip',StimWindow,vbl+(MTI.pauseRefresh(frameNum-1)+0.5)/StimWindowRefresh,2);            
			%Screen('Flip',StimWindow,vbl+(sum(1+MTI.pauseRefresh(1:frameNum-1))-0.5)/StimWindowRefresh,2);
			frameTimes(frameNum)=StimTriggerAct('Stim_afterframe_trigger',MTI.stimid,frameNum);
			StimTriggerAct('Stim_beforeframe_trigger',MTI.stimid,frameNum);
		end;
		Screen('Flip',StimWindow,vbl+(MTI.pauseRefresh(end)+0.5)/StimWindowRefresh); % the +0.5 is here because these pause times for CLUTanims can range from -1 due to backward compatibility
    end;

elseif strcmp(MTI.ds.displayType,'Movie')&strcmp(MTI.ds.displayProc,'standard'),
	startStopTimes(2) = StimTriggerAct('Stim_ONSET_trigger',MTI.stimid);
	if NS_PTBv<3,
		Screen(StimWindow,'SetClut',MTI.ds.clut); % does waitblanking
		Screen('CopyWindow',MTI.ds.offscreen(MTI.df.frames(1)),StimWindow,MTI.MovieParams.Movie_sourcerect(1,:), MTI.df.rect,'srcCopyQuickly');
		frameTimes(1) = StimTriggerAct('Stim_afterframe_trigger',MTI.stimid,1);
		for frameNum=2:length(MTI.df.frames);
			Screen(StimWindow,'WaitBlanking',MTI.pauseRefresh(frameNum-1));
			StimTriggerAct('Stim_beforeframe_trigger',MTI.stimid,frameNum);
			rectnum = 1+mod(MTI.df.frames(frameNum),length(MTI.ds.offscreen));
			Screen('CopyWindow',MTI.ds.offscreen(MTI.df.frames(frameNum)),StimWindow,MTI.MovieParams.Movie_sourcerect(frameNum,:), MTI.df.rect,'srcCopyQuickly');
			frameTimes(frameNum) = StimTriggerAct('Stim_afterframe_trigger',MTI.stimid,frameNum);
		end;
		Screen(StimWindow,'WaitBlanking',MTI.pauseRefresh(end));
	else,
		%Screen('LoadNormalizedGammaTable',StimWindow,MTI.ds.clut,1); % this seems to be no longer necessary or correct, the textures already have colors
		%Screen('LoadNormalizedGammaTable',StimWindow,StimWindowPreviousCLU
		%T,1);  % this has already been done above
		%Screen('FillRect',StimWindow,round(255*MTI.ds.clut(1,:,:)));
		frameNum = 1;
		textures = MTI.MovieParams.Movie_textures{frameNum};
		Screen('DrawTextures',StimWindow,MTI.ds.offscreen(textures),squeeze(MTI.MovieParams.Movie_sourcerects(:,frameNum,textures)),squeeze(MTI.MovieParams.Movie_destrects(:,frameNum,textures)),...
				squeeze(MTI.MovieParams.Movie_angles(:,frameNum,textures)),MTI.MovieParams.Movie_filters(frameNum),squeeze(MTI.MovieParams.Movie_globalalphas(:,frameNum,textures)));
		if StimWindowUseCLUTMapping, Screen('LoadNormalizedGammaTable',StimWindow,linspace(0,1,256)' * ones(1,3),1); end;
		vbl = Screen('Flip',StimWindow,0);
		frameTimes(1) = StimTriggerAct('Stim_afterframe_trigger',MTI.stimid,1);
		%Screen('FillRect',StimWindow,255*MTI.ds.clut(1,:,:)); % fill the other buffer with background -- seems to be unnecessary
		StimTriggerAct('Stim_beforeframe_trigger',MTI.stimid,1);
		for frameNum=2:length(MTI.df.frames);
			textures = MTI.MovieParams.Movie_textures{frameNum};
			Screen('DrawTextures',StimWindow,MTI.ds.offscreen(textures),squeeze(MTI.MovieParams.Movie_sourcerects(:,frameNum,textures)),squeeze(MTI.MovieParams.Movie_destrects(:,frameNum,textures)),...
					squeeze(MTI.MovieParams.Movie_angles(:,frameNum,textures)),MTI.MovieParams.Movie_filters(frameNum),squeeze(MTI.MovieParams.Movie_globalalphas(:,frameNum,textures)));
			if StimWindowUseCLUTMapping, Screen('LoadNormalizedGammaTable',StimWindow,linspace(0,1,256)' * ones(1,3),1); end;
			vbl=Screen('Flip',StimWindow,vbl+(MTI.pauseRefresh(frameNum-1)-0.5)/StimWindowRefresh);
			frameTimes(frameNum) = StimTriggerAct('Stim_afterframe_trigger',MTI.stimid,frameNum);
			WaitSecs(1/10000);
			StimTriggerAct('Stim_beforeframe_trigger',MTI.stimid,frameNum);
		end;
		if StimWindowUseCLUTMapping, Screen('LoadNormalizedGammaTable',StimWindow,linspace(0,1,256)' * ones(1,3),1); end;
		Screen('Flip',StimWindow,vbl+(MTI.pauseRefresh(end)-0.5)/StimWindowRefresh);
        end;
elseif strcmp(lower(MTI.ds.displayType),'multimovie')&strcmp(MTI.ds.displayProc,'standard'),
	% only PTB3 and up
	% show frame 1
	frameNum = 1;
	numMultiMovies = length(MTI.MovieParams.Movie_textures);
	m = 1;
	for m=1:numMultiMovies, % this will be the number of multi-stims to show
		textures = MTI.MovieParams.Movie_textures{m}{frameNum};
		Screen('DrawTextures',StimWindow,MTI.ds.offscreen{m}(textures),squeeze(MTI.MovieParams.Movie_sourcerects{m}(:,frameNum,textures)),squeeze(MTI.MovieParams.Movie_destrects{m}(:,frameNum,textures)),...
			squeeze(MTI.MovieParams.Movie_angles{m}(:,frameNum,textures)),1,squeeze(MTI.MovieParams.Movie_globalalphas{m}(:,frameNum,textures)));
		if m==numMultiMovies, if StimWindowUseCLUTMapping, Screen('LoadNormalizedGammaTable',StimWindow,linspace(0,1,256)' * ones(1,3),1); end; end;
	end; % drawing of frame 1 is finished, flip the screen and trigger the frame
	vbl = Screen('Flip',StimWindow,0);
	frameTimes(1) = StimTriggerAct('Stim_afterframe_trigger',MTI.stimid,1);
	StimTriggerAct('Stim_beforeframe_trigger',MTI.stimid,1);
	% show frames 2 - end
	for frameNum=2:length(MTI.df.frames);
		for m=1:numMultiMovies,
			textures = MTI.MovieParams.Movie_textures{m}{frameNum};
			Screen('DrawTextures',StimWindow,MTI.ds.offscreen{m}(textures),squeeze(MTI.MovieParams.Movie_sourcerects{m}(:,frameNum,textures)),squeeze(MTI.MovieParams.Movie_destrects{m}(:,frameNum,textures)),...
				squeeze(MTI.MovieParams.Movie_angles{m}(:,frameNum,textures)),1,squeeze(MTI.MovieParams.Movie_globalalphas{m}(:,frameNum,textures)));
			if (m==numMultiMovies), if StimWindowUseCLUTMapping, Screen('LoadNormalizedGammaTable',StimWindow,linspace(0,1,256)' * ones(1,3),1); end; end;
		end; % done drawing stims, now flip and trigger
		vbl=Screen('Flip',StimWindow,vbl+(MTI.pauseRefresh(frameNum-1)-0.5)/StimWindowRefresh);
		frameTimes(frameNum) = StimTriggerAct('Stim_afterframe_trigger',MTI.stimid,frameNum);
		WaitSecs(1/10000);
		StimTriggerAct('Stim_beforeframe_trigger',MTI.stimid,frameNum);
	end;
	if StimWindowUseCLUTMapping, Screen('LoadNormalizedGammaTable',StimWindow,linspace(0,1,256)' * ones(1,3),1); end;
	Screen('Flip',StimWindow,vbl+(MTI.pauseRefresh(end)-0.5)/StimWindowRefresh);
elseif strcmp(MTI.ds.displayType,'custom'),
	done=0; stamp=0; info=[]; stampNum=1;
	startStopTimes(2) = StimTriggerAct('Stim_ONSET_trigger',MTI.stimid);
	while(done==0),
		eval(['[done,stamp,info]=' MTI.ds.displayProc '(info,StimWindow,MTI.ds,MTI.df);']);
		if stamp==1, % make a time stamp
			frameTimes(stampNum) = StimTriggerAct('Stim_afterframe_trigger',MTI.stimid,stampNum);
			stampNum = stampNum + 1;
			StimTriggerAct('Stim_beforeframe_trigger',MTI.stimid,stampNum);
		end;
	end;

elseif strcmp(MTI.ds.displayProc,'customdraw'), % calls the stim's 'customdraw' function
	done=0; stamp=0; info=[]; stampNum=1;
	startStopTimes(2) = StimTriggerAct('Stim_ONSET_trigger',MTI.stimid);
	while(done==0),
		eval(['[done,stamp,info]=customdraw(stim,info,MTI);']);
		if stamp==1, % make a time stamp
			frameTimes(stampNum) = StimTriggerAct('Stim_afterframe_trigger',MTI.stimid,stampNum);
			stampNum = stampNum + 1;
			StimTriggerAct('Stim_beforeframe_trigger',MTI.stimid,stampNum);
		end;
	end;


elseif strcmpi(MTI.ds.displayType,'QUICKTIME'),   % note, quicktime play only supported in PTB-3
    Screen('LoadNormalizedGammaTable',StimWindow,StimWindowPreviousCLUT);
    Screen('SetMovieTimeIndex', MTI.ds.userfield.movie, 0); % play from beginning, regardless of where we played last time
	done = 0; frameNum = 0;
	startStopTimes(2) = StimTriggerAct('Stim_ONSET_trigger',MTI.stimid);
	Screen('PlayMovie',MTI.ds.userfield.movie,1);
	while ~done,
		if frameNum>0, StimTriggerAct('Stim_beforeframe_trigger',MTI.stimid,frameNum); end;
		tex = Screen('GetMovieImage',StimWindow,MTI.ds.userfield.movie);
		if tex<=0, done = 1; break; % detect hitting the end of the movie
		else,
			frameNum = frameNum + 1;
			Screen('DrawTexture',StimWindow,tex,[],MTI.df.rect);
			if StimWindowUseCLUTMapping, Screen('LoadNormalizedGammaTable',StimWindow,linspace(0,1,256)' * ones(1,3),1); end;
			Screen('Flip',StimWindow);
			frameTimes(frameNum) = StimTriggerAct('Stim_afterframe_trigger',MTI.stimid,frameNum);
			Screen('Close',tex);
		end;
	end;
	Screen('PlayMovie',MTI.ds.userfield.movie,0); % stop the movie from playing

elseif strcmp(MTI.ds.displayType,'Sound'),
	startStopTimes(2) = StimTriggerAct('Stim_ONSET_trigger',MTI.stimid);
	Snd('Play',MTI.ds.userfield.sound,MTI.ds.userfield.rate);
	StimTriggerAct('Stim_beforeframe_trigger',MTI.stimid,1);
	Snd('Wait');
	frameTimes(1) = StimTriggerAct('Stim_afterframe_trigger',MTI.stimid,1);
end;

if MTI.postBGframes>0,
	if NS_PTBv<3,
		Screen(StimWindow,'SetClut',MTI.ds.clut_bg);
		startStopTimes(3) = StimTriggerAct('Stim_OFFSET_trigger',MTI.stimid);
		Screen(StimWindow,'WaitBlanking',MTI.postBGframes);
	else,
		if 1,
		       	ngt = Screen('ReadNormalizedGammaTable',StimWindow);
			if ~eqlen(ngt,StimWindowPreviousCLUT),
				Screen('LoadNormalizedGammaTable', StimWindow, MTI.ds.clut_bg,1);
			end;
			Screen(StimWindow,'FillRect',round(255*MTI.ds.clut_bg(1,:,:))); % make sure background is in
			vbl = Screen('Flip', StimWindow, 0, 0);
			Screen(StimWindow,'FillRect',round(255*MTI.ds.clut_bg(1,:,:))); % make sure background is in
			%Screen('Flip', StimWindow, vbl + (MTI.postBGframes-0.5)/StimWindowRefresh);
		elseif strcmpi(MTI.ds.displayType,'CLUTanim'),
			Screen(StimWindow,'FillRect',0); % make sure background is in 2nd buffer
			vbl = Screen('Flip', StimWindow, 0); % wait for blanking
			Screen(StimWindow,'FillRect',0); % make sure background is in 2nd buffer
	        	WaitSecs(0.2);
		        Screen('LoadNormalizedGammaTable', StimWindow, MTI.ds.clut_bg,1);
		else,
			Screen('FillRect',StimWindow,round(255*MTI.ds.clut_bg(1,:,:))); % make sure background is installed
			vbl = Screen('Flip', StimWindow, 0); % wait for blanking
			Screen('FillRect',StimWindow,round(255*MTI.ds.clut_bg(1,:,:))); % make sure background is installed
		        WaitSecs(0.2);
			if StimWindowUseCLUTMapping, Screen('LoadNormalizedGammaTable',StimWindow,linspace(0,1,256)' * ones(1,3),1); end;
		end;
	        startStopTimes(3) = StimTriggerAct('Stim_OFFSET_trigger',MTI.stimid);
	        Screen('Flip', StimWindow, vbl + (MTI.postBGframes+0.5)/StimWindowRefresh);
	        WaitSecs(0.2);
	end;
else,
	startStopTimes(3) = StimTriggerAct('Stim_OFFSET_trigger',MTI.stimid);
end;

ngt = Screen('ReadNormalizedGammaTable',StimWindow);
if ~eqlen(ngt,StimWindowPreviousCLUT),
	Screen('LoadNormalizedGammaTable', StimWindow, MTI.ds.clut_bg,1);
end;
Screen(StimWindow,'FillRect',round(255*MTI.ds.clut_bg(1,:,:))); % make sure background is in
Screen('Flip',StimWindow,0,0,1);
Screen(StimWindow,'FillRect',round(255*MTI.ds.clut_bg(1,:,:))); % make sure background is in
%Screen(StimWindow,'FillRect',0); % make sure background is in
Screen('Flip',StimWindow,0,0,1);

startStopTimes(4) = StimTriggerAct('Stim_BGpost_trigger',MTI.stimid);

if strcmp(MTI.ds.displayType,'Sound'), Snd('Close'); end;

if MTI.ds.makeClip&NS_PTBv<3, % clear the clipping region
	Screen(StimWindow,'SetDrawingRegion',StimWindowRect);
end;
