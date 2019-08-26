%====================================================
%  
%====================================================

function [IMG,err] = CreateNaPA_v1b_Func(INPUT)

Status('busy','Create NaPA Image');
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
IC = INPUT.IC;
IMP = INPUT.IMP;
arrSDC = INPUT.SDC;
clear INPUT;

%----------------------------------------------
% Import FID
%----------------------------------------------
func = str2func([IMG.importfidfunc,'_Func']);  
INPUT.IMP = IMP;
[FID,err] = func(FID,INPUT);
if err.flag
    return
end
clear INPUT;

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

%---------------------------------------------
% Plot
%---------------------------------------------
plotFID = 1;
if plotFID == 1;
    figure(1); hold on;
    abstest = mean(abs(FID.FIDmat),1);
    plot(abstest,'r');
    abstest = mean(abs(DCCOR.FIDmat),1);
    plot(abstest,'b');
    title('Mean data magnitude');

    figure(3); hold on;
    Dat = FID.FIDmat(:,1);
    plot(abs(Dat));
    title('First Data Point');
end

%---------------------------------------------
% Put in array form
%---------------------------------------------
[nproj,npro] = size(DCCOR.FIDmat);
arrDAT = DatMat2Arr(DCCOR.FIDmat,nproj,npro);

%---------------------------------------------
% Compensate Data
%---------------------------------------------
arrDAT = arrDAT.*arrSDC;
[DAT] = DatArr2Mat(arrDAT,IMP.PROJimp.nproj,IMP.PROJimp.npro);

%----------------------------------------------
% Create Image
%----------------------------------------------
func = str2func([IMG.imagecreatefunc,'_Func']);  
INPUT.IMP = IMP;
INPUT.DAT = DAT;
[IC,err] = func(IC,INPUT);
if err.flag
    return
end
clear INPUT;
Im = IC.Im;
IC = rmfield(IC,'Im');

%---------------------------------------------
% Orient
%---------------------------------------------
if strcmp(IMG.orient,'47T_Adj')
    Im = permute(Im,[2,1,3]);
    Im = flipdim(Im,1);
end

%---------------------------------------------
% Return
%---------------------------------------------
IMG.Im = Im;
IMG.ImSz = IC.ImSz;
IMG.zf = IC.zf;
IMG.returnfov = IC.returnfov;
IMG.IC = IC;
IMG.maxval = max(abs(Im(:)));

%----------------------------------------------------
% Panel Items
%----------------------------------------------------
Panel(1,:) = {'kSz0',IMG.IC.kSz0,'Output'};
Panel(2,:) = {'ImSz',IMG.ImSz,'Output'};
Panel(3,:) = {'MaxVal',IMG.maxval,'Output'};
PanelOutput = cell2struct(Panel,{'label','value','type'},2);
IMG.PanelOutput = PanelOutput;

Status('done','');
Status2('done','',2);
Status2('done','',3);

