function b = sendremotecommand(strs, number)

%  Part of the NewStim package
%  B = SENDREMOTECOMMAND(STRS)
%
%  Sends a command to a remote machine. The remote directory is checked for
%  existance, and, if it doesn't exist, an error is given.  Otherwise, the
%  command given in STRS (which should be a cellstr array of strings) is copied
%  to the remote computer.  A "Please Wait" dialog is given while the local
%  computer waits for a response from the remote computer.  The user may cancel
%  this waiting by clicking "Cancel".
%
%   B is 1 if the command was received and processed correctly, and 0 otherwise.
%   Note that the 0 condition can arise if there is an error on the remote
%   machine or if the user pressed cancel.
%
%  The script that is provided should include the line 'save gotit -mat' or
%  equivilent because SENDREMOTECOMMAND checks for the existence of 'gotit'
%  to indicate the script has finished on the remote machine.
%
%  If the remote script generates a file called 'fromremote' in its remote
%  directory, then 'fromremote' is transferred to the remote directory on
%  the calling computer.  If the remote communication method is 'filesystem'
%  then this step is performed automatically by the filesystem.  A more
%  transparent way of transferring this data is to use SENDREMOTECOMMANDVAR.
%
%  B = SENDREMOTECOMMAND(STRS,NUMBER) will modify all the files so they are
%  FNAME_NUMBER (e.g., 'fromremote_NUMBER'), so that the user can communicate
%  with many computers.
%
%   See also:  REMOTECOMM, SENDREMOTECOMMANDVAR

if nargin>1,
	nstr = ['_' int2str(number)];
else,
	nstr = '';
end;


remotecommglobals;

b = 0; errorflag = 0;
if checkremotedir(Remote_Comm_dir), % directory exists
	if exist([fixpath(Remote_Comm_dir) 'gotit' nstr])==2,
		delete([fixpath(Remote_Comm_dir) 'gotit']); end;
	if exist([fixpath(Remote_Comm_dir) 'fromremote' nstr])==2,
        	delete([fixpath(Remote_Comm_dir) 'fromremote' nstr]); end;
	if exist([fixpath(Remote_Comm_dir) 'scripterror' nstr])==2,
		delete([fixpath(Remote_Comm_dir) 'scripterror' nstr]); end;
	if nargin>1,
		b = writeremote(strs,number);
	else,
		b = writeremote(strs);
	end;
	if b,
		pathn=fixpath(Remote_Comm_dir);
		fname = [pathn 'gotit' nstr];
		fnameerror = [pathn 'scripterror' nstr];
		g = msgbox('Please wait', 'Please wait');
		x = findobj(g,'Style','PushButton');
		set(x,'String','Cancel');
		drawnow;
		dowait(1);
		cd(pwd); % flush file info
		scriptdone = 0;
		while (~scriptdone&ishandle(g)),
			dowait(1);
			drawnow;
			if strcmp(Remote_Comm_method,'filesystem'),
				cd(pwd); % flush file info
				errorflag = exist(fnameerror);
				scriptdone = exist(fname)|errorflag;
				if errorflag,
					load(fnameerror,'-mat');
					errordlg(['Error: remote script failed with error ' errorstr '.']);
				end;
			elseif strcmp(Remote_Comm_method,'sockets'),
				pnet(Remote_Comm_conn,'setreadtimeout',0.1);
				str=pnet(Remote_Comm_conn,'readline'),
				if length(str)>=11&strcmp(str(1:11),'SCRIPT DONE'),
					scriptdone = 1;
					pnet(Remote_Comm_conn,'setreadtimeout',5);
					str = '';
					B = 0;
					while ~B,
						str = pnet(Remote_Comm_conn,'readline');
						if length(str>=12)&strcmp(str(1:12),'RECEIVE FILE'),
							[sz,dum1,dum2,ind] = sscanf(str,'RECEIVE FILE %d',1);
							recvname = str(ind+1:end); % maybe end-1
							fprintf(['Preparing to receive file ' recvname '.\n']);
							pnet(Remote_Comm_conn,'readtofile',[pathn recvname],sz);
						end;
						A = length(str)>=13;
						if A, B=strcmp(str(1:13),'TRANSFER DONE');else, B=0;end;
					end;
					pnet(Remote_Comm_conn,'close');
				elseif length(str)>=12&strcmp(str(1:12),'SCRIPT ERROR'),
					errordesc = str(14:end);
					errordlg(['Error: remote script failed with error ' errordesc '.']);
					scriptdone = 1; errorflag = 1;
					pnet(Remote_Comm_conn,'close');
				end;
			end;
		end;
                if ishandle(g), delete(g); end;
                b=scriptdone&~errorflag;
	end;
end;

if b|errorflag, try, delete([fixpath(Remote_Comm_dir) filesep 'runit' nstr '.m']); end; end;
