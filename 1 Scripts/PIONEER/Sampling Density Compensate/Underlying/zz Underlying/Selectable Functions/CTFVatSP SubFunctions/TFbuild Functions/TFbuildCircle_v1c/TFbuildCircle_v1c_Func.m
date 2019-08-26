%================================================================================
% 
%================================================================================

function [TFB,err] = TFbuildCircle_v1c_Func(TFB,INPUT)

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
if isfield(IMP,'impPROJdgn');
    PROJdgn = IMP.impPROJdgn;
else
    PROJdgn = IMP.PROJdgn;
end
PROJimp = IMP.PROJimp;
DblKern = KRNprms.DblKern;
FwdKern = KRNprms.FwdKern;
RvsKern = KRNprms.RvsKern;
clear INPUT

%----------------------------------------
% Error Tests
%----------------------------------------
if isfield(PROJdgn,'elip')
    if PROJdgn.elip ~= 1;                   
        err.flag = 1;
        err.msg = 'Elip Not Supported with TFbuildSphere';
        return
    end
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
top = ceil(TFB.RadDim) + 1;
bot = ceil((FwdKern.W+RvsKern.W)*SubSamp/2) + 1;
Loc = zeros((2*bot+1)^2*(top+bot+1),2);
Val = zeros((2*bot+1)^2*(top+bot+1),2);
n = 1;
m = 1;
L = length(TFO.r)-1;
for x = -bot:top
    for y = -bot:bot
        r = sqrt(x^2 + y^2)/TFB.RadDim;
        if r <= 1 
             Loc(n,:) = [x y];  
             Val(n) = lin_interp4(TFO.tf,r,L);
             n = n+1;
        elseif r > 1 && r <= 1.0001                             % accomodate quantization (for TFB.MinRadDim > 80, below does nothing)
             Loc(n,:) = [x y];  
             r = 1;
             Val(n) = lin_interp4(TFO.tf,r,L);
             n = n+1;                
        end
    end
    Status2('busy',num2str(top+bot-m+1),3);
    m = m+1;    
end
Status2('done','',3);
%TFB.Loc = kmax*Loc(1:n-1,:)/TFB.RadDim;                  % wrong way
TFB.Loc = Loc(1:n-1,:)*(PROJdgn.kstep/SubSamp);
TFB.Val = Val(1:n-1);
TFB.LocMax = max((TFB.Loc(:,1).^2 + TFB.Loc(:,2).^2).^(0.5));
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


