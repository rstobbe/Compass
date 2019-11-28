%=====================================================
% 
%=====================================================

function [GTDES,err] = PowerProfileTest_v1a_Func(GTDES,INPUT)

Status2('busy','Create Power Profile Test Gradients',2);
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
gatmaxdur0 = GTDES.gatmaxdur0;
pregdur0 = GTDES.pregdur0;
totgraddur0 = GTDES.totgraddur0;
gsl = GTDES.gsl;
dir = GTDES.dir;

%---------------------------------------------
% Make Integral Gradient Timings
%---------------------------------------------
preglen = round(pregdur0/gstepdur);
pregdur = preglen*gstepdur;
gatmaxlen = round(gatmaxdur0/gstepdur);
gatmaxdur = gatmaxlen*gstepdur;
totgradlen = round(totgraddur0/gstepdur);
totgraddur = totgradlen*gstepdur;

%---------------------------------------------
% Timing
%---------------------------------------------
T = (0:gstepdur:gstepdur*totgradlen);

%---------------------------------------------
% Build Gradient Shape
%---------------------------------------------
Empty0 = zeros(1,totgradlen);
t = (gstepdur:gstepdur:GTDES.pcgrad*gsl*1.1);
ramp = gsl*t;
ind = find(ramp >= GTDES.pcgrad,1,'first');
grampup = ramp(1:ind-1);
rampdown = GTDES.pcgrad - ramp;
ind = find(rampdown <= 0,1,'first');
grampdown = rampdown(1:ind-1);
Gpc0 = [zeros(1,preglen) grampup GTDES.pcgrad*ones(1,gatmaxlen-length(grampup)) grampdown];
Gpc0 = cat(2,Gpc0,zeros(1,totgradlen-length(Gpc0)));
if strcmp(dir,'Z')
    Gpc = cat(3,Empty0,Empty0,Gpc0);
    dirind = 3;
elseif strcmp(dir,'Y')
    Gpc = cat(3,Empty0,Gpc0,Empty0);
    dirind = 2;
elseif strcmp(dir,'X')
    Gpc = cat(3,Gpc0,Empty0,Empty0);
    dirind = 1;
end
Gpc = repmat(Gpc,[GTDES.numpctests 1 1]);

%---------------------------------------------
% Combine
%---------------------------------------------
G = Gpc;

%---------------------------------------------
% Visualize
%---------------------------------------------
Gvis0 = []; L = [];
for n = 1:length(T)-1
    L = [L [T(n) T(n+1)]];
    Gvis0 = [Gvis0 [Gpc0(n) Gpc0(n)]];
end
L = [L T(length(T))];
Gvis = [Gvis0 Gpc0(length(Gpc0))];
fh = figure(1000); hold on; 
plot(L,Gvis); 
plot([0 L(length(L))],[0 0],':');    

xlabel('ms');
ylabel('mT');
title('Test Waveforms');
ylim([0 GTDES.pcgrad*1.1]);

GTDES.Figure(1).Name = 'Test Gradient Waveforms';
GTDES.Figure(1).Type = 'Graph';
GTDES.Figure(1).hFig = fh;
GTDES.Figure(1).hAx = gca;

%---------------------------------------------
% Write to Structure
%---------------------------------------------
GTDES.aves = ones(1,GTDES.numpctests);
GTDES.pregdur = pregdur;
GTDES.gatmaxdur = gatmaxdur;
GTDES.totgraddur = totgraddur;
GTDES.initfinaldecay = pregdur + gatmaxdur;
GTDES.Gshapes = Gpc0;
GTDES.G = G;
GTDES.T = T;
GTDES.L = L;
GTDES.Gvis = Gvis;
GTDES.tgwfm = gstepdur*length(G(1,:,1)); 
GTDES.Dir = dirind;
GTDES.gval = GTDES.pcgrad;
GTDES.pnum = 1;

%---------------------------------------------
% Test
%---------------------------------------------
test = GTDES.T(end);
if round(GTDES.tgwfm*1e6) ~= round(test*1e6)
    error();
end

GTDES.Type = 'PC';
GTDES.EnumType = 21;
GTDES.SuggestedName = ['PC' num2str(round(GTDES.pcgrad*10)) num2str(gatmaxdur) num2str(GTDES.numpctests) '1' dir];

%---------------------------------------------
% Panel Output
%--------------------------------------------- 
Panel(1,:) = {'Method',GTDES.method,'Output'};
Panel(2,:) = {'NumPCTests',GTDES.numpctests,'Output'};
Panel(3,:) = {'PCGrad (mT/m)',GTDES.pcgrad,'Output'};
Panel(4,:) = {'PreGradDur (ms)',GTDES.pregdur,'Output'};
Panel(5,:) = {'GradAtMaxDur (ms)',GTDES.gatmaxdur,'Output'};
Panel(6,:) = {'TotGradDur (ms)',GTDES.totgraddur,'Output'};
Panel(7,:) = {'GradStepDur (us)',GTDES.gstepdur,'Output'};
Panel(8,:) = {'GradSlew (mT/m/ms)',GTDES.gsl,'Output'};
Panel(9,:) = {'GradDir',GTDES.dir,'Output'};
PanelOutput = cell2struct(Panel,{'label','value','type'},2);
GTDES.PanelOutput = PanelOutput;

Status2('done','',2);
Status2('done','',3);
