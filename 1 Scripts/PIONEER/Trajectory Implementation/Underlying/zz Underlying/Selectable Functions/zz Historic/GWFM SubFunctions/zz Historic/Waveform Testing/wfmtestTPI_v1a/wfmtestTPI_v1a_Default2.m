%=========================================================
% 
%=========================================================

function [default] = wfmtestTPI_v1a_Default2(SCRPTPATHS)

SysGmax = 50;
SysGslew = 120;
SysGSRbuff = 0.05;

m = 1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'SysGmax (mT/m)';
default{m,1}.entrystr = SysGmax;

m = m+1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'GSR (mT/m/ms)';
default{m,1}.entrystr = SysGslew;

m = m+1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'GSRbuff (ms)';
default{m,1}.entrystr = SysGSRbuff;
