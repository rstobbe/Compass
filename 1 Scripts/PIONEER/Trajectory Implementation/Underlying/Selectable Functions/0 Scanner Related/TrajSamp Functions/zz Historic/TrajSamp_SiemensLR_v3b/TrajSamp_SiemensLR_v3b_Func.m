%=========================================================
%
%=========================================================

function [TSMP,err] = TrajSamp_SiemensLR_v3b_Func(TSMP,INPUT)

Status2('busy','Define Trajectory Sampling Timing',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Get Input
%---------------------------------------------
PROJdgn = INPUT.PROJdgn;
PROJimp = INPUT.PROJimp;
GWFM = INPUT.GWFM;
SYS = INPUT.SYS;

%---------------------------------------------
% Dwell time for critical sampling
%---------------------------------------------                 
TSMP.maxspherefreq = GWFM.Gmax*PROJdgn.fov/2*PROJimp.gamma;              % Spherical FoV
TSMP.dwellcrit = 1000/(2*TSMP.maxspherefreq);                            % in ms

%---------------------------------------------
% Initial estimate of dwell and npro  
%---------------------------------------------
dwell0 = TSMP.dwellcrit/TSMP.reloversamp;
npro0 = round(PROJdgn.tro/dwell0);
dwell0 = PROJdgn.tro/npro0;
npro0 = round(PROJdgn.tro/dwell0);
dwell0 = PROJdgn.tro/npro0;

%---------------------------------------------
% Make dwell a multiple of sampbase
%---------------------------------------------              
dwell = dwell0*1e6 - rem(dwell0*1e6,SYS.SampBase);                  
npro = npro0;
go = 1;
while go == 1
    start = PROJdgn.tro*1e6 - npro*dwell;
    if start > 0.005
        npro = npro + 1;
    elseif start < -0.005
        dwell = dwell - SYS.SampBase;
    else
        break
    end
end

%---------------------------------------------
% Tests 
%---------------------------------------------
if npro*dwell+start ~= PROJdgn.tro*1e6
    error();
end

%---------------------------------------------
% Increase Tro to Accomodate GradDel
%---------------------------------------------
extrapoints = ceil(SYS.GradDel*1e6/dwell);

%---------------------------------------------
% Return
%---------------------------------------------
TSMP.dwell = dwell/1e6;
TSMP.tro = TSMP.dwell*npro;
TSMP.troMag = TSMP.dwell*(npro+extrapoints);
TSMP.npro = npro-TSMP.discard;  
TSMP.nproMag = npro+extrapoints;  
TSMP.tdp = (TSMP.npro-TSMP.discard)*PROJdgn.nproj;
TSMP.tdpMag = (npro+extrapoints)*PROJdgn.nproj;
TSMP.trajosamp = TSMP.dwellcrit/TSMP.dwell;                  % how much oversampled from design
TSMP.samplingBW = 1000/TSMP.dwell;

%---------------------------------------------
% Panel Output
%--------------------------------------------- 
Panel(1,:) = {'tro (ms)',TSMP.tro,'Output'};
Panel(2,:) = {'dwell (ms)',TSMP.dwell,'Output'};
Panel(3,:) = {'npro',TSMP.npro,'Output'};
Panel(4,:) = {'tdp',TSMP.tdp,'Output'};
Panel(5,:) = {'trajosamp',TSMP.trajosamp,'Output'};
PanelOutput = cell2struct(Panel,{'label','value','type'},2);
TSMP.PanelOutput = PanelOutput;






