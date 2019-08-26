%=========================================================
% 
%=========================================================

function [OUTPUT,err] = DiffImConsolD2M_v1b_Func(INPUT)

Status('busy','Consolidate Dicom into Matrix');
Status2('done','',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';
OUTPUT = struct();

%---------------------------------------------
% Get Input
%---------------------------------------------
CSD = INPUT.CSD;
IMAT = INPUT.IMAT;

%---------------------------------------------
% Variables
%---------------------------------------------
averageaves = CSD.averageaves;
averagedirs = CSD.averagedirs;

%---------------------------------------------
% Load Dicom Images Into Matrix
%---------------------------------------------
func = str2func([CSD.loadfunc,'_Func']);
INPUT = struct();
[IMAT,err] = func(IMAT,INPUT);
if err.flag
    return
end

%---------------------------------------------
% Average
%---------------------------------------------
if strcmp(averageaves,'Yes')
    if strcmp(IMAT.dims{6},'ave')
        dwims = squeeze(mean(IMAT.dwims,6));
        IMAT.dims = IMAT.dims(1:5);
    else
        error();
    end
else
    dwims = IMAT.dwims;
end
if strcmp(averagedirs,'Yes')
    if strcmp(IMAT.dims{5},'dir')
        dwims = squeeze(mean(dwims,5));
        IMAT.dims = IMAT.dims(1:4);
    else
        error();
    end
end
IMAT.dwims = dwims;
test = size(dwims);

%---------------------------------------------
% Return
%---------------------------------------------
OUTPUT.CSD = CSD;
OUTPUT.IMAT = IMAT;


