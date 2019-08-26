%=======================================================
% 
%=======================================================

function [TFB,err] = TFbuildElip_v1c_Func(TFB,INPUT)

Status2('done','Build TF',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Get Input
%---------------------------------------------
IMP = INPUT.IMP;
TFO = INPUT.TFO;
KRNprms = INPUT.KRNprms;
PROJdgn = IMP.impPROJdgn;
PROJimp = IMP.PROJimp;
DblKern = KRNprms.DblKern;
clear INPUT

%----------------------------------------
% Error Tests
%----------------------------------------
if not(isfield(PROJdgn,'elip'))
    err.flag = 1;
    err.msg = '''Elip'' must be specified by design';
    return
end

%----------------------------------------
% 'Sphere-Array' Size Test
%----------------------------------------
m = 1;
for n = DblKern.OKforSS:0.0005:TFB.MaxSubSamp
    test = round(1e9/(n*DblKern.res))/1e9;
    if not(rem(test,1)) && not(rem(DblKern.W*n,1))
        psubsamp(m) = n;
        m = m+1;
    end    
end  
kmax = PROJdgn.kmax*PROJimp.meanrelkmax;
SubSamp = psubsamp(1);
TFB.RadDim = round((kmax/PROJdgn.kstep)*SubSamp);
while TFB.RadDim < TFB.MinRadDim
    ind = find(psubsamp == SubSamp,1);
    if ind == length(psubsamp)
        err.flag = 1;
        err.msg = 'increase ''MaxSubSamp'' or decrease ''MinRadDim''';
        return
    end
    SubSamp = psubsamp(ind+1);
    TFB.RadDim = round((kmax/PROJdgn.kstep)*SubSamp);
end
TFB.SubSamp = SubSamp;

%----------------------------------------
% Continue (now done later)
%----------------------------------------
%if TFB.RadDim > 100 || TFB.SubSamp > 2.5
%    button = questdlg(['RadDim = ',num2str(TFB.RadDim),', SubSamp = ',num2str(TFB.SubSamp),', Continue:']);
%    if strcmp(button,'No')
%        err.flag = 4;
%        err.msg = '';
%        return
%    end   
%end

%----------------------------------------
% Test
%----------------------------------------
TFquantrad = TFB.RadDim/TFB.SubSamp;
DESquantrad = kmax/PROJdgn.kstep;
TFB.rKernWid = TFquantrad/DESquantrad; 
if abs(TFB.rKernWid-1) > 0.001
    button = questdlg(['TF Sphere Quantization Error = ',num2str(100*abs(TFB.rKernWid-1)),'% Continue:']);
    if strcmp(button,'No')
        err.flag = 4;
        err.msg = '';
        return
    end  
end

%----------------------------------------
% Build 'Sphere-Array'
%----------------------------------------
Status2('busy','Build Transfer Function Shape',2);
R = ceil(TFB.RadDim) + 1;
Loc = zeros((2*R)^3,3);
Val = zeros((2*R)^3,1);
n = 1;
m = 1;
L = length(TFO.r)-1;
for x = -R:R
    for y = -R:R
        for z = -ceil(R*PROJdgn.elip):ceil(R*PROJdgn.elip)
            r0 = sqrt(x^2 + y^2 + z^2);
            if r0 == 0
                r = 0;
            else
                phi = acos(z/r0);
                rmax = sqrt(((PROJdgn.elip*TFB.RadDim)^2)/(PROJdgn.elip^2*(sin(phi))^2 + (cos(phi))^2));
                r = r0/rmax;
            end
            if r <= 1 
                 Loc(n,:) = [x y z];  
                 Val(n) = lin_interp4(TFO.tf,r,L);
                 n = n+1;              
            end
        end
    end
    Status2('busy',num2str(2*R-m+1),3);   
    m = m+1; 
end
Status2('done','',3);
Tot = (n-1);
compV = PROJdgn.elip*pi*(4/3)*TFB.RadDim.^3;
TFB.relQuantSphereVol = Tot/compV;
if abs((1-TFB.relQuantSphereVol)*100) > 2
    err.flag = 1;
    err.msg = 'Spheroid Creation More than 2% in error (increase ''MaxRadDim'')';
    return
end
Status2('done','',3);
%TFB.Loc = kmax*Loc(1:n-1,:)/TFB.RadDim;                  % wrong way
TFB.Loc = Loc(1:n-1,:)*(PROJdgn.kstep/SubSamp);
TFB.Val = Val(1:n-1);
TFB.LocMax = max((TFB.Loc(:,1).^2 + TFB.Loc(:,2).^2 + TFB.Loc(:,3).^2).^(0.5));
TFB.rLocMax = TFB.LocMax/kmax;

%----------------------------------------
% Test (already done - same result)
%----------------------------------------
%if abs(TFB.rLocMax-1) > 0.001
%    err.flag = 1;
%    err.msg = 'increase ''MinRadDim''';
%    return
%end

Status2('done','',2);
Status2('done','',3);


