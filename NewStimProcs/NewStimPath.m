function thepath = NewStimPath
% NewStimPath - returns the directory path location of the NewStim package
%
%   THEPATH = NEWSTIMPATH
%
%   Returns the pathname of the NewStim package

thepath = which('NewStimInit');
pi = find(thepath==filesep);
thepath = [thepath(1:pi(end)-1) filesep];
