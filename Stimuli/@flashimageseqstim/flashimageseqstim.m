function [fis] = flashimageseqstim(FISp, OLDSTIM)

% [FIS] = FLASHIMAGESEQSTIM(FISp)
%
%  Flashes a sequence of images on the screen according to user
%  parameters.  The parameters FISp can either be the string
%  'graphical' (in which case the user is prompted for the
%  remaining parameters), the string 'default' (in which case 
%  default parameter values are used) or it can be a structure
%  as described below.  
%
%  One may also use
%    
%  [FIS] = FLASHIMAGESEQSTIM('graphical',OLDFIS)
%
%  which will offer the parameters of OLDFIS as the initial values
%  for FIS.
%
%  The parameters for the FISp structure are as follows:
%
%  repeat -          1x1  Number of times to repeat each sequence.
%  repeat_interval - 1x1  Number of seconds to pause between sequence repeats
%  BG -              1x3  RGB color of the background.
%  dirname -         1xN  Character array with full directory name where
%                             images will be read; these images will be
%                             read in alphabetical order.
%  onsets -          1xM  Onset times for each image in the sequence (seconds)
%  durations -       1xM  Duration times for each image (in seconds)
%  rect -            1x4  The rectangle on the screen where the stimulus
%                             should be shown.
%                         Use [topleft_x topleft_y botright_x botright_y].
%  intensity         1x1  0-1 (the image is multiplied by this value to reduce intensity)
%  dispprefs -            cell displayprefs options (or use '{}' for defaults)
%
%                              Questions to vanhoosr@brandeis.edu

if nargin==0,
	fis = flashimageseqstim('default');
	return;
end;

default_dirname = [NewStimPath 'Stimuli' filesep 'default_files' filesep 'flashimageseqstim_images'];

default_p = struct('repeat',5,'repeat_interval',0.2-2*0.0167,'dirname',default_dirname, ...
		'BG',0*[1 1 1], 'onsets',[0 0.0167],'durations',[0.0167 0.0167],...
		'rect',[000 000 800 600],'intensity',1);
default_p.dispprefs = {};

finish = 1;

if nargin==1,oldstim=[]; else, oldstim = OLDSTIM; end;

if ischar(FISp),
	if strcmp(FISp,'graphical'),
		if isempty(oldstim),
			p = get_graphical_input(flashimageseqstim('default'));
		else,
			p = get_graphical_input(oldstim);
		end;
		if isempty(p), finish = 0; else, FISp = p; end;
	elseif strcmp(FISp,'default'),
		FISp = default_p;
	else,% there is an error
		error('Unknown string input to flashimageseqstim.');
	end;
else, % a structure
	[good,errormsg]=verify(FISp);
	if ~good,error(['Could not create flashimageseqstim: ' errormsg]);end;
end;

if finish,
	s = stimulus(5);
        fisp = struct('params',FISp);
        fisp.dispprefs = FISp.dispprefs;
	% had to fix b/c matlab is fussy about order of parameters
	fis = class(fisp,'flashimageseqstim',s);
	fis.stimulus = setdisplayprefs(fis.stimulus,displayprefs(FISp.dispprefs));
else,
	fis = [];
end;

