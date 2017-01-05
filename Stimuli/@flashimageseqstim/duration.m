function t = duration(fis)

p = getparameters(fis);

t = p.repeat*(max(p.onsets'+p.durations')+p.repeat_interval);


