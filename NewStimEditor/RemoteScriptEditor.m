function RemoteScriptEditor(figNum,soefig)

%  REMOTESCRIPTEDITOR
%
%  RemoteScriptEditor brings up a tool for transfering NewStim scripts to a
%  remote machine.  The tool provides limited options for editing the scripts on
%  this remote machine as well.  (To edit scripts on the local machine, use the
%  ScriptEditor, which can be brought up by clicking on the button
%  'Local Script Editor'.)  When transferring to the remote machine, there will
%  be a pause and a dialog box displayed asking you to wait or cancel.  If the
%  remote machine has crashed, you may click cancel, re-initialize the remote
%  machine, and click 'Update' on the remote side of the editor.
%  These operations performed by the function are the following:
%
%  Update             - Update the editor's list of stimuli.  This is useful if
%                       a non-graphical script creates a stimulus that the
%                       editor is not aware of.  The one on the left is for
%                       the local scripts and the one on the right is for the
%                       remote scripts.
%  Help               - Display this file.
%  Load               - Load the script(s) into memory on the remote side
%                       (requires psychophysics toolbox on remote side).
%  Unload             - unload the script(s) into memory on the remote side
%                       (requires psychophysics toolbox on remote side).
%  Strip              - Disassociates the script from any memory structures
%                       (such as offscreen buffers) without deleting these
%                       structures.  Useful if you want to make a copy of a
%                       script that you later delete.
%                       (requires psychophysics toolbox on remote side).
%  Edit               - Edit the remote script (more limited than editing local
%  Delete             - Remove the currently selected scripts from memory.
%  Duplicate          - Make a copy of a script.
%
%  Note:  When the please wait button appears, you will only be able to press
%  'Stop' every few seconds or so.  Just hold the mouse button there.
%
%  Note:  Loaded scripts are marked with a '*'.
%
%  See also:  SCRIPTEDITOR, STIMEDITOR

if nargin==0, 	fig=figure;set(fig,'MenuBar','none');
		drawScriptEditor(fig);RemoteScriptEditor('Update',fig);
elseif ~ischar(figNum),  % is the call described above
	fig = figNum; figure(fig); clf; set(fig,'MenuBar','none');
	drawScriptEditor(fig); RemoteScriptEditor('Update',fig);
else, % it is a callback
	command = figNum;
	theFig = gcbf;
	if nargin==2, theFig = soefig;
	elseif isempty(theFig), theFig = gcbf;
	else, theFig = gcf;
	end;
	scriptedstruct = get(theFig,'UserData');
	lbloc = scriptedstruct.lbloc; lbrem=scriptedstruct.lbrem;
	switch command,
		case 'Update',
			RemoteScriptEditor('UpdateLoc',theFig);
			RemoteScriptEditor('UpdateRem',theFig);
		case 'UpdateLoc',
			g = listofvars('stimscript');
			set(lbloc,'String',g,'value',[]);
			RemoteScriptEditor('EnableDisable',theFig);
		case 'UpdateRem',
			save_str={'cd(pwd);save(''fromremote'',''s'',''-mat'');'
			'save(''gotit'',''g'',''-mat'');'};
			str = cat(1,update_str,save_str);
			b = sendremotecommand(str);
			if b,  % we know pathname is good
				pathn = rempath;
				fname = [pathn 'fromremote'];
				s=load(fname,'-mat'); s = s.s;
				%s(1),
				handleupdate(s,lbrem);
				RemoteScriptEditor('EnableDisable',theFig);
			end;
		case 'Toremote',
                        unloadstr={'names=load(''toremote'',''-mat'');fnames=fieldnames(names);',...
                                   'for i=1:length(fnames),'...
                                     'if exist(fnames{i}),'...
                                       'eval([''b=isa('' fnames{i} '', ''''stimscript'''');'']);',...
                                       'if b,eval([fnames{i} '' = unloadStimScript('' fnames{i} '');'']);end;'...
                                       'eval([''b=isa('' fnames{i} '', ''''stimulus'''');'']);',...
                                       'if b,eval([fnames{i} '' = unloadstim('' fnames{i} '');'']);end;'...
                                      'end;'...
                                    'end;'}';
			trans_str =cat(1,{'load(''toremote'',''-mat'');'},update_str);
			save_str= {'save(''fromremote'',''s'',''-mat'');'
			   'save(''gotit'',''g'',''-mat'');'};
			trans_str = cat(1,trans_str,save_str);
                        trans_str = cat(1,unloadstr,trans_str);
			b= checkremdir;
			if b,
				strs = lb_getselected(lbloc);
				if length(strs)>0,
					biglist = [];
					for i=1:length(strs),
						g = char(strs(i));
						biglist=[biglist ' ''' g ''','];
					end;
					if ~isempty(biglist),
						biglist=biglist(1:end-1);
					end;
					v = str2mat(version('-release'));
					if v>13, biglist = [biglist ',''-V6'' ']; end;
					pathn=rempath;
					fname = [pathn 'toremote'];
					evalin('base',['save(''' fname ''',' biglist ',''-mat'');']);
					b=sendremotecommand(trans_str);
					if b,
						pathn = rempath;
						fname = [pathn 'fromremote'];
						s=load(fname,'-mat'); s = s.s;
						%s(1),
						handleupdate(s,lbrem);
					        RemoteScriptEditor('EnableDisable',theFig);
					end;
				end;
			end;
		case 'Toremoteload',
                        unloadstr={'names=load(''toremote'',''-mat'');fnames=fieldnames(names);',...
                                   'for i=1:length(fnames),'...
                                     'if exist(fnames{i}),'...
                                       'eval([''b=isa('' fnames{i} '', ''''stimscript'''');'']);',...
                                       'if b,eval([fnames{i} '' = unloadStimScript('' fnames{i} '');'']);end;'...
                                       'eval([''b=isa('' fnames{i} '', ''''stimulus'''');'']);',...
                                       'if b,eval([fnames{i} '' = unloadstim('' fnames{i} '');'']);end;'...
                                      'end;'...
                                    'end;'}';
                        loadstr={ 'for i=1:length(fnames),'...
                                     'if exist(fnames{i}),'...
                                       'eval([''b=isa('' fnames{i} '', ''''stimscript'''');'']);',...
                                       'if b,eval([fnames{i} '' = loadStimScript('' fnames{i} '');'']);end;'...
                                       'eval([''b=isa('' fnames{i} '', ''''stimulus'''');'']);',...
                                       'if b,eval([fnames{i} '' = loadstim('' fnames{i} '');'']);end;'...
                                      'end;'...
                                    'end;'}';
			trans_str =cat(1,{'load(''toremote'',''-mat'');'},loadstr);
			save_str= {'save(''fromremote'',''s'',''-mat'');'
			   'save(''gotit'',''g'',''-mat'');'};
			trans_str = cat(1,trans_str,update_str);
                        trans_str = cat(1,trans_str,save_str);
                        trans_str = cat(1,unloadstr,trans_str);
			b= checkremdir;
			if b,
				strs = lb_getselected(lbloc);
				if length(strs)>0,
					biglist = [];
					for i=1:length(strs),
						g = char(strs(i));
						biglist=[biglist ' ''' g ''','];
					end;
					if ~isempty(biglist),
						biglist=biglist(1:end-1);
					end;
					pathn=rempath;
					v = str2num(version('-release'));
					if v>13, biglist = [biglist ', ''-V6'' ']; end;
					fname = [pathn 'toremote'];
					evalin('base',['save(''' fname ''',' biglist ',''-mat'');']);
					b=sendremotecommand(trans_str);
					if b,
						pathn = rempath;
						fname = [pathn 'fromremote'];
						s=load(fname,'-mat'); s = s.s;
						%s(1),
						handleupdate(s,lbrem);
					        RemoteScriptEditor('EnableDisable',theFig);
					end;
				end;
			end;
		case 'Tolocal',
			remsavestr = {};
			strs = lb_getselected(lbrem);
			if length(strs)>0,
			   ts=[];
		  	   for i=1:length(strs),
				g = char(strs(i));
				if g(end)=='*', g=g(1:end-1);end;
				ts =  [ts ' ' g] ;
			   end;
			end;
			save_str= {['save fromremote ' ts ' -mat']
			   'save(''gotit'',''g'',''-mat'');'};
			remsavestr = cat(1,{'g=5;'},save_str);
			b=sendremotecommand(remsavestr);
			if b,
				pathn = rempath;
				fname = [pathn 'fromremote'];
				evalin('base',['load ' fname ' -mat;']);
				z=geteditor('RemoteScriptEditor');
				if z,RemoteScriptEditor('UpdateLoc',z);end;
				z=geteditor('ScriptEditor');
				if z,ScriptEditor('Update',z);end;
			end;
		case 'Help',
			g = help('RemoteScriptEditor');
			textbox('RemoteScriptEditor help',g);
		case 'Load',
			loadstr = {};
			save_str= {'save(''fromremote'',''s'',''-mat'');'
			   'save(''gotit'',''g'',''-mat'');'};
			strs = lb_getselected(lbrem);
			if length(strs)>0,
		  	   for i=1:length(strs),
				g = char(strs(i));
				if g(end)=='*', g=g(1:end-1);end;
				ts = { [g '=loadStimScript(' g ');'] };
				loadstr = cat(1,loadstr,ts);
			   end;
			end;
			loadstr = cat(1,loadstr,update_str);
			loadstr = cat(1,loadstr,save_str);
			b=sendremotecommand(loadstr);
			if b,
				pathn = rempath;
				fname = [pathn 'fromremote'];
				s=load(fname,'-mat'); s = s.s;
				%s(1),
				handleupdate(s,lbrem);
			        RemoteScriptEditor('EnableDisable',theFig);
			end;
		case 'Unload',
			loadstr = {};
			save_str= {'save(''fromremote'',''s'',''-mat'');'
			   'save(''gotit'',''g'',''-mat'');'};
			strs = lb_getselected(lbrem);
			if length(strs)>0,
		  	   for i=1:length(strs),
				g = char(strs(i));
				if g(end)=='*', g=g(1:end-1);end;
				ts = { [g '=unloadStimScript(' g ');'] };
				loadstr = cat(1,loadstr,ts);
			   end;
			end;
			loadstr = cat(1,loadstr,update_str);
			loadstr = cat(1,loadstr,save_str);
			b=sendremotecommand(loadstr);
			if b,
				pathn = rempath;
				fname = [pathn 'fromremote'];
				s=load(fname,'-mat'); s = s.s;
				%s(1),
				handleupdate(s,lbrem);
			        RemoteScriptEditor('EnableDisable',theFig);
			end;
		case 'Strip',
			loadstr = {};
			save_str= {'save(''fromremote'',''s'',''-mat'');'
			   'save(''gotit'',''g'',''-mat'');'};
			strs = lb_getselected(lbrem);
			if length(strs)>0,
		  	   for i=1:length(strs),
				g = char(strs(i));
				if g(end)=='*', g=g(1:end-1);end;
				ts = { [g '=strip(' g ');'] };
				loadstr = cat(1,loadstr,ts);
			   end;
			end;
			loadstr = cat(1,loadstr,update_str);
			loadstr = cat(1,loadstr,save_str);
			b=sendremotecommand(loadstr);
			if b,
				pathn = rempath;
				fname = [pathn 'fromremote'];
				s=load(fname,'-mat'); s = s.s;
				%s(1),
				handleupdate(s,lbrem);
			        RemoteScriptEditor('EnableDisable',theFig);
			end;
		case 'Edit', % should only occur when 1 script is selected
			strs = char(lb_getselected(lb));
			evalin('base',['ScriptObjEditor(''' strs ''');']);
		case 'Duplicate',
                        % should only occur when 1 stimulus is selected
                        namenotfound=1;
                        prompt={'Name of new script:'}; def = {''};
                        dlgTitle = 'New script name...';lineNo=1;
                        while (namenotfound),
                                answ=inputdlg(prompt,dlgTitle,lineNo,def);
				an = char(answ);
                                if isempty(answ), namenotfound = 0; %cancelled
                                elseif isempty(an),
                                   uiwait(errordlg('Syntax error in name'));
				elseif ~isvarname(an), % syntax err
                                   uiwait(errordlg('Syntax error in name'));
                                else, % okay, make the stim
                                   namenotfound = 0;
                                   g = lb_getselected(lbrem); g = char(g);
				   if g(end)=='*', g=g(1:end-1); end;
				   dupstr={[char(answ) '=' g ';']};
			       save_str= {'save(''fromremote'',''s'',''-mat'');'
			                     'save(''gotit'',''g'',''-mat'');'};
				   dupstr=cat(1,dupstr,update_str);
				   dupstr=cat(1,dupstr,save_str);
				   b=sendremotecommand(dupstr);
				   if b,
				     pathn = rempath;
				     fname = [pathn 'fromremote'];
				     s=load(fname,'-mat'); s = s.s;
				     set(lbrem,'Value',[]);
				     handleupdate(s,lbrem);
				     z=geteditor('RemoteScriptEditor');
				     if z,
			               RemoteScriptEditor('EnableDisable',z);
				     end;
				   end;
                                end;
                        end;
		case 'Delete',
			loadstr = {};
			save_str= {'save(''fromremote'',''s'',''-mat'');'
			   'save(''gotit'',''g'',''-mat'');'};
			strs = lb_getselected(lbrem);
			if length(strs)>0,
		  	   for i=1:length(strs),
				g = char(strs(i));
				if g(end)=='*', g=g(1:end-1);end;
				ts = { ['clear ' g ] };
				loadstr = cat(1,loadstr,ts);
			   end;
			end;
			loadstr = cat(1,loadstr,update_str);
			loadstr = cat(1,loadstr,save_str);
			b=sendremotecommand(loadstr);
			if b,
				pathn = rempath;
				fname = [pathn 'fromremote'];
				s=load(fname,'-mat'); s = s.s;
				%s(1),
				set(lbrem,'Value',[]);
				handleupdate(s,lbrem);
			        RemoteScriptEditor('EnableDisable',theFig);
			end;
		case 'EnableDisable'
			strs = lb_getselected(lbloc);
			if length(strs)>0,
				set(scriptedstruct.toremote,'enable','on');
				set(scriptedstruct.toremoteload,'enable','on');
			else,
				set(scriptedstruct.toremote,'enable','off');
				set(scriptedstruct.toremoteload,'enable','off');
			end;
			strs = lb_getselected(lbrem);
			if length(strs)>0,
				if length(strs)==1,
				   set(scriptedstruct.edit,'enable','on');
				   set(scriptedstruct.duplicate,'enable','on');
				else,
				   set(scriptedstruct.edit,'enable','off');
				   set(scriptedstruct.duplicate,'enable','off');
				end;
				set(scriptedstruct.delete,'enable','on');
				set(scriptedstruct.load,'enable','on');
				set(scriptedstruct.unload,'enable','on');
				set(scriptedstruct.strip,'enable','on');
				set(scriptedstruct.fromremote,'enable','on');
			else,
				set(scriptedstruct.delete,'enable','off');
				set(scriptedstruct.edit,'enable','off');
				set(scriptedstruct.load,'enable','off');
				set(scriptedstruct.unload,'enable','off');
				set(scriptedstruct.strip,'enable','off');
				set(scriptedstruct.duplicate,'enable','off');
				set(scriptedstruct.fromremote,'enable','off');
			end;
			%set(scriptedstruct.fromremote,'enable','off');
	end;
end;

function str = update_str
	str = {	'g = listofvars(''stimscript'');'
	'b=zeros(size(g));'
	'for i=1:length(g),'
	'  ch=char(g(i));'
	'  eval([''b(i) = isloaded('' ch '');'']);'
	'end;'
	's=struct(''scripts'',g,''loaded'',b);'};

function handleupdate(s,lbrem)
	strs=cell(length(s),1);
	for i=1:length(s),
	ad = '';
	if s(i).loaded(i), ad = '*'; end;
		strs(i) = { [s(i).scripts ad] };
	end;
	set(lbrem,'Value',[]);
	set(lbrem,'String',strs);
	z=geteditor('RunExperiment');
	if ~isempty(z),
		ud = get(z,'UserData');
		set(ud.rslb,'Value',1);
		set(ud.rslb,'String',strs);
		runexpercallbk('EnDis',z);
	end;

function pathn = rempath
remotecommglobals;
pathn = fixpath(Remote_Comm_dir);

function b= checkremdir;
pathn=rempath;
b = checkremotedir(pathn);

function drawScriptEditor(h0)
sh=00;s2=30;
set(h0,'Units','points', ...
        'Color',[0.8 0.8 0.8], ...
        'MenuBar','none', ...
        'PaperPosition',[18 180 576 432], ...
        'PaperUnits','points', ...
        'Position',[160.8 209.6 676.8000000000001 220], ...
        'Tag','Fig2');
		settoolbar(h0,'none');
h1 = uicontrol('Parent',h0, ...
        'Units','points', ...
        'BackgroundColor',[0.8 0.8 0.8], ...
        'FontSize',16, ...
        'FontWeight','bold', ...
        'HorizontalAlignment','left', ...
        'ListboxTop',0, ...
        'Position',[10.4+sh 152+s2 177.6 26.4], ...
        'String','Remote Script Editor:', ...
        'Style','text', ...
        'Tag','StaticText1');
helpbt = uicontrol('Parent',h0, ...
        'Units','points', ...
        'BackgroundColor',[0.8 0.8 0.8], ...
        'Callback','RemoteScriptEditor Help', ...
        'FontWeight','bold', ...
        'ListboxTop',0, ...
        'Position',[235.2+sh 157.6+s2 91.2 22.4], ...
        'String','Help', ...
        'Tag','Pushbutton1');
deletebt = uicontrol('Parent',h0, ...
        'Units','points', ...
        'BackgroundColor',[0.8 0.8 0.8], ...
        'Callback','RemoteScriptEditor Delete', ...
        'FontWeight','bold', ...
        'ListboxTop',0, ...
        'Position',[553.6+sh 13.6+s2 112.8 20.8], ...
        'String','Delete', ...
        'Tag','Pushbutton1');
editbt = uicontrol('Parent',h0, ...
        'Units','points', ...
        'BackgroundColor',[0.8 0.8 0.8], ...
        'Callback','RemoteScriptEditor Edit', ...
        'FontWeight','bold', ...
        'ListboxTop',0, ...
        'Position',[553.6+sh 35.2+s2 112.8 21.6], ...
        'String','Edit', ...
        'Tag','Pushbutton1');
duplicatebt = uicontrol('Parent',h0, ...
        'Units','points', ...
        'BackgroundColor',[0.8 0.8 0.8], ...
        'Callback','RemoteScriptEditor Duplicate', ...
        'FontWeight','bold', ...
        'ListboxTop',0, ...
        'Position',[553.6+sh 126.4+s2 112 20.8], ...
        'String','Duplicate', ...
        'Tag','Pushbutton1');
stripbt = uicontrol('Parent',h0, ...
        'Units','points', ...
        'BackgroundColor',[0.8 0.8 0.8], ...
        'Callback','RemoteScriptEditor Strip', ...
        'FontWeight','bold', ...
        'ListboxTop',0, ...
        'Position',[553.6+sh 57.6+s2 112 21.6], ...
        'String','Strip', ...
        'Tag','Pushbutton1');
unloadbt = uicontrol('Parent',h0, ...
        'Units','points', ...
        'BackgroundColor',[0.8 0.8 0.8], ...
        'Callback','RemoteScriptEditor Unload', ...
        'FontWeight','bold', ...
        'ListboxTop',0, ...
        'Position',[553.6+sh 80.80000000000001+s2 112.8 22.4], ...
        'String','Unload', ...
        'Tag','Pushbutton1');
loadbt = uicontrol('Parent',h0, ...
        'Units','points', ...
        'BackgroundColor',[0.8 0.8 0.8], ...
        'Callback','RemoteScriptEditor Load', ...
        'FontWeight','bold', ...
        'ListboxTop',0, ...
        'Position',[553.6+sh 104+s2 112 21.6], ...
        'String','Load', ...
        'Tag','Pushbutton1');
updatebt = uicontrol('Parent',h0, ...
        'Units','points', ...
        'BackgroundColor',[0.8 0.8 0.8], ...
        'Callback','RemoteScriptEditor UpdateRem', ...
        'FontWeight','bold', ...
        'ListboxTop',0, ...
        'Position',[552.8000000000001+sh 149.6+s2 112.8 19.2], ...
        'String','Update', ...
        'Tag','Pushbutton1');
lbrem = uicontrol('Parent',h0, ...
        'Units','points', ...
        'BackgroundColor',[1 1 1], ...
        'Callback','RemoteScriptEditor EnableDisable', ...
        'Max',2, ...
        'Position',[336+sh 10.4+s2 211.2 148.8], ...
        'String',{}, ...
        'Style','listbox', ...
        'Tag','Listbox1', ...
        'Value',[]);
h1 = uicontrol('Parent',h0, ...
        'Units','points', ...
        'BackgroundColor',[0.8 0.8 0.8], ...
        'FontWeight','bold', ...
        'ListboxTop',0, ...
        'Position',[348+sh 163.2+s2 177.6 12.8], ...
        'String','Remote', ...
        'Style','text', ...
        'Tag','StaticText2');
lbloc = uicontrol('Parent',h0, ...
        'Units','points', ...
        'BackgroundColor',[1 1 1], ...
        'Callback','RemoteScriptEditor EnableDisable', ...
        'Max',2, ...
        'Position',[10.4+sh 32.8+s2 211.2 111.2], ...
        'String',{}, ...
        'Style','listbox', ...
        'Tag','Listbox1', ...
        'Value',[]);
h1 = uicontrol('Parent',h0, ...
        'Units','points', ...
        'BackgroundColor',[0.8 0.8 0.8], ...
        'FontWeight','bold', ...
        'ListboxTop',0, ...
        'Position',[25.6+sh 145.6+s2 177.6 12.8], ...
        'String','Local', ...
        'Style','text', ...
        'Tag','StaticText2');
h1 = uicontrol('Parent',h0, ...
        'Units','points', ...
        'BackgroundColor',[0.8 0.8 0.8], ...
        'Callback','if geteditor(''ScriptEditor''),figure(geteditor(''ScriptEditor''));else ScriptEditor;end;', ...
        'FontWeight','bold', ...
        'ListboxTop',0, ...
        'Position',[9.600000000000001+sh 10.4+s2 112 18.4], ...
        'String','Local Script Editor', ...
        'Tag','Pushbutton1');
updatelocbt = uicontrol('Parent',h0, ...
        'Units','points', ...
        'BackgroundColor',[0.8 0.8 0.8], ...
        'Callback','RemoteScriptEditor UpdateLoc', ...
        'FontWeight','bold', ...
        'ListboxTop',0, ...
        'Position',[124+sh 9.600000000000001+s2 96.80000000000001 19.2], ...
        'String','Update', ...
        'Tag','Pushbutton1');
toremotebt = uicontrol('Parent',h0, ...
        'Units','points', ...
        'BackgroundColor',[0.8 0.8 0.8], ...
        'Callback','RemoteScriptEditor Toremote', ...
        'FontWeight','bold', ...
        'ListboxTop',0, ...
        'Position',[252+sh 105.6+s2 65.60000000000001 22.4], ...
        'String','-->', ...
        'Tag','Pushbutton1');
toremoteloadbt = uicontrol('Parent',h0, ...
        'Units','points', ...
        'BackgroundColor',[0.8 0.8 0.8], ...
        'Callback','RemoteScriptEditor Toremoteload', ...
        'FontWeight','bold', ...
        'ListboxTop',0, ...
        'Position',[252+sh 125.6+s2 65.6 22.4], ...
        'String','-->+load', ...
        'Tag','Pushbutton1');
fromremotebt = uicontrol('Parent',h0, ...
        'Units','points', ...
        'BackgroundColor',[0.8 0.8 0.8], ...
        'Callback','RemoteScriptEditor Fromremote', ...
        'FontWeight','bold', ...
        'ListboxTop',0, ...
        'Position',[251.2+sh 72+s2 65.60000000000001 22.4], ...
        'String','<--', ...
        'Tag','Pushbutton1','Callback','RemoteScriptEditor Tolocal');
h1 = uicontrol('Parent',h0, ...
        'Units','points', ...
        'BackgroundColor',[0.8 0.8 0.8], ...
        'FontWeight','bold', ...
        'ListboxTop',0, ...
        'Position',[9.6+sh 8 96.8 19], ...
        'String','Remote directory:', ...
        'Style','text', ...
        'Tag','StaticText2');
global Remote_Comm_dir;
remdirctl = uicontrol('Parent',h0, ...
        'Units','points', ...
        'BackgroundColor',[1 1 1], ...
        'FontWeight','bold', ...
        'ListboxTop',0, ...
        'Position',[124+sh 10 300 19], ...
        'String',Remote_Comm_dir, ...
        'Style','edit', ...
        'Tag','StaticText2');
set(h0,'UserData',struct('lbloc',lbloc,'update',updatebt,'help',helpbt,...
	'load',loadbt,'lbrem',lbrem,...
	'edit',editbt,'delete',deletebt, ...
	'unload',unloadbt,'strip',stripbt,'duplicate',duplicatebt,'tag',...
	'RemoteScriptEditor','updateloc',updatelocbt,'toremoteload',toremoteloadbt,'toremote',toremotebt,...
	'fromremote',fromremotebt,'remdir',remdirctl));
