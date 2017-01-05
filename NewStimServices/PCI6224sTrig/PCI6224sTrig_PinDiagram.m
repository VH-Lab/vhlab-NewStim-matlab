function PCI6224Trig_PinDiagram
% PCI6224TRIG_PINDIAGRAM Pin diagram for PCI6224Trig device
%
%    The PCI6224 Trigger system uses the first 16 digital pins as
%    digital outs.
%
%    The first 8 pins (P0.0-P0.7) encode the stimulus.
%    The second 8 pins (P1.0-P1.7) are used to encode the stimulus status.
%
%    :
%    8:  Transition from 1 to 0 indicates stim onset; transition from 0 to 1 indicates stim offset (stim trigger)
%    9:  Transition from 0 to 1 indicates a new data frame is being displayed on the monitor (frame trigger)
%   10:  Transition from 0 to 1 indicates a stimulus will be arriving soon (background pretime trigger)
%   11:  Unused presently
%   12:  Unused presently
%   13:  Unused presently
%   14:  Unused presently
%   15:  Unused presently
%
%   See also: PCI6224Trig_Open
