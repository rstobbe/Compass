%=====================================================
% 
%=====================================================

function [GRD,err] = CreateMultiBPGradsUSL_v1c_Func(GRD,INPUT)

Status('busy','Create Multiple Bipolar Gradient Files');
Status2('done','',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Get Input
%---------------------------------------------
SYSWRT = INPUT.SYSWRT;
TSAMP = INPUT.TSAMP;
clear INPUT

%---------------------------------------------
% Common Variables
%---------------------------------------------
gstepdur = GRD.gstepdur/1000;
pregdur0 = GRD.pregdur0;
gatmaxdur0 = GRD.gatmaxdur0;
intergdur0 = GRD.intergdur0;
gstart = GRD.gstart;
gstep = GRD.gstep;
gstop = GRD.gstop;
gsl = GRD.gsl;
gvalsarr = (gstart:gstep:gstop);
ngrads = length(gvalsarr);

%---------------------------------------------
% Make Integral Gradient Timings
%---------------------------------------------
preglen = round(pregdur0/gstepdur);
pregdur = preglen*gstepdur;
gatmaxlen = round(gatmaxdur0/gstepdur);
gatmaxdur = gatmaxlen*gstepdur;
interglen = round(intergdur0/gstepdur);
intergdur = interglen*gstepdur;

%---------------------------------------------
% Test
%---------------------------------------------
ramptime = gstop/gsl;
if gatmaxdur < ramptime + 0.2
    err.flag = 1;
    err.msg = 'Expand GatMaxDur to accomodate gradient slew';
    return
end
if intergdur < 2*ramptime + 0.2
    err.flag = 1;
    err.msg = 'Expand InterGDur to accomodate gradient slew';
    return
end

%---------------------------------------------
% For Siemens Put the Biggest First
%---------------------------------------------
gvalsarr = flip(gvalsarr);

%---------------------------------------------
% Build Gradient Shape
%---------------------------------------------
t = (gstepdur:gstepdur:gstop*gsl*1.1);
ramp = gsl*t;

for n = 1:ngrads
    ind = find(ramp >= gvalsarr(n),1,'first');
    grampup = ramp(1:ind-1);
    rampdown = gvalsarr(n) - ramp;
    ind = find(rampdown <= 0,1,'first');
    grampdown = rampdown(1:ind-1);
    G0(n,:) = [zeros(1,preglen) grampup gvalsarr(n)*ones(1,gatmaxlen-length(grampup)) grampdown...
          zeros(1,interglen-length(grampdown)) -grampup -gvalsarr(n)*ones(1,gatmaxlen-length(grampup))...
          -grampdown zeros(1,gatmaxlen-length(grampup))];
end
G = cat(3,G0,G0,G0);
T = (0:gstepdur:gstepdur*(length(G0(1,:))-1));

%---------------------------------------------
% Visualize
%---------------------------------------------
for m = 1:ngrads
    Gvis0 = []; L = [];
    for n = 1:length(T)-1
        L = [L [T(n) T(n+1)]];
        Gvis0 = [Gvis0 [G0(m,n) G0(m,n)]];
    end
    L = [L T(length(T))];
    Gvis(m,:) = [Gvis0 G0(m,length(G0(1,:)))];
    figure(1000); hold on; 
    plot(L,Gvis(m,:)); 
    plot([0 L(length(L))],[0 0],':');    
end

%---------------------------------------------
% Write to Structure
%---------------------------------------------
GRD.pregdur = pregdur;
GRD.gatmaxdur = gatmaxdur;
GRD.intergdur = intergdur;
GRD.initfinaldecay = pregdur + gatmaxdur*2 + intergdur;
GRD.G = G;
GRD.T = T;
GRD.L = L;
GRD.Gvis = Gvis;
GRD.graddur = gstepdur*length(G0(1,:)); 

%---------------------------------------------
% Test
%---------------------------------------------
test = GRD.T(length(GRD.T)) + gstepdur;
if round(GRD.graddur*1e6) ~= round(test*1e6)
    error();
end

%---------------------------------------------
% Test Sampling
%---------------------------------------------
func = str2func([GRD.testsampfunc,'_Func']);
INPUT.IMP = [];
[TSAMP,err] = func(TSAMP,INPUT);
if err.flag
    return
end
mIMP = TSAMP.IMP;
clear INPUT

%---------------------------------------------
% Update modified IMP structure
%---------------------------------------------
sz = size(GRD.G);
mIMP.GWFM.tgwfm = GRD.graddur;
mIMP.impPROJdgn.nproj = sz(1);
mIMP.path = 'Y:\6 Siemens\0 SysTestAcq';

%---------------------------------------------
% Write System
%---------------------------------------------
func = str2func([GRD.syswrtfunc,'_Func']);
INPUT.G = GRD.G;
INPUT.IMP = mIMP;
INPUT.type = 20;
[SYSWRT,err] = func(SYSWRT,INPUT);
if err.flag
    return
end
clear INPUT

