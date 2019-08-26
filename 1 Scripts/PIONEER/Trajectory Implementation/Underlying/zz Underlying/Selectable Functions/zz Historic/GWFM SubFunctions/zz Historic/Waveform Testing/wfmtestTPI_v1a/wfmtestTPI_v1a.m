%=====================================================
% Test Gradient WaveForm - TPI
%=====================================================

function [warning,warnflag,PROJimp,IMPipt] = wfmtestTPI_v1a(PROJimp,G,IMPipt)

warning = '';
warnflag = 0;

PROJimp.sysmaxgrad = str2double(IMPipt(strcmp('SysGmax (mT/m)',{IMPipt.labelstr})).entrystr);
PROJimp.sysgradslew = str2double(IMPipt(strcmp('GSR (mT/m/ms)',{IMPipt.labelstr})).entrystr);
PROJimp.sysgradslewbuff = str2double(IMPipt(strcmp('GSRbuff (ms)',{IMPipt.labelstr})).entrystr);

PROJimp.gmax = max(G(:));
if PROJimp.gmax > PROJimp.sysmaxgrad
    [IMPipt] = AddToPanelOutput(IMPipt,'Gmax (mT/m)','0output',PROJimp.gmax,'0error');
    warnflag = 2;
    warning = 'Gmax larger than SysGmax';
else
    [IMPipt] = AddToPanelOutput(IMPipt,'Gmax (mT/m)','0output',PROJimp.gmax,'0numout');
end

qT = PROJimp.GQNT.arr;
isteps = G(:,1,:);
max_istep = max(abs(isteps(:)));
if max_istep/PROJimp.sysgradslew + PROJimp.sysgradslewbuff > PROJimp.iseg
    warnflag = 2;
    warning = [warning 'System gradient step response to slow for implementation - increase Iseg']; 
end

m = (2:length(qT)-1);
twsteps = G(:,m,:)-G(:,m-1,:);
max_twstep = max(abs(twsteps(:)));
PROJimp.maxtwgstep = max_twstep;
if (max_twstep/PROJimp.sysgradslew + PROJimp.sysgradslewbuff) > PROJimp.twseg
    [IMPipt] = AddToPanelOutput(IMPipt,'Gmaxstep (mT/m)','0output',PROJimp.maxtwgstep,'0error');    
    warnflag = 2;
    warning = [warning 'System gradient step response to slow for implementation - increase twGseg'];
else
    [IMPipt] = AddToPanelOutput(IMPipt,'Gmaxstep (mT/m)','0output',PROJimp.maxtwgstep,'0numout');
end



       