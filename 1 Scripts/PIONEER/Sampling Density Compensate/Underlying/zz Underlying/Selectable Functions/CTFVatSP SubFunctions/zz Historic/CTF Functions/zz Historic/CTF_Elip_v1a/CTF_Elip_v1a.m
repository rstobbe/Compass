%================================================================================
%
%================================================================================

function [CTF,SCRPTipt,err] = CTF_Elip_v1a(PROJdgn,PROJimp,TF,KRNprms,CTF,SDCS,SCRPTipt,err)


%----------------------------------------
% 'Sphere-Array' Size Test
%----------------------------------------
kmax = SDCS.compkmax;
SubSamp = SDCS.SubSamp;
CTF.RadDim = round((kmax/PROJdgn.kstep)*SubSamp);
while CTF.RadDim < CTF.MinRadDim
    m = 1;
    for n = 2.5:0.01:4
        test = round(1e9/(n*KRNprms.res))/1e9;
        if not(rem(test,1))
            psubsamp(m) = n;
            m = m+1;
        end    
    end
    ind = find(psubsamp == SubSamp,1);
    if ind == length(psubsamp)
        error();
    end
    SubSamp = psubsamp(ind+1);
    CTF.RadDim = round((kmax/PROJdgn.kstep)*SubSamp);
end
CTF.SubSamp = SubSamp;

%----------------------------------------
% Build 'Sphere-Array'
%----------------------------------------
Status2('busy','Build Transfer Function Shape',2);
R = CTF.RadDim + 1;

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
                rmax = sqrt(((PROJdgn.elip*CTF.RadDim)^2)/(PROJdgn.elip^2*(sin(phi))^2 + (cos(phi))^2));
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
Tot = (n-1);
compV = PROJdgn.elip*pi*(4/3)*CTF.RadDim.^3;
Dif = Tot/compV
if abs((1-Dif)*100) > 2
    err.flag = 1;
    err.msg = 'Spheroid Creation More than 2% in error (increase matrix dimension)';
    return
end
Loc = Loc(1:n-1,:)*(PROJdgn.kstep/SubSamp);
Val = Val(1:n-1);

%----------------------------------------
% Convolve 'Sphere-Array'
%----------------------------------------
Status2('busy','Convolve Transfer Function Shape',2);
[Ksz,Kx,Ky,Kz,centre] = NormProjGrid_v4(Loc,NaN,NaN,kmax,PROJdgn.kstep,KRNprms.W,SubSamp,'A2A');

zWtest = 2*(ceil((KRNprms.W*SubSamp-2)/2)+1)/SubSamp;                       % with mFCMexSingleR_v
if zWtest > KRNprms.zW
    error('Kernel Zero-Fill Too Small');
end
KRNprms.W = KRNprms.W*SubSamp;
KRNprms.res = KRNprms.res*SubSamp;
if round(1e9/KRNprms.res) ~= 1e9*round(1/KRNprms.res)
    error('should not get here - already tested');
end    
KRNprms.iKern = round(1/KRNprms.res);
CONVprms.chW = ceil((KRNprms.W-2)/2);                    % with mFCMexSingleR_v3
StatLev = 3;

[ConvTF,outerror,outerrorflag] = mFCMexSingleR_v3(Ksz,Kx,Ky,Kz,KRNprms,Val,CONVprms,StatLev);
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
CTF.rconv = (-(centre-1):(centre-1))/CTF.RadDim; 
CTF.ConvTF = ConvTF*PROJdgn.projosamp*PROJimp.osamp/(SubSamp^3);
                           
%----------------------------------------
% Visuals
%----------------------------------------
if (strcmp(CTF.visuals,'On'))         
    figure(300); hold on;
    plot(CTF.rconv,squeeze(CTF.ConvTF(centre,centre,:)),'b-*');
    plot(CTF.rconv,squeeze(CTF.ConvTF(centre,:,centre)),'g-*');
    plot(CTF.rconv,squeeze(CTF.ConvTF(:,centre,centre)),'r-*');
    xlim([0 1.2]); 
    title('Convolved TF Shape Profile');   

    figure(301);
    imshow(squeeze(CTF.ConvTF(centre,:,:)),[0 max(CTF.ConvTF(:))]);
    figure(302);
    imshow(squeeze(CTF.ConvTF(:,:,centre)),[0 max(CTF.ConvTF(:))]);
    
end

Status2('done','',2);
Status2('done','',3);


