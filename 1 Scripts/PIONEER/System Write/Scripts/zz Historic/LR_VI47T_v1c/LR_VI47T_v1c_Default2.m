%=========================================================
% 
%=========================================================

function [default] = LR_VI47T_v1c_Default2(SCRPTPATHS)

if strcmp(filesep,'\')
    wrgradpath = [SCRPTPATHS.pioneerloc,'System Write\Underlying\Selectable Functions\WrtGrad Functions\'];
    wrparmpath = [SCRPTPATHS.pioneerloc,'System Write\Underlying\Selectable Functions\WrtParam Functions\'];
elseif strcmp(filesep,'/')
end
wrgradfunc = 'WrtGrad_NFilesV_v1c';
wrparmfunc = 'WrtParam_LRnoVSL_v1d';
addpath([wrgradpath,wrgradfunc]);
addpath([wrparmpath,wrparmfunc]);

m = 1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'SysWrt_Name';
default{m,1}.entrystr = '';

m = m+1;
default{m,1}.entrytype = 'RunExtFunc';
default{m,1}.labelstr = 'Imp_File';
default{m,1}.entrystr = '';
default{m,1}.buttonname = 'Load';
default{m,1}.runfunc1 = 'LoadTrajImpCur_v4';
default{m,1}.(default{m,1}.runfunc1).curloc = SCRPTPATHS.outloc;
default{m,1}.(default{m,1}.runfunc1).loadpanel = 'No';
default{m,1}.runfunc2 = 'LoadTrajImpDef_v4';
default{m,1}.(default{m,1}.runfunc2).defloc = SCRPTPATHS.outloc;
default{m,1}.(default{m,1}.runfunc2).loadpanel = 'No';
default{m,1}.searchpath = SCRPTPATHS.rootloc;
default{m,1}.path = SCRPTPATHS.rootloc;

m = m+1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'def_gcoil';
default{m,1}.entrystr = 'Mar2013_noVSL';

m = m+1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'def_graddel (us)';
default{m,1}.entrystr = '25';

m = m+1;
default{m,1}.entrytype = 'ScrptFunc';
default{m,1}.labelstr = 'WrtGradfunc';
default{m,1}.entrystr = wrgradfunc;
default{m,1}.searchpath = wrgradpath;
default{m,1}.path = [wrgradpath,wrgradfunc];

m = m+1;
default{m,1}.entrytype = 'ScrptFunc';
default{m,1}.labelstr = 'WrtParamfunc';
default{m,1}.entrystr = wrparmfunc;
default{m,1}.searchpath = wrparmpath;
default{m,1}.path = [wrparmpath,wrparmfunc];

m = m+1;
default{m,1}.entrytype = 'RunScrptFunc';
default{m,1}.scrpttype = 'SystemWrite';
default{m,1}.labelstr = 'SystemWrite';
default{m,1}.entrystr = '';
default{m,1}.buttonname = 'Write';

