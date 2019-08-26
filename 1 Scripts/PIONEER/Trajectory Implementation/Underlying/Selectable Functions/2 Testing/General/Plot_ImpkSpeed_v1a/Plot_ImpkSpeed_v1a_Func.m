%==================================================
% 
%==================================================

function [OUTPUT,err] = Plot_ImpkSpeed_v1a_Func(INPUT)

Status('busy','Plot k-space from implementation');
Status2('done','',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';
OUTPUT = struct();

%-----------------------------------------------------
% Get Input
%-----------------------------------------------------
PLOT = INPUT.PLOT;
N = PLOT.trajnum;

%-----------------------------------------------------
% Get Implementation Info
%-----------------------------------------------------
IMP = INPUT.IMP;
Kmat = IMP.Kmat;
T = IMP.samp;
%PROJimp = IMP.PROJimp;
%PROJdgn = IMP.PROJdgn;
%kmax = PROJdgn.kmax;

%-----------------------------------------------------
% Calculate Speed (if not present)
%-----------------------------------------------------
if not(isfield(IMP,'CACC'))
    calcvelfunc = str2func('CalcVel_v2a');
    [vel,Tvel0] = calcvelfunc(squeeze(Kmat(N,:,:)),T);
    magvel0 = sqrt(vel(:,1).^2 + vel(:,2).^2 + vel(:,3).^2);
end

figure(500);
plot(Tvel0(2:length(Tvel0)),magvel0(2:length(Tvel0)));
ylim([0 1500]); xlim([0 5]);
ylabel('1/m/ms');
xlabel('ms');
OutStyle(2);