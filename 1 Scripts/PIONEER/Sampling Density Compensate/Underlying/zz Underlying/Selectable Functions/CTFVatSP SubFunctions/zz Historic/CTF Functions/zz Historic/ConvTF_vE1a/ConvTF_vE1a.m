%================================================================================
% ConvTF
% - Find the Radial Shape of the Desired TF convolved with the gridding kernal
% - Compensation scaled to final TF values for perfect Nyquist sampling.
% (vE)
% - Use pre-made convolution kernel
% (1a)
% - 
%================================================================================

function [CTF,SCRPTipt,err] = ConvTF_vE1a(PROJdgn,PROJimp,TF,KRNprms,CTF,SDCS,SCRPTipt,err)

Vis = SCRPTipt(strcmp('ConvTF Vis',{SCRPTipt.labelstr})).entrystr;
if iscell(Vis)
    Vis = SCRPTipt(strcmp('ConvTF Vis',{SCRPTipt.labelstr})).entrystr{SCRPTipt(strcmp('ConvTF Vis',{SCRPTipt.labelstr})).entryvalue};
end

%----------------------------------------
% Error Tests
%----------------------------------------
if PROJdgn.elip ~= 1;                    %not hooked up yet...
    if length(err) ~= 1
        errn = length(err)+1;
    else
        errn = 1;
    end
    err(errn).flag = 1;
    err(errn).msg = 'Elip Not Supported with ConvTF_vE1a';
    return
end

%----------------------------------------
% 'Sphere-Array' Size Test
%----------------------------------------
kmax = CTF.kmax;
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
Status2('busy','Build Desired Transfer Function Shape',2);
top = CTF.RadDim + 1;
bot = ceil(KRNprms.W*SubSamp/2) + 1;
Loc = zeros((top-bot)^3,3);
Val = zeros((top-bot)^3,1);
n = 1;
m = 1;
L = length(TF.r)-1;
for x = -bot:top
    for y = -bot:bot
        for z = -bot:bot
            r = sqrt(x^2 + y^2 + z^2)/CTF.RadDim;
            if r <= 1 
                 Loc(n,:) = [x y z];  
                 Val(n) = lin_interp4(TF.tf,r,L);
                 n = n+1;
            elseif r > 1 && r <= 1.0001                             % accomodate quantization...
                 Loc(n,:) = [x y z];  
                 r = 1;
                 Val(n) = lin_interp4(TF.tf,r,L);
                 n = n+1;                
            end
        end
    end
    Status2('busy',num2str(top+bot-m+1),3);
    m = m+1;    
end
Loc = Loc(1:n-1,:)*(PROJdgn.kstep/SubSamp);
Val = Val(1:n-1);
%test = max(max(max(sqrt(Loc(:,1).^2 + Loc(:,2).^2 + Loc(:,3).^2))))
%Tot = (n-1)

%----------------------------------------
% Convolve 'Sphere-Array'
%----------------------------------------
Status2('busy','Convolve Desired Transfer Function Shape',2);
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
% Pick centre value
%----------------------------------------
rconv = (0:(centre-1))/CTF.RadDim; 
SDconv = ConvTF(centre:Ksz,centre,centre);
SDconv = PROJdgn.projosamp*PROJimp.osamp*SDconv/(SubSamp^3);

rconv2 = (0:0.001:rconv(length(rconv)));
SDconv2 = interp1(rconv,SDconv,rconv2,'cubic');
CTF.rconv = rconv2;                                         % use interpolated array
CTF.SDconv = SDconv2;                                   

%----------------------------------------
% Visuals
%----------------------------------------
if strcmp(Vis,'On') && strcmp(CTF.testing,'No')             % if testing - plotted outside...
    figure(100); hold on;
    plot(rconv,SDconv,'b-*');
    plot(rconv2,SDconv2,'r-');
    xlim([0 1.2]); 
    title('Convolved TF Shape');   
end

Status2('done','',2);
Status2('done','',3);


