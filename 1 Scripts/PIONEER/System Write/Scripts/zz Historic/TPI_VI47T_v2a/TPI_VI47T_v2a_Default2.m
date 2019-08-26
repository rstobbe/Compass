%=========================================================
% 
%=========================================================

function [default] = TPI_VI47T_v2a_Default2(SCRPTPATHS)

if strcmp(filesep,'\')
    wrgradpath = [SCRPTPATHS.pioneerloc,'System Write\Underlying\Selectable Functions\WrtGrad Functions\'];
    wrparmpath = [SCRPTPATHS.pioneerloc,'System Write\Underlying\Selectable Functions\WrtParam Functions\'];
    wrrefocuspath = [SCRPTPATHS.pioneerloc,'System Write\Underlying\Selectable Functions\WrtRefocus Functions\'];
elseif strcmp(filesep,'/')
end
wrgradfunc = 'WrtGrad_NFilesV_v1c';
wrparmfunc = 'WrtParam_REALVSL_v2a';
wrrefocusfunc = 'WrtRefocus_REALVSL_v1e';
addpath([wrgradpath,wrgradfunc]);
addpath([wrparmpath,wrparmfunc]);
addpath([wrrefocuspath,wrrefocusfunc]);

m = 1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'SysWrt_Name';
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
default{m,1}.entrytype = 'ScrptFunc';
default{m,1}.labelstr = 'WrtGradfunc';
default{m,1}.entrystr = wrgradfunc;
default{m,1}.searchpath = wrgradpath;
default{m,1}.path = [wrgradpath,wrgradfunc];

m = m+1;
default{m,1}.entrytype = 'ScrptFunc';
default{m,1}.labelstr = 'WrtRefocusfunc';
default{m,1}.entrystr = wrrefocusfunc;
default{m,1}.searchpath = wrrefocuspath;
default{m,1}.path = [wrrefocuspath,wrrefocusfunc];

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