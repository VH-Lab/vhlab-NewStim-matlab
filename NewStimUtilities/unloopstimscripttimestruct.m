function newstimscripttimestruct = unloopstimscripttimestruct(the_stimscripttimestruct)
% UNLOOPSTIMSCRIPTTIMESTRUCT - Remove 'loop' information from periodicstims in a script
%
%   NEWSTIMSCRIPTTIMESTRUCT = UNLOOPSTIMSCRIPTTIMESTRUCT(THE_STIMSCRIPTTIMESTRUCT)
%
%   Removes loop information from periodicstims in a STIMSCRIPT and associated MTI
%   that are contained in THE_STIMSCRIPTTIMESTRUCT (see STIMSCRIPTTIMESTRUCT).
%   The 'loop' parameter is set to 0 in the script, and the MTI is updated so the
%   stimulus appeared to have only the duration of the first loop.
%

myscript = the_stimscripttimestruct.stimscript;
mymti = the_stimscripttimestruct.mti;

do = getDisplayOrder(myscript);

for i=1:numStims(myscript),
	stim = get(myscript,i);
	if isa(stim,'periodicstim'),
		params = getparameters(stim);
		if isfield(params,'loops'),
			if params.loops>0,
				fraction_to_cut = params.loops/(params.loops+1);
				fraction_to_leave = 1-fraction_to_cut;
				params.loops = 0;
				newstim = periodicstim(params);
				myscript = set(myscript,newstim,i);
				mti_indexes = find(do==i);
				for j=1:length(mti_indexes),
					stim_meat_duration = diff(mymti{mti_indexes(j)}.startStopTimes(2:3));
					new_stim_meat_duration = stim_meat_duration * fraction_to_leave;
					stim_post_background = diff(mymti{mti_indexes(j)}.startStopTimes(3:4));
					mymti{mti_indexes(j)}.startStopTimes(3) = mymti{mti_indexes(j)}.startStopTimes(2)+...
						new_stim_meat_duration;
					mymti{mti_indexes(j)}.startStopTimes(4) = mymti{mti_indexes(j)}.startStopTimes(3)+...
						stim_post_background;
				end;
			end;
		end;
	end;
end;

newstimscripttimestruct = stimscripttimestruct(myscript,mymti);
