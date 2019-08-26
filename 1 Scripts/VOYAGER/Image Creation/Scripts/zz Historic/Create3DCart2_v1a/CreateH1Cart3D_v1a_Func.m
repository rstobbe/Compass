%====================================================
%  
%====================================================

function [IMG,err] = CreateH1Cart3D_v1a_Func(INPUT)

Status('busy','Create H1 3D-Cartesian Image');
Status2('done','',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Get Input
%---------------------------------------------
IMG = INPUT.IMG;
FID = INPUT.FID;
DCCOR = INPUT.DCCOR;
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
clear INPUT;

%----------------------------------------------
% Test
%----------------------------------------------
Dat = FID.FIDmat;
dp = 60;
figure(10); hold on;
plot(angle(Dat(:,dp)));

%----------------------------------------------
% DCcor FID
%----------------------------------------------
func = str2func([IMG.dccorfunc,'_Func']);  
INPUT.FID = FID;
[DCCOR,err] = func(DCCOR,INPUT);
if err.flag
    return
end
clear INPUT;

%Dat = DCCOR.FIDmat;
Dat = FID.FIDmat;

%------------------------------------------
% Separate into Matrix
%------------------------------------------
osnp = FID.ExpPars.Acq.osnro;
nv1 = FID.ExpPars.Acq.nv1;
nv2 = FID.ExpPars.Acq.nv2;
DatMat = zeros(osnp,nv1,nv2);
ind = 0;
for n = 1:nv2
    for m = 1:nv1
        ind = ind+1;
        DatMat(:,n,m) = Dat(ind,:);
    end
end

%------------------------------------------
% Zero Fill
%------------------------------------------

%------------------------------------------
% FT
%------------------------------------------
Im = fftshift(ifftn(ifftshift(DatMat)));

%------------------------------------------
% Orient
%------------------------------------------

%------------------------------------------
% Scale
%------------------------------------------

%------------------------------------------
% Crop
%------------------------------------------

%---------------------------------------------
% Return
%---------------------------------------------
IMG.Im = Im;
%IMG.ImSz = IC.ImSz;
%IMG.zf = IC.zf;
%IMG.returnfov = IC.returnfov;
%IMG.IC = IC;
%IMG.maxval = max(abs(Im(:)));

%----------------------------------------------------
% Panel Items
%----------------------------------------------------
%Panel(1,:) = {'','','Output'};
%PanelOutput = cell2struct(Panel,{'label','value','type'},2);
%IMG.PanelOutput = PanelOutput;

Status('done','');
Status2('done','',2);
Status2('done','',3);



