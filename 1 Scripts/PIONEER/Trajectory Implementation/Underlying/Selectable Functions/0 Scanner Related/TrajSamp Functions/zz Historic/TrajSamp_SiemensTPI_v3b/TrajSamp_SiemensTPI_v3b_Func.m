%=========================================================
%
%=========================================================

function [TSMP,err] = TrajSamp_SiemensTPI_v3b_Func(TSMP,INPUT)

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
TSMP.dwelldesign = PROJdgn.iseg/(PROJdgn.rad*PROJdgn.p);                 % Spherical FoV

%---------------------------------------------
% Initial estimate of dwell and npro  
%---------------------------------------------
dwell0 = TSMP.dwellcrit/TSMP.reloversamp;
npro0 = round((PROJdgn.tro-TSMP.startsteps*SYS.GradSampBase/1000)/dwell0);
dwell0 = (PROJdgn.tro-TSMP.startsteps*SYS.GradSampBase/1000)/npro0;
npro0 = round((PROJdgn.tro-TSMP.startsteps*SYS.GradSampBase/1000)/dwell0);
dwell0 = (PROJdgn.tro-TSMP.startsteps*SYS.GradSampBase/1000)/npro0;

%---------------------------------------------
% Make dwell a multiple of sampbase
%---------------------------------------------              
dwell = dwell0*1e6 - rem(dwell0*1e6,SYS.SampBase);                  
npro = npro0;
go = 1;
while go == 1
    start = PROJdgn.tro*1e6 - npro*dwell;
    if start > 1.005*TSMP.startsteps*SYS.GradSampBase*1000
        npro = npro + 1;
    elseif start < 0.995*TSMP.startsteps*SYS.GradSampBase*1000
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
% Return
%---------------------------------------------
TSMP.sampstart = TSMP.startsteps*SYS.GradSampBase/1000;
TSMP.dwell = dwell/1e6;
TSMP.tro = TSMP.dwell*npro+TSMP.sampstart;
TSMP.npro = npro;  
TSMP.tdp = TSMP.npro*PROJdgn.nproj;
TSMP.trajosamp = TSMP.dwelldesign/TSMP.dwell;                  % how much oversampled from design
TSMP.samplingBW = 1000/TSMP.dwell;

%---------------------------------------------
% Panel Output
%--------------------------------------------- 
Panel(1,:) = {'tro (ms)',TSMP.tro,'Output'};
Panel(2,:) = {'dwell (ms)',TSMP.dwell,'Output'};
Panel(3,:) = {'sampstart (ms)',TSMP.sampstart,'Output'};
Panel(4,:) = {'npro',TSMP.npro,'Output'};
Panel(5,:) = {'tdp',TSMP.tdp,'Output'};
Panel(6,:) = {'trajosamp',TSMP.trajosamp,'Output'};
PanelOutput = cell2struct(Panel,{'label','value','type'},2);
TSMP.PanelOutput = PanelOutput;






