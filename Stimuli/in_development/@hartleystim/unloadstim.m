function [outstim] = unloadstim(Hstim)

if isloaded(Hstim) == 1,
	ds = struct(getdisplaystruct(Hstim.stimulus));
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
	Hstim.stimulus = setdisplaystruct(Hstim.stimulus,[]);
	Hstim.stimulus = unloadstim(Hstim.stimulus);
end;

outstim = Hstim;
