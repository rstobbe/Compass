%=========================================================
% (v1e)
%       - Update for RWSUI_BA
%=========================================================

function [SCRPTipt,CTFout,err] = CTFVatSP_DblConv_kElip_v1e(SCRPTipt,CTF,err)

Status('busy','Convolved Output Transfer Function at Samp');
Status2('done','',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Load Input
%---------------------------------------------
CTFout.TFbuildfunc = CTF.('TFbuildfunc').Func;

%---------------------------------------------
% Setup up Called Function
%---------------------------------------------
TFB = CTF.('TFbuildfunc');
CallingPanel = CTF.Struct.labelstr;
if isfield(CTF,([CallingPanel,'_Data']))
    if isfield(CTF.([CallingPanel,'_Data']),('TFbuildfunc_Data'))
        TFB.('TFbuildfunc_Data') = CTF.([CallingPanel,'_Data']).('TFbuildfunc_Data');
    end
end

%---------------------------------------------
% Get Working Structures / Variables
%---------------------------------------------
PROJdgn = CTF.PROJdgn;
PROJimp = CTF.PROJimp;
Kmat = CTF.Kmat;
TFO = CTF.TFO;
KRNprms = CTF.KRNprms;
DblKern = KRNprms.DblKern;
FwdKern = KRNprms.FwdKern;
RvsKern = KRNprms.RvsKern;

%---------------------------------------------
% Functions
%---------------------------------------------
CTFout.S2GConvfunc = 'mFCMexSingleR_v3';
CTFout.G2SConvfunc = 'mG2SMexSingleR_v3';
S2Gconvfunc = str2func(CTFout.S2GConvfunc);
G2Sconvfunc = str2func(CTFout.G2SConvfunc);

%--------------------------------------
% Build Desired TF
%--------------------------------------
Status2('busy','Build Desired TF',2);
Status2('busy','',3);
TFB.PROJdgn = PROJdgn;
TFB.PROJimp = PROJimp;
TFB.TFO = TFO;
TFB.KRNprms = KRNprms;
func = str2func(CTFout.TFbuildfunc);
[SCRPTipt,TFB,err] = func(SCRPTipt,TFB);
Status2('done','',2);
if err.flag
    return
end

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
% Normalize Desired TF to Grid
%----------------------------------------
maxkmax = PROJimp.maxrelkmax*PROJdgn.kmax;
kernwid = DblKern.W;
[Ksz,Kx,Ky,Kz,centre] = NormProjGrid_v4(TFB.Loc,NaN,NaN,maxkmax,PROJdgn.kstep,kernwid,TFB.SubSamp,'A2A');

%----------------------------------------
% DblKern Convolve (for testing)
%----------------------------------------
Status2('busy','Convolve TF to Grid with DblKern',2);
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
StatLev = 3;

[ConvTF,outerror,outerrorflag] = S2Gconvfunc(Ksz,Kx,Ky,Kz,DblKern,TFB.Val,CONVprms,StatLev);
if outerrorflag == 1
    err.flag = 1;
    err.msg = outerror;
    return
end
ConvTF = ConvTF/(DblKern.convscaleval*TFB.SubSamp^3);
ConvTF = ConvTF*PROJimp.projosamp*PROJimp.trajosamp;
ConvTF = ConvTF/PROJdgn.elip;

CTFvis = 'On';
if (strcmp(CTFvis,'On'))         
    figure(300); hold on; title('Convolved (desired/expected) TF');
    rconv = (0:(centre-1))/TFB.RadDim; 
    ConvTFprof = ConvTF(centre:Ksz,centre,centre);
    plot(rconv,ConvTFprof,'b-');
    plot([TFO.r 1],[TFO.tf 0]*PROJimp.projosamp*PROJimp.trajosamp,'k:');
end

%----------------------------------------
% FwdKern Convolve
%----------------------------------------
Status2('busy','Convolve TF to Grid',2);
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
StatLev = 3;

[ConvTF,outerror,outerrorflag] = S2Gconvfunc(Ksz,Kx,Ky,Kz,FwdKern,TFB.Val,CONVprms,StatLev);
if outerrorflag == 1
    err.flag = 1;
    err.msg = outerror;
    return
end
ConvTF = ConvTF/(FwdKern.convscaleval*TFB.SubSamp^3);
ConvTF = ConvTF*PROJimp.projosamp*PROJimp.trajosamp;
ConvTF = ConvTF/PROJdgn.elip;

if (strcmp(CTFvis,'On'))         
    figure(300); hold on;
    rconv = (0:(centre-1))/TFB.RadDim; 
    ConvTFprof = ConvTF(centre:Ksz,centre,centre);
    plot(rconv,ConvTFprof,'r-');
end

%----------------------------------------
% Normalize Sampling Locations to Grid
%----------------------------------------
[Ksz,Kx,Ky,Kz,centre] = NormProjGrid_v4(Kmat,PROJimp.nproj,PROJimp.npro,maxkmax,PROJdgn.kstep,kernwid,TFB.SubSamp,'M2A');

%----------------------------------------
% Reverse Convolve
%----------------------------------------
Status2('busy','Convolve Grid to Sampling Points',2);
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
StatLev = 3;

Kx = [centre;Kx];
Ky = [centre;Ky];
Kz = [centre;Kz];
[DOV,outerror,outerrorflag] = G2Sconvfunc(Ksz,Kx,Ky,Kz,RvsKern,ConvTF,CONVprms,StatLev);
if outerrorflag == 1
    err.flag = 1;
    err.msg = outerror;
    return
end

DOV = DOV/(RvsKern.convscaleval*TFB.SubSamp^3);
%normDOV = DOV(1);
%DOV = DOV/normDOV;
if (strcmp(CTFvis,'On'))         
    figure(300); hold on;
    plot((((Kx-centre).^2 + (Ky-centre).^2 + (Kz-centre).^2).^(0.5))/TFB.RadDim,DOV,'k*');
end
DOV = DOV(2:length(DOV));

%----------------------------------------
% Return
%----------------------------------------
CTFout.DOV = DOV;
CTFout.TFB = TFB;

%----------------------------------------------------
% Panel Output
%----------------------------------------------------
Panel(1,:) = {'TF_RadDim',TFB.RadDim,'Output'};
Panel(2,:) = {'TF_SubSamp',TFB.SubSamp,'Output'};
Panel(3,:) = {'TF_rLocMax',TFB.rLocMax,'Output'};
PanelOutput = cell2struct(Panel,{'label','value','type'},2);
CTFout.PanelOutput = PanelOutput;

Status('done','');
Status2('done','',2);
Status2('done','',3);

