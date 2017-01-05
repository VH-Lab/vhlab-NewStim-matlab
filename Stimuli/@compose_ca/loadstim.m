function [outstim] = loadstim(cca)


%  LOADSTIM - Loads the COMPOSE_CA stimulus
%
%  NEWCCA = LOADSTIM(MYCOMPOSE_CA);
%
%  Loads MYCOMPOSE_CA stimulus into memory.
%
%  See also: COMPOSE_CA, STIMULUS/LOADSTIM

p = getparameters(cca);

NewStimGlobals;
StimWindowGlobals;

l = numStims(cca);
for i=1:l,
	if ~isloaded(cca.stimlist{i}),
		cca.stimlist{i} = loadstim(cca.stimlist{i});
	end;
end;

width = diff(p.rect([1 3])); height = diff(p.rect([2 4]));

CIs = unique(cca.clutindex);

if length(CIs)~=0,
	numeachct = floor(255 / length(CIs));  % how many entries per color table
else,
	numeachct = 256;
end;

ctstartend = [];  ctind = 1;
firstmembers = [];
clut = {};


if haspsychtbox,
	for i=1:length(CIs),
		ctstartend = [ ctstartend ; 1+[ctind ctind+numeachct-1]];
		ctind = ctind+numeachct;
		ind = find(CIs(i)==cca.clutindex);
		firstmembers(end+1) = ind(1); % the first member for each
	end;
	if NS_PTBv<3,
		myoffscreen = screen(-1,'OpenOffscreenWindow',0,[0 0 width height]);
	else,
		myoffscreen = Screen('MakeTexture',StimWindow,zeros(height,width));
		%OpenStimScreenBlender;
		%StimScreenBlenderGlobals;
	end;
	for i=1:l,
		df = struct(getdisplayprefs(cca.stimlist{i}));
		ds = struct(getdisplaystruct(cca.stimlist{i}));
		% get the image and shift it to the proper clut entries
		if NS_PTBv<3,
			myimage = double(screen(ds.offscreen,'GetImage'));
		else,
            disp(['trying to get screen image, i=' int2str(i)]);
            Screen(ds.offscreen,'GetImage'),
            disp(['trying to get screen image, i=' int2str(i)]);
			myimage = double(Screen(ds.offscreen,'GetImage'));
            size(myimage),
		end;
		z = find(myimage==0);
		myctind = find(CIs==cca.clutindex(i));
		mynewimage = round(rescale(myimage,[1 255],ctstartend(myctind,:)-1));
		mynewimage(z) = 0; % set every background pixel back to background
		% now copy the stimulus window to our offscreen buffer, clipping if necessary
		if strcmp(ds.displayType,'CLUTanim'),
			if NS_PTBv<3,
				if ds.makeClip, screen(myoffscreen,'SetDrawingRegion',ds.clipRect,ds.makeClip-1); end;
				screen(myoffscreen,'PutImage',mynewimage,df.rect);
				if ds.makeClip, screen(myoffscreen,'SetDrawingRegion',[0 0 width height]); end;
			else,
				% must blend correctly
                disp('getting 1st image')
				mycurrentImage = double(screen(myoffscreen,'GetImage',[],[],[],1));
				%myCurrImageBF{i} = mycurrentImage;
				if ds.makeClip>0&ds.makeClip<4, % must do manual clipping
					% clipRect is in global screen coords, but in this case that is the composed offscreen
					[dummy,maskImage] = NewStimMasker(myimage,df.rect,ds.makeClip,ds.clipRect,0);
				elseif ds.makeClip==4,
					maskImage = ds.clipRect;
				end;
				% now must project image and blend it
				mytemptexture = Screen('MakeTexture',StimWindow,cat(3,mynewimage,maskImage));
				%myImageSeq{i} = myimage; myImageMaskSeq{i} = maskImage;
				%screen('DrawTexture',myoffscreen,mytemptexture,[],df.rect,[],0,[],[],StimScreenBlenderGLSL);
				screen('DrawTexture',myoffscreen,mytemptexture,[],df.rect,[],0,[],[],[]);
				screen('Close',mytemptexture);
				% now clear the alpha channels so we don't need a blender later
                disp('getting alpha channel?? image')
				myupdatedImage = double(Screen(myoffscreen,'GetImage',[],[],[],2));
				mynewoffscreen = Screen('MakeTexture',StimWindow,myupdatedImage(:,:,1));
				screen('Close',myoffscreen);
				myoffscreen = mynewoffscreen;
				%mycurrentImage = double(screen(myoffscreen,'GetImage',[],[],[],1));
				%myCurrImageAF{i} = mycurrentImage;
			end;
		end;
	end;
	% now clear the alpha channels so we don't need a blender later
	%myupdatedImage = double(screen(myoffscreen,'GetImage',[],[],[],2));
	%mynewoffscreen = screen('MakeTexture',StimWindow,myupdatedImage(:,:,1));
	%screen('Close',myoffscreen);
	%myoffscreen = mynewoffscreen;
	if numStims(cca)>1, % now build color table
		df0 = getdisplayprefs(cca.stimlist{1});
		ds0 = struct(getdisplaystruct(cca.stimlist{1}));
		for j=1:length(ds0.clut),
			ctab = repmat([0 0 0],256,1);
			for i=1:length(firstmembers),
				ds = struct(getdisplaystruct(cca.stimlist{firstmembers(i)}));
					if cca.clutindex(firstmembers(i))==min(CIs), ctab(1,:) = ds0.clut{j}(1,:); end; % grab background
					newinds = round(rescale(2:numeachct+1,[2 numeachct+1],[2 256]));
					ctab(ctstartend(i,1):ctstartend(i,2),:) = ds.clut{j}(newinds,:);
			end;
			clut = cat(1,clut,{ctab});
		end;
		dS = {'displayType','CLUTanim','displayProc','standard',...
			'offscreen',myoffscreen,'frames',ds0.frames,'depth',ds0.depth,...
			'clut_usage',ds0.clut_usage,'clut',clut,...
			'clut_bg',ds0.clut_bg};
		df0 = setvalues(df0,{'rect',p.rect,p.dispprefs{:}});
	else,
		df0 = displayprefs(cat(2,{'fps',1,'rect',p.rect,'frames',1},p.dispprefs));
		dS = {'displayType','CLUTanim','displayProc','standard',...
			'offscreen',myoffscreen,'frames',1,'depth',8,...
			'clut_usage',repmat(1,256),'clut',repmat([128 128 128],256,1),...
			'clut_bg',repmat([128 128 128],256,1)};
	end;
	outstim = cca;
	outstim = setdisplayprefs(outstim,df0);
	outstim = setdisplaystruct(outstim,displayStruct(dS));
	outstim.stimulus = loadstim(outstim.stimulus);
	if NS_PTBv>=3&0, CloseStimScreenBlender; end;
else,
	outstim = cca;
end;


