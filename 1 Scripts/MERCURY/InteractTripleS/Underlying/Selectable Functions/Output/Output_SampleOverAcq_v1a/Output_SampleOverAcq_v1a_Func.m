%======================================================
% 
%======================================================

function [OUT,err] = Output_SampleOverAcq_v1a_Func(OUT,INPUT)

Status2('busy','Output',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Get Input
%---------------------------------------------
APP = INPUT.APP;
SIM = INPUT.SIM;
clear INPUT

%---------------------------------------------
% Get Acq Times
%---------------------------------------------
n = 1;
acqtimes = OUT.acqtimes;
while true
    [time,acqtimes] = strtok(acqtimes,{',',' '});
    OUT.acqtimeval(n) = str2double(time);
    n = n+1;
    if isempty(acqtimes)
        break
    end
end

AcqElm = APP.SIM.AcqElm;
ARR = APP.SIM.ARR;
AcqStart = ARR.SegBounds(AcqElm);

%---------------------------------------------
% Test
%---------------------------------------------
if AcqStart+max(OUT.acqtimeval) > max(SIM.Time)
    err.flag = 1;
    err.msg = 'AcqTimes longer than simulation';
    return
end

%---------------------------------------------
% Data @ Acq Times
%---------------------------------------------
OUT.Vals = interp1(SIM.Time,SIM.Val,AcqStart+OUT.acqtimeval);
Mat = [OUT.acqtimeval;OUT.Vals.'].';

%---------------------------------------------
% Write Excel
%---------------------------------------------
[file,path] = uiputfile('*.xlsx','Write Excel');
if path ~= 0
    xlswrite([path,file],Mat);
else
    file = 'Not Written';
end

%----------------------------------------------------
% Panel Items
%----------------------------------------------------
Panel(1,:) = {'','','Output'};
Panel(2,:) = {'Output',OUT.method,'Output'};
Panel(3,:) = {'File',file,'Output'};
OUT.Panel = Panel;
OUT.PanelOutput = cell2struct(OUT.Panel,{'label','value','type'},2);

Status2('done','',2);
Status2('done','',3);
