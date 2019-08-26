%=====================================================
%
%=====================================================

function [GCGB0,err] = ImCon3DGridCGoff_v4a_Func(GCGB0,INPUT)

Status2('busy','Gridding With CG B0 Correction',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Get Input
%---------------------------------------------
Dat0 = INPUT.FID.FIDmat;
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

%---
%IMaskV = [0 0 0];
%beta0 = 3;
%beta = [20 10 5 0];
%relCGerrbreak = [0.9 0.9 0.9];
IMaskV = 0;
beta0 = 0;
beta = 5;
relCGerrbreak = 1;
%---

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

%---------------------------------------------
% FoV Mask Generate
%---------------------------------------------
Mask0 = zeros(Imsz,Imsz,Imsz);
C = Imsz/2;
for n = 1:Imsz
    for m = 1:Imsz
        for p = 1:Imsz
            rad = sqrt((n-C)^2 + (m-C)^2 + (p-C)^2);
            if rad <= C;
                Mask0(n,m,p) = 1;
            end
        end
    end
end

%---------------------------------------------
% Create Output Filter
%---------------------------------------------
Filt0 = Kaiser_v1b(Imsz,Imsz,Imsz,beta0,'unsym'); 

%---------------------------------------------
% Data - Setup
%---------------------------------------------
Dat0 = DatArr2Mat(Dat0,IMP.PROJimp.nproj,IMP.PROJimp.npro);
SDCmat = SDCArr2Mat(SDC,IMP.PROJimp.nproj,IMP.PROJimp.npro);
clear SDC;

fnum = 1;
CGerr0 = 1e6;
while true

    if fnum > length(beta)
        break
    end
    
    %---------------------------------------------
    % Create Starting Image
    %---------------------------------------------
    func = str2func([GCGB0.gridfunc,'_Func']);  
    INPUT.IMP = IMP;
    INPUT.DAT = Dat0.*SDCmat;
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
    % Intensity Mask Generate
    %---------------------------------------------
    Mask = Mask0;
    Mask(abs(Im)<IMaskV(fnum)*max(abs(Im(:)))) = 0;    
    
    %---------------------------------------------
    % Create Filter
    %---------------------------------------------
    betaval = beta(fnum)
    Filt = Kaiser_v1b(Imsz,Imsz,Imsz,betaval,'unsym'); 
        
    %---------------------------------------------
    % Filter
    %---------------------------------------------
    Im = fftshift(fftn(ifftshift(Filt.*fftshift(ifftn(ifftshift(Im))))));   

    %---------------------------------------------
    % Apply Mask
    %---------------------------------------------
    Im = Im.*Mask;
    
    %---------------------------------------------
    % Test Starting Image
    %---------------------------------------------
    test = 1;
    if test == 1
        Imscale = max(abs(Im(:)));
        IMSTRCT.type = 'abs'; IMSTRCT.start = 1; IMSTRCT.step = 1; IMSTRCT.stop = Imsz; 
        IMSTRCT.rows = floor(sqrt(Imsz)); IMSTRCT.lvl = [0 Imscale]; IMSTRCT.SLab = 0; IMSTRCT.figno = 1000; 
        IMSTRCT.docolor = 0; IMSTRCT.ColorMap = 'ColorMap4'; IMSTRCT.figsize = [];
        AxialMontage_v2a(Im,IMSTRCT);
    end
    [xsz,ysz,zsz] = size(Im);
    Im0 = Im;
    if fnum == 1
        ImN = Im;
    end

    %===================================================
    % CG Algorithm
    %===================================================
    stop = 0;
    for its = 1:100

        %---------------------------------------------
        % Sample Previous Image
        %---------------------------------------------
        func = str2func([GCGB0.ksampfunc,'_Func']);  
        OB.Ob = ImN;
        OB.ObMatSz = Imsz;
        INPUT.OB = OB;
        INPUT.IMP = IMP;
        INPUT.B0Map = B0Map;
        INPUT.IFprms = IFprms;
        INPUT.KRNprms = KRNprms;
        [KSMP,err] = func(KSMP,INPUT);
        if err.flag
            return
        end
        Dat = KSMP.SampDat;
        Dat = DatArr2Mat(Dat,IMP.PROJimp.nproj,IMP.PROJimp.npro);

        %---------------------------------------------
        % Create New Image
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
        % Filter
        %---------------------------------------------
        Im = fftshift(fftn(ifftshift(Filt.*fftshift(ifftn(ifftshift(Im))))));      

        %---------------------------------------------
        % Apply Mask
        %---------------------------------------------
        Im = Im.*Mask;
  
        %---------------------------------------------
        % Test New Image
        %---------------------------------------------
        test = 1;
        if test == 1
            IMSTRCT.type = 'abs'; IMSTRCT.start = 1; IMSTRCT.step = 1; IMSTRCT.stop = Imsz; 
            IMSTRCT.rows = floor(sqrt(Imsz)); IMSTRCT.lvl = [0 Imscale]; IMSTRCT.SLab = 0; IMSTRCT.figno = 1001; 
            IMSTRCT.docolor = 0; IMSTRCT.ColorMap = 'ColorMap4'; IMSTRCT.figsize = [];
            AxialMontage_v2a(Im,IMSTRCT);
        end

        %---------------------------------------------
        % Determine Residual (Gradient)
        %---------------------------------------------
        Res = Im-Im0;

        %---------------------------------------------
        % Test Residual
        %---------------------------------------------
        test = 1;
        if test == 1
            IMSTRCT.type = 'abs'; IMSTRCT.start = 1; IMSTRCT.step = 1; IMSTRCT.stop = Imsz; 
            IMSTRCT.rows = floor(sqrt(Imsz)); IMSTRCT.lvl = [0 Imscale]; IMSTRCT.SLab = 0; IMSTRCT.figno = 2000; 
            IMSTRCT.docolor = 0; IMSTRCT.ColorMap = 'ColorMap4'; IMSTRCT.figsize = [];
            AxialMontage_v2a(Res,IMSTRCT);
        end

        %---------------------------------------------
        % Conjugate Gradient Calc
        %---------------------------------------------
        im0 = reshape(Im0,[numel(Im0),1]);  
        r = 0.5*reshape(Res,[numel(Res),1]);  
        CGerr = (r'*r)/(im0'*im0)
        if CGerr > CGerr0*relCGerrbreak(fnum)
            stop = 1;
        end
        CGerr0 = CGerr;
        if its == 1
            p = r;              % conjugate vector
        else
            p = r + ((r'*r)/(rold'*rold))*p;        % new gradient vector contains history of past vector(s)...
        end
        alpha = (r'*r)/(r'*p);
        ImN = reshape(ImN,[numel(ImN),1]) - alpha*p;
        rold = r;

        %---------------------------------------------
        % Test Conjugate vector
        %---------------------------------------------    
        test = 1;
        if test == 1
            tC = reshape(alpha*p,[xsz,ysz,zsz]);
            IMSTRCT.type = 'abs'; IMSTRCT.start = 1; IMSTRCT.step = 1; IMSTRCT.stop = Imsz; 
            IMSTRCT.rows = floor(sqrt(Imsz)); IMSTRCT.lvl = [0 Imscale]; IMSTRCT.SLab = 0; IMSTRCT.figno = 2001; 
            IMSTRCT.docolor = 0; IMSTRCT.ColorMap = 'ColorMap4'; IMSTRCT.figsize = [];
            AxialMontage_v2a(tC,IMSTRCT);
        end          

        %---------------------------------------------
        % Images
        %---------------------------------------------
        ImN = reshape(ImN,[xsz,ysz,zsz]);

        %---------------------------------------------
        % Test Image
        %---------------------------------------------    
        test = 1;
        if test == 1
            tIm = abs(fftshift(fftn(ifftshift(Filt0.*fftshift(ifftn(ifftshift(ImN)))))));   
            IMSTRCT.type = 'abs'; IMSTRCT.start = 1; IMSTRCT.step = 1; IMSTRCT.stop = Imsz; 
            IMSTRCT.rows = floor(sqrt(Imsz)); IMSTRCT.lvl = [0 Imscale]; IMSTRCT.SLab = 0; IMSTRCT.figno = 1002; 
            IMSTRCT.docolor = 0; IMSTRCT.ColorMap = 'ColorMap4'; IMSTRCT.figsize = [];
            AxialMontage_v2a(tIm,IMSTRCT);
        end        

        %---------------------------------------------
        % End
        %---------------------------------------------      
        if stop == 1
            fnum = fnum + 1
            CGerr0 = 1e6;
            break
        end
    end
end
Im = abs(fftshift(fftn(ifftshift(Filt0.*fftshift(ifftn(ifftshift(ImN))))))); 

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
GCGB0.Im = Im;
GCGB0.ImSz_X = sz;
GCGB0.ImSz_Y = sz;
GCGB0.ImSz_Z = sz;
GCGB0.maxval = max(abs(Im(:)));
GCGB0.ReconPars = ReconPars;
GCGB0.PanelOutput = PanelOutput;

Status2('done','',2);
Status2('done','',3);

