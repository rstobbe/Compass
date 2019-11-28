%=====================================================
% 
%=====================================================

function [GTDES,err] = PowerProfileTest_v1b_Func(GTDES,INPUT)

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
readdur0 = GTDES.readdur0;
pregdur0 = GTDES.pregdur0;
rewinddur0 = GTDES.rewinddur0;
gsl = GTDES.gsl;
dir = GTDES.dir;

%---------------------------------------------
% Make Integral Gradient Timings
%---------------------------------------------
preglen = round(pregdur0/gstepdur);
pregdur = preglen*gstepdur;
readlen = round(readdur0/gstepdur);
readdur = readlen*gstepdur;
rewindlen = round(rewinddur0/gstepdur);
rewinddur = rewindlen*gstepdur;
postlen = 2/gstepdur;
postdur = 2;
totgradlen = preglen + readlen + rewindlen + postlen;
totgraddur = totgradlen*gstepdur;

%---------------------------------------------
% Timing
%---------------------------------------------
T = (0:gstepdur:gstepdur*totgradlen);

%---------------------------------------------
% Build Rewind
%---------------------------------------------
rwgrad = GTDES.readgrad*(readdur/rewinddur)/2;
if rwgrad > 50
    err.flag = 1;
    err.msg = 'Increase RewindDur';
end

%---------------------------------------------
% Build Gradient Shape
%---------------------------------------------
t = (gstepdur:gstepdur:rwgrad*gsl*1.1);
ramp = gsl*t;
ind = find(ramp >= rwgrad,1,'first');
grampup = ramp(1:ind-1);
rampdown = rwgrad - ramp;
ind = find(rampdown <= 0,1,'first');
grampdown = rampdown(1:ind-1);
GpcRW = [zeros(1,preglen) grampup rwgrad*ones(1,rewindlen-length(grampup)) grampdown];

t = (gstepdur:gstepdur:GTDES.readgrad*gsl*1.1);
ramp = gsl*t;
ind = find(ramp >= GTDES.readgrad,1,'first');
grampup = ramp(1:ind-1);
rampdown = GTDES.readgrad - ramp;
ind = find(rampdown <= 0,1,'first');
grampdown = rampdown(1:ind-1);
Gpc0 = [-GpcRW grampup GTDES.readgrad*ones(1,readlen-length(grampup)) grampdown];

test = sum(Gpc0)

Gpc0 = cat(2,Gpc0,zeros(1,totgradlen-length(Gpc0)));
Empty0 = zeros(1,totgradlen);
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
Gpc = repmat(Gpc,[GTDES.numtests 1 1]);

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

GTDES.Figure(1).Name = 'Test Gradient Waveforms';
GTDES.Figure(1).Type = 'Graph';
GTDES.Figure(1).hFig = fh;
GTDES.Figure(1).hAx = gca;

%---------------------------------------------
% Write to Structure
%---------------------------------------------
GTDES.aves = ones(1,GTDES.numtests);
GTDES.pregdur = pregdur;
GTDES.rewinddur = rewinddur;
GTDES.readdur = readdur;
GTDES.totgraddur = totgraddur;
GTDES.initfinaldecay = pregdur + readdur;
GTDES.Gshapes = Gpc0;
GTDES.G = G;
GTDES.T = T;
GTDES.L = L;
GTDES.Gvis = Gvis;
GTDES.tgwfm = gstepdur*length(G(1,:,1)); 
GTDES.Dir = dirind;
GTDES.gval = GTDES.readgrad;
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
GTDES.SuggestedName = ['PC' num2str(round(GTDES.readgrad*10)) num2str(readdur) num2str(GTDES.numtests) '1' dir];

%---------------------------------------------
% Panel Output
%--------------------------------------------- 
Panel(1,:) = {'Method',GTDES.method,'Output'};
Panel(2,:) = {'NumTests',GTDES.numtests,'Output'};
Panel(3,:) = {'PreDur (ms)',GTDES.pregdur,'Output'};
Panel(4,:) = {'RewindDur (ms)',GTDES.rewinddur,'Output'};
Panel(5,:) = {'ReadDur (ms)',GTDES.readdur,'Output'};
Panel(6,:) = {'ReadGrad (mT/m)',GTDES.readgrad,'Output'};
Panel(7,:) = {'GradStepDur (us)',GTDES.gstepdur,'Output'};
Panel(8,:) = {'GradSlew (mT/m/ms)',GTDES.gsl,'Output'};
Panel(9,:) = {'GradDir',GTDES.dir,'Output'};
PanelOutput = cell2struct(Panel,{'label','value','type'},2);
GTDES.PanelOutput = PanelOutput;

Status2('done','',2);
Status2('done','',3);
