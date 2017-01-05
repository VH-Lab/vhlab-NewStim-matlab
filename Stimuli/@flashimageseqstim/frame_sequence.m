function [images_used, dataframeduration] = frame_sequence(fss)

% FRAME_SEQUENCE - returns frame sequence for frameimagesequencestim
%
%   [IMAGES_USED,DATAFRAMEDURATION] = FRAME_SEQUENCE(FIS)
%
%   Returns the images that are used for each image frame of the frameimagesequencestim.
%   IMAGES_USED is num_images X num_frames; if IMAGES_USED(x,y) is 1, then it means that
%   image x should be displayed in frame y.
%
%   DATAFRAMEDURATION indicates how many video frames the sequence should pause for the image frame.
%

StimWindowGlobals;

p = getparameters(fss);

on_times = p.onsets';
off_times = p.onsets'+p.durations';

on_frames = 1+round(on_times*StimWindowRefresh);
off_frames = 1+round(off_times*StimWindowRefresh);

unique_frames=unique([1;on_frames;off_frames]); % these are video frame numbers when image needs to change

images_used = zeros(length(p.onsets),length(unique_frames));

dataframeduration = diff(unique_frames);

for i=1:length(p.onsets),
	frame_on = find(on_frames(i)==unique_frames);
	frame_off = find(off_frames(i)==unique_frames);
	images_used(i,frame_on:frame_off-1) = 1;
end;

images_used = images_used(:,1:end-1);  % remove last "frame" which really isn't a frame but just used to calculate dataframeduration(end)

 % now deal with repeats

if p.repeat_interval>0,
        dataframeduration(end+1) = round(p.repeat_interval*StimWindowRefresh);
        images_used(:,end+1) = zeros(size(images_used,1),1);
end;

if p.repeat>1,
        dataframeduration = repmat(dataframeduration,p.repeat,1);
        images_used = repmat(images_used,1,p.repeat);
end;

