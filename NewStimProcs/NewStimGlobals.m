% NewStimGlobals.m
%
% Global variables; users can set these values in NewStimConfiguration.m file
%   that is located in the "configuration" folder
%
% pixels_per_cm           : pixels per cm of stimulus monitor
% 
% NewStimStimList         : a list of all supported stimulus objects
% NewStimStimScriptList   : a list of all supported stimscript objects
%
% StimDisplayOrderRemote  : I do not remember what this is for
%
% NS_PTBvers              : The Psychophysics toolbox version: 0(none),2(2),3(3)
% 
% NewStimTriggeredStimPresentation : Should we base stimulus delivery off of triggers?
% NewStimTriggeredStimPresentation_Sign: high to low (0) or low to high (1)?
% NewStimTriggeredStimPresentation_timeout: how long do we wait for a trigger change before we give up?
%
% NewStimUseRushForDisplay: Should we use the 'rush' command to hurry our display? usually this will be 1
%
%   Legacy variables, not used anymore; these are now wrapped into NewStimService devices
% NSUseInitialSerialTrigger     : 0/1 use a serial port initial trigger
% NSUseStimSerialTrigger        : 0/1 use a serial port trigger before each stimulus
% NSUsePCIDIO96Trigger          : 0/1 use a Nat. Instruments PCI DIO 96 card for stim reporting
%
% NSMaxStimsPerStimScript       : The maximum number of stimuli per
%                                       stimscript that can be displayed 

   % do not set values here, edit NewStimConfiguration.m file in
   % configuration folder
   
global pixels_per_cm;

global NSUseInitialSerialTrigger NSUseStimSerialTrigger NSUsePCIDIO96Trigger NSUsePCIDIO96InputTrigger % these are old

global NewStimStimList
global NewStimStimScriptList

global NewStimPeriodicStimUseDrawTexture

global NS_PTBv  % psychtoolbox version, 0, 2, or 3

global StimDisplayOrderRemote

global NewStimTriggeredStimPresentation
global NewStimTriggeredStimPresentation_Sign
global NewStimTriggeredStimPresentation_timeout

global NewStimUseRushForDisplay

global NSMaxStimsPerStimScript
