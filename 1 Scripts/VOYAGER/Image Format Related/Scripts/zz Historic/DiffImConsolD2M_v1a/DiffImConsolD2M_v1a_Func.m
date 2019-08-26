%=========================================================
% 
%=========================================================

function [OUTPUT,err] = DiffImConsolD2M_v1a_Func(INPUT)

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
average = CSD.average;

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
if strcmp(average,'Yes')
    if strcmp(IMAT.dims{6},'ave')
        dwims = squeeze(mean(IMAT.dwims,6));
    else
        error();
    end
end
IMAT.dwims = dwims;
IMAT.dims = IMAT.dims(1:5);

%---------------------------------------------
% Return
%---------------------------------------------
OUTPUT.CSD = CSD;
OUTPUT.IMAT = IMAT;


