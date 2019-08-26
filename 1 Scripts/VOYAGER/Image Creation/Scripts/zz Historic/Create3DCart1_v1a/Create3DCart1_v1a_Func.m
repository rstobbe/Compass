%====================================================
%  
%====================================================

function [IMG,err] = Create3DCart1_v1a_Func(INPUT,IMG)

Status('busy','Create 3D-Cartesian Image');
Status2('done','',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Get Input
%---------------------------------------------
FID = INPUT.FID;
KDCCOR = INPUT.KDCCOR;
IDCCOR = INPUT.IDCCOR;
RCOMB = INPUT.RCOMB;
clear INPUT;

%----------------------------------------------
% Import FID
%----------------------------------------------
func = str2func([IMG.importfidfunc,'_Func']);  
INPUT = struct();
[FID,err] = func(FID,INPUT);
if err.flag
    return
end
ExpPars = FID.ExpPars;
FIDmat = FID.FIDmat;
clear INPUT;
clear FID;

%----------------------------------------------
% DCcor FID
%----------------------------------------------
func = str2func([IMG.kdccorfunc,'_Func']);  
INPUT.FIDmat = FIDmat;
INPUT.nrcvrs = ExpPars.nrcvrs;
[KDCCOR,err] = func(KDCCOR,INPUT);
if err.flag
    return
end
FIDmat = KDCCOR.FIDmat;
clear INPUT;
clear KDCCOR;

%----------------------------------------------
% DCcor Image
%----------------------------------------------
%func = str2func([IMG.imdccorfunc,'_Func']);  
%INPUT.FIDmat = FIDmat;
%INPUT.nrcvrs = ExpPars.nrcvrs;
%[IDCCOR,err] = func(IDCCOR,INPUT);
%if err.flag
%    return
%end
%FIDmat = IDCCOR.FIDmat;
%clear INPUT;
%clear IDCCOR;

%------------------------------------------
% Combine Receivers
%------------------------------------------
func = str2func([IMG.rcvcombfunc,'_Func']);  
INPUT.vis = 'Yes';
INPUT.FIDmat = FIDmat;
INPUT.nrcvrs = ExpPars.nrcvrs;
[RCOMB,err] = func(RCOMB,INPUT);
if err.flag
    return
end
Im = RCOMB.Im;
clear INPUT;
clear RCOMB;

%-------------------------------------------
% Orient
%-------------------------------------------
Im = flipdim(Im,3);

%---------------------------------------------
% Return
%---------------------------------------------
IMG.Im = Im;
IMG.ExpPars = ExpPars;

%----------------------------------------------------
% Panel Items
%----------------------------------------------------
%Panel(1,:) = {'','','Output'};
%PanelOutput = cell2struct(Panel,{'label','value','type'},2);
%IMG.PanelOutput = PanelOutput;

Status('done','');
Status2('done','',2);
Status2('done','',3);



