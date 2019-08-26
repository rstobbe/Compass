%=========================================================
% 
%=========================================================

function [ROIERR,err] = RoiErrorPlot_v1a_Func(ROIERR,INPUT)

Status2('busy','Plot ROI Error',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Get Input
%---------------------------------------------
STUDY = INPUT.STUDY;
clear INPUT

%---------------------------------------------
% Load
%---------------------------------------------
for n = 1:4
    RoiNames = STUDY.Volunteer(1).ReturnAllRoiNames;
    if not(strcmp(RoiNames{end},'ROI_NAWM'))
        err.flag = 1;
        err.msg = 'Last ROI should be NAWM';
    end
    vols = STUDY.Volunteer(n).ReturnAllRoiValues('Vol');
    valFull = STUDY.Volunteer(n).ReturnAllRoiValues('Mean_Full');
    errFull = STUDY.Volunteer(n).ReturnAllRoiValues('NPI95_Full');
    psfFull = STUDY.Volunteer(n).ReturnAllRoiValues('PSFA_Full');
    valFullNAWM = valFull(end);
    errFullNAWM = errFull(end);
    valFull = valFull(1:end-1);
    errFull = errFull(1:end-1);
    psfFull = psfFull(1:end-1);
    vols = vols(1:end-1);

    %---------------------------------------------
    % Relative
    %---------------------------------------------
    rvalFull = valFull/valFullNAWM;
    rerrFull = abs(rvalFull).*sqrt((errFull./valFull).^2 + (errFullNAWM./valFullNAWM).^2);

    %---------------------------------------------
    % Plot
    %---------------------------------------------
    figure(100); hold on;
    plot(vols,(rvalFull-1),'b*');
    plot([vols;vols],[(rvalFull-1)+rerrFull;(rvalFull-1)-rerrFull],'b-');

    %---------------------------------------------
    % Plot
    %---------------------------------------------
    figure(101); hold on;
    plot(psfFull,(rvalFull-1)./psfFull,'r*');

    %---------------------------------------------
    % Plot
    %---------------------------------------------
    figure(102); hold on;
    plot(psfFull,(rvalFull-1),'m*');

end

Status2('done','',2);
Status2('done','',3);
