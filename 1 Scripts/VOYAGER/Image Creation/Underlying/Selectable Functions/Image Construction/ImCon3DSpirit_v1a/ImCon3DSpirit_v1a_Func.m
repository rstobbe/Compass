%=====================================================
%
%=====================================================

function [SPIRIT,err] = ImCon3DSpirit_v1a_Func(SPIRIT,INPUT)

Status2('busy','Spirit Image Construction',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Get Input
%---------------------------------------------
Dat = INPUT.Dat;
GKERN = SPIRIT.GKERN;
GCDAT = SPIRIT.GCDAT;
GWCALC = SPIRIT.GWCALC;
GACALC = SPIRIT.GACALC;
GCONV = SPIRIT.GCONV;
GRD = SPIRIT.GRD;
GRDR = SPIRIT.GRDR;
IMP = SPIRIT.IMP;
SDCS = SPIRIT.SDCS;
SDC = SDCS.SDC;
clear SDCS;
KRNprms = SPIRIT.KRNprms;
clear INPUT;
SPIRIT = rmfield(SPIRIT,{'IMP','SDCS','KRNprms'});

%=================================================
% Spirit - Setup
%=================================================
Nrcvrs = length(Dat(1,:));
Dat0 = zeros(IMP.PROJimp.nproj,IMP.PROJimp.npro,8);
SDCmat = zeros(IMP.PROJimp.nproj,IMP.PROJimp.npro,8);
for n = 1:Nrcvrs
    Dat0(:,:,n) = DatArr2Mat(squeeze(Dat(:,n)),IMP.PROJimp.nproj,IMP.PROJimp.npro);
    SDCmat(:,:,n) = SDCArr2Mat(SDC,IMP.PROJimp.nproj,IMP.PROJimp.npro);
end
clear SDC;
clear Dat;

do = 0;
if do == 1
    %---------------------------------------------
    % Grid Original Input
    %---------------------------------------------
    func = str2func([SPIRIT.gridfunc,'_Func']);  
    INPUT.IMP = IMP;
    for n = 1:Nrcvrs;
        INPUT.DAT = squeeze(Dat0(:,:,n).*SDCmat(:,:,n));
        INPUT.KRNprms = KRNprms;
        INPUT.SubSamp = 1.25;
        GRD.type = 'complex';
        [GRD,err] = func(GRD,INPUT);
        if err.flag
            return
        end
        kMat0 = GRD.GrdDat;
        if n == 1
            sz = length(kMat0);
            kMatOrig = zeros(sz,sz,sz,Nrcvrs);
        end
        kMatOrig(:,:,:,n) = kMat0;
    end
    clear GRD;
    kMat0 = kMatOrig;
    save('D:\UData2','kMat0');
    error();
end
%load('D:\UData2');
load('D:\Data');
whos

%tkMat = kMat0;
%for n = 1:8
%    kMat0(:,:,:,n) = tkMat(:,:,:,1);
%end

kMatOrig = kMat0;
%---------------------------------------------
% Test Images
%---------------------------------------------
test = 0;
if test == 1
    Im0 = zeros(size(kMatOrig));
    for n = 1:Nrcvrs;
        Im0(:,:,:,n) = fftshift(ifftn(ifftshift(kMatOrig(:,:,:,n))));
        tIm0 = abs(Im0(:,:,:,n))/max(max(max(abs(Im0(:,:,:,n)))));
        sz = size(tIm0);
        minval = 0;
        maxval = 1;
        rows = floor(sqrt(sz(3))); 
        IMSTRCT.type = 'abs'; IMSTRCT.start = 1; IMSTRCT.step = 1; IMSTRCT.stop = sz(3); 
        IMSTRCT.rows = rows; IMSTRCT.lvl = [minval maxval]; IMSTRCT.SLab = 0; IMSTRCT.figno = 1000+n; 
        IMSTRCT.docolor = 0; IMSTRCT.ColorMap = 'ColorMap4'; 
        IMSTRCT.figsize = [];
        AxialMontage_v2a(tIm0,IMSTRCT);
    end
    Im0 = Im0.^2;
    Im0 = squeeze(sum(Im0,4));
    Im0 = abs(Im0)/max(abs(Im0(:)));
    IMSTRCT.figno = 1000+n+1; 
    AxialMontage_v2a(Im0,IMSTRCT);
end

%---------------------------------------------
% Get Grappa Kernel
%---------------------------------------------
func = str2func([SPIRIT.kernfunc,'_Func']);  
INPUT = '';
[GKERN,err] = func(GKERN,INPUT);
if err.flag
    return
end
clear INPUT;

%---------------------------------------------
% Get Grappa Calibration Data
%---------------------------------------------
func = str2func([SPIRIT.caldatfunc,'_Func']);  
INPUT.kDat = kMat0;
[GCDAT,err] = func(GCDAT,INPUT);
if err.flag
    return
end
clear INPUT;
cDat = GCDAT.cDat;

%---------------------------------------------
% Calculate Grappa Weights
%---------------------------------------------
func = str2func([SPIRIT.wcalcfunc,'_Func']);  
INPUT.GKERN = GKERN;
INPUT.cDat = cDat;
[GWCALC,err] = func(GWCALC,INPUT);
if err.flag
    return
end
clear INPUT;
G = GWCALC.G
test = max(abs(G))

%---------------------------------------------
% Calculate Adjoint of Grappa Weights 
%---------------------------------------------
func = str2func([SPIRIT.acalcfunc,'_Func']);  
INPUT.G = G;
[GACALC,err] = func(GACALC,INPUT);
if err.flag
    return
end
clear INPUT;
Gadjoint = GACALC.Gadjoint;

%---------------------------------------------
% Image Scale Test level
%---------------------------------------------
Im = fftshift(ifftn(ifftshift(kMatOrig(:,:,:,1)))); 
sz = size(Im);
IMSTRCT.type = 'abs'; IMSTRCT.start = 1; IMSTRCT.step = 1; IMSTRCT.stop = sz(3); 
IMSTRCT.rows = floor(sqrt(sz(3))); IMSTRCT.lvl = [0 max(abs(Im(:)))]; IMSTRCT.SLab = 0; 
IMSTRCT.docolor = 0; IMSTRCT.ColorMap = 'ColorMap4'; IMSTRCT.figsize = [];
IMSTRCT.figno = 2000;
AxialMontage_v2a(Im,IMSTRCT);

for its = 1:3
%---------------------------------------------
% Test Latest
%---------------------------------------------
Im = fftshift(ifftn(ifftshift(kMat0(:,:,:,1)))); 
IMSTRCT.figno = 2001;
IMSTRCT.lvl = [0 max(abs(Im(:)))];
AxialMontage_v2a(Im,IMSTRCT);
    
%=================================================
% Spirit - Grappa Consistency Leg
%=================================================
    dograppa = 0;
    if dograppa == 1;
        
    %---------------------------------------------
    % Standard Grappa Convolution
    %---------------------------------------------
    func = str2func([SPIRIT.convfunc,'_Func']);  
    INPUT.GKERN = GKERN;
    INPUT.G = G;
    INPUT.kDat = kMat0;
    [GCONV,err] = func(GCONV,INPUT);
    if err.flag
        return
    end
    clear INPUT;
    kMat1 = GCONV.kDat;
    
    Im = fftshift(ifftn(ifftshift(kMat1(:,:,:,1))));
    IMSTRCT.figno = 2002;
    AxialMontage_v2a(Im,IMSTRCT);

    %---------------------------------------------
    % Subtraction
    %---------------------------------------------
    subErr1 = kMat1 - kMat0;
    %test = max(abs(subErr1(:)))
    clear kMat1;

    Im = fftshift(ifftn(ifftshift(subErr1(:,:,:,1))));
    IMSTRCT.figno = 2003;
    AxialMontage_v2a(Im,IMSTRCT);
    
    %---------------------------------------------
    % Adjoint Grappa Convolution
    %---------------------------------------------
    func = str2func([SPIRIT.convfunc,'_Func']);  
    INPUT.GKERN = GKERN;
    INPUT.G = Gadjoint;
    INPUT.kDat = subErr1;
    [GCONV,err] = func(GCONV,INPUT);
    if err.flag
        return
    end
    clear INPUT;
    subErr2 = GCONV.kDat;

    Im = fftshift(ifftn(ifftshift(subErr2(:,:,:,1))));
    IMSTRCT.figno = 2004;
    AxialMontage_v2a(Im,IMSTRCT);    
    
    %---------------------------------------------
    % Subtraction
    %---------------------------------------------
    GrappaErr = (subErr2 - subErr1);

    Im = fftshift(ifftn(ifftshift(GrappaErr(:,:,:,1))));
    IMSTRCT.figno = 2005;
    AxialMontage_v2a(Im,IMSTRCT);    
       
    end
    
%=================================================
% Spirit - Data Consistency Leg
%=================================================    
    dogridding = 1;
    if dogridding == 1;

    %---------------------------------------------
    % Reverse Grid
    %---------------------------------------------
    func = str2func([SPIRIT.gridrevfunc,'_Func']);  
    Dat1 = zeros(size(Dat0));
    Subsamp = 1.25;
    INPUT.IMP = IMP;
    %for n = 1:Nrcvrs
    for n = 1:1
        INPUT.kDat = squeeze(kMat0(:,:,:,n));
        INPUT.KRNprms = KRNprms;
        INPUT.SubSamp = Subsamp;
        GRDR.type = 'complex';
        [GRDR,err] = func(GRDR,INPUT);
        if err.flag
            return
        end
        Dat1(:,:,n) = DatArr2Mat(GRDR.SampDat,IMP.PROJimp.nproj,IMP.PROJimp.npro);
    end
    GRDR = rmfield(GRDR,'SampDat');

    %figure(3000); hold on;
    %plot(real(squeeze(Dat0(1,:,1))),'k')
    %plot(real(squeeze(Dat1(1,:,1))),'r')
    %figure(3001); hold on;
    %plot(imag(squeeze(Dat0(1,:,1))),'k')
    %plot(imag(squeeze(Dat1(1,:,1))),'r')
    
    %---------------------------------------------
    % Subtraction
    %---------------------------------------------    
    subErr = Dat1 - Dat0;
    
    %---------------------------------------------
    % Grid Error
    %---------------------------------------------
    func = str2func([SPIRIT.gridfunc,'_Func']);  
    DataErr = zeros(size(kMat0));
    Subsamp = 1.25;
    INPUT.IMP = IMP;
    %for n = 1:Nrcvrs
    for n = 1:1
        INPUT.DAT = squeeze(subErr(:,:,n).*SDCmat(:,:,n));
        INPUT.KRNprms = KRNprms;
        INPUT.SubSamp = Subsamp;
        GRD.type = 'complex';
        [GRD,err] = func(GRD,INPUT);
        if err.flag
            return
        end
        DataErr(:,:,:,n) = GRD.GrdDat;
    end
    GRD = rmfield(GRD,'GrdDat');
    
    Im = fftshift(ifftn(ifftshift(DataErr(:,:,:,1))));
    IMSTRCT.figno = 2006;
    AxialMontage_v2a(Im,IMSTRCT);        

    end
    
    error();
    
%=================================================
% CG
%=================================================          
    lambda = 0.01;
    kMat0 = kMat0 - (DataErr + lambda*GrappaErr);
    %kMat0 = kMat0 - DataErr;
    %kMat0 = kMat0 - lambda*GrappaErr;
end    
    
%---------------------------------------------
% Return
%---------------------------------------------
SPIRIT.kDat = kDat;

Status2('done','',2);
Status2('done','',3);

