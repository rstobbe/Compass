%=====================================================
%
%=====================================================

function [GCGB0,err] = ImCon3DGridCGoff_v1c_Func(GCGB0,INPUT)

Status2('busy','Gridding With CG B0 Correction',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Get Input
%---------------------------------------------
Dat = INPUT.FID.FIDmat;
ReconPars = INPUT.FID.ReconPars;
GRD = GCGB0.GRD;
KSMP = GCGB0.KSMP;
B0Map = GCGB0.B0Map;
IMP = GCGB0.IMP;
SDCS = GCGB0.SDCS;
SDC = SDCS.SDC;
clear SDCS;
KRNprms = GCGB0.KRNprms;
IFprms = GCGB0.IFprms;
GCGB0 = rmfield(GCGB0,{'IMP','SDCS','B0Map','KRNprms','IFprms'});
clear INPUT;

%---------------------------------------------
% Get Gridding Ksz
%---------------------------------------------
Type = 'M2M';
[Ksz,SubSamp,~,~,~,~,~,err] = ConvSetupTest_v1a(IMP,KRNprms,Type);
if err.flag
    return
end

%---------------------------------------------
% Setup / Test
%---------------------------------------------
ZF = IFprms.ZF;
if Ksz > ZF
    err.flag = 1;
    err.msg = ['ZF must be greater than ',num2str(Ksz)];
    return
end
if rem(ZF,SubSamp)
    err.flag = 1;
    err.msg = 'ZF must be a multiple of SubSamp';
    return
end
Imbot = ZF*(SubSamp-1)/(2*SubSamp)+1;
Imtop = ZF*(SubSamp+1)/(2*SubSamp);
Imsz = Imtop-Imbot+1;

sz = size(B0Map);
if sz(1) == 0
    B0Map = zeros(Imsz,Imsz,Imsz);
elseif sz(1) ~= Imsz
    err.flag = 1;
    err.msg = ['B0Map size must be: ',num2str(Imsz)];
    return
end
%B0Map = zeros(Imsz,Imsz,Imsz);

%---------------------------------------------
% Data - Setup
%---------------------------------------------
Dat = DatArr2Mat(Dat,IMP.PROJimp.nproj,IMP.PROJimp.npro);
SDCmat = SDCArr2Mat(SDC,IMP.PROJimp.nproj,IMP.PROJimp.npro);
clear SDC;

%===================================================
% CG Algorithm
%===================================================
stop = 0;
for its = 1:100

    %---------------------------------------------
    % Create Images
    %---------------------------------------------
    func = str2func([GCGB0.gridfunc,'_Func']);  
    INPUT.IMP = IMP;
    INPUT.DAT = Dat.*SDCmat;
    INPUT.KRNprms = KRNprms;
    INPUT.SubSamp = SubSamp;
    INPUT.StatLev = 3;
    GRD.implement = 'CUDA';
    GRD.precision = 'Double';
    GRD.type = 'complex';
    [GRD,err] = func(GRD,INPUT);
    if err.flag
        return
    end
    if GRD.Ksz > ZF
        error();
    end
    Im = zerofill_isotropic_odd_doubles(ifftshift(GRD.GrdDat/SubSamp^3),ZF);
    Im = fftshift(ifftn(Im));
    Im = Im./IFprms.V;
    Im = Im(Imbot:Imtop,Imbot:Imtop,Imbot:Imtop);

    %---------------------------------------------
    % Test Images
    %---------------------------------------------
    test = 1;
    if test == 1
        tImInt0scale = max(abs(Im(:)));
        tIm = abs(Im);
        IMSTRCT.type = 'abs'; IMSTRCT.start = 1; IMSTRCT.step = 1; IMSTRCT.stop = Imsz; 
        IMSTRCT.rows = floor(sqrt(Imsz)); IMSTRCT.lvl = [0 tImInt0scale]; IMSTRCT.SLab = 0; IMSTRCT.figno = 1000; 
        IMSTRCT.docolor = 0; IMSTRCT.ColorMap = 'ColorMap4'; IMSTRCT.figsize = [];
        AxialMontage_v2a(tIm,IMSTRCT);
    end
    
    %---------------------------------------------
    % Conjugate Gradient Calc
    %---------------------------------------------
    [xsz,ysz,zsz] = size(Im);
    if its == 1
        b = reshape(Im,[numel(Im),1]);    % Ax=b  (A=IE'DEI and b=IE'Dm)  
        x = zeros(size(b));
        r = b;              % residual
        p = b;              % conjugate vector
    else
        Ap = reshape(Im,[numel(Im),1]);
        alpha = (r'*r)/(p'*Ap);
        x = x + alpha*p;
        rnew = r - alpha*Ap;
        CGerr = (rnew'*rnew)/(b'*b)
        if CGerr < GCGB0.cgerrbreak
            stop = 1;
        end
        beta = (rnew'*rnew)/(r'*r);
        p = rnew + beta*p;
        r = rnew;
    end

    %---------------------------------------------
    % Images
    %---------------------------------------------
    Imint = reshape(p,[xsz,ysz,zsz]);
    Imout = reshape(x,[xsz,ysz,zsz]);

    %---------------------------------------------
    % End
    %---------------------------------------------      
    if stop == 1 || its == (GCGB0.maxits+1)
        its = its-1
        GCGB0.its = its-1;
        break
    end
    
    %---------------------------------------------
    % Test Intermediate Image
    %---------------------------------------------
    test = 1;
    if test == 1
        tIm = abs(Imint);
        tImInt2scale = max(tIm(:));
        IMSTRCT.type = 'abs'; IMSTRCT.start = 1; IMSTRCT.step = 1; IMSTRCT.stop = Imsz; 
        IMSTRCT.rows = floor(sqrt(Imsz)); IMSTRCT.lvl = [0 tImInt2scale]; IMSTRCT.SLab = 0; IMSTRCT.figno = 1001; 
        IMSTRCT.docolor = 0; IMSTRCT.ColorMap = 'ColorMap4'; IMSTRCT.figsize = [];
        AxialMontage_v2a(tIm,IMSTRCT);
    end     

    %---------------------------------------------
    % Test Output Image
    %---------------------------------------------    
    test = 1;
    if test == 1
        tIm = abs(Imout);
        tImOutscale = max(tIm(:));
        IMSTRCT.type = 'abs'; IMSTRCT.start = 1; IMSTRCT.step = 1; IMSTRCT.stop = Imsz; 
        IMSTRCT.rows = floor(sqrt(Imsz)); IMSTRCT.lvl = [0 tImOutscale]; IMSTRCT.SLab = 0; IMSTRCT.figno = 1002; 
        IMSTRCT.docolor = 0; IMSTRCT.ColorMap = 'ColorMap4'; IMSTRCT.figsize = [];
        AxialMontage_v2a(tIm,IMSTRCT);
    end        

    %---------------------------------------------
    % Sample Intermediate Image
    %---------------------------------------------
    func = str2func([GCGB0.ksampfunc,'_Func']);  
    OB.Ob = Imint;
    OB.ObMatSz = Imsz;
    INPUT.OB = OB;
    INPUT.IMP = IMP;
    INPUT.B0Map = -B0Map;
    INPUT.IFprms = IFprms;
    INPUT.KRNprms = KRNprms;
    [KSMP,err] = func(KSMP,INPUT);
    if err.flag
        return
    end
    Dat = KSMP.SampDat;
    Dat = DatArr2Mat(Dat,IMP.PROJimp.nproj,IMP.PROJimp.npro);
end

%---------------------------------------------
% Test Output Image
%---------------------------------------------    
test = 1;
if test == 1
    tIm = abs(Imout);
    tImOutscale = max(tIm(:));
    IMSTRCT.type = 'abs'; IMSTRCT.start = 1; IMSTRCT.step = 1; IMSTRCT.stop = Imsz; 
    IMSTRCT.rows = floor(sqrt(Imsz)); IMSTRCT.lvl = [0 tImOutscale]; IMSTRCT.SLab = 0; IMSTRCT.figno = 1002; 
    IMSTRCT.docolor = 0; IMSTRCT.ColorMap = 'ColorMap4'; IMSTRCT.figsize = [];
    AxialMontage_v2a(tIm,IMSTRCT);
end     

%---------------------------------------------
% ReturnFov
%---------------------------------------------
returnfov = 'No';
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
%func = str2func([IC.orientfunc,'_Func']);  
%INPUT.Im = Im;
%[ORNT,err] = func(ORNT,INPUT);
%if err.flag
%    return
%end
%clear INPUT
%Im = ORNT.Im;

%--------------------------------------------
% Panel
%--------------------------------------------
Panel(1,:) = {'Test','','Output'};
PanelOutput = cell2struct(Panel,{'label','value','type'},2);

%---------------------------------------------
% Return
%---------------------------------------------
GCGB0.Im = Imout;
GCGB0.ImSz_X = sz;
GCGB0.ImSz_Y = sz;
GCGB0.ImSz_Z = sz;
GCGB0.maxval = max(abs(Im(:)));
GCGB0.ReconPars = ReconPars;
GCGB0.PanelOutput = PanelOutput;

Status2('done','',2);
Status2('done','',3);

