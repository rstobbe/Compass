%=========================================================
% (v1a)
%   
%=========================================================

function [DOV,SDCS,SCRPTipt,err] = CTFVatSP_DblConv_kSphere_v1a(Kmat,PROJimp,TF,KRNprms,SDCS,SCRPTipt,err)

DOV = [];
CTF.TFbuildfunc = SCRPTipt(strcmp('TFbuildfunc',{SCRPTipt.labelstr})).entrystr;

CTF.S2GConvfunc = 'mFCMexSingleR_v3';
CTF.G2SConvfunc = 'mG2SMexSingleR_v3';
S2Gconvfunc = str2func(CTF.S2GConvfunc);
G2Sconvfunc = str2func(CTF.G2SConvfunc);
CTFvis = 'On';
DblKern = KRNprms.DblKern;
FwdKern = KRNprms.FwdKern;
RvsKern = KRNprms.RvsKern;

%--------------------------------------
% Build Convolved TF
%--------------------------------------
Status2('busy','Build TF',2);
Status2('busy','',3);
func = str2func(CTF.TFbuildfunc);
[CTF,SCRPTipt,err] = func(PROJimp,TF,KRNprms,CTF,SDCS,SCRPTipt,err);
Status2('done','',2);
for n = 1:length(err)
    if err(n).flag == 1
        return
    end
end

%----------------------------------------
% DblKern Convolve (for testing)
%----------------------------------------
Status2('busy','Convolve TF with DblKern',2);
[Ksz,Kx,Ky,Kz,centre] = NormProjGrid_v4(CTF.Loc,NaN,NaN,SDCS.compkmax,PROJimp.kstep,DblKern.W,CTF.SubSamp,'A2A');

zWtest = 2*(ceil((DblKern.W*CTF.SubSamp-2)/2)+1)/CTF.SubSamp;                       % with mFCMexSingleR_v3
if zWtest > DblKern.zW
    error('Kernel Zero-Fill Too Small');
end
DblKern.W = DblKern.W*CTF.SubSamp;
DblKern.res = DblKern.res*CTF.SubSamp;
if round(1e9/DblKern.res) ~= 1e9*round(1/DblKern.res)
    error('should not get here - already tested');
end    
DblKern.iKern = round(1/DblKern.res);
CONVprms.chW = ceil((DblKern.W-2)/2);                    % with mFCMexSingleR_v3
StatLev = 3;

[ConvTF,outerror,outerrorflag] = S2Gconvfunc(Ksz,Kx,Ky,Kz,DblKern,CTF.Val,CONVprms,StatLev);
if outerrorflag == 1
    if length(err) ~= 1
        errn = length(err)+1;
    else
        errn = 1;
    end
    err(errn).flag = 1;
    err(errn).msg = outerror;
    return
end
ConvTF = ConvTF/ConvTF(centre,centre,centre);

if (strcmp(CTFvis,'On'))         
    figure(300); hold on;
    rconv = (0:(centre-1)); 
    ConvTFprof = ConvTF(centre:Ksz,centre,centre);
    plot(rconv,ConvTFprof,'b-');
end

%----------------------------------------
% FwdKern Convolve
%----------------------------------------
Status2('busy','Convolve TF to Grid',2);
[Ksz,Kx,Ky,Kz,centre] = NormProjGrid_v4(CTF.Loc,NaN,NaN,SDCS.compkmax,PROJimp.kstep,DblKern.W,CTF.SubSamp,'A2A');

zWtest = 2*(ceil((FwdKern.W*CTF.SubSamp-2)/2)+1)/CTF.SubSamp;                       % with mFCMexSingleR_v3
if zWtest > FwdKern.zW
    error('Kernel Zero-Fill Too Small');
end
FwdKern.W = FwdKern.W*CTF.SubSamp;
FwdKern.res = FwdKern.res*CTF.SubSamp;
if round(1e9/FwdKern.res) ~= 1e9*round(1/FwdKern.res)
    error('should not get here - already tested');
end    
FwdKern.iKern = round(1/FwdKern.res);
CONVprms.chW = ceil((FwdKern.W-2)/2);                    % with mFCMexSingleR_v3
StatLev = 3;

[ConvTF,outerror,outerrorflag] = S2Gconvfunc(Ksz,Kx,Ky,Kz,FwdKern,CTF.Val,CONVprms,StatLev);
if outerrorflag == 1
    if length(err) ~= 1
        errn = length(err)+1;
    else
        errn = 1;
    end
    err(errn).flag = 1;
    err(errn).msg = outerror;
    return
end
ConvTF = ConvTF/ConvTF(centre,centre,centre);

if (strcmp(CTFvis,'On'))         
    figure(300); hold on;
    rconv = (0:(centre-1)); 
    ConvTFprof = ConvTF(centre:Ksz,centre,centre);
    plot(rconv,ConvTFprof,'r-');
end


%----------------------------------------
% Reverse Convolve
%----------------------------------------
Status2('busy','Convolve Grid to Sampling Points',2);
[Ksz,Kx,Ky,Kz,centre] = NormProjGrid_v4(Kmat,PROJimp.nproj,PROJimp.npro,SDCS.compkmax,PROJimp.kstep,DblKern.W,CTF.SubSamp,'M2A');

zWtest = 2*(ceil((RvsKern.W*CTF.SubSamp-2)/2)+1)/CTF.SubSamp;                       % with mFCMexSingleR_v3
if zWtest > RvsKern.zW
    error('Kernel Zero-Fill Too Small');
end
RvsKern.W = RvsKern.W*CTF.SubSamp;
RvsKern.res = RvsKern.res*CTF.SubSamp;
if round(1e9/RvsKern.res) ~= 1e9*round(1/RvsKern.res)
    error('should not get here - already tested');
end    
RvsKern.iKern = round(1/RvsKern.res);
CONVprms.chW = ceil((RvsKern.W-2)/2);                    % with mFCMexSingleR_v3
StatLev = 3;

Kx = [centre;Kx];
Ky = [centre;Ky];
Kz = [centre;Kz];
Rad = ((Kx-centre).^2 + (Ky-centre).^2 + (Kz-centre).^2).^(0.5);
Kx = Rad + centre;
%----------------
% testing
%Kx = (0:0.01:centre-0.1) + centre;
%----------------
Ky = zeros(size(Kx)) + centre;
Kz = zeros(size(Kx)) + centre;

[DOV,outerror,outerrorflag] = G2Sconvfunc(Ksz,Kx,Ky,Kz,RvsKern,ConvTF,CONVprms,StatLev);
if outerrorflag == 1
    if length(err) ~= 1
        errn = length(err)+1;
    else
        errn = 1;
    end
    err(errn).flag = 1;
    err(errn).msg = outerror;
    return
end

DOV = DOV/(CTF.SubSamp^3);
normDOV = DOV(1);
DOV = DOV/normDOV;
if (strcmp(CTFvis,'On'))         
    figure(300); hold on;
    plot((((Kx-centre).^2 + (Ky-centre).^2 + (Kz-centre).^2).^(0.5)),DOV,'k*');
end

DOV = DOV(2:length(DOV));
SDCS.CTF = CTF;

