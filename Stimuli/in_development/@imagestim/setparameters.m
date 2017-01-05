function s = setparameters(S,p)

%  SETPARAMETERS - Set the parameters for imagestim
%
%  NEWIS = SETPARAMETERS(IS,P)
%
%  Sets the parameters of IS to P.  The loaded status is preserved.
%  See IMAGESTIM for a description of these parameters.
%
%  See also:  IMAGESTIM, GETPARAMETERS, STIMULUS/SETPARAMETERS

default_p = struct('rect',[0 0 200 200], 'BG',[128 128 128],...
	'filename','','maskfile','','duration',1,'dispprefs',{{}});

if isempty(p),
    par = default_p;
else,
    [b,ermsg] = verifyimagestim(p);
    %if b, error(['Error in imagestim parameters: ' ermsg]); end;
    par = p;
end;

sr = 0;
s = S;
oldp = getparameters(S);
if ~isempty(oldp),
	if oldp ~= p,
		sr = 1;
	end;
else, sr = 1;
end;

if sr, % must set and reload
    l = isloaded(S);
    if l, S = unloadstim(S); end;
    S.ISparams = par;
    dp = getdisplayprefs(S);
    if isempty(dp),
            dp=displayprefs({'fps',120,'rect',par.rect,'frames',1,...
            par.dispprefs{:}});
    else, dp=setvalues(dp,{'fps',120,'rect',par.rect,'frames',1,...
            par.dispprefs{:}});
    end;
    S = setdisplayprefs(S,dp);
    if l, S = loadstim(S); end;
    s = S;
end;
