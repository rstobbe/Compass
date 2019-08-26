%=========================================================
% 
%=========================================================

function [IC,err] = ImCon3DGridding_v1b_Func(IC,INPUT)

Status2('busy','Create Image Via Gridding',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Get Input
%---------------------------------------------
Dat = INPUT.FID.FIDmat;
ReconPars = INPUT.FID.ReconPars;
IMP = IC.IMP;
SDC = IC.SDCS.SDC;
IFprms = IC.IFprms;
GRD = IC.GRD;
ORNT = IC.ORNT;
clear INPUT;
IC = rmfield(IC,{'SDCS','IMP','IFprms','GRD'});

%---------------------------------------------
% Variables
%---------------------------------------------
returnfov = IC.returnfov;
ZF = IFprms.ZF;

%---------------------------------------------
% Compensate Data
%---------------------------------------------
DatSz = size(Dat);
if DatSz(1) == 1 || DatSz(2) == 1    
    Dat = Dat.*SDC;
    [DAT] = DatArr2Mat(Dat,IMP.PROJimp.nproj,IMP.PROJimp.npro);
else
    [Dat] = DatMat2Arr(Dat,IMP.PROJimp.nproj,IMP.PROJimp.npro);
    Dat = Dat.*SDC;
    [DAT] = DatArr2Mat(Dat,IMP.PROJimp.nproj,IMP.PROJimp.npro);
end
    
%---------------------------------------------
% Grid Data
%---------------------------------------------
Status2('busy','Grid Data',2);
func = str2func([IC.gridfunc,'_Func']);  
INPUT.IMP = IMP;
INPUT.DAT = DAT;
INPUT.ZF = ZF;
GRD.type = 'complex';
INPUT.StatLev = 3;
[GRD,err] = func(GRD,INPUT);
if err.flag
    return
end
clear INPUT
GrdDat = GRD.GrdDat;
SS = GRD.SS;
Ksz = GRD.Ksz;

%---------------------------------------------
% Test
%---------------------------------------------
if Ksz > ZF
    err.flag = 1;
    err.msg = ['Zero-Fill is to small. Ksz = ',num2str(Ksz)];
    return
end
if rem(ZF/SS,1) && strcmp(returnfov,'Yes')
    err.flag = 1;
    err.msg = 'ZF*SS must be a integer';
    return
end

%---------------------------------------------
% Zero Fill / FT
%---------------------------------------------
Status2('busy','Zero-Fill / FT',2);
GrdDat = ifftshift(GrdDat);
sz = size(GrdDat);
if sz(1) ~= ZF 
    GrdDat = zerofill_isotropic_odd_doubles(GrdDat,ZF);
end
Im = fftshift(ifftn(GrdDat));

%---------------------------------------------
% Inverse Filter
%---------------------------------------------
Im = Im./IFprms.V;

%---------------------------------------------
% ReturnFov
%---------------------------------------------
if strcmp(returnfov,'Yes')
    bot = ZF*(SS-1)/(2*SS)+1;
    top = ZF*(SS+1)/(2*SS);
    bot = floor(bot);
    top = ceil(top);
    Im = Im(bot:top,bot:top,bot:top);
    sz = ZF/SS; 
else
    sz = ZF; 
end

%---------------------------------------------
% Orient
%---------------------------------------------
func = str2func([IC.orientfunc,'_Func']);  
INPUT.Im = Im;
INPUT.ReconPars = ReconPars;
[ORNT,err] = func(ORNT,INPUT);
if err.flag
    return
end
Im = ORNT.Im;
ReconPars = ORNT.ReconPars;
clear INPUT;
clear ORNT;

%--------------------------------------------
% Panel
%--------------------------------------------
Panel(1,:) = {'ImFoV_LR',ReconPars.ImfovLR,'Output'};
Panel(2,:) = {'ImFoV_TB',ReconPars.ImfovTB,'Output'};
Panel(3,:) = {'ImFoV_IO',ReconPars.ImfovIO,'Output'};
Panel(4,:) = {'ImSz_LR',ReconPars.ImszLR,'Output'};
Panel(5,:) = {'ImSz_TB',ReconPars.ImszTB,'Output'};
Panel(6,:) = {'ImSz_IO',ReconPars.ImszIO,'Output'};
Panel(7,:) = {'ImMaxVal',max(abs(Im(:))),'Output'};
Panel(8,:) = {'kSz0',Ksz,'Output'};
PanelOutput = cell2struct(Panel,{'label','value','type'},2);

%---------------------------------------------
% Remove GrdDat (no need to save)
%---------------------------------------------
GRD = rmfield(GRD,'GrdDat');

%---------------------------------------------
% Return
%---------------------------------------------
IC.Im = Im;
IC.ImSz_X = sz;
IC.ImSz_Y = sz;
IC.ImSz_Z = sz;
IC.maxval = max(abs(Im(:)));
IC.kSz0 = Ksz;
IC.GRD = GRD;
IC.ReconPars = ReconPars;
IC.PanelOutput = PanelOutput;

Status2('done','',2);
Status2('done','',3);
