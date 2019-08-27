%====================================================
%  
%====================================================

function [PLFID,err] = FidPreload_v1b_Func(INPUT,PLFID)

Status('busy','PreLoad FID');
Status2('done','',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Get Input
%---------------------------------------------
FID = INPUT.FID;
FIDP = INPUT.FIDP;
clear INPUT;

%----------------------------------------------
% Process Fid
%----------------------------------------------
func = str2func([FIDP.method,'_Func']);  
INPUT.FID = FID;
[FIDP,err] = func(FIDP,INPUT);
if err.flag
    return
end
clear INPUT;

%---------------------------------------------
% Return
%---------------------------------------------
PLFID.DATA = FID.DATA;
PLFID.DATA.FIDmat = FIDP.FIDmat;
PLFID.PanelOutput = FID.DATA.PanelOutput;
PLFID.ExpDisp = FID.DATA.ExpDisp;
PLFID.path = FID.DATA.path;

Status('done','');
Status2('done','',2);
Status2('done','',3);

