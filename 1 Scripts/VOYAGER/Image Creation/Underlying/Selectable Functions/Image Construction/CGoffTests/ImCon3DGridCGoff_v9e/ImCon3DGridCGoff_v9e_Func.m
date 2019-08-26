%=====================================================
%
%=====================================================

function [GCGB0,err] = ImCon3DGridCGoff_v9e_Func(GCGB0,INPUT)

Status2('busy','Gridding With CG B0 Correction',1);
Status2('done','',2);
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
STRT = GCGB0.STRT;
BRK = GCGB0.BRK;
MSK = GCGB0.MSK;
VIS = GCGB0.VIS;
B0Map = GCGB0.B0MAP.Im;
IMP = GCGB0.IMP;
SDCS = GCGB0.SDCS;
SDCSarr = SDCS.SDCSarr;
clear SDCS;
KRNprms = GCGB0.KRNprms;
IFprms = GCGB0.IFprms;
GCGB0 = rmfield(GCGB0,{'IMP','SDCS','B0MAP','KRNprms','IFprms'});
clear INPUT;

%---------------------------------------------
% Setup / Test
%---------------------------------------------
Type = 'M2M';
[Ksz,SubSamp,~,~,~,~,~,err] = ConvSetupTest_v1a(IMP,KRNprms,Type);
if err.flag
    return
end

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
if sz(1) ~= Imsz
    err.flag = 1;
    err.msg = ['B0Map size must be: ',num2str(Imsz)];
    return
end

%---------------------------------------------
% Data Setup
%---------------------------------------------
Dat0 = DatArr2Mat(Dat0,IMP.PROJimp.nproj,IMP.PROJimp.npro);
for n = 1:length(SDCSarr)
    beta(n) = SDCSarr(n).TFO.beta;
    if isfield(SDCSarr(n).TFO,'sqroot');
        sqroot{n} = SDCSarr(n).TFO.sqroot;
    else
        sqroot{n} = 'no';
    end
end
for n = 1:2:length(SDCSarr)
    if beta(n) ~= beta(n+1)
        err.flag = 1;
        err.msg = ['SDC problem (filer - root - filter...)'];
        return
    end
    if strcmp(sqroot{n},'yes') || strcmp(sqroot{n+1},'no')
        err.flag = 1;
        err.msg = ['SDC problem (filer - root - filter...)'];
        return
    end
    SDCmatF{n} = SDCArr2Mat(SDCSarr(n).SDC,IMP.PROJimp.nproj,IMP.PROJimp.npro);    
    SDCmatR{n} = SDCArr2Mat(SDCSarr(n+1).SDC,IMP.PROJimp.nproj,IMP.PROJimp.npro); 
end
clear SDCSarr;

%---------------------------------------------
% Grid Setup
%---------------------------------------------
gridfunc = str2func([GCGB0.gridfunc,'_Func']);  
INPUT.IMP = IMP;
INPUT.KRNprms = KRNprms;
INPUT.SubSamp = SubSamp;
INPUT.StatLev = 3;
INPUT.ZF = ZF;
GRD.implement = 'CUDA';
GRD.precision = 'Double';
GRD.type = 'complex';

%---------------------------------------------
% Sample Setup
%---------------------------------------------
ksampfunc = str2func([GCGB0.ksampfunc,'_Func']);  
INPUT.B0Map = B0Map;
INPUT.IFprms = IFprms;
OB.ObMatSz = Imsz;

%---------------------------------------------
% Starting Image
%---------------------------------------------
Status2('busy','Get Starting Image',2);
startfunc = str2func([GCGB0.startfunc,'_Func']);  
[STRT,err] = startfunc(STRT,INPUT);
if err.flag
    return
end
if strcmp(STRT.create,'yes')
    Status2('busy','Create Starting Image',2);
    INPUT.DAT = Dat0.*SDCmatF{n};
    [GRD,err] = gridfunc(GRD,INPUT);
    if err.flag
        return
    end
    ImBase = fftshift(ifftn(ifftshift(GRD.GrdDat/SubSamp^3)));
    ImBase = ImBase./IFprms.V;
    ImBase = ImBase(Imbot:Imtop,Imbot:Imtop,Imbot:Imtop); 
else
    ImBase = STRT.Im;
end

%---------------------------------------------
% Start
%---------------------------------------------
for n = 1:length(SDCmatF)

    %---------------------------------------------
    % Create Comparison Image (Im0)
    %---------------------------------------------
    Status2('busy','Create Comparison Image',2);
    INPUT.DAT = Dat0.*SDCmatF{n};
    [GRD,err] = gridfunc(GRD,INPUT);
    if err.flag
        return
    end
    Im0 = fftshift(ifftn(ifftshift(GRD.GrdDat/SubSamp^3)));
    Im0 = Im0./IFprms.V;
    Im0 = Im0(Imbot:Imtop,Imbot:Imtop,Imbot:Imtop);

    %---------------------------------------------
    % Generate Masks
    %---------------------------------------------
    Status2('busy','Generate Masks',2);
    maskfunc = str2func([GCGB0.maskfunc,'_Func']);  
    INPUT.Im = Im0;
    [MSK,err] = maskfunc(MSK,INPUT);
    if err.flag
        return
    end
    Mask = MSK.Mask;
    INPUT = rmfield(INPUT,'Im');
      
    %---------------------------------------------
    % CG Algorithm
    %---------------------------------------------
    CGerr0 = 1e6;
    [xsz,ysz,zsz] = size(Im0);
    CGvec = zeros(size(Im0));
    ImTest = zeros(size(Im0));
    for its = 1:100

        %---------------------------------------------
        % Apply Mask
        %---------------------------------------------
        ImBase = ImBase.*Mask;

        %---------------------------------------------
        % Apply B0 to New Base Image 
        %---------------------------------------------
        Status2('busy','Apply B0 to New ''Base'' Image',2);
        OB.Ob = ImBase;
        INPUT.OB = OB;
        INPUT.B0Map = B0Map;
        [KSMP,err] = ksampfunc(KSMP,INPUT);
        if err.flag
            return
        end
        Dat = KSMP.SampDat;
        Dat = DatArr2Mat(Dat,IMP.PROJimp.nproj,IMP.PROJimp.npro);
        INPUT.DAT = Dat.*SDCmatR{n};
        [GRD,err] = gridfunc(GRD,INPUT);
        if err.flag
            return
        end
        ImOff = fftshift(ifftn(ifftshift(GRD.GrdDat/SubSamp^3)));
        ImOff = ImOff./IFprms.V;
        ImOff = ImOff(Imbot:Imtop,Imbot:Imtop,Imbot:Imtop);   

        %---------------------------------------------
        % Determine Residual (Gradient)
        %---------------------------------------------
        Res = (ImOff.*Mask)-(Im0.*Mask);

        %---------------------------------------------
        % Test Output Image
        %---------------------------------------------
        Status2('busy','Test Output Image',2);
        OB.Ob = ImBase;
        INPUT.OB = OB;
        INPUT.B0Map = zeros(size(B0Map));
        [KSMP,err] = ksampfunc(KSMP,INPUT);
        if err.flag
            return
        end
        Dat = KSMP.SampDat;
        Dat = DatArr2Mat(Dat,IMP.PROJimp.nproj,IMP.PROJimp.npro);
        INPUT.DAT = Dat.*SDCmatR{n};
        [GRD,err] = gridfunc(GRD,INPUT);
        if err.flag
            return
        end
        ImTest = fftshift(ifftn(ifftshift(GRD.GrdDat/SubSamp^3)));
        ImTest = ImTest./IFprms.V;
        ImTest = ImTest(Imbot:Imtop,Imbot:Imtop,Imbot:Imtop); 

        %---------------------------------------------
        % Visualization
        %---------------------------------------------
        Status2('busy','Visualize',2);
        visfunc = str2func([GCGB0.visfunc,'_Func']);  
        INPUT.Im0 = Im0;
        INPUT.ImBase = ImBase;
        INPUT.ImOff = ImOff;
        INPUT.ImTest = ImTest;
        INPUT.Res = Res;
        INPUT.CGvec = CGvec;
        [VIS,err] = visfunc(VIS,INPUT);
        if err.flag
            return
        end

        %---------------------------------------------
        % Conjugate Gradient Calc (Find New Base Image)
        %---------------------------------------------
        Status2('busy','Calculate Conjugate Gradient',2);
        im0 = reshape(Im0,[numel(Im0),1]);  
        r = 0.5*reshape(Res,[numel(Res),1]);  
        CGerr = (r'*r)/(im0'*im0)
        if its == 1
            p = r;              % conjugate vector
        else
            p = r + ((r'*r)/(rold'*rold))*p;        % new gradient vector contains history of past vector(s)...
        end
        alpha = (r'*r)/(r'*p);
        ImBase = reshape(ImBase,[numel(ImBase),1]) - alpha*p;
        rold = r;
        ImBase = reshape(ImBase,[xsz,ysz,zsz]);
        CGvec = reshape(alpha*p,[xsz,ysz,zsz]);

        %---------------------------------------------
        % Break Test
        %---------------------------------------------
        Status2('busy','Break Test',2);
        breakfunc = str2func([GCGB0.breakfunc,'_Func']);  
        INPUT.CGerr = CGerr;
        [BRK,err] = breakfunc(BRK,INPUT);
        if err.flag
            return
        end
        if BRK.end == 1;
            break
        end

    end
end
Im = ImTest;

%--------------------------------------------
% Panel
%--------------------------------------------
Panel(1,:) = {'','','Output'};
PanelOutput = cell2struct(Panel,{'label','value','type'},2);

%---------------------------------------------
% Return
%---------------------------------------------
GCGB0.Im = Im;
GCGB0.ImBase = ImBase;
GCGB0.ImSz_X = sz;
GCGB0.ImSz_Y = sz;
GCGB0.ImSz_Z = sz;
GCGB0.maxval = max(abs(Im(:)));
GCGB0.ReconPars = ReconPars;
GCGB0.PanelOutput = PanelOutput;

Status2('done','',2);
Status2('done','',3);

