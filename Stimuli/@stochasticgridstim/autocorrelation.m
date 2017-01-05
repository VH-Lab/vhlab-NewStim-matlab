function [xc_stimstim] = autocorrelation(sgs, si, maxlag, forcetheory)
% AUTOCORRELATION - Produce the autocorrelation of a STOCHASTICGRIDSTIM
%
%  [XC_STIMSTIM] = AUTOCORRELATION(SGS, SI, MAXLAG, FORCETHEORY)
%
%  Produces the autocorrelation for a STOCHASTICGRIDSTIM at 
%  a given signal sampling interval SI.
%
%  Inputs:
%     SGS - The STOCHASTICGRIDSTIM stimulus object
%     SI  - The sampling interval at which data will be acquired
%     MAXLAG - The largest sample lag over which to calculate the autocorrelation
%     FORCETHEORY - Optional (default value 0). This will examine whether
%                   the parameters the SGS match a known template, and,
%                   in this case, the theoretical autocorrelation will be
%                   returned instead of the empirical autocorrelation.
%                   If the parameters do not match a known template, then 
%                   EMPTY is returned for XC_STIMSTIM.
%  Outputs:
%     XC_STIMSTIM - The autocorrelation of the stimulus with itself.
%                   Each column contains the autocorrelation for a different
%                   grid position.  We assume that adjacent bins are independent
%                   (should be true for a zero-mean stimulus).
%

xc_stimstim = [];

p = getparameters(sgs);

if nargin<4,
	forcetheory = 0;
end;

if forcetheory==0,
	error(['Empirical autocorrelation not yet implemented (darn deadlines).']); 
end;

if forcetheory,
	% this isn't very smart...deadline...
	%warning('Programmer note: make better recognition of these states');
	if eqlen(size(p.values),[3 3]),
		udist = unique(p.dist);
		if length(udist)==2,
			for j=1:2,
				if sum([p.dist==udist(j)])==2,
					alpha = p.dist(j);
				end;
			end;
			% si - units signal sample interval (seconds per signal sample)
                        % fps - stimulus frames per second
                        %  (1/si) / fps = signal samples / stimulus frame
			signal_samples_per_frame = (1/si) / p.fps;
			n = 0:maxlag;
			xc_stimstim = step_autocorrelation(alpha, signal_samples_per_frame, n);
			[x,y]=getgrid(sgs);
			xc_stimstim = repmat(xc_stimstim(:),1,x*y); % 1 column per grid position
		end;
	end;
end;
