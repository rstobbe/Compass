%====================================================
%  
%====================================================

function [PLFID,err] = FidPreload_v1a_Func(INPUT,PLFID)

Status('busy','PreLoad FID');
Status2('done','',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Get Input
%---------------------------------------------
FID = INPUT.FID;
FIDR = INPUT.FIDR;
clear INPUT;

%----------------------------------------------
% Rearrange Fid
%----------------------------------------------
func = str2func([FIDR.method,'_Func']);  
INPUT.FID = FID;
[FIDR,err] = func(FIDR,INPUT);
if err.flag
    return
end
clear INPUT;

%---------------------------------------------
% Return
%---------------------------------------------
PLFID.DATA = FID.DATA;
PLFID.DATA.FIDmat = FIDR.FIDmat;
PLFID.PanelOutput = FID.DATA.PanelOutput;
PLFID.ExpDisp = FID.DATA.ExpDisp;
PLFID.path = FID.DATA.path;

Status('done','');
Status2('done','',2);
Status2('done','',3);

