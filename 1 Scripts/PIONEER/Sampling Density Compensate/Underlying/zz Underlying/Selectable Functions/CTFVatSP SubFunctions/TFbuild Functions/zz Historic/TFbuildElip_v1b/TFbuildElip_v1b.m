%================================================================================
% (v1b)
%       - Update for RWSUI_BA 
%       - Location values defined at integers when normalized to grid
%           (otherwise can yeild systematic kernel quantization error)
%       - limit W to integer multiples
%================================================================================

function [SCRPTipt,TFBout,err] = TFbuildElip_v1b(SCRPTipt,TFB)

Status2('done','Build TF',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Load Input
%---------------------------------------------
TFBout.MinRadDim = str2double(TFB.('MinRadDim'));
TFBout.MaxSubSamp = str2double(TFB.('MaxSubSamp'));

%---------------------------------------------
% Get Working Structures / Variables
%---------------------------------------------
PROJdgn = TFB.PROJdgn;
PROJimp = TFB.PROJimp;
TFO = TFB.TFO;
KRNprms = TFB.KRNprms;

DblKern = KRNprms.DblKern;
FwdKern = KRNprms.FwdKern;
RvsKern = KRNprms.RvsKern;

%----------------------------------------
% Error Tests
%----------------------------------------
if not(isfield(PROJdgn,'elip'))
    err(errn).flag = 1;
    err(errn).msg = '''Elip'' must be specified by design';
    return
end

%----------------------------------------
% 'Sphere-Array' Size Test
%----------------------------------------
m = 1;
for n = DblKern.OKforSS:0.0005:TFBout.MaxSubSamp
    test = round(1e9/(n*DblKern.res))/1e9;
    if not(rem(test,1)) && not(rem(DblKern.W*n,1))
        psubsamp(m) = n;
        m = m+1;
    end    
end  
kmax = PROJdgn.kmax*PROJimp.meanrelkmax;
SubSamp = psubsamp(1);
TFBout.RadDim = round((kmax/PROJdgn.kstep)*SubSamp);
while TFBout.RadDim < TFBout.MinRadDim
    ind = find(psubsamp == SubSamp,1);
    if ind == length(psubsamp)
        err.flag = 1;
        err.msg = 'increase ''MaxSubSamp'' or decrease ''MinRadDim''';
        return
    end
    SubSamp = psubsamp(ind+1);
    TFBout.RadDim = round((kmax/PROJdgn.kstep)*SubSamp);
end
TFBout.SubSamp = SubSamp;

%----------------------------------------
% Continue
%----------------------------------------
if TFBout.RadDim > 100
    button = questdlg('RadDim > 100, Continue:');
    if strcmp(button,'No')
        err.flag = 4;
        err.msg = '';
        return
    end   
end

%----------------------------------------
% Test
%----------------------------------------
TFquantrad = TFBout.RadDim/TFBout.SubSamp;
DESquantrad = kmax/PROJdgn.kstep;
TFBout.rKernWid = TFquantrad/DESquantrad; 
if abs(TFBout.rKernWid-1) > 0.001
    err.flag = 1;
    err.msg = 'Quantization not good. Try increasing ''MinRadDim''';
    return
end

%----------------------------------------
% Build 'Sphere-Array'
%----------------------------------------
Status2('busy','Build Transfer Function Shape',2);
R = TFBout.RadDim + 1;
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
                rmax = sqrt(((PROJdgn.elip*TFBout.RadDim)^2)/(PROJdgn.elip^2*(sin(phi))^2 + (cos(phi))^2));
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
compV = PROJdgn.elip*pi*(4/3)*TFBout.RadDim.^3;
TFBout.relQuantSphereVol = Tot/compV;
if abs((1-TFBout.relQuantSphereVol)*100) > 2
    err.flag = 1;
    err.msg = 'Spheroid Creation More than 2% in error (increase ''MaxRadDim'')';
    return
end
TFBout.Loc = Loc(1:n-1,:)*(PROJdgn.kstep/SubSamp);
TFBout.Val = Val(1:n-1);
TFBout.LocMax = max((TFBout.Loc(:,1).^2 + TFBout.Loc(:,2).^2 + TFBout.Loc(:,3).^2).^(0.5));

%----------------------------------------
% Test
%----------------------------------------
TFBout.rLocMax = TFBout.LocMax/kmax;
if abs(TFBout.rLocMax-1) > 0.001
    err.flag = 1;
    err.msg = 'increase ''MinRadDim''';
    return
end

Status2('done','',2);
Status2('done','',3);


