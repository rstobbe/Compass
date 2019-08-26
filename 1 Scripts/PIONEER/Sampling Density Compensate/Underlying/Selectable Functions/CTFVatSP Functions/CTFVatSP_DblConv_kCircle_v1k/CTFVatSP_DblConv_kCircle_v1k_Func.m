%=========================================================
%
%=========================================================

function [CTFV,err] = CTFVatSP_DblConv_kCircle_v1k_Func(CTFV,INPUT)

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

%----------------------------------------
% Tests
%----------------------------------------
if isfield(PROJdgn,'elip')
    if PROJdgn.elip ~= 1;                   
        err.flag = 1;
        err.msg = 'Elip Not Supported with ''CTFVatSP_DblConv_kCircle''';
        return
    end
else
    PROJdgn.elip = 1;
end
if size(Kmat,2) == 3 
    if sum(Kmat,3) ~= 0
        err.flag = 1;
        err.msg = '''CTFVatSP_DblConv_kCircle'' is for 2D kSpace Sampling';
        return 
    end
end

%---------------------------------------------
% Common Variables
%---------------------------------------------
kstep = PROJdgn.kstep;
CTFvis = 'On';

%---------------------------------------------
% Functions
%---------------------------------------------
if strcmp(SDCS.Device,'Mex')
    err.flag = 1;
    err.msg = 'Mex Is Not Suppported';
    return
elseif strcmp(SDCS.Device,'CUDA')
    CUDAdevice = 1;
    if strcmp(SDCS.Precision,'Double')
        CTFV.S2GConvfunc = 'mS2GCUDADoubleR2D_v4f';
        CTFV.G2SConvfunc = 'mG2SCUDADoubleR2D_v4f';
    elseif strcmp(SDCS.Precision,'Single')
        err.flag = 1;
        err.msg = 'Single Precision Is Not Suppported';
        return
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
[Ksz,Kx,Ky,centre] = NormProjGrid2D_v4c(TFB.Loc,NaN,NaN,kstep,CONVprms.chW,TFB.SubSamp,'A2A');
Fcentre = centre;
%test = max([Kx,Ky,Kz]);

%----------------------------------------
% DblKern Convolve (for testing)
%----------------------------------------
Status2('busy','Convolve TF to Grid with DblKern',2);
StatLev = 3;
[ConvTF,err] = S2Gconvfunc(Ksz,Kx,Ky,DblKern,TFB.Val,CONVprms,StatLev,CUDAdevice);
if err.flag
    return
end
ConvTF = ConvTF/(DblKern.convscaleval*TFB.SubSamp^2);
if strcmp(CTFV.Norm,'SampChars')
    ConvTF = ConvTF*PROJimp.projosamp*PROJimp.trajosamp;
    ConvTF = ConvTF/PROJdgn.elip;
end

if (strcmp(CTFvis,'On'))         
    figure(300); hold on; title('Convolved (desired/expected) TF');
    rconv = (0:(centre-1))/TFB.RadDim; 
    ConvTFprof = ConvTF(centre:Ksz,centre);
    plot(rconv,ConvTFprof,'b-');
    if strcmp(CTFV.Norm,'SampChars')
        plot([TFO.r 1],[TFO.tf 0]*PROJimp.projosamp*PROJimp.trajosamp/PROJdgn.elip,'k:');
    elseif strcmp(CTFV.Norm,'OneAtCen')
        plot([TFO.r 1],[TFO.tf 0],'k:');
    end
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
[ConvTF,err] = S2Gconvfunc(Ksz,Kx,Ky,FwdKern,TFB.Val,CONVprms,StatLev,CUDAdevice);
if err.flag
    return
end
ConvTF = ConvTF/(FwdKern.convscaleval*TFB.SubSamp^2);
if strcmp(CTFV.Norm,'SampChars')
    ConvTF = ConvTF*PROJimp.projosamp*PROJimp.trajosamp;
    ConvTF = ConvTF/PROJdgn.elip;
end

if (strcmp(CTFvis,'On'))         
    figure(300); hold on;
    rconv = (0:(centre-1))/TFB.RadDim; 
    ConvTFprof = ConvTF(centre:Ksz,centre);
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
[Ksz,Kx,Ky,centre] = NormProjGridExt2D_v4c(Kmat,PROJimp.nproj,PROJimp.npro,kstep,CONVprms.chW,TFB.SubSamp,Fcentre,'M2A');

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
Rad = ((Kx-centre).^2 + (Ky-centre).^2).^(0.5);
Kx = Rad + centre;
%----------------
% testing
%Kx = (0:0.01:centre-0.1) + centre;
%----------------
Ky = zeros(size(Kx)) + centre;
[DOV,err] = G2Sconvfunc(Ksz,Kx,Ky,RvsKern,ConvTF,CONVprms,StatLev,CUDAdevice);
if err.flag == 1
    return
end

DOV = DOV/(RvsKern.convscaleval*TFB.SubSamp^2);
%normDOV = DOV(1);
%DOV = DOV/normDOV;
if (strcmp(CTFvis,'On'))         
    figure(300); hold on;
    plot((((Kx-centre).^2 + (Ky-centre).^2).^(0.5))/TFB.RadDim,DOV,'k*');
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

