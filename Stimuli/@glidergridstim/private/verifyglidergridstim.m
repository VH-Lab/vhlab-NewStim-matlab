function [good, errormsg] = verifyglidergridstim(parameters)
% VERIFYGLIDERGRIDSTIM - Verify that a parameter set for the GLIDERGRIDSTIM are valid
%
%   [GOOD,ERRORMSG] = VERIFYGLIDERGRIDSTIM(PARAMETERS)
%
%   Returns GOOD = 1 if the PARAMETERS are valid; otherwise GOOD = 0
%   If GOOD==0, then an ERRORMSG describing the problem is returned in ERRORMSG.
%

proceed = 1;
errormsg = '';

if proceed,
	% check that all arguments are present and appropriately sized
	fieldNames = {'BG','FG1','FG2','correlator','correlator_sign','rect','pixSize','N','randState'};
        fieldSizes = {[1 3],[1 3],[1 3],[1 1],[1 1],[1 4],[1 2],[1 1],[35 1]}; 
	[proceed,errormsg] = hasAllFields(parameters, fieldNames, fieldSizes);
	if proceed,
            proceed = isfield(parameters,'dispprefs');
            if ~proceed, errormsg = 'no displayprefs field.'; end;
        end;
end;

if proceed,
	% check rect, pixSize args
	if ~isa(parameters.dispprefs,'cell'),
		errormsg = 'dispprefs must be a list/cell.';
		proceed = 0;
	else,
		width  = parameters.rect(3) - parameters.rect(1);
		height = parameters.rect(4) - parameters.rect(2);

        	x = parameters.pixSize(1); y = parameters.pixSize(2);
        	if (x>=1), X = x; else, X = width * x; end;
        	if (y>=1), Y = y; else, Y = height * y; end;
        	proceed = (fix(width/X)==width/X) & (fix(height/Y)==height/Y);
		if ~proceed,
			errormsg = 'Grid square size specified does not _exactly_ cover area.';
		end;
	end;
end;

if proceed,
	% check colors
	f = find(parameters.BG<0|parameters.BG>255);
	if f, proceed = 0; errormsg = 'R,G,B in BG must be in [0..255]'; end;
	f = find(parameters.FG1<0|parameters.FG1>255);
	if f, proceed = 0; errormsg = 'R,G,B in FG1 must be in [0..255]'; end;
	f = find(parameters.FG2<0|parameters.FG2>255);
	if f, proceed = 0; errormsg = 'R,G,B in FG2 must be in [0..255]'; end;
end;

if proceed,
	if (parameters.correlator<0 | parameters.correlator>5),
		proceed = 0; errormsg = 'correlator must be between 0 and 5';
	end;
end;

if proceed,
	if ~(parameters.correlator_sign==-1 | parameters.correlator_sign==1)
		proceed = 0; errormsg = 'correlator_sign must be -1 or 1';
	end;
end;

if isfield(parameters,'angle'),
	if ~isnumeric(parameters.angle), proceed = 0; errormsg = 'angle must be a number.'; end;
end;

if proceed,
	if parameters.fps<=0, proceed = 0; errormsg = 'fps must be positive.';
	elseif parameters.N<=0, proceed = 0; errormsg = 'N must be positive.';
	end;
end;

if proceed, % check displayprefs for validity
	try, dummy = displayprefs(parameters.dispprefs);
	catch, proceed = 0; errormsg = ['dispprefs invalid: ' lasterr];
	end;
end;

good = proceed;
