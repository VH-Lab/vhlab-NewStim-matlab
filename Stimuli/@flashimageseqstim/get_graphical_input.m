function params = get_graphical_input(oldstim)

if isempty(oldstim),
	FISparams = getparameters(flashimagestim('default'));
else,
	FISparams = getparameters(oldstim);
end;

FISparams = getparameters(oldstim);

repeat_str = num2str(FISparams.repeat);
repeat_interval_str = num2str(FISparams.repeat_interval);
bg_str = mat2str(FISparams.BG);
dirname_str = FISparams.dirname;
onsets_str = mat2str(FISparams.onsets);
durations_str = mat2str(FISparams.durations);
rect_str = mat2str(FISparams.rect);
dp_str = wimpcell2str(FISparams.dispprefs);


h0 = figure('Color',[0.8 0.8 0.8], 'Position',[165   376   488   541]);
settoolbar(h0,'none'); set(h0,'menubar','none');

ok_ctl = uicontrol('Parent',h0, ...
        'Units','points', ...
        'BackgroundColor',[0.7 0.7 0.7], ...
        'Callback','set(gcbo,''userdata'',[1]);uiresume(gcf);', ...
        'FontWeight','bold', ...
        'ListboxTop',0, ...
        'Position',[36 22 71 27], ...
        'String','OK', ...
        'Tag','Pushbutton1', ...
        'UserData',0);
cancel_ctl = uicontrol('Parent',h0, ...
        'Units','points', ...
        'BackgroundColor',[0.7 0.7 0.7], ...
        'Callback','set(gcbo,''userdata'',[1]);uiresume(gcf);', ...
        'FontWeight','bold', ...
        'ListboxTop',0, ...
        'Position',[173 24 71 27], ...
        'String','Cancel', ...
        'Tag','Pushbutton1', ...
        'UserData',0);
h1 = uicontrol('Parent',h0, ...
        'Units','points', ...
        'BackgroundColor',[0.7 0.7 0.7], ...
        'Callback',...
	'textbox(''flashimageseqstim help'',help(''flashimageseqstim''));', ...
        'FontWeight','bold', ...
        'ListboxTop',0, ...
        'Position',[304 25 71 27], ...
        'String','Help', ...
        'Tag','Pushbutton1');
h1 = uicontrol('Parent',h0, ...
        'Units','points', ...
        'BackgroundColor',[0.8 0.8 0.8], ...
        'FontSize',18, ...
        'FontWeight','bold', ...
        'ListboxTop',0, ...
        'Position',[51.2 382.4 284.8 24.8], ...
        'String','New flashimageseqstim object...', ...
        'Style','text', ...
        'Tag','StaticText1');
h1 = uicontrol('Parent',h0, ...
        'Units','points', ...
        'BackgroundColor',[0.8 0.8 0.8], ...
        'HorizontalAlignment','left', ...
        'ListboxTop',0, ...
        'Position',[31.2 340.8 216 19.2], ...
        'String','[1x4] Rect [top_x top_y bottom_x bottom_y]', ...
        'Style','text', ...
        'Tag','StaticText2');
rect_ctl = uicontrol('Parent',h0, ...
        'Units','points', ...
        'BackgroundColor',[1 1 1], ...
        'HorizontalAlignment','left', ...
        'ListboxTop',0, ...
        'Position',[255.2 344.8 124 18.4], ...
        'String',rect_str, ...
        'Style','edit', ...
        'Tag','EditText1');
h1 = uicontrol('Parent',h0, ...
        'Units','points', ...
        'BackgroundColor',[0.8 0.8 0.8], ...
        'HorizontalAlignment','left', ...
        'ListboxTop',0, ...
        'Position',[31.2 313.6 216 19.2], ...
        'String','[1x3] background color [r g b], each in 0..255', ...
        'Style','text', ...
        'Tag','StaticText2');
bg_ctl = uicontrol('Parent',h0, ...
        'Units','points', ...
        'BackgroundColor',[1 1 1], ...
        'HorizontalAlignment','left', ...
        'ListboxTop',0, ...
        'Position',[256 320 124 18.4], ...
        'String',bg_str, ...
        'Style','edit', ...
        'Tag','EditText1');
repeat_interval_ctl = uicontrol('Parent',h0, ...
        'Units','points', ...
        'BackgroundColor',[1 1 1], ...
        'HorizontalAlignment','left', ...
        'ListboxTop',0, ...
        'Position',[255.2 294.4 123.2 20.8], ...
        'String',repeat_interval_str, ...
        'Style','edit', ...
        'Tag','EditText1');
h1 = uicontrol('Parent',h0, ...
        'Units','points', ...
        'BackgroundColor',[0.8 0.8 0.8], ...
        'HorizontalAlignment','left', ...
        'ListboxTop',0, ...
        'Position',[31.2 288 187.2 19.2], ...
        'String','Repeat interval (seconds)', ...
        'Style','text', ...
        'Tag','StaticText2');
onsets_ctl = uicontrol('Parent',h0, ...
        'Units','points', ...
        'BackgroundColor',[1 1 1], ...
        'HorizontalAlignment','left', ...
        'ListboxTop',0, ...
        'Position',[319.2 267.2 57.6 21.6], ...
        'String',onsets_str, ...
        'Style','edit', ...
        'Tag','EditText1');
h1 = uicontrol('Parent',h0, ...
        'Units','points', ...
        'BackgroundColor',[0.8 0.8 0.8], ...
        'HorizontalAlignment','left', ...
        'ListboxTop',0, ...
        'Position',[26.4 260 277.6 21.6], ...
        'String','Onsets (seconds) [image1 image2 ...]', ...
        'Style','text', ...
        'Tag','StaticText2');
repeat_ctl = uicontrol('Parent',h0, ...
        'Units','points', ...
        'BackgroundColor',[1 1 1], ...
        'HorizontalAlignment','left', ...
        'ListboxTop',0, ...
        'Position',[174.4 239.2 30.4 18.4], ...
        'String',repeat_str, ...
        'Style','edit', ...
        'Tag','EditText1');
h1 = uicontrol('Parent',h0, ...
        'Units','points', ...
        'BackgroundColor',[0.8 0.8 0.8], ...
        'HorizontalAlignment','left', ...
        'ListboxTop',0, ...
        'Position',[31.2 234.4 140.8 19.2], ...
        'String','[1x1] Repeat how many times?', ...
        'Style','text', ...
        'Tag','StaticText2');
h1 = uicontrol('Parent',h0, ...
        'Units','points', ...
        'BackgroundColor',[0.8 0.8 0.8], ...
        'HorizontalAlignment','left', ...
        'ListboxTop',0, ...
        'Position',[210.4 236 116 19.2], ...
        'String','Durations (seconds) [image1 image2 ...]', ...
        'Style','text', ...
        'Tag','StaticText2');
durations_ctl = uicontrol('Parent',h0, ...
        'Units','points', ...
        'BackgroundColor',[1 1 1], ...
        'HorizontalAlignment','left', ...
        'ListboxTop',0, ...
        'Position',[335.2 240 36.8 18.4], ...
        'String',durations_str, ...
        'Style','edit', ...
        'Tag','EditText1');
h1 = uicontrol('Parent',h0, ...
        'Units','points', ...
        'BackgroundColor',[0.8 0.8 0.8], ...
        'HorizontalAlignment','left', ...
        'ListboxTop',0, ...
        'Position',[25.6 144.8 344 19.2], ...
        'String','Dirname (full path on stim computer)', ...
        'Style','text', ...
        'Tag','StaticText2');
dirname_ctl = uicontrol('Parent',h0, ...
        'Units','points', ...
        'BackgroundColor',[1 1 1], ...
        'HorizontalAlignment','left', ...
        'ListboxTop',0, ...
        'Position',[29.6 122.4 343.2 22.4], ...
        'String',dirname_str,...
        'Style','edit', ...
        'Tag','EditText1');
dp_ctl = uicontrol('Parent',h0, ...
        'Units','points', ...
        'BackgroundColor',[1 1 1], ...
        'HorizontalAlignment','left', ...
        'ListboxTop',0, ...
        'Position',[29.6 75.2 343.2 22.4], ...
        'String',dp_str, ...
        'Style','edit', ...
        'Tag','EditText1');
h1 = uicontrol('Parent',h0, ...
        'Units','points', ...
        'BackgroundColor',[0.8 0.8 0.8], ...
        'HorizontalAlignment','left', ...
        'ListboxTop',0, ...
        'Position',[25.6 97.6 344 19.2], ...
        'String','Set any displayprefs options here: example: {''BGpretime'',1}', ...
        'Style','text', ...
        'Tag','StaticText2');
h1 = uicontrol('Parent',h0, ...
        'Units','points', ...
        'BackgroundColor',[0.8 0.8 0.8], ...
        'HorizontalAlignment','left', ...
        'ListboxTop',0, ...
        'Position',[28 205.6 277.6 21.6], ...
        'String','[1x1] Number of frames to pause between blinks', ...
        'Style','text', ...
        'Tag','StaticText2');
bgpause_ctl = uicontrol('Parent',h0, ...
        'Units','points', ...
        'BackgroundColor',[1 1 1], ...
        'HorizontalAlignment','left', ...
        'ListboxTop',0, ...
        'Position',[319.2 210.4 57.6 21.6], ...
        'String','', ...
        'Style','edit', ...
        'Tag','EditText1');

% check for errors

error_free = 0;

sgsp = [];

while ~error_free,
        drawnow;
        uiwait(h0);

	if get(cancel_ctl,'userdata')==1,
		error_free = 1;
	else, % it was OK


repeat_str = num2str(FISparams.repeat);
repeat_interval_str = num2str(FISparams.repeat_interval);
bg_str = mat2str(FISparams.BG);
dirname_str = FISparams.dirname;
onsets_str = mat2str(FISparams.onsets);
durations_str = mat2str(FISparams.durations);
rect_str = mat2str(FISparams.rect);
dp_str = wimpcell2str(FISparams.dispprefs);

		rect_str = get(rect_ctl,'String');
		bg_str = get(bg_ctl,'String');
		repeat_interval_str=get(repeat_interval_ctl,'String');
		dirname=get(dirname_ctl,'String');
		repeat_str = get(repeat_ctl,'String');
		onsets_str = get(onsets_ctl,'String');
		durations_str = get(durations_ctl,'String');
		dp_str = get(dp_ctl,'String');
	
		so = 1; % syntax_okay;
		try, rect = eval(rect_str);
		catch, errordlg('Syntax error in Rect');so=0;
		end;
		try, bg = eval(bg_str);
		catch, errordlg('Syntax error in BG');so=0;
		end;
		try, repeat_interval= eval(repeat_interval_str);
		catch, errordlg('Syntax error in repeat_interval');so=0;
		end;
		try, onsets=eval(onsets_str);
		catch, errordlg('Syntax error in onsets');so=0;
		end;
		try, repeat = eval(repeat_str);
		catch, errordlg('Syntax error in repeat'); so=0;
		end;
		try, durations=eval(durations_str);
		catch, errordlg('Syntax error in durations'); so=0;
		end;
		try, dp=eval(dp_str);
		catch, errordlg('Syntax error in displayprefs'); so=0;end;

		if so,

			fisp = struct('repeat',repeat,'repeat_interval',repeat_interval,...
				'BG',bg,'dirname',dirname,'onsets',onsets,'durations',durations,...
				'rect',rect);
			fisp.dispprefs = dp;

			[good, err] = verify(fisp);
			if ~good, errordlg(['Parameter value invalid: ' err]);
				set(ok_ctl,'userdata',0);
			else, error_free = 1;
			end;
		else, set(ok_ctl,'userdata',0);
		end;
	end;
end; % while loop

if get(ok_ctl,'userdata')==1,
	params = fisp;
else, params = [];
end;
delete(h0);

function str = wimpcell2str(theCell)
 %1-dim cells only, only chars and matricies
str = '{  ';
for i=1:length(theCell),
        if ischar(theCell{i})
                str = [str '''' theCell{i} ''', '];
        elseif isnumeric(theCell{i}),
                str = [str mat2str(theCell{i}) ', '];
        end;
end;
str = [str(1:end-2) '}'];

