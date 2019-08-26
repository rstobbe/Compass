%=========================================================
% 
%=========================================================

function [WRT,err] = CreateClientData_v1a_Func(INPUT,WRT)

Status('busy','Create Client Data');
Status2('done','',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Get Input
%---------------------------------------------
LOAD = INPUT.LOAD;
KERN = INPUT.KERN;
BUILD = INPUT.BUILD;
IMP = INPUT.IMP;
clear INPUT;

%---------------------------------------------
% Load Data
%---------------------------------------------
func = str2func([LOAD.method,'_Func']);
INPUT = struct();
[LOAD,err] = func(LOAD,INPUT);
if err.flag
    return
end
RawData = LOAD.Data;
clear INPUT

%---------------------------------------------
% Load Kernel
%---------------------------------------------
func = str2func([KERN.method,'_Func']);
INPUT = struct();
[KERN,err] = func(KERN,INPUT);
if err.flag
    return
end
RawData = LOAD.Data;
clear INPUT

%---------------------------------------------
% Build Data
%---------------------------------------------
func = str2func([BUILD.method,'_Func']);
INPUT.IMP = IMP;
INPUT.RawData = RawData;
INPUT.KERN = KERN;
[BUILD,err] = func(BUILD,INPUT);
if err.flag
    return
end

%---------------------------------------------
% Write Recon 
%---------------------------------------------
Panel(1,:) = {'','','Output'};
% Panel(2,:) = {'Name',WRT.name,'Output'};
% Panel(3,:) = {'','','Output'};
% Panel(4,:) = {'IMP',IMP.name,'Output'};
% Panel(5,:) = {'SDC',SDCS.name,'Output'};
WRT.PanelOutput = cell2struct(Panel,{'label','value','type'},2);
WRT.name = 'Test';

Status2('done','',1);
Status2('done','',2);
Status2('done','',3);



