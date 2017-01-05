function [done,stamp,infoO] = customdraw(ps, info, MTI)

% CUSTOMDRAW - Custom draw routine for periodicstim
%
%  [DONE,STAMP,INFO] = CUSTOMDRAW(THEPERIODICSTIM, INFO, STIMWINDOW,...
%                    MTI)
%
%  This custom draw routine is used for display "plaid" sums of gratings.
%
%  

StimWindowGlobals;

done = 0;
stamp = 1; % always stamp unless we're on the last frame, see below

if isempty(info),
	infoO = struct('frameNum',1,'vbl',0);
else,
	infoO = info;
end;


frameNum = infoO.frameNum;

if frameNum==1, % first frame
	Screen('LoadNormalizedGammaTable',StimWindow,StimWindowPreviousCLUT);
	Screen('FillRect',StimWindow,round(255*MTI.ds.clut(1,:,:)));
	textures = find(MTI.MovieParams.Movie_textures{frameNum});
	textures = textures(1:end-2);
	Screen('DrawTextures',StimWindow,MTI.ds.offscreen(textures),squeeze(MTI.MovieParams.Movie_sourcerects(:,frameNum,textures)),squeeze(MTI.MovieParams.Movie_destrects(:,frameNum,textures)),...
		squeeze(MTI.MovieParams.Movie_angles(:,frameNum,textures)),1,squeeze(MTI.MovieParams.Movie_globalalphas(:,frameNum,textures)));

	% here draw texture end-1 with clipping set to texture end, mimic DriftDemo5
	Screen('Blendfunction',StimWindow,GL_ONE, GL_ZERO,[0 0 0 1]);
	textures = find(MTI.MovieParams.Movie_textures{frameNum});
	textures = textures(end);
	Screen('DrawTextures',StimWindow,MTI.ds.offscreen(textures),squeeze(MTI.MovieParams.Movie_sourcerects(:,frameNum,textures)),squeeze(MTI.MovieParams.Movie_destrects(:,frameNum,textures)),...
		squeeze(MTI.MovieParams.Movie_angles(:,frameNum,textures)),1,squeeze(MTI.MovieParams.Movie_globalalphas(:,frameNum,textures)));
	Screen('Blendfunction',StimWindow, GL_DST_ALPHA, GL_ONE_MINUS_DST_ALPHA, [1 1 1 1]);
	textures = find(MTI.MovieParams.Movie_textures{frameNum});
	textures = textures(end-1);
	Screen('DrawTextures',StimWindow,MTI.ds.offscreen(textures),squeeze(MTI.MovieParams.Movie_sourcerects(:,frameNum,textures)),squeeze(MTI.MovieParams.Movie_destrects(:,frameNum,textures)),...
		squeeze(MTI.MovieParams.Movie_angles(:,frameNum,textures)),1,squeeze(MTI.MovieParams.Movie_globalalphas(:,frameNum,textures)));
	Screen('Blendfunction',StimWindow, GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA); % restore things back

	if StimWindowUseCLUTMapping, Screen('LoadNormalizedGammaTable',StimWindow,linspace(0,1,256)' * ones(1,3),1); end;
	infoO.vbl = Screen('Flip',StimWindow,0);
elseif frameNum<=length(MTI.df.frames),
	textures = find(MTI.MovieParams.Movie_textures{frameNum});
	textures = textures(1:end-2);
	Screen('DrawTextures',StimWindow,MTI.ds.offscreen(textures),squeeze(MTI.MovieParams.Movie_sourcerects(:,frameNum,textures)),squeeze(MTI.MovieParams.Movie_destrects(:,frameNum,textures)),...
		squeeze(MTI.MovieParams.Movie_angles(:,frameNum,textures)),1,squeeze(MTI.MovieParams.Movie_globalalphas(:,frameNum,textures)));

	% here draw texture end-1 with clipping set to texture end, mimic DriftDemo5
	Screen('Blendfunction',StimWindow,GL_ONE, GL_ZERO,[0 0 0 1]);
	textures = find(MTI.MovieParams.Movie_textures{frameNum});
	textures = textures(end);
	Screen('DrawTextures',StimWindow,MTI.ds.offscreen(textures),squeeze(MTI.MovieParams.Movie_sourcerects(:,frameNum,textures)),squeeze(MTI.MovieParams.Movie_destrects(:,frameNum,textures)),...
		squeeze(MTI.MovieParams.Movie_angles(:,frameNum,textures)),1,squeeze(MTI.MovieParams.Movie_globalalphas(:,frameNum,textures)));
	Screen('Blendfunction',StimWindow, GL_DST_ALPHA, GL_ONE_MINUS_DST_ALPHA, [1 1 1 1]);
	textures = find(MTI.MovieParams.Movie_textures{frameNum});
	textures = textures(end-1);
	Screen('DrawTextures',StimWindow,MTI.ds.offscreen(textures),squeeze(MTI.MovieParams.Movie_sourcerects(:,frameNum,textures)),squeeze(MTI.MovieParams.Movie_destrects(:,frameNum,textures)),...
		squeeze(MTI.MovieParams.Movie_angles(:,frameNum,textures)),1,squeeze(MTI.MovieParams.Movie_globalalphas(:,frameNum,textures)));
	Screen('Blendfunction',StimWindow, GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA); % restore things back

	if StimWindowUseCLUTMapping, Screen('LoadNormalizedGammaTable',StimWindow,linspace(0,1,256)' * ones(1,3),1); end;
	infoO.vbl=Screen('Flip',StimWindow,infoO.vbl+(MTI.pauseRefresh(frameNum-1)-0.5)/StimWindowRefresh);
end;


if frameNum>length(MTI.df.frames),
	if StimWindowUseCLUTMapping, Screen('LoadNormalizedGammaTable',StimWindow,linspace(0,1,256)' * ones(1,3),1); end;
	Screen('Flip',StimWindow,infoO.vbl+(MTI.pauseRefresh(end)-0.5)/StimWindowRefresh);
	stamp = 0; % not a new data frame, just waiting for the old one to play out
	done = 1;
end;

infoO.frameNum = infoO.frameNum + 1;
