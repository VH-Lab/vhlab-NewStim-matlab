function colors = pscolors(Hstim)
% PSCOLORS - the colors for a periodicstim /Hartley stimulus
%
%   COLORS = PSCOLORS(PSSTIM)
%
%    Returns the background, backdrop, and max
%    offset high and max offset low colors for a
%    periodicstim.
%
%    The values are returned on a 0-1 "luminance" scale
%    as well as in RGB.
%
% See also: PERIODICSTIM
%
 
Hparams = Hstim.Hparams;
  
midpoint = Hparams.background;
maxOffset = min ( (abs(1-midpoint)), abs(midpoint) );
darkoffset = -maxOffset*Hparams.contrast; % "luminance" of darkest shade
lightoffset = +maxOffset*Hparams.contrast; % "luminance" of brightest shade

middle_rgb = Hparams.chromlow+(Hparams.chromhigh-Hparams.chromlow)*midpoint;
low_rgb = middle_rgb + (Hparams.chromhigh-Hparams.chromlow)*darkoffset;
high_rgb = middle_rgb + (Hparams.chromhigh-Hparams.chromlow)*lightoffset;

if size(Hparams.backdrop,2)==1,
	backdropRGB = Hparams.chromlow+(Hparams.chromhigh-Hparams.chromlow)*Hparams.backdrop;
elseif size(Hparams.backdrop,2)==3,
	backdropRGB = Hparams.backdrop;
else,
	error(['Unknown value for backdrop ' mat2str(Hparams.backdrop) '.']);
end;

clear Hparams Hstim;

colors = workspace2struct;
