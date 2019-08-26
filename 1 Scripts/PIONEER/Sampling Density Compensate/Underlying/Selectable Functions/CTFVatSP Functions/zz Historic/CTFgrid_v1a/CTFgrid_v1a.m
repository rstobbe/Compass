%================================================================================
% (CTFgrid)
%================================================================================

function [CTF,SDCS,SCRPTipt,err] = CTFgrid_v1a(Kmat,PROJdgn,PROJimp,TF,KRNprms,SDCS,SCRPTipt,err)

CTF.TFRadDim = str2double(SCRPTipt(strcmp('TFRadDim',{SCRPTipt.labelstr})).entrystr);
CTF.scale = SCRPTipt(strcmp('CTFscale',{SCRPTipt.labelstr})).entrystr;
if iscell(CTF.scale)
    CTF.scale = SCRPTipt(strcmp('CTFscale',{SCRPTipt.labelstr})).entrystr{SCRPTipt(strcmp('CTFscale',{SCRPTipt.labelstr})).entryvalue};
end

%----------------------------------------
% Error Tests
%----------------------------------------
if not(isfield(PROJdgn,'elip'))
    err.flag = 1;
    err.msg = 'Projection design must specify ''elip''';
    return
end

%----------------------------------------
% 'Sphere-Array' Size Test
%----------------------------------------
kmax = SDCS.compkmax;
SampSpacing = CTF.TFRadDim/(kmax/PROJdgn.kstep);

%----------------------------------------
% Build 'Sphere-Array'
%----------------------------------------
Status2('busy','Build Transfer Function Shape',2);
R = CTF.TFRadDim + 1;
Loc = zeros((2*R)^3,3);
Val = zeros((2*R)^3,1);
n = 1;
m = 1;
L = length(TF.r)-1;
for x = -R:R
    for y = -R:R
        for z = -ceil(R*PROJdgn.elip):ceil(R*PROJdgn.elip)
            r0 = sqrt(x^2 + y^2 + z^2);
            if r0 == 0
                r = 0;
            else
                phi = acos(z/r0);
                rmax = sqrt(((PROJdgn.elip*CTF.TFRadDim)^2)/(PROJdgn.elip^2*(sin(phi))^2 + (cos(phi))^2));
                r = r0/rmax;
            end
            if r <= 1 
                 Loc(n,:) = [x y z];  
                 Val(n) = lin_interp4(TF.tf,r,L);
                 n = n+1;
            elseif r > 1 && r <= 1.0001                             % accomodate quantization (for CTF.MinRadDim > 80, below does nothing)
                 Loc(n,:) = [x y z];  
                 r = 1;
                 Val(n) = lin_interp4(TF.tf,r,L);
                 n = n+1;                
            end
        end
    end
    Status2('busy',num2str(2*R-m+1),3);   
    m = m+1; 
end
Status2('done','',3);
Tot = (n-1);
compV = PROJdgn.elip*pi*(4/3)*CTF.TFRadDim.^3;
CTF.relQuantSphereVol = Tot/compV;
if abs((1-CTF.relQuantSphereVol)*100) > 2
    err.flag = 1;
    err.msg = 'Spheroid Creation More than 2% in error (increase ''MaxRadDim'')';
    return
end
Loc = Loc(1:n-1,:)*(PROJdgn.kstep/SampSpacing);
Val = Val(1:n-1);

%----------------------------------------
% Convolve 'Sphere-Array'
%----------------------------------------
KRNprms0 = KRNprms;
Status2('busy','Convolve Transfer Function Shape',2);
[Ksz,Kx,Ky,Kz,centre] = NormProjGrid_v4(Loc,NaN,NaN,kmax,PROJdgn.kstep,KRNprms0.W,SDCS.SubSamp,'A2A');

zWtest = 2*(ceil((KRNprms0.W*SDCS.SubSamp-2)/2)+1)/SDCS.SubSamp;                       % with mFCMexSingleR_v
if zWtest > KRNprms0.zW
    error('Kernel Zero-Fill Too Small');
end
KRNprms0.W = KRNprms0.W*SDCS.SubSamp;
KRNprms0.res = KRNprms0.res*SDCS.SubSamp;
if round(1e9/KRNprms0.res) ~= 1e9*round(1/KRNprms0.res)
    error('should not get here - already tested');
end    
KRNprms0.iKern = round(1/KRNprms0.res);
CONVprms.chW = ceil((KRNprms0.W-2)/2);                    % with mFCMexSingleR_v3
StatLev = 3;

[ConvTF,outerror,outerrorflag] = mFCMexSingleR_v3(Ksz,Kx,Ky,Kz,KRNprms0,Val,CONVprms,StatLev);
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

%----------------------------------------
% Return
%----------------------------------------
CTF.rconvSS = ((-(centre-1):(centre-1))/SDCS.SubSamp)/(kmax/PROJdgn.kstep); 

%----------------------------------------
% Scale
%----------------------------------------
if strcmp(CTF.scale,'includeOS')
    if isfield(PROJdgn,'projosamp')
        CTF.ConvTFSS = PROJdgn.projosamp*PROJimp.osamp*ConvTF/(SampSpacing^3);
    else
        CTF.ConvTFSS = PROJimp.osamp*ConvTF/(SampSpacing^3);
    end
elseif strcmp(CTF.scale,'CentreVal1')
    CentreVal = max(Val);                   % assuming 'normal' sort of tranfer function
    CTF.ConvTFSS = ConvTF/(CentreVal*(SampSpacing^3));
else
    CTF.ConvTFSS = ConvTF/(SampSpacing^3);
end

%----------------------------------------
% Visuals
%----------------------------------------
CTF.visuals = 'On';
if (strcmp(CTF.visuals,'On'))         
    figure(300); hold on;
    plot(CTF.rconvSS,squeeze(CTF.ConvTFSS(centre,centre,:)),'b-*');
    plot(CTF.rconvSS,squeeze(CTF.ConvTFSS(centre,:,centre)),'g-*');
    plot(CTF.rconvSS,squeeze(CTF.ConvTFSS(:,centre,centre)),'r-*');
    %xlim([0 1.2]); 
    title('Convolved TF Shape Profiles');   
    figure(301); hold on;
    plot(squeeze(CTF.ConvTFSS(centre,centre,:)),'b-*');
    plot(squeeze(CTF.ConvTFSS(centre,:,centre)),'g-*');
    plot(squeeze(CTF.ConvTFSS(:,centre,centre)),'r-*');
    title('Convolved TF Shape Profiles');   
    %figure(301);
    %imshow(squeeze(CTF.ConvTFSS(centre,:,:)),[0 max(CTF.ConvTFSS(:))]);
    %figure(302);
    %imshow(squeeze(CTF.ConvTFSS(:,:,centre)),[0 max(CTF.ConvTFSS(:))]);    
end


%======================================================================
% non subsampled
%======================================================================
SubSamp = 1;

%----------------------------------------
% Convolve 'Sphere-Array'
%----------------------------------------
KRNprms0 = KRNprms;
Status2('busy','Convolve Transfer Function Shape',2);
[Ksz,Kx,Ky,Kz,centre] = NormProjGrid_v4(Loc,NaN,NaN,kmax,PROJdgn.kstep,KRNprms0.W,SubSamp,'A2A');

zWtest = 2*(ceil((KRNprms0.W*SubSamp-2)/2)+1)/SubSamp;                       % with mFCMexSingleR_v
if zWtest > KRNprms0.zW
    error('Kernel Zero-Fill Too Small');
end
KRNprms0.W = KRNprms0.W*SubSamp;
KRNprms0.res = KRNprms0.res*SubSamp;
if round(1e9/KRNprms0.res) ~= 1e9*round(1/KRNprms0.res)
    error('should not get here - already tested');
end    
KRNprms0.iKern = round(1/KRNprms0.res);
CONVprms.chW = ceil((KRNprms0.W-2)/2);                    % with mFCMexSingleR_v3
StatLev = 3;

[ConvTF,outerror,outerrorflag] = mFCMexSingleR_v3(Ksz,Kx,Ky,Kz,KRNprms0,Val,CONVprms,StatLev);
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

%----------------------------------------
% Return
%----------------------------------------
CTF.rconv = (-(centre-1):(centre-1))/(kmax/PROJdgn.kstep); 

%----------------------------------------
% Scale
%----------------------------------------
if strcmp(CTF.scale,'includeOS')
    if isfield(PROJdgn,'projosamp')
        CTF.ConvTF = PROJdgn.projosamp*PROJimp.osamp*ConvTF/(SampSpacing^3);
    else
        CTF.ConvTF = PROJimp.osamp*ConvTF/(SampSpacing^3);
    end
elseif strcmp(CTF.scale,'CentreVal1')
    CentreVal = max(Val);                   % assuming 'normal' sort of tranfer function
    CTF.ConvTF = ConvTF/(CentreVal*(SampSpacing^3));
else
    CTF.ConvTF = ConvTF/(SampSpacing^3);
end

%----------------------------------------
% Visuals
%----------------------------------------
CTF.visuals = 'On';
if (strcmp(CTF.visuals,'On'))         
    figure(302); hold on;
    plot(CTF.rconv,squeeze(CTF.ConvTF(centre,centre,:)),'b-*');
    plot(CTF.rconv,squeeze(CTF.ConvTF(centre,:,centre)),'g-*');
    plot(CTF.rconv,squeeze(CTF.ConvTF(:,centre,centre)),'r-*');
    %xlim([0 1.2]); 
    title('Convolved TF Shape Profiles');   
    figure(303); hold on;
    plot(squeeze(CTF.ConvTF(centre,centre,:)),'b-*');
    plot(squeeze(CTF.ConvTF(centre,:,centre)),'g-*');
    plot(squeeze(CTF.ConvTF(:,centre,centre)),'r-*');
    title('Convolved TF Shape Profiles');   
    %figure(301);
    %imshow(squeeze(CTF.ConvTF(centre,:,:)),[0 max(CTF.ConvTF(:))]);
    %figure(302);
    %imshow(squeeze(CTF.ConvTF(:,:,centre)),[0 max(CTF.ConvTF(:))]);    
end

Status2('done','',2);
Status2('done','',3);


