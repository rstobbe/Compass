%====================================================
% 
%====================================================

function [TSMP,err] = TrajSamp_LRideal_v1b_Func(TSMP,INPUT)

Status2('busy','Calculate Trajectory Sampling',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Get Input
%---------------------------------------------
PROJdgn = INPUT.PROJdgn;

%---------------------------------------------
% Common Variables
%---------------------------------------------
oversamp = TSMP.oversamp;
startfrac = TSMP.startfrac;
tro = PROJdgn.tro;
nproj = PROJdgn.nproj;

%---------------------------------------------
% Calculate
%---------------------------------------------
dwell0 = PROJdgn.maxsmpdwell/oversamp;
sampstart = dwell0*startfrac;
dwell = (tro-sampstart)/ceil(tro/dwell0);

%---------------------------------------------
% Test
%---------------------------------------------
test = (sampstart:dwell:tro);
if test(length(test)) ~= tro
    error();
end

%---------------------------------------------
% Return
%---------------------------------------------
TSMP.sampstart = sampstart;
TSMP.sampstartfrac = startfrac;
TSMP.dwell = dwell;
TSMP.tro = test(length(test));
TSMP.npro = length(test);   
TSMP.tdp = TSMP.npro*nproj;
TSMP.trajosamp = oversamp;

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




