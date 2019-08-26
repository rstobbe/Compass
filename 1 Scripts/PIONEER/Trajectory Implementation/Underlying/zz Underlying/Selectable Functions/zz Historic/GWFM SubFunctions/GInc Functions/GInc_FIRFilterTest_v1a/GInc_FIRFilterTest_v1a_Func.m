%=====================================================
% 
%=====================================================

function [GINC,err] = GInc_FIRFilterTest_v1a_Func(GINC,INPUT)

Status2('busy','FIRFilter Testing',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Get Input
%---------------------------------------------
G = INPUT.G0;
T = INPUT.T;
clear INPUT

%---------------------------------------------
% Filter
%---------------------------------------------
filt = dsp.FIRFilter;
reset(filt);
filt.Numerator = fir1(10,0.1);
[nProj,~,~] = size(G);
Gfilt = zeros(size(G));
for n = 1:nProj
    for d = 1:3
        Gfilt(n,:,d) = step(filt,squeeze(G(n,:,d)).');
    end
end

GINC.G = Gfilt;
GINC.T = T;

Status2('done','',3);
