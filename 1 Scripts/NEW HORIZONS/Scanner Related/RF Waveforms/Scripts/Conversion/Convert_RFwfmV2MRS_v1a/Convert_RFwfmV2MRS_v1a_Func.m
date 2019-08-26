%====================================================
%  
%====================================================

function [TST,err] = Convert_RFwfmV2MRS_v1a_Func(INPUT,TST)

Status('busy','Convert RF waveforem');
Status2('done','',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Get Input
%---------------------------------------------
RFfile = INPUT.RFfile;
clear INPUT;

%---------------------------------------------
% Load Waveform
%---------------------------------------------
[RFMRS,err] = Load_RFMRS_v1a(RFfile);

%---------------------------------------------
% Plot
%---------------------------------------------
figure(100); hold on;
plot(RFMRS);
title('RF pulse shape');

%---------------------------------------------
% Convert to Varian
%---------------------------------------------
RFV = zeros(3,length(RFMRS));
for n = 1:length(RFMRS)
    if RFMRS(n) == 0
        RFV(1,n) = 0;
    else
        if sign(RFMRS(n)) == 1
            RFV(1,n) = 0;
        else
            RFV(1,n) = 180;
        end
    end
    RFV(2,n) = abs(RFMRS(n))*1023;
    RFV(3,n) = 1;
end
        
%---------------------------------------------
% Write Waveform
%---------------------------------------------
[err] = Write_RFV_v1a(RFV);


Status('done','');
Status2('done','',2);
Status2('done','',3);

