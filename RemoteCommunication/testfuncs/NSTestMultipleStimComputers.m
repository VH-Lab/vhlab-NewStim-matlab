function NSTestMultipleStimComputers(number, saveit, ds)
% NSTESTMULTIPLESTIMCOMPUTERS - A short test script to try running stims on multiple computers
%  
%   NSTESTMULTIPLESTIMCOMPUTERS(NUMBER, SAVEIT, DS)
%
%   Tests running a stimulus on a remote computer.
%
%   Inputs:
%       NUMBER: The stimulus is run on stimulus computer NUMBER.
%       SAVEIT: Should we save the record 0/1 (1 is save)
%           DS: A directory structure (DIRSTRUCT) that manages the experiment directory.
%
%   DS is the DIRSTRUCT record

mypath = []; myname = []; myremotepath = [];

if saveit,
	mynewdirname = [getpathname(ds) filesep newtestdir(ds)];
	[mypath,myname] = fileparts(mynewdirname);
	myremotepath = (localpath2remote(mypath));
end;


priority = 1;
abortable = 1;

thescript_alt = append(stimscript(0),periodicstim('default'));

str_alt = {     'save gotit_1 abortable -mat;'
            'thescript_alt = loadStimScript(thescript_alt);'
            'mti=DisplayTiming(thescript_alt);'
            'stimorder_alt = getDisplayOrder(thescript_alt);'
            '[MTI2,start]=DisplayStimScript(thescript_alt,mti,priority,abortable);'
            'saveScript = strip(unloadStimScript(thescript_alt));'
            'MTI2 = stripMTI(MTI2);'
            'try, snd(''play'',''glass'');snd(''play'',''glass'');snd(''play'',''glass''); catch, beep; pause(0.5); beep; pause(0.5); beep; end;'
            'if saveit, disp([''saving now, to '' fixpath(myremotepath) myname filesep ''stims_alt.mat'']); end;'
            'if saveit, try, mkdir(myremotepath,myname); end; save([fixpath(myremotepath) myname filesep ''stims_alt.mat''],''saveScript'',''start'',''MTI2'',''-mat''); end;'
        };

[b] =sendremotecommandvar(str_alt,...
	{'thescript_alt','priority','abortable','saveit','mypath','myname','myremotepath'}, ...
	{thescript_alt,priority,abortable,saveit,mypath,myname,myremotepath},1);

