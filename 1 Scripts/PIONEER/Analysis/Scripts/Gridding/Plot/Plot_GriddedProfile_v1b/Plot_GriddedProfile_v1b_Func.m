%=========================================================
% 
%=========================================================

function [PLOT,err] = Plot_GriddedProfile_v1b_Func(INPUT,PLOT)

Status('busy','Plot Gridded Profile');
Status2('done','',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Get Input
%---------------------------------------------
GRD = INPUT.GRD;
GrdDat = GRD.GrdDat;
Ksz = GRD.Ksz;
clear INPUT;

%---------------------------------------------
% Plot
%---------------------------------------------
figure(1000); hold on;
plot(GrdDat(:,(Ksz+1)/2,(Ksz+1)/2));
plot(GrdDat((Ksz+1)/2,:,(Ksz+1)/2));
plot(squeeze(GrdDat((Ksz+1)/2,(Ksz+1)/2,:)));