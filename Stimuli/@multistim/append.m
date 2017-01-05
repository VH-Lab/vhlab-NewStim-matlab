function newms = append(ms,varargin)

%  APPEND - add stimuli to a MULTISTIM object
%
%    NEWMS = APPEND(THEMS, THESTIM, [THESTIM2,...])
%
%  Adds stimuli to the list of stimuli to be composed in a MULTISTIM stimulus
%  object.  The new MULTISTIM object is returned in NEWMS.  One may add
%  more than one stimulus by providing additional arguments.
%
%  See also: MULTISTIM, MULTISTIM/GET, MULTISTIM/SET,
%            MULTISTIM/SETCLUTINDEX

for i=1:length(varargin),
	if isa(varargin{i},'stimulus'),
		ms.stimlist{end+1} = varargin{i};
	else, error(['Error: stimulus number ' int2str(i) ' to be appended isn''t a stimulus.']);
	end;
end;
newms = ms;
