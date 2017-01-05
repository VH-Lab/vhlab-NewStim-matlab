function [stim_values, do] = stimscript2stimvalues(s, param)
% STIMSCRIPT2STIMVALUES - Return stimulus values from all stims in a stimulus script
%
%  [STIM_VALUES, DO] = STIMSCRIPT2STIMVALUES(S, PARAM)
%
%  Given a stimscript S, this function examines the display order
%  and records the stimulus parameter value of PARAM for each stimulus
%  that is to be presented (or was presented). The display order of the
%  stimuli is given in DO. 
%
%  If a stimulus has a parameter 'isblank' that is set to 1, then
%  NaN is returned as the stimulus value for that stim.
%
%  If a stimulus has no parameter named 'PARAM' then NaN is returned.
%  
%  See also: MTI2STIMTIMES, GETDISPLAYORDER
%

stim_values = [];
do = getDisplayOrder(s);

for i=1:length(do),
	p = getparameters(get(s,do(i)));
	if isfield(p,'isblank'),
		if p.isblank==1,
			stim_values(i) = NaN;
		end;
	elseif isfield(p,param),
		stim_values(i) = getfield(p,param);
	else,
		stim_values(i) = NaN;
	end;
end;

