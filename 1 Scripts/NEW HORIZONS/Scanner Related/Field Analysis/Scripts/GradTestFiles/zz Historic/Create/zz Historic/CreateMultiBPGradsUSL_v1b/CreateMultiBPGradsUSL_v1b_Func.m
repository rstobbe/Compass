%=====================================================
% 
%=====================================================

function [GRD,err] = CreateMultiBPGradsUSL_v1b_Func(GRD,INPUT)

Status('busy','Create Multiple Bipolar Gradient Files');
Status2('done','',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Get Input
%---------------------------------------------
WRTP = INPUT.WRTP;
WRTG = INPUT.WRTG;
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
if gatmaxdur < ramptime + 0.3
    err.flag = 1;
    err.msg = 'Expand GatMaxDur to accomodate gradient slew';
    return
end
if intergdur < 2*ramptime + 0.3
    err.flag = 1;
    err.msg = 'Expand InterGDur to accomodate gradient slew';
    return
end

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
    figure(1); hold on; 
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
GRD.G = G0;
GRD.T = T;
GRD.L = L;
GRD.Gvis = Gvis;
GRD.graddur = gstepdur*length(G0(1,:)); 

%---------------------------------------------
% Test
%---------------------------------------------
test = GRD.T(length(GRD.T)) + gstepdur;
if GRD.graddur ~= test
    error();
end

%---------------------------------------------
% Write Gradients
%---------------------------------------------
func = str2func([GRD.wrtgradfunc,'_Func']);
INPUT.G = G;
INPUT.rdur = ones(1,length(G0(1,:)));
INPUT.sym = 'None';
[WRTG,err] = func(WRTG,INPUT);
if err.flag
    return
end
clear INPUT

%---------------------------------------------
% Write Parameter File
%--------------------------------------------- 
func = str2func([GRD.wrtparamfunc,'_Func']);
INPUT.gontime = GRD.graddur;
INPUT.gval = GRD.gstop;
INPUT.gvalinparam = 0;
INPUT.slewrate = 0;
INPUT.falltime = 0;
INPUT.pnum = ngrads;
INPUT.GradLoc = WRTG.GradLoc;
[WRTP,err] = func(WRTP,INPUT);
if err.flag 
    return
end
clear INPUT

%---------------------------------------------
% Return
%--------------------------------------------- 
GRD.WRTG = WRTG;
GRD.WRTP = WRTP;


