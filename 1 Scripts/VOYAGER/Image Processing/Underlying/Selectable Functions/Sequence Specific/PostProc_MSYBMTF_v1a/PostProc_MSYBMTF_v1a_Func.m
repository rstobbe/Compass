%=====================================================
%
%=====================================================

function [PSTP,err] = PostProc_MSYBMTF_v1a_Func(PSTP,INPUT)

Status2('busy','Post Processing',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Get Input
%---------------------------------------------
IMG = INPUT.IMG;
FAT = PSTP.FAT;
MT = PSTP.MT;
clear INPUT;

%----------------------------------------------
% Fat Suppress
%----------------------------------------------
func = str2func([PSTP.fatfunc,'_Func']);  
INPUT.IMG = IMG;
[FAT,err] = func(FAT,INPUT);
if err.flag
    return
end
Im = FAT.Im;
test = size(Im);
clear INPUT;

%--------------------------------------------
% Panel
%--------------------------------------------
Panel(1,:) = {'ISHIM',PSTP.ishimfunc,'Output'};
Panel(1,:) = {'','','Output'};
PSTP.PanelOutput = cell2struct(Panel,{'label','value','type'},2);

%----------------------------------------------
% Return
%----------------------------------------------
PSTP.Im = Im;

Status2('done','',2);
Status2('done','',3);



