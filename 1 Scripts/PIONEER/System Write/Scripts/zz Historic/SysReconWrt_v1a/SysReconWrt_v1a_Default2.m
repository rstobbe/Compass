%=========================================================
% 
%=========================================================

function [default] = SysReconWrt_v1a_Default2(SCRPTPATHS)

if strcmp(filesep,'\')
    wrtsyspath = [SCRPTPATHS.pioneerloc,'System Write\Underlying\Selectable Functions\System Write\'];
    wrtreconpath = [SCRPTPATHS.pioneerloc,'System Write\Underlying\Selectable Functions\Recon Write\'];
elseif strcmp(filesep,'/')
end
wrtsysfunc = 'SysWrt_Siemens_v1b';
wrtreconfunc = 'ReconWrtAsImplementation_v1a';

m = 1;
default{m,1}.entrytype = 'OutputName';
default{m,1}.labelstr = 'SysWrt_Name';
default{m,1}.entrystr = '';

m = m+1;
default{m,1}.entrytype = 'ScriptName';
default{m,1}.labelstr = 'Script_Name';
default{m,1}.entrystr = '';

m = m+1;
default{m,1}.entrytype = 'RunExtFunc';
default{m,1}.labelstr = 'Imp_File';
default{m,1}.entrystr = '';
default{m,1}.buttonname = 'Load';
default{m,1}.runfunc1 = 'LoadTrajImpCur';
default{m,1}.(default{m,1}.runfunc1).curloc = SCRPTPATHS.outloc;
default{m,1}.runfunc2 = 'LoadTrajImpDisp';

m = m+1;
default{m,1}.entrytype = 'RunExtFunc';
default{m,1}.labelstr = 'SDC_File';
default{m,1}.entrystr = '';
default{m,1}.buttonname = 'Load';
default{m,1}.runfunc1 = 'LoadSDCCur';
default{m,1}.(default{m,1}.runfunc1).curloc = SCRPTPATHS.outloc;
default{m,1}.runfunc2 = 'LoadSDCDisp';

m = m+1;
default{m,1}.entrytype = 'ScrptFunc';
default{m,1}.labelstr = 'WrtReconfunc';
default{m,1}.entrystr = wrtreconfunc;
default{m,1}.searchpath = wrtreconpath;
default{m,1}.path = [wrtreconpath,wrtreconfunc];

m = m+1;
default{m,1}.entrytype = 'ScrptFunc';
default{m,1}.labelstr = 'WrtSysfunc';
default{m,1}.entrystr = wrtsysfunc;
default{m,1}.searchpath = wrtsyspath;
default{m,1}.path = [wrtsyspath,wrtsysfunc];

m = m+1;
default{m,1}.entrytype = 'RunScrptFunc';
default{m,1}.scrpttype = 'SystemWrite';
default{m,1}.labelstr = 'SystemWrite';
default{m,1}.entrystr = '';
default{m,1}.buttonname = 'Write';
