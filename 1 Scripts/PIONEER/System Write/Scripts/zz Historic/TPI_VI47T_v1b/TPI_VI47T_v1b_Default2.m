%=========================================================
% 
%=========================================================

function [default] = TPI_VI47T_v1b_Default2(SCRPTPATHS)

if strcmp(filesep,'\')
    wrgradpath = [SCRPTPATHS.rootloc,'System Write\Underlying\Selectable Functions\WrtGrad Functions\'];
    wrparmpath = [SCRPTPATHS.rootloc,'System Write\Underlying\Selectable Functions\WrtParam Functions\'];
    wrrefocuspath = [SCRPTPATHS.rootloc,'System Write\Underlying\Selectable Functions\WrtRefocus Functions\'];
elseif strcmp(filesep,'/')
end
wrgrad = 'WrtGrad_NFilesV_v1b';
wrparm = 'WrtParam_REALVSL_v1c';
wrrefocus = 'WrtRefocus_REALVSL_v1c';

m = 1;
default{m,1}.entrytype = 'RunExtFunc';
default{m,1}.labelstr = 'Imp_File';
default{m,1}.entrystr = '';
default{m,1}.buttonname = 'Load';
default{m,1}.runfunc1 = 'LoadTrajImpCur_v4';
default{m,1}.(default{m,1}.runfunc1).curloc = SCRPTPATHS.outloc;
default{m,1}.(default{m,1}.runfunc1).loadpanel = 'Yes';
default{m,1}.runfunc2 = 'LoadTrajImpDef_v4';
default{m,1}.(default{m,1}.runfunc2).defloc = SCRPTPATHS.outloc;
default{m,1}.(default{m,1}.runfunc2).loadpanel = 'Yes';

m = m+1;
default{m,1}.entrytype = 'ScrptFunc';
default{m,1}.labelstr = 'WrtGradfunc';
default{m,1}.entrystr = wrgrad;
default{m,1}.searchpath = wrgradpath;

m = m+1;
default{m,1}.entrytype = 'ScrptFunc';
default{m,1}.labelstr = 'WrtRefocusfunc';
default{m,1}.entrystr = wrrefocus;
default{m,1}.searchpath = wrrefocuspath;

m = m+1;
default{m,1}.entrytype = 'ScrptFunc';
default{m,1}.labelstr = 'WrtParamfunc';
default{m,1}.entrystr = wrparm;
default{m,1}.searchpath = wrparmpath;

m = m+1;
default{m,1}.entrytype = 'RunScrptFunc';
default{m,1}.scrpttype = 'SystemWrite';
default{m,1}.labelstr = 'SystemWrite';
default{m,1}.entrystr = '';
default{m,1}.buttonname = 'Write';

