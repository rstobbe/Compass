%================================================================================
% (v1a)
%   - 
%================================================================================

function [CTF,SCRPTipt,err] = TFbuildElip_v1a(PROJimp,TF,KRNprms,CTF,SDCS,SCRPTipt,err)

CTF.MinRadDim = str2double(SCRPTipt(strcmp('MinRadDim',{SCRPTipt.labelstr})).entrystr);
CTF.MaxSubSamp = str2double(SCRPTipt(strcmp('MaxSubSamp',{SCRPTipt.labelstr})).entrystr);

%----------------------------------------
% Error Tests
%----------------------------------------
if not(isfield(PROJimp,'elip'))
    err.flag = 1;
    err.msg = 'Projection design must specify ''elip''';
    return
end

%----------------------------------------
% 'Sphere-Array' Size Test
%----------------------------------------
m = 1;
for n = 1.25:0.01:CTF.MaxSubSamp
    test = round(1e9/(n*KRNprms.res))/1e9;
    if not(rem(test,1))
        psubsamp(m) = n;
        m = m+1;
    end    
end
kmax = SDCS.compkmax;
SubSamp = SDCS.SubSamp;
CTF.RadDim = round((kmax/PROJimp.kstep)*SubSamp);
while CTF.RadDim < CTF.MinRadDim
    ind = find(psubsamp == SubSamp,1);
    if ind == length(psubsamp)
        err.flag = 1;
        err.msg = 'kSpace matrix too small - increase (MaxSubSamp) or decrease (MinRadDim)';
        return
    end
    SubSamp = psubsamp(ind+1);
    CTF.RadDim = round((kmax/PROJimp.kstep)*SubSamp);
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
        for z = -ceil(R*PROJimp.elip):ceil(R*PROJimp.elip)
            r0 = sqrt(x^2 + y^2 + z^2);
            if r0 == 0
                r = 0;
            else
                phi = acos(z/r0);
                rmax = sqrt(((PROJimp.elip*CTF.RadDim)^2)/(PROJimp.elip^2*(sin(phi))^2 + (cos(phi))^2));
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
compV = PROJimp.elip*pi*(4/3)*CTF.RadDim.^3;
CTF.relQuantSphereVol = Tot/compV;
if abs((1-CTF.relQuantSphereVol)*100) > 2
    err.flag = 1;
    err.msg = 'Spheroid Creation More than 2% in error (increase ''MaxRadDim'')';
    return
end
Status2('done','',3);
CTF.Loc = Loc(1:n-1,:)*(PROJimp.kstep/SubSamp);
CTF.Val = Val(1:n-1);

Status2('done','',2);
Status2('done','',3);

