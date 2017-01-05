function F = findtransitions(SG, colors_from, colors_to, tolerance)
% FINDTRANSITIONS - Find transitions between specific colors for STOCHASTICGRIDSTIM
%
%  F = FINDTRANSITIONS(SG, COLORS_FROM, COLOR_TO)  or
%  F = FINDTRANSITIONS(SG, COLORS_FROM, COLOR_TO, TOLERANCE)
%
%  For a STOCHASTICGRIDSTIMULUS SG, finds frame numbers that correspond to a
%  transition from any of one set of colors COLORS_FROM to any of another
%  set of colors COLOR_TO. COLORS_FROM and COLOR_TO should contain
%  1 set of RGB values in each row. These RGB values should run from 0 to 255.
%
%  F{i} has the frame numbers that correspond to these transitions for grid number i. The
%  second frame (the that completes the transition) is the frame that is reported.
%
%  The transition from the background color at the beginning of the stimulus is included.
%
%  If TOLERANCE is provided, then any color that is within TOLERANCE (euclidean
%  distance) is counted as matching COLORS_FROM or COLORS_TO. By default, TOLERANCE is 0.
%
%  Example:  % Find all black to white transitions
%	sgs = stochasticgridstim('default');
%       colors_from = [ 0 0 0 ]; % black
%       colors_to   = [ 255 255 255 ]; %white
%       F = findtransitions(sgs,colors_from,colors_to);
%
%  See also: GETGRID, GETGRIDVALUES, GETGRIDPOSITIONS
%

if nargin<4,
	tolerance = 0;
end;  

 % step 1 - set up output variable

[X,Y] = getgrid(SG);

F = cell(X*Y,1);

 % step 2 - find which grid index values, if any, correspond to COLORS_FROM, COLORS_TO

p = getparameters(SG);
colors = p.values;
colors(end+1,:) = p.BG;
V = [size(colors,1)*ones(X*Y,1) getgridvalues(SG)]; % include background transition first

colors_to_ind = [];
for i=1:size(colors_to,1)  % this could be vectorized 1 more step
	best_match = Inf;
	for j=1:size(colors,1),
		dist =  norm(colors(j,:)-colors_to(i,:));
		if dist<=tolerance, % we have a match
			colors_to_ind(end+1) = j;
		end;
	end;
end;

colors_from_ind = [];
for i=1:size(colors_from,1)  % this could be vectorized one more step
	best_match = Inf;
	for j=1:size(colors,1),
		dist =  norm(colors(j,:)-colors_from(i,:));
		if dist<=tolerance, % we have a match
			colors_from_ind(end+1) = j;
		end;
	end;
end;

  % step 3 - now find all transitions from one to the other

is_to_color = ismember(V,colors_to_ind);
is_from_color = ismember(V,colors_from_ind);

transitions = is_from_color(:,1:end-1) & is_to_color(:,2:end);

  % report this back 

for i=1:X*Y,
	F{i} = find(transitions(i,:));
end;


