%=========================================================
% 
%=========================================================

function [default] = ImpLoadCombined_v1a_Default2(SCRPTPATHS)

global COMPASSINFO

m = 1;
default{m,1}.entrytype = 'RunExtFunc';
default{m,1}.labelstr = 'Recon_File';
default{m,1}.entrystr = '';
default{m,1}.buttonname = 'Load';
default{m,1}.runfunc1 = 'LoadTrajImpCur';
default{m,1}.(default{m,1}.runfunc1).curloc = SCRPTPATHS.outloc;
default{m,1}.(default{m,1}.runfunc1).defloc = COMPASSINFO.USERGBL.trajreconloc;
default{m,1}.runfunc2 = 'LoadTrajImpDisp';
