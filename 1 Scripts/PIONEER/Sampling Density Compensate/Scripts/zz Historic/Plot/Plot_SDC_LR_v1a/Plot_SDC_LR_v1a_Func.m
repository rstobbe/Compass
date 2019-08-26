%==================================================
% 
%==================================================

function [PLOT,err] = Plot_SDC_LR_v1a_Func(PLOT,INPUT)

Status('busy','Plot SDC');
Status2('done','',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%-----------------------------------------------------
% Get Input
%-----------------------------------------------------
ANLZ = INPUT.SDC.IT.ANLZ;
clear INPUT

clr = 'r*';

if strcmp(PLOT.xaxis,'SampNum');
    xax = ANLZ.sampno;
    xstring = 'sampling point number';    
else
    xax = ANLZ.rads;
    xstring = 'relative radial dimension';
end

%--------------------------------------
% Data
%--------------------------------------
MeanAbsErrTot = ANLZ.MeanAbsErrTot(length(ANLZ.MeanAbsErrTot))
Eff = ANLZ.Eff(length(ANLZ.MeanAbsErrTot))
MeanAbsErrTrajArr = ANLZ.MeanAbsErrTrajArr(1:12)

%--------------------------------------
% Figures
%--------------------------------------
%figure(51);
%plot(xax,ANLZ.SDC,'r*');
%title('SDC Values at Sampling Point Locations'); xlabel('relative radial dimension');

figure(52); 
plot(xax,ANLZ.DOV,'k*');
plot(xax,ANLZ.W,'r*');
title('Output Values at Sampling Point Locations'); xlabel(xstring);

figure(53); clf(53); hold on;
plot(ANLZ.MeanErrTrajArr,'r*');
smootherr = smooth(ANLZ.MeanErrTrajArr,20);
plot(smootherr,'k');
title('Mean Relative Error Along Trajectory'); xlabel('sampling point number');    

%figure(53);
%plot(xax,ANLZ.E*100,'r*');
%title('Error (%) at Sampling Point Locations'); xlabel(xstring);

%figure(54); hold on;
%plot(ANLZ.MeanAbsErrTrajArr,clr);
%title('Average Absolute Error (%) Along Trajectory'); xlabel('sampling point number');    
%ylim([0 0.5]);

%figure(56);
%plot(ANLZ.MeanSDCTrajArr,clr);
%title('Mean SDC Along Trajectory'); xlabel('sampling point number');   


