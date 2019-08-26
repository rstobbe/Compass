%=========================================================
% 
%=========================================================

function [default] = WrtSys_VarianTpi_v1a_Default2(SCRPTPATHS)

if strcmp(filesep,'\')
    wrgradpath = [SCRPTPATHS.pioneerloc,'System Write\Underlying\zz Underlying\WrtGrad Functions\'];
    wrparampath = [SCRPTPATHS.pioneerloc,'System Write\Underlying\zz Underlying\WrtParam Functions\'];
    wrrefocuspath = [SCRPTPATHS.pioneerloc,'System Write\Underlying\zz Underlying\WrtRefocus Functions\'];
elseif strcmp(filesep,'/')
end
wrgradfunc = 'WrtGrad_NFilesV_v1c';
wrrefocusfunc = 'WrtRefocus_REALVSL_v1e';
wrparamfunc = 'WrtParam_REALVSL_v2a';

m = 1;
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
default{m,1}.entrystr = wrparamfunc;
default{m,1}.searchpath = wrparampath;
default{m,1}.path = [wrparampath,wrparamfunc];

