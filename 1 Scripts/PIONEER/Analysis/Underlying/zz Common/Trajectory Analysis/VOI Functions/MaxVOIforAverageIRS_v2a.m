%==============================================
% 
%==============================================

function [ROI,err] = MaxVOIforAverageIRS_v2a(ROI,INPUT)

Status2('busy','Find ROI in Object',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Common Variables
%---------------------------------------------
Im = INPUT.SmearIm;
clear INPUT

%--------------------------------------
% Determine Nroi
%--------------------------------------  
func = @(V)MEOVatTroArrOpt_v1b_Reg(V,ANLZ,INPUT);
V0 = ROI.aveirs;
options = optimoptions('fmincon',...
                       'DiffMinChange',ANLZ.difminchng,...
                       'Diagnostics','on',...
                       'Display','iter',...
                       'StepTolerance',0.001);
[V,meov] = fmincon(func,V0,[],[],[],[],lb,ub,[],options);


% finish

roi = logical(Im >= de);
MROI = Im(roi);
aveROI = mean(MROI(:));



Status2('done','',2);
Status2('done','',3);



