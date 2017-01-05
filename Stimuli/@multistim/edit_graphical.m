function [newms,cancelled] = edit_graphical(ms)

  % we will edit newms and keep ms around in case user cancels
newms = ms;

cancelled = 0;
h0=editfig;

p = getparameters(newms);

stimlist = get(newms);

set(ft(h0,'RectEdit'),'String',mat2str(p.rect));
set(ft(h0,'DispPrefsEdit'),'String',wimpcell2str(p.dispprefs));
updatelist(h0,newms);

error_free = 0;
while ~error_free,
	drawnow;
	uiwait(h0);
	if get(ft(h0,'CanButt'),'userdata')==1,
		error_free = 1;
		cancelled = 1;
		newms = ms;
	elseif get(ft(h0,'AddNewBt'),'userdata')==1,
		set(ft(h0,'AddNewBt'),'userdata',0);
		StimList = NewStimList;
		[S,V]=listdlg('PromptString','Select new stimulus type','ListString',StimList,...
			'SelectionMode','single');
		mystim = [];
		if V==1,
			try, 
				eval(['mystim = ' StimList{S} '(''graphical'');']);
			catch, mystim = [];
			end;
		end;
		if ~isempty(mystim), newms = append(newms,mystim); end;
		updatelist(h0,newms);
	elseif get(ft(h0,'AddVarBt'),'userdata')==1,
		set(ft(h0,'AddVarBt'),'userdata',0);
		StimList = listofvars('stimulus');
		[S,V]=listdlg('PromptString','Select new stimulus','ListString',StimList,...
			'SelectionMode','single');
		mystim = [];
		if V==1,
			try, mystim = evalin('base',[StimList{S} ';']);
			catch, mystim = [];
			end;
		end;
		if ~isempty(mystim), newms = append(newms,mystim); end;
		updatelist(h0,newms);
	elseif get(ft(h0,'InsertBt'),'userdata')==1,
		set(ft(h0,'InsertBt'),'userdata',0);
		val = get(ft(h0,'StimlistList'),'value');
		if ~isempty(val),
			StimList = NewStimList;
			[S,V]=listdlg('PromptString','Select new stimulus type','ListString',StimList,...
				'SelectionMode','single');
			mystim = [];
			if V==1,
				try, 
					eval(['mystim = ' StimList{S} '(''graphical'');']);
				catch, mystim = [];
				end;
			end;
			if ~isempty(mystim), newms = insert(newms,mystim,val-1); end;
			updatelist(h0,newms);
		end;
	elseif get(ft(h0,'InsertVarBt'),'userdata')==1,
		set(ft(h0,'InsertVarBt'),'userdata',0);
		val = get(ft(h0,'StimlistList'),'value');
		if ~isempty(val),
			StimList = listofvars('stimulus');
			[S,V]=listdlg('PromptString','Select new stimulus','ListString',StimList,...
				'SelectionMode','single');
			mystim = [];
			if V==1,
				try, mystim = evalin('base',[StimList{S} ';']);
				catch, mystim = [];
				end;
			end;
			if ~isempty(mystim), newms = insert(newms,mystim,val-1); end;
			updatelist(h0,newms);
		end;
	elseif get(ft(h0,'RemoveBt'),'userdata')==1,
		set(ft(h0,'RemoveBt'),'userdata',0);
		val = get(ft(h0,'StimlistList'),'value');
		if ~isempty(val),
			newms = remove(newms,val);
			updatelist(h0,newms);
		end;
	elseif get(ft(h0,'OKButt'),'userdata')==1, % it was okay
		rect_str=get(ft(h0,'RectEdit'),'String');
		dp_str = get(ft(h0,'DispPrefsEdit'),'String');

		so = 1; % syntax okay
		try,p.rect=eval(rect_str);
			catch,errordlg('Syntax error in rect');so=0;end;
		try,p.dispprefs=eval(dp_str);
			catch,errordlg('Syntax error in dispprefs');so=0;end;
		if so,
			try,
				newms = setparameters(newms,p);
				error_free = 1;
			catch,
				errordlg(lasterr);
				set(ft(h0,'OKButt'),'userdata',0);
			end;
		end;
	end;
end;

delete(h0);

function h = ft(h1,st)  % shorthand
h = findobj(h1,'Tag',st);

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

function updatelist(h1,ms)
h = ft(h1,'StimlistList');
str = {};
for i=1:numStims(ms), str{i} = [class(get(ms,i)) ' | ' int2str(i) ]; end;
if ~isempty(str),
	set(h,'string',str);
	set(ft(h1,'InsertBt'),'enable','on');
	set(ft(h1,'InsertVarBt'),'enable','on');
	set(ft(h1,'RemoveBt'),'enable','on');
	set(h,'value',1);
else,
	set(h,'string','');
	set(ft(h1,'InsertBt'),'enable','off');
	set(ft(h1,'InsertVarBt'),'enable','off');
	set(ft(h1,'RemoveBt'),'enable','off');
	set(h,'value',1);
end;


