function [stimtimes_on, stimtimes_off] = mti2stimonoff(mti, useframes)
% MTI2STIMONOFF - Return stim ON and OFF times from an MTI
%
%  [STIMTIMES_ON, STIMTIMES_OFF] = MTI2STIMONOFF(MTI)
%
%  Given an MTI record from a set of stimuli that were run, 
%  this function extracts the stim start and end times.
%  STIMTIMES_ON is a list of all the stimulus onsets and
%  STIMTIMES_OFF is a list of all the stimulus offsets.
%
%  One can also use the form:
% 
%  [STIMTIMES_ON, STIMTIMES_OFF] = MTI2STIMONOFF(MTI, USEFRAMES)
%  
%  If USEFRAMES is 1, then the end of the stimulus is taken to be the
%  the final frametrigger plus the length of the median frame interval.
%
%  See also: DISPLAYTIMING, STIMSCRIPT2STIMVALUES
%

stimtimes_on = [];
stimtimes_off = [];

if nargin>1,
	frame = useframes;
else,
	frame = 0;
end;

for i=1:length(mti),
	stimtimes_on(i) = mti{i}.startStopTimes(2);
	if frame,
		df = median(diff(mti{i}.frameTimes));
		if isnan(df), % no frame information, fall back to startStopTimes
			stimtimes_off(i) = mti{i}.startStopTimes(3);
		else,
			stimtimes_off(i) = mti{i}.frameTimes(end)+df;
		end;
	else,
		stimtimes_off(i) = mti{i}.startStopTimes(3);
	end;
end;

