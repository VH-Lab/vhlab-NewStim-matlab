function [stimscripttimestructlist] = DemultiplexScriptMTI(the_stimscripttimestruct, paramname);
% DEMULTIPLEXSCRIPTMTI - Returns a script/MTI with a subset of specified stimuli
%
%   [STIMSCRIPTTIMESTRUCTLIST,PARAMVALS,...] =
%      DEMULTIPLEXSCRIPTMTI(THE_STIMSCRIPTTIMESTRUCT, PARAMNAME)
%
%   "Demultiplexes" a STIMSCRIPTTIMESTRUCT (THE_STIMSCRIPTTIMESTRUCT) where many
%   parameters are co-varied. PARAMNAME is the parameter that is demultiplexed;
%   all stimuli that have PARAMNAME are identified, and then a new
%   STIMSCRIPTTIMESTRUCT is created for each of the values of PARAMNAME that are
%   encountered. These STIMSCRIPTTIMESTRUCTs are returned as 1xN list STIMSCRIPTTIMESTRUCTLIST.
%
%   See also: STIMSCRIPTTIMESTRUCT

paramvalues = [];
paramstimlist = [];

myscript = the_stimscripttimestruct.stimscript;
mymti = the_stimscripttimestruct.mti;

 % step 1: find all the stims that have the parameter and have a value for that parameter

for i=1:numStims(myscript),
	stim = get(myscript,i);
	params = getparameters(stim);
	if isfield(params,paramname), % do we have the field?
		paramvalues(end+1) = getfield(params,paramname);
		paramstimlist(end+1) = i;
	end;
end;

unique_values = unique(paramvalues);

stimscripttimestructlist = struct('stimscript','','mti','');
stimscripttimestructlist = stimscripttimestructlist([]);

for i=1:length(unique_values),
	indvalues = find(paramvalues==unique_values(i));
	stims_to_include = paramstimlist(indvalues);
	[newscript,dummy,newmti] = DecomposeScriptMTI(myscript,mymti,stims_to_include);
	stimscripttimestructlist(end+1) = stimscripttimestruct(newscript,newmti);
end;
