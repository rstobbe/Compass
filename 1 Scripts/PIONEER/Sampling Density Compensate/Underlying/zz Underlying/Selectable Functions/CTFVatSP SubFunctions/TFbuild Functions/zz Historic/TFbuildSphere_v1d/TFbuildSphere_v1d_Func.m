%================================================================================
% 
%================================================================================

function [TFB,err] = TFbuildSphere_v1d_Func(TFB,INPUT)

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
% Test
%----------------------------------------
beta = 30;
step = (1/floor(PROJdgn.rad*1.0));
r1 = (0:step:1);
r2 = (1-step:-step:step);
Filt1 = besseli(0,beta * sqrt(1 - r1.^2)); 
Filt2 = besseli(0,beta * sqrt(1 - r2.^2)); 
Filt = [Filt1 zeros(1,20000-2*floor(PROJdgn.rad*1.0)) Filt2];
Filt = Filt/Filt(1);
%figure(10); plot(Filt);

TF = [TFO.tf zeros(1,5999) ones(1,4000)]; 
filtTF = ifft(fft(TF).*Filt);

TFO.tf = abs(filtTF(1:12001));
TFO.tf(TFO.tf < 1e-7) = 0;
TFO.r = (0:0.0001:1.20);
relkspace = 1.20;
figure(300); hold on;
plot(TFO.r,TFO.tf);

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
%----
kmax = PROJdgn.kmax;                            % compensate to design k-mask (i.e. eliminate sampling past relative radius of 1)
%----
SubSamp = psubsamp(1);
TFB.RadDim = round(PROJdgn.rad*SubSamp);
while TFB.RadDim < TFB.MinRadDim
    ind = find(psubsamp == SubSamp,1);
    if ind == length(psubsamp)
        err.flag = 1;
        err.msg = 'increase ''MaxSubSamp'' or decrease ''MinRadDim''';
        return
    end
    SubSamp = psubsamp(ind+1);
    TFB.RadDim = round(PROJdgn.rad*SubSamp);
end
TFB.SubSamp = SubSamp;

%----------------------------------------
% Test
%----------------------------------------
TFquantrad = TFB.RadDim/TFB.SubSamp;
TFB.rKernWid = TFquantrad/PROJdgn.rad; 
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
top = ceil(TFB.RadDim*relkspace) + 1;
bot = ceil((FwdKern.W+RvsKern.W)*SubSamp/2) + 1;
Loc = zeros((2*bot+1)^2*(top+bot+1),3);
Val = zeros((2*bot+1)^2*(top+bot+1),3);
n = 1;
m = 1;
%L = length(TFO.r)-1;
L = 10000;
for x = -bot:top
    for y = -bot:bot
        for z = -bot:bot
            r = sqrt(x^2 + y^2 + z^2)/TFB.RadDim;
            if r <= relkspace 
                Loc(n,:) = [x y z];  
                Val(n) = lin_interp4(TFO.tf,r,L);
                n = n+1;
%             elseif r > relkspace && r <= relkspace*1.0001                             % accomodate quantization (for TFB.MinRadDim > 80, below does nothing)
%                  Loc(n,:) = [x y z];  
%                  r = relkspace;
%                  Val(n) = lin_interp4(TFO.tf,r,L);
%                  n = n+1;                
            end
        end
    end
    Status2('busy',num2str(top+bot-m+1),3);
    m = m+1;    
end
Status2('done','',3);
TFB.Loc = Loc(1:n-1,:)*(PROJdgn.kstep/SubSamp);
TFB.Val = Val(1:n-1);
TFB.LocMax = max((TFB.Loc(:,1).^2 + TFB.Loc(:,2).^2 + TFB.Loc(:,3).^2).^(0.5));
TFB.rLocMax = TFB.LocMax/kmax;

Status2('done','',2);
Status2('done','',3);


