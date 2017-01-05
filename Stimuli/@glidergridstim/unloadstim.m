function [outstim] = unloadstim(GGSstim)
% GLIDERGRIDSTIM/UNLOADSTIM - Unload a GLIDERGRIDSTIM
%
%  OUTSTIM = UNLOADSTIM(GGSTIM)
%
%  Unloads the GLIDERGRIDSTIM GGSTIM and releases
%  all video memory associated with the stimulus.
%
%  See also: STIMULUS/UNLOAD
%

if isloaded(GGSstim) == 1,
	ds = struct(getdisplaystruct(GGSstim.stimulus));
	os = ds.offscreen;
	for i=1:length(os),
		if os(i)~=0,
			try,
				Screen(os(i),'close');
			catch,
				os(i) = 0;
			end;
		end;
	end;
	GGSstim.stimulus = setdisplaystruct(GGSstim.stimulus,[]);
	GGSstim.stimulus = unloadstim(GGSstim.stimulus);
end;

outstim = GGSstim;
