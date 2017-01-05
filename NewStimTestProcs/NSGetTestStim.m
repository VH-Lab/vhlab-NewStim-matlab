function stim = NSGetTestStim(stimclass)


if ischar(stimclass)&strcmp(upper(stimclass),'ALL'),
	mylist = {'stochasticgridstim' 'periodicstim'};
	stim = NSGetTestStim(mylist);
	return;
end;


if iscell(stimclass),
	stim = {};
	for i=1;length(stimclass),
		stim{i} = NSGetTestStim(stimclass{i});
	end;
	return;
elseif ischar(stimclass),
	switch stimclass,
		case 'stochasticgridstim',
			stim = stochasticgridstim('default');
			p = getparameters(stim);
			p.N = 15; p.fps = 1;
			p.rect = [200 200 500 500]; 
			stim = stochasticgridstim(p);
		case 'stochasticgridstim_elong',
			stim = stochasticgridstim('default');
			p = getparameters(stim);
			p.N = 15; p.fps = 10;
			p.rect = [0 0 400 600];
			p.angle = 45;
			p.pixSize = [ 25 50];
			stim = stochasticgridstim(p);    
		case 'stochasticgridstim_elong2',
			stim = stochasticgridstim('default');
			p = getparameters(stim);
			p.N = 35; p.fps = 15;
			p.rect = [0 0 800 600];
			p.angle = 45;
			p.pixSize = [ 800 25];
			stim = stochasticgridstim(p);  
	        case 'periodicstimsimple',
			stim = periodicstim('graphical');
			%p = getparameters(stim);
			%p.flickerType = 2;
			%p.animType = 2;
		case 'periodicstim',
			stim = periodicstim('default');
			p = getparameters(stim);
			p.rect = [200 200 400 1000];
			p.sFrequency = 0.2;
			p.windowShape = 6;
			p.nSmoothPixels = 1;
			p.aperture = [20 20];
			stim = periodicstim(p);
		case 'periodicstimwpsmask',
			stim = periodicstim('default');
			p = getparameters(stim);
			p.rect = [100 100 800 700];
			p.sFrequency = 0.05;
			p.windowShape = 3;
			p.nSmoothPixels = 1;
			p.animType =  4;
			p.angle = 45;
			p.ps_mask = periodicstim(p);
			p.sFrequency = 0.2;
			p.animType = 4;
			p.angle = 135;
			p.sPhaseShift = pi/2;
			stim = periodicstim(p);
		case 'periodicstimgaussian',
			stim = periodicstim('default');
			p = getparameters(stim);
			p.rect = [100 100 200 200];
			p.sFrequency = 0.08;
			p.windowShape = 8;
			p.nSmoothPixels = 1;
			p.animType =  4;
			p.angle = 45;
			stim = periodicstim(p);
		case 'periodicstimwpsadd',
			stim = periodicstim('default');
			p = getparameters(stim);
			p.rect = [100 100 800 700];
			p.sFrequency = 0.05;
			p.windowShape = 7;
			p.aperture = [ 100 100 ];
			p.nSmoothPixels = 1;
			p.animType =  4;
			p.angle = 45;
			p.contrast = 0.3;
			p.ps_add = periodicstim(p);
			p.sFrequency = 0.2;
			p.animType = 4;
			p.angle = 135;
			p.windowShape = 7;
			p.aperture = [ 100 100 ];
			p.sPhaseShift = pi/2;
			stim = periodicstim(p);
		case 'PSwindowShapes',
			stim = periodicstim('default');
			p = getparameters(stim);
			p.rect = [200 200 400 1000];
			p.sFrequency = 0.2;
			p.windowShape = 3;
			p.nSmoothPixels = 1;
			%p.flickerType = 2;
			%p.animType = 2;
			stim = periodicstim(p);
		case 'periodicstimwoverlay',
			stim = periodicstim('default');
			p = getparameters(stim);
			p.rect = [000 000 600 600];
			p.sFrequency = 0.2;
			p.tFrequency = 4;
			p.nCycles = 8;
			p.windowShape = 3;
			p.nSmoothPixels = 1;
			p_ = p;
			p_.rect = [200 200 400 400];
			p_.angle = p.angle + 90;
			p.ps_overlay = periodicstim(p_);
			stim = periodicstim(p);
		case 'centersurroundstim',
			stim=centersurroundstim('graphical');
		case 'blinkingstim',
			stim = blinkingstim('graphical');
		case 'polygonstim',
			stim = polygonstim('graphical');
		case 'shapemoviestim',
			stim = shapemoviestim('graphical');
			sms.type = 1;
			sms.position.x=50; sms.position.y=50;
			sms.onset = 1;
			sms.duration = 5;
			sms.size = 10;
			sms.color.r=0; sms.color.g=255; sms.color.b=0;
			sms.contrast = 1;
			sms.speed.x = 5; sms.speed.y = 5;
			sms.orientation = 0;
			sms.eccentricity = 1;
			sms(2) = sms(1);
			sms(2).speed.x = -5; sms(2).speed.y = -5;
			stim = addshapemovies(stim,{sms sms});
		case 'multistim',
			StimWindowGlobals;
			mystim = periodicstim('default');
			p = getparameters(mystim);
			p.angle = 45;
			p.rect = [400 400 600 600];
			p.sFrequency = 0.2;
			p.windowShape = 1;
			p.nSmoothPixels = 1;
			mystim = periodicstim(p);
			if 0,
				mynewstim = append(multistim(p),mystim);
				stim=mynewstim;
			else,
				thescript = makeflanktuning(mystim, [45], 45+[0 90], 400, 1, 1, 0.5, StimWindowRect, 0);	
				stim = thescript;
			end;
		case 'notmultistim',
			StimWindowGlobals;
			mystim = periodicstim('default');
			p = getparameters(mystim);
			p.angle = 45;
			p.rect = [400 400 600 600];
			p.sFrequency = 0.2;
			p.windowShape = 3;
			p.nSmoothPixels = 1;
			stim = periodicstim(p);
		case 'orthgratinggrid',
			mystim = periodicstim('default');
			p = getparameters(mystim);
			p.sFrequency = 0.08;
			p.tFrequency = 4;
			p.nCycles = 20;
			screenrect = [0 0 800 600];
			thescript = makeorthogonaltrainingstim(periodicstim(p),[0:45:360-45],screenrect);
			stim=thescript;
		case 'smallgratinggrid',
			mystim = periodicstim('default');
			p = getparameters(mystim);
			p.sFrequency = 0.08;
			p.tFrequency = 4;
			p.nCycles = 20;
			screenrect = [0 0 800 600];
			thescript = makeorthogonaltrainingstim(periodicstim(p),[0:45:360-45],screenrect,0);
			stim=thescript;
		case 'combinemoviestim',
		case 'combinemoviestim',
			ps_script = periodicscript('graphical');
			stim = combinemoviestim(struct('script',ps_script));
			case 'combinemoviestim2',
			stim = periodicstim('default');
			p = getparameters(stim);
			p.rect = [200 200 400 400];
			p.sFrequency = 0.2;
			p.windowShape = 6;
			p.nSmoothPixels = 1;
			p.aperature = [60 60];
			p.angle = 90;
			stim = periodicstim(p);
            
			ps_script = append(stimscript(0),stim);
			stim = periodicstim('default');
			p = getparameters(stim);
			p.rect = [200 200 400 400];
			p.sFrequency = 0.2;
			p.windowShape = 6;
			p.nSmoothPixels = 1;
			p.aperature = [20 20];
			stim = periodicstim(p);

			ps_script = append(ps_script,stim);
            
			cms = combinemoviestim(struct('script',ps_script));            
			stim = cms;
		case 'rcgratingstim',
			stim = rcgratingstim('default');
			p = getparameters(stim);
			p.baseps = periodicstim('graphical');
			p.reps = 10;
			p.order = 1;
			p.pausebetweenreps = 1;
			p.dur = 1/60;
			p.orientations = [0:22.5:180-22.5];
			p.spatialfrequencies = [ 0.025 0.05 0.1 0.2 0.4 0.8];
			p.spatialphases = [ 0:pi/4:2*pi-pi/4 ];
			p.dispprefs = {};
			stim = rcgratingstim(p);
		case 'quicktimestim',
			mystim = quicktimestim('default');
			p = getparameters(mystim);
			p.filename=[PsychtoolboxRoot 'PsychDemos' filesep 'QuicktimeDemos' filesep 'DualDiscs.mov'];
			p.filename=['/Users/vanhoosr/Desktop/matrix_lighter.mov'];
			stim = quicktimestim(p);
		case 'flashimageseqstim',
			stim = flashimageseqstim('default');
	end;
end;
