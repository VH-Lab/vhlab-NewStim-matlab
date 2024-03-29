% prior to running, user needs to:
%   turn off screen saver
%   put computer into 256 colors
%   set screen res
%   mount any other necessary computers

if 0,
	addpath([pwd 'commands']);
	applescript('helloIgor.applescript');
end;

close all;
NewStimInit;
remotecommglobals;
ReceptiveFieldGlobals;

if (Remote_Comm_isremote&haspsychtbox),
	CloseStimScreen;
   	ShowStimScreen;

	quickRFmap;

	NewStimGlobals;
	NewStimTriggeredStimPresentation = 0;

	warmupps=periodicstim('default');
	warmup = stimscript(0);
	warmup=append(warmup,warmupps);
	warmup=loadStimScript(warmup);
	MTI=DisplayTiming(warmup);
	DisplayStimScript(warmup,MTI,0,0);
end;

theDir=Remote_Comm_dir;
cd(theDir);
if exist('runit.m')==2, delete runit.m, end;

switch Remote_Comm_method,

case 'filesystem',
	while 1,  % needs control-C to exit
		pause(2);
		clc;
		cd(theDir); % refresh file directory
		disp('Waiting for remote commands...press COMMAND-PERIOD (APPLE-.) to interrupt.');
	
		errorflag = 0;
		txt = checkscript('runit.m');
		if ~isempty(txt),
			try,
				eval(txt);
			catch,
				errorflag = 1;
				errorstr = lasterr;
				inds = find(errorstr==sprintf(Remote_Comm_eol)); errorstr(inds) = ':';
				save scripterror errorstr -mat
				disp(['Error in script: ' errorstr '.']);
			end;
			cd(theDir);
			disp('Ran file, deleting...');
			delete runit.m;
			if exist('toremote')==2, delete('toremote'); end;
		end;
	end;
case 'sockets',
	pnet('closeall');
	while 1, % needs control-C to exit
		if exist('fromremote')==2, delete('fromremote'); end;
		if exist('toremote')==2, delete('toremote'); end;
		if exist('gotit')==2, delete('gotit'); end;
		fprintf('Reseting sockets.\n');
		pnet('closeall');
		sockcon = pnet('tcpsocket',Remote_Comm_port);
		if sockcon >= 0,
			Remote_Comm_conn = pnet(sockcon,'tcplisten'); % will wait here until connected
		else, 
			error(['Could not open socket on port ' int2str(Remote_Comm_port) '.']);
		end;
		fprintf('Received remote connection, awaiting commands.\n');
		scriptdone = 0; errorflag = 0;
		tic;
		while ~scriptdone,
			t = toc;
			pnet(Remote_Comm_conn,'setreadtimeout',10);
			str = pnet(Remote_Comm_conn,'readline');
			if length(str)>1, str, end;
			if length(str) == 0 & toc>30, scriptdone = 1; % if no response in 30s, assume none coming
			elseif strcmp(str,'PING'),
				fprintf(['Writing PONG.\n']);
				pnet(Remote_Comm_conn,'printf',['PONG' Remote_Comm_eol]);
				scriptdone = 1;
			elseif length(str)>=12&strcmp(str(1:12),'RECEIVE FILE'),
				fprintf('Preparing to receive file.\n');
				[B,dum1,dum2,ind]=sscanf(str,'RECEIVE FILE %d',1);
				recvname = str(ind+1:end),
				pnet(Remote_Comm_conn,'readtofile',recvname,B);
				tic;
			elseif length(str)>=11&strcmp(str(1:11),'RUN SCRIPT '),
				errorflag = 0;
				errorstr = '';
				fprintf('Received RUN SCRIPT command\n');
				txt = checkscript(str(12:end));
				if ~isempty(txt),
					try,
						eval(txt);
						disp(['Eval successful.']);
					catch,  
						disp(['Script error!']);
						errorflag = 1;
						errorstr = lasterr;
					end;
					cd(theDir);
					disp('Ran file, deleting...');
					delete runit.m;
				end;
				if ~errorflag&~isempty(txt),
					pnet(Remote_Comm_conn,'setwritetimeout',5);
					pnet(Remote_Comm_conn,'printf',['SCRIPT DONE' Remote_Comm_eol]);
					if exist('gotit')==2,
						d = dir('gotit');
						pnet(Remote_Comm_conn,'setwritetimeout',5);
						pnet(Remote_Comm_conn,'printf',...
						['RECEIVE FILE %d gotit' Remote_Comm_eol],d.bytes);
						pnet(Remote_Comm_conn,'writefromfile','gotit');
						delete('gotit');
					end;
					if exist('fromremote')==2,
						fprintf('Preparing to write fromremote.\n');
						d = dir('fromremote');
						pnet(Remote_Comm_conn,'setwritetimeout',5);
						pnet(Remote_Comm_conn,'printf',...
							['RECEIVE FILE %d fromremote' Remote_Comm_eol],d.bytes);
						pnet(Remote_Comm_conn,'writefromfile','fromremote');
					end;
					pnet(Remote_Comm_conn,'setwritetimeout',5);
					pnet(Remote_Comm_conn,'printf',['TRANSFER DONE' Remote_Comm_eol]);
					scriptdone = 1;
				else,
					disp(['Script failed with error ' errorstr]);
					inds = find(errorstr==sprintf(Remote_Comm_eol)); errorstr(inds) = ':';
					pnet(Remote_Comm_conn,'setwritetimeout',5);
					pnet(Remote_Comm_conn,'printf',['SCRIPT ERROR ' errorstr Remote_Comm_eol]);
					scriptdone = 1;
				end;
			end;
		end;
	end;
end;
