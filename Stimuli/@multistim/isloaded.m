function b = isloaded(ms)

%  ISLOADED - Is the MULTISTIM stimulus loaded?
%
%    B = ISLOADED(MYMULTISTIM)
% 
%    Returns 1 if the MYMULTISTIM stim is loaded.
%  

b = 1; i = 1; l = numStims(ms);

if l==0, b = 0; end;

while (b&(i<=l)), b = b&isloaded(ms.stimlist{i}); i=i+1; end;
