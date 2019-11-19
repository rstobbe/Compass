%=====================================================
% 
%=====================================================

function [GTDES,err] = BPGradCompositeTest_v1d_Func(GTDES,INPUT)

Status2('busy','Create Multiple Bipolar Gradient Files',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Get Input
%---------------------------------------------
clear INPUT

%---------------------------------------------
% Common Variables
%---------------------------------------------
gstepdur = GTDES.gstepdur/1000;
pregdur0 = GTDES.pregdur0;
gatmaxdur0 = GTDES.gatmaxdur0;
intergdur0 = GTDES.intergdur0;
totgraddur0 = GTDES.totgraddur0;
gstart = GTDES.gstart;
gstep = GTDES.gstep;
gstop = GTDES.gstop;
gsl = GTDES.gsl;
gvalsarr = (gstart:gstep:gstop);
ngrads = length(gvalsarr);
dir = GTDES.dir;

%---------------------------------------------
% Make Integral Gradient Timings
%---------------------------------------------
preglen = round(pregdur0/gstepdur);
pregdur = preglen*gstepdur;
gatmaxlen = round(gatmaxdur0/gstepdur);
gatmaxdur = gatmaxlen*gstepdur;
interglen = round(intergdur0/gstepdur);
intergdur = interglen*gstepdur;
totgradlen = round(totgraddur0/gstepdur);
totgraddur = totgradlen*gstepdur;

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
% Timing
%---------------------------------------------
T = (0:gstepdur:gstepdur*totgradlen);

%---------------------------------------------
% Build BG Array
%---------------------------------------------
Empty0 = zeros(1,totgradlen);
Gbg0 = zeros(GTDES.numbgtests,totgradlen);
Gbg = cat(3,Gbg0,Gbg0,Gbg0);

%---------------------------------------------
% Build PL Array
%---------------------------------------------
t = (gstepdur:gstepdur:GTDES.plgrad*gsl*1.1);
ramp = gsl*t;
ind = find(ramp >= GTDES.plgrad,1,'first');
grampup = ramp(1:ind-1);
rampdown = GTDES.plgrad - ramp;
ind = find(rampdown <= 0,1,'first');
grampdown = rampdown(1:ind-1);
Gpl = [grampup GTDES.plgrad*ones(1,totgradlen-length(grampup)-length(grampdown)) grampdown];
if strcmp(dir,'Z');
    Gpl = cat(3,Empty0,Empty0,Gpl);
elseif strcmp(dir,'Y');
    Gpl = cat(3,Empty0,Gpl,Empty0);
elseif strcmp(dir,'X');
    Gpl = cat(3,Gpl,Empty0,Empty0);
end
Gpl = repmat(Gpl,[GTDES.numpltests 1 1]);

%---------------------------------------------
% Build Gradient Shape
%---------------------------------------------
gvalsarr = flip(gvalsarr);                  % For Siemens Put the Biggest First
t = (gstepdur:gstepdur:gstop*gsl*1.1);
ramp = gsl*t;

for n = 1:ngrads
    ind = find(ramp >= gvalsarr(n),1,'first');
    grampup = ramp(1:ind-1);
    rampdown = gvalsarr(n) - ramp;
    ind = find(rampdown <= 0,1,'first');
    grampdown = rampdown(1:ind-1);
    Gbp0(n,:) = [zeros(1,preglen) grampup gvalsarr(n)*ones(1,gatmaxlen-length(grampup)) grampdown...
          zeros(1,interglen-length(grampdown)) -grampup -gvalsarr(n)*ones(1,gatmaxlen-length(grampup))...
          -grampdown zeros(1,gatmaxlen-length(grampup))];
end
Gbp0 = cat(2,Gbp0,zeros(ngrads,totgradlen-length(Gbp0)));
EmptyArr = repmat(Empty0,[ngrads 1]);
if strcmp(dir,'Z');
    Gbp3 = cat(3,EmptyArr,EmptyArr,Gbp0);
    dirind = 3;
elseif strcmp(dir,'Y');
    Gbp3 = cat(3,EmptyArr,Gbp0,EmptyArr);
    dirind = 2;
elseif strcmp(dir,'X');
    Gbp3 = cat(3,Gbp0,EmptyArr,EmptyArr);
    dirind = 1;
end
Gbp = repmat(Gbp3,[GTDES.numwfmtests 1 1]);

%---------------------------------------------
% Combine
%---------------------------------------------
G = cat(1,Gbg,Gpl,Gbp);

%---------------------------------------------
% Visualize
%---------------------------------------------
for m = 1:ngrads
    Gvis0 = []; L = [];
    for n = 1:length(T)-1
        L = [L [T(n) T(n+1)]];
        Gvis0 = [Gvis0 [Gbp0(m,n) Gbp0(m,n)]];
    end
    L = [L T(length(T))];
    Gvis(m,:) = [Gvis0 Gbp0(m,length(Gbp0(1,:)))];
    fh = figure(1000); hold on; 
    plot(L,Gvis(m,:)); 
    plot([0 L(length(L))],[0 0],':');    
end
xlabel('ms');
ylabel('mT');
title('Test Waveforms');

GTDES.Figure(1).Name = 'Test Gradient Waveforms';
GTDES.Figure(1).Type = 'Graph';
GTDES.Figure(1).hFig = fh;
GTDES.Figure(1).hAx = gca;

%---------------------------------------------
% Write to Structure
%---------------------------------------------
GTDES.aves = [zeros(1,GTDES.numbgtests),ones(1,GTDES.numpltests),repmat((2:ngrads+1).',[GTDES.numwfmtests 1]).'];
GTDES.pregdur = pregdur;
GTDES.gatmaxdur = gatmaxdur;
GTDES.intergdur = intergdur;
GTDES.totgraddur = totgraddur;
GTDES.initfinaldecay = pregdur + gatmaxdur*2 + intergdur;
GTDES.Gshapes = Gbp0;
GTDES.G = G;
GTDES.T = T;
GTDES.L = L;
GTDES.Gvis = Gvis;
GTDES.tgwfm = gstepdur*length(G(1,:,1)); 
GTDES.Dir = dirind;
GTDES.gval = gvalsarr;
GTDES.pnum = ngrads;

%---------------------------------------------
% Test
%---------------------------------------------
test = GTDES.T(end);
if round(GTDES.tgwfm*1e6) ~= round(test*1e6)
    error();
end

GTDES.Type = 'BP';
GTDES.EnumType = 20;
GTDES.SuggestedName = ['BP' num2str(max(gvalsarr)) num2str(ngrads) num2str(gsl) '1' dir];

%---------------------------------------------
% Panel Output
%--------------------------------------------- 
Panel(1,:) = {'Method',GTDES.method,'Output'};
Panel(2,:) = {'NumBgTests',GTDES.numbgtests,'Output'};
Panel(3,:) = {'NumPlTests',GTDES.numpltests,'Output'};
Panel(4,:) = {'NumWfmTests',GTDES.numwfmtests,'Output'};
Panel(5,:) = {'PlGrad (mT/m)',GTDES.plgrad,'Output'};
Panel(6,:) = {'TotGradDur (ms)',GTDES.totgraddur,'Output'};
Panel(7,:) = {'PreGradDur (ms)',GTDES.pregdur,'Output'};
Panel(8,:) = {'TotGradDur (ms)',GTDES.totgraddur,'Output'};
Panel(9,:) = {'PreGradDur (ms)',GTDES.pregdur,'Output'};
Panel(10,:) = {'GradAtMaxDur (ms)',GTDES.gatmaxdur,'Output'};
Panel(11,:) = {'InterGradDur (ms)',GTDES.intergdur,'Output'};
Panel(12,:) = {'GradStepDur (us)',GTDES.gstepdur,'Output'};
Panel(13,:) = {'GradSlew (mT/m/ms)',GTDES.gsl,'Output'};
Panel(14,:) = {'GradStart (mT)',GTDES.gstart,'Output'};
Panel(15,:) = {'GradStep (mT)',GTDES.gstep,'Output'};
Panel(16,:) = {'GradStop (mT)',GTDES.gstop,'Output'};
Panel(17,:) = {'GradDir',GTDES.dir,'Output'};
PanelOutput = cell2struct(Panel,{'label','value','type'},2);
GTDES.PanelOutput = PanelOutput;


Status2('done','',2);
Status2('done','',3);
