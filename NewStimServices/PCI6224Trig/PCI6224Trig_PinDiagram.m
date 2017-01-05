function PCI6224Trig_PinDiagram
% PCI6224TRIG_PINDIAGRAM Pin diagram for PCI6224Trig device
%
%    The PCI6224 Trigger system uses the first 16 digital pins as
%    digital outs.
%
%    The second 8 pins (P1.0-P1.7) encode the stimulus.
%    The first 8 pins (P0.0-P0.7) are used to encode the stimulus status.
%
%    :
%    0:  Transition from 1 to 0 indicates stim onset; transition from 0 to 1 indicates stim offset (stim trigger)
%    1:  Transition from 0 to 1 indicates a new data frame is being displayed on the monitor (frame trigger)
%    2:  Transition from 0 to 1 indicates a stimulus will be arriving soon (background pretime trigger)
%    3:  Unused presently
%    4:  Unused presently
%    5:  Unused presently
%    6:  Unused presently
%    7:  Unused presently
%
%   See also: PCI6224Trig_Open
