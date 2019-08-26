%=========================================================
% 
%=========================================================

function [CTFV,err] = CTFVatSP_DblConv_kElip_v1h_Func(CTFV,INPUT)

Status2('busy','Convolved Output Transfer Function at Samp',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Get Input
%---------------------------------------------
IMP = INPUT.IMP;
if isfield(IMP,'impPROJdgn');
    PROJdgn = IMP.impPROJdgn;
else
    PROJdgn = IMP.PROJdgn;
end
PROJimp = IMP.PROJimp;
Kmat = IMP.Kmat;
TFO = INPUT.TFO;
KRNprms = INPUT.KRNprms;
SDCS = INPUT.SDCS;
DblKern = KRNprms.DblKern;
FwdKern = KRNprms.FwdKern;
RvsKern = KRNprms.RvsKern;
clear INPUT;

%---------------------------------------------
% Common Variables
%---------------------------------------------
kstep = PROJdgn.kstep;
CTFvis = 'On';

%---------------------------------------------
% Functions
%---------------------------------------------
if strcmp(SDCS.Device,'Mex')
    if strcmp(SDCS.Precision,'Double')
        CTFV.S2GConvfunc = 'mS2GMexDoubleR_v3a';
        CTFV.G2SConvfunc = 'mG2SMexDoubleR_v3b';
    elseif strcmp(SDCS.Precision,'Single')
        CTFV.S2GConvfunc = 'mS2GMexSingleR_v3a';
        CTFV.G2SConvfunc = 'mG2SMexSingleR_v3b';
    end
elseif strcmp(SDCS.Device,'CUDA')
    if strcmp(SDCS.Precision,'Double')
        CTFV.S2GConvfunc = 'mS2GCUDADoubleR_v4d';
        CTFV.G2SConvfunc = 'mG2SCUDADoubleR_v4d';
    elseif strcmp(SDCS.Precision,'Single')
        CTFV.S2GConvfunc = 'mS2GCUDASingleR_v4d';
        CTFV.G2SConvfunc = 'mG2SCUDASingleR_v4d';
    end
end
S2Gconvfunc = str2func(CTFV.S2GConvfunc);
G2Sconvfunc = str2func(CTFV.G2SConvfunc);

%---------------------------------------------
% Build Desired TF
%---------------------------------------------
Status2('busy','Build Desired TF',2);
func = str2func([CTFV.TFbuildfunc,'_Func']);  
TFB = CTFV.TFB;
INPUT.IMP = IMP;
INPUT.TFO = TFO;
INPUT.KRNprms = KRNprms;
[TFB,err] = func(TFB,INPUT);
if err.flag
    return
end
clear INPUT

%--------------------------------------
% Test
%--------------------------------------
button = questdlg(['TF array is ',num2str(length(TFB.Loc)),' points long. SubSamp is ',num2str(TFB.SubSamp),'. RadDim is ',num2str(TFB.RadDim),'. Continue?']); 
if strcmp(button,'No') || strcmp(button,'Cancel')
    err.flag = 4;
    err.msg = '';
    return
end

%----------------------------------------
% DblKern Convolve Setup
%----------------------------------------
zWtest = 2*(ceil((DblKern.W*TFB.SubSamp-2)/2)+1)/TFB.SubSamp;                       % with mFCMexSingleR_v3
if zWtest > DblKern.zW
    error('Kernel Zero-Fill Too Small');
end
DblKern.W = DblKern.W*TFB.SubSamp;
DblKern.res = DblKern.res*TFB.SubSamp;
if round(1e9/DblKern.res) ~= 1e9*round(1/DblKern.res)
    error('should not get here - already tested');
end    
DblKern.iKern = round(1/DblKern.res);
CONVprms.chW = ceil((DblKern.W-2)/2);                    % with mFCMexSingleR_v3

%----------------------------------------
% Normalize Desired TF to Grid
%----------------------------------------
rad = sqrt(Kmat(:,:,1).^2 + Kmat(:,:,2).^2 + Kmat(:,:,3).^2);
kmax = max(rad(:));
[Ksz,Kx,Ky,Kz,centre] = NormProjGrid_v3b(TFB.Loc,NaN,NaN,kmax,kstep,CONVprms.chW,TFB.SubSamp,'A2A');
Fcentre = centre;

%----------------------------------------
% DblKern Convolve (for testing)
%----------------------------------------
Status2('busy','Convolve TF to Grid with DblKern',2);
StatLev = 3;
[ConvTF,err] = S2Gconvfunc(Ksz,Kx,Ky,Kz,DblKern,TFB.Val,CONVprms,StatLev);
if err.flag
    return
end
ConvTF = ConvTF/(DblKern.convscaleval*TFB.SubSamp^3);
ConvTF = ConvTF*PROJimp.projosamp*PROJimp.trajosamp;
ConvTF = ConvTF/PROJdgn.elip;

if (strcmp(CTFvis,'On'))         
    figure(301); hold on; title('Convolved (desired/expected) TF');
    rconv = (0:(centre-1))/TFB.RadDim; 
    ConvTFprof = ConvTF(centre:Ksz,centre,centre);
    plot(rconv,ConvTFprof,'b-');
    plot([TFO.r 1],[TFO.tf 0]*PROJimp.projosamp*PROJimp.trajosamp/PROJdgn.elip,'k:');
end

%----------------------------------------
% FwdKern Convolve Setup
%----------------------------------------
zWtest = 2*(ceil((FwdKern.W*TFB.SubSamp-2)/2)+1)/TFB.SubSamp;                       % with mFCMexSingleR_v3
if zWtest > FwdKern.zW
    error('Kernel Zero-Fill Too Small');
end
FwdKern.W = FwdKern.W*TFB.SubSamp;
FwdKern.res = FwdKern.res*TFB.SubSamp;
if round(1e9/FwdKern.res) ~= 1e9*round(1/FwdKern.res)
    error('should not get here - already tested');
end    
FwdKern.iKern = round(1/FwdKern.res);
CONVprms.chW = ceil((FwdKern.W-2)/2);                    % with mFCMexSingleR_v3

%----------------------------------------
% FwdKern Convolve 
%----------------------------------------
Status2('busy','Convolve TF to Grid',2);
StatLev = 3;
[ConvTF,err] = S2Gconvfunc(Ksz,Kx,Ky,Kz,FwdKern,TFB.Val,CONVprms,StatLev);
if err.flag
    return
end
ConvTF = ConvTF/(FwdKern.convscaleval*TFB.SubSamp^3);
ConvTF = ConvTF*PROJimp.projosamp*PROJimp.trajosamp;
ConvTF = ConvTF/PROJdgn.elip;

if (strcmp(CTFvis,'On'))         
    figure(301); hold on;
    rconv = (0:(centre-1))/TFB.RadDim; 
    ConvTFprof = ConvTF(centre:Ksz,centre,centre);
    plot(rconv,ConvTFprof,'r-');
end

%----------------------------------------
% Reverse Convolve Setup
%----------------------------------------
zWtest = 2*(ceil((RvsKern.W*TFB.SubSamp-2)/2)+1)/TFB.SubSamp;                       % with mFCMexSingleR_v3
if zWtest > RvsKern.zW
    error('Kernel Zero-Fill Too Small');
end
RvsKern.W = RvsKern.W*TFB.SubSamp;
RvsKern.res = RvsKern.res*TFB.SubSamp;
if round(1e9/RvsKern.res) ~= 1e9*round(1/RvsKern.res)
    error('should not get here - already tested');
end    
RvsKern.iKern = round(1/RvsKern.res);
CONVprms.chW = ceil((RvsKern.W-2)/2);                    % with mFCMexSingleR_v3

%----------------------------------------
% Normalize Sampling Locations to Grid
%----------------------------------------
[Ksz,Kx,Ky,Kz,centre] = NormProjGrid_v3b(Kmat,PROJimp.nproj,PROJimp.npro,kmax,kstep,CONVprms.chW,TFB.SubSamp,'M2A');

%----------------------------------------
% Test
%----------------------------------------
if centre~=Fcentre
    error('coding problem');
end

%----------------------------------------
% Reverse Convolve 
%----------------------------------------
Status2('busy','Convolve Grid to Sampling Points',2);
StatLev = 3;
Kx = [centre;Kx];
Ky = [centre;Ky];
Kz = [centre;Kz];
[DOV,err] = G2Sconvfunc(Ksz,Kx,Ky,Kz,RvsKern,ConvTF,CONVprms,StatLev);
if err.flag == 1
    return
end

DOV = DOV/(RvsKern.convscaleval*TFB.SubSamp^3);
%normDOV = DOV(1);
%DOV = DOV/normDOV;
if (strcmp(CTFvis,'On'))         
    figure(301); hold on;
    plot((((Kx-centre).^2 + (Ky-centre).^2 + (Kz-centre).^2).^(0.5))/TFB.RadDim,DOV,'k*');
end
DOV = DOV(2:length(DOV));

%----------------------------------------
% Return
%----------------------------------------
CTFV.DOV = DOV;
CTFV.TFB = TFB;

%----------------------------------------------------
% Panel Output
%----------------------------------------------------
Panel(1,:) = {'TF_RadDim',TFB.RadDim,'Output'};
Panel(2,:) = {'TF_SubSamp',TFB.SubSamp,'Output'};
Panel(3,:) = {'TF_rLocMax',TFB.rLocMax,'Output'};
PanelOutput = cell2struct(Panel,{'label','value','type'},2);
CTFV.PanelOutput = PanelOutput;

Status2('done','',2);
Status2('done','',3);
