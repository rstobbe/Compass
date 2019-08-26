%=========================================================
% 
%=========================================================

function [IC,err] = ImageViaGriddingStandard_v1a_Func(IC,INPUT)

Status2('busy','Create Image Via Gridding',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Get Input
%---------------------------------------------
DAT = INPUT.DAT;
IMP = INPUT.IMP;
IFprms = IC.IFprms;
clear INPUT;

%---------------------------------------------
% Variables
%---------------------------------------------
ZF = IC.zf;
returnfov = IC.returnfov;

%---------------------------------------------
% Tests
%---------------------------------------------
if ZF ~= IFprms.ZF;
    err.flag = 1;
    err.msg = 'Inverse filter ''ZF'' does not match input ''ZF''';
    return
end

%---------------------------------------------
% Grid Data
%---------------------------------------------
Status2('busy','Grid Data',2);
func = str2func([IC.gridfunc,'_Func']);  
INPUT.IMP = IMP;
INPUT.DAT = DAT;
GRD = IC.GRD;
GRD.type = 'complex';
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
%elseif rem(ZF/SS,1) && strcmp(returnfov,'Yes')
%    button = questdlg('Exact FoV will not be returned (ZF*SS not an integer). Continue?');
%    if strcmp(button,'No')
%        err.flag = 1;
%        err.msg = 'ZF*SS must be a integer';
%        return
%    end
end

%---------------------------------------------
% Zero Fill / FT
%---------------------------------------------
Status2('busy','Zero-Fill / FT',2);
GrdDat = ifftshift(GrdDat);
Im = zerofill_isotropic_odd_doubles(GrdDat,ZF);
Im = fftshift(ifftn(Im));

%---------------------------------------------
% Inverse Filter
%---------------------------------------------
Im = Im./IFprms.V;

%--------------------------------------
% ReturnFov
%--------------------------------------
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
% Return
%---------------------------------------------
IC.Im = Im;
IC.ImSz = sz;
IC.GRD = GRD;
IC.kSz0 = Ksz;

Status2('done','',2);
Status2('done','',3);
