%=====================================================
% 
%=====================================================

function [GTDES,err] = TrajectoryTest_v1c_Func(GTDES,INPUT)

Status2('busy','Extract Trajectory for Testing',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Get Input
%---------------------------------------------
IMP = GTDES.IMP;
clear INPUT

%---------------------------------------------
% Test
%---------------------------------------------
T = IMP.qTscnr;
gstepdur = T(2);
if rem(GTDES.pregdur,gstepdur) || rem(GTDES.totgdur,gstepdur)
    err.flag = 1;
    err.msg = ['PreGDur and TotGDur must be multiples of ',num2str(gstepdur)*1000,' us'];
    return
end

%---------------------------------------------
% Add Predelay
%---------------------------------------------
prepad = round(GTDES.pregdur/gstepdur);
T = [T T(end)+(gstepdur:gstepdur:prepad*gstepdur)];

%---------------------------------------------
% Add Postdelay
%---------------------------------------------
postpad = round((GTDES.totgdur-T(end))/gstepdur);
T = [T T(end)+(gstepdur:gstepdur:postpad*gstepdur)];
totgradlen = length(T)-1;

%---------------------------------------------
% Build BG Array
%---------------------------------------------
Empty0 = zeros(1,totgradlen);
Gbg0 = zeros(GTDES.numbgtests,totgradlen);
Gbg = cat(3,Gbg0,Gbg0,Gbg0);

%---------------------------------------------
% Build PL Array
%---------------------------------------------
gsl = 100;
t = (gstepdur:gstepdur:GTDES.plgrad*gsl*1.1);
ramp = gsl*t;
ind = find(ramp >= GTDES.plgrad,1,'first');
grampup = ramp(1:ind-1);
rampdown = GTDES.plgrad - ramp;
ind = find(rampdown <= 0,1,'first');
grampdown = rampdown(1:ind-1);
Gpl = [grampup GTDES.plgrad*ones(1,totgradlen-length(grampup)-length(grampdown)) grampdown];
if strcmp(GTDES.dir,'Z');
    Gpl = cat(3,Empty0,Empty0,Gpl);
elseif strcmp(GTDES.dir,'Y');
    Gpl = cat(3,Empty0,Gpl,Empty0);
elseif strcmp(GTDES.dir,'X');
    Gpl = cat(3,Gpl,Empty0,Empty0);
end
Gpl = repmat(Gpl,[GTDES.numpltests 1 1]);

%---------------------------------------------
% Extract Trajectory
%---------------------------------------------
if strcmp(GTDES.usetrajdir,'X')
    dir = 1;
elseif strcmp(GTDES.usetrajdir,'Y')
    dir = 2;
elseif strcmp(GTDES.usetrajdir,'Z')
    dir = 3;
end
if strcmp(GTDES.usetrajnum(1:6),'Select')
    ngrads = str2double(GTDES.usetrajnum(7:end));
    nppd = IMP.PSMP.nppd;
    step = round(nppd/ngrads);
    usetraj = (1:step:step*ngrads);
else
    ngrads = 1;
    usetraj = str2double(GTDES.usetrajnum);
    if isnan(usetraj)
        err.flag = 1;
        err.msg = '''UseTrajNum'' error';
        return
    end
end
Gtrj0 = IMP.G(usetraj,:,dir);
Gtrj0 = [zeros(ngrads,prepad),Gtrj0,zeros(ngrads,postpad)];
EmptyArr = repmat(Empty0,[ngrads 1]);
if strcmp(GTDES.dir,'Z');
    Gtrj3 = cat(3,EmptyArr,EmptyArr,Gtrj0);
    dirind = 3;
elseif strcmp(GTDES.dir,'Y');
    Gtrj3 = cat(3,EmptyArr,Gtrj0,EmptyArr);
    dirind = 2;
elseif strcmp(GTDES.dir,'X');
    Gtrj3 = cat(3,Gtrj0,EmptyArr,EmptyArr);
    dirind = 1;
end
Gtrj = repmat(Gtrj3,[GTDES.numwfmtests 1 1]);

%---------------------------------------------
% Combine
%---------------------------------------------
G = cat(1,Gbg,Gpl,Gtrj);
sz = size(G);

%---------------------------------------------
% Visualize
%---------------------------------------------
for m = 1:ngrads
    Gvis0 = []; L = [];
    for n = 1:length(T)-1
        L = [L [T(n) T(n+1)]];
        Gvis0 = [Gvis0 [Gtrj0(m,n) Gtrj0(m,n)]];
    end
    L = [L T(length(T))];
    Gvis(m,:) = [Gvis0 Gtrj0(m,length(Gtrj0(1,:)))];
    figure(1000); hold on; 
    plot(L,Gvis(m,:)); 
    plot([0 L(length(L))],[0 0],':');    
end

%---------------------------------------------
% Save Expected kSpace
%---------------------------------------------
if strcmp(GTDES.usetrajdir,GTDES.dir)
    GTDES.samp = IMP.samp;
    GTDES.Kmat = IMP.Kmat(usetraj,:,dir);
    figure(1234)
    plot(GTDES.samp,GTDES.Kmat);
end

%---------------------------------------------
% Write to Structure
%---------------------------------------------
GTDES.aves = [zeros(1,GTDES.numbgtests),ones(1,GTDES.numpltests),repmat((2:ngrads+1).',[GTDES.numwfmtests 1]).'];
GTDES.totgraddur = T(end);
GTDES.Gshapes = Gtrj0;
GTDES.G = G;
GTDES.T = T;
GTDES.L = L;
GTDES.Gvis = Gvis;
GTDES.tgwfm = gstepdur*length(G(1,:,1)); 
GTDES.Dir = dirind;
GTDES.pnum = ngrads;
GTDES.gval = max(abs(G(:)));

%---------------------------------------------
% Test
%---------------------------------------------
test = GTDES.T(end);
if round(GTDES.tgwfm*1e6) ~= round(test*1e6)
    error();
end

GTDES.Type = 'TJ';
GTDES.EnumType = 10;
GTDES.SuggestedName = ['TJ' num2str(round(GTDES.gval)) num2str(ngrads) '1' GTDES.dir];
GTDES = rmfield(GTDES,'IMP');

Status2('done','',2);
Status2('done','',3);

