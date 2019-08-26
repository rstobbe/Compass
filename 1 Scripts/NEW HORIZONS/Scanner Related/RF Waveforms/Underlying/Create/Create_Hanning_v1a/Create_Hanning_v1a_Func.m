%====================================================
%  
%====================================================

function [PLS,err] = Create_Hanning_v1a_Func(PLS,INPUT)

Status2('busy','Create Hanning Pulse',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Get Input
%---------------------------------------------
clear INPUT;

%---------------------------------------------
% Create Waveform
%---------------------------------------------
wfm0 = sinc((-PLS.lobes:0.001:PLS.lobes));
filt = hann(length(wfm0));
wfm = filt.'.*wfm0;

figure(1000); hold on;
plot(wfm0);
plot(filt);
plot(wfm);

%---------------------------------------------
% Assign Type
%---------------------------------------------
PLS.type = 'excitation';
PLS.modulation = 'amplitude';
PLS.gradref = 'yes';

%---------------------------------------------
% Return
%---------------------------------------------
PLS.wfm = wfm;
PLS.Dflip = PLS.flip;
PLS.Dtbwprod = PLS.lobes*2;

Status2('done','',2);
Status2('done','',3);

