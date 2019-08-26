%=====================================================
%
%=====================================================

function [GCGB0,err] = ImCon3DGridCGoff_v7a_Func(GCGB0,INPUT)

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
B0Map0 = GCGB0.B0Map;
IMP = GCGB0.IMP;
SDCS = GCGB0.SDCS;
SDC = SDCS.SDC;
clear SDCS;
KRNprms = GCGB0.KRNprms;
IFprms = GCGB0.IFprms;
GCGB0 = rmfield(GCGB0,{'IMP','SDCS','B0Map','KRNprms','IFprms'});
clear INPUT;

%---------------------------------------------
% Testing
%---------------------------------------------
B0MapScl = [0.2 0.4 0.5 0.6 0.7 0.75];
relCGerrbreak = [0.8 0.9 0.9 0.9 0.9 1];
 
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

sz = size(B0Map0);
if sz(1) == 0
    B0Map0 = zeros(Imsz,Imsz,Imsz);
elseif sz(1) ~= Imsz
    err.flag = 1;
    err.msg = ['B0Map size must be: ',num2str(Imsz)];
    return
end

%---------------------------------------------
% FoV Mask Generate
%---------------------------------------------
Mask = zeros(Imsz,Imsz,Imsz);
C = Imsz/2;
for n = 1:Imsz
    for m = 1:Imsz
        for p = 1:Imsz
            rad = sqrt((n-C)^2 + (m-C)^2 + (p-C)^2);
            if rad <= C;
                Mask(n,m,p) = 1;
            end
        end
    end
end

%---------------------------------------------
% Data - Setup
%---------------------------------------------
Dat0 = DatArr2Mat(Dat0,IMP.PROJimp.nproj,IMP.PROJimp.npro);
SDCmat = SDCArr2Mat(SDC,IMP.PROJimp.nproj,IMP.PROJimp.npro);
clear SDC;

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
% Apply FoV Mask
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
ImN = Im;

%===================================================
% CG Algorithm
%===================================================
CGerr0 = 1e6;
for sclnum = 1:100;
    if sclnum > length(B0MapScl)
        break
    end
    
    %---------------------------------------------
    % B0 Map Scale
    %---------------------------------------------
    B0MapSclVal = B0MapScl(sclnum)
    B0Map = B0MapSclVal*B0Map0;
    
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
        % Apply FoV Mask
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
        if CGerr > CGerr0
            break
        end
        if CGerr > CGerr0*relCGerrbreak(sclnum)
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
            IMSTRCT.type = 'abs'; IMSTRCT.start = 1; IMSTRCT.step = 1; IMSTRCT.stop = Imsz; 
            IMSTRCT.rows = floor(sqrt(Imsz)); IMSTRCT.lvl = [0 Imscale]; IMSTRCT.SLab = 0; IMSTRCT.figno = 1002; 
            IMSTRCT.docolor = 0; IMSTRCT.ColorMap = 'ColorMap4'; IMSTRCT.figsize = [];
            AxialMontage_v2a(ImN,IMSTRCT);
        end        

        %---------------------------------------------
        % End
        %---------------------------------------------      
        if stop == 1 
            itsarr(sclnum) = its-1;
            CGerr0 = 1e6;
            break
        end
    end
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
GCGB0.Im = Im;
GCGB0.ImSz_X = sz;
GCGB0.ImSz_Y = sz;
GCGB0.ImSz_Z = sz;
GCGB0.maxval = max(abs(Im(:)));
GCGB0.ReconPars = ReconPars;
GCGB0.PanelOutput = PanelOutput;

Status2('done','',2);
Status2('done','',3);

