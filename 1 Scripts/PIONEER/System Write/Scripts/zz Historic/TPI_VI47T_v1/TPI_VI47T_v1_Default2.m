%=========================================================
% 
%=========================================================

function [default] = TPI_VI47T_v1_Default2(SCRPTPATHS)

if strcmp(filesep,'\')
    wrgradpath = [SCRPTPATHS.rootloc,'System Write\Underlying\Selectable Functions\WrtGrad Functions\'];
    wrparmpath = [SCRPTPATHS.rootloc,'System Write\Underlying\Selectable Functions\WrtParam Functions\'];
    wrrefocuspath = [SCRPTPATHS.rootloc,'System Write\Underlying\Selectable Functions\WrtRefocus Functions\'];
elseif strcmp(filesep,'/')
end
addpath(genpath(wrgradpath));
addpath(genpath(wrparmpath));
addpath(genpath(wrrefocuspath))
wrgrad = 'WrtGrad_NFilesV_v1a';
wrparm = 'WrtParam_REALVSL_v1a';
wrrefocus = 'WrtRefocus_REALVSL_v1a';

m = 1;
default{m,1}.entrytype = 'RunExtFunc';
default{m,1}.labelstr = 'Imp_File';
default{m,1}.entrystr = '';
default{m,1}.buttonname = 'Load';
default{m,1}.runfunc = 'LoadTrajectoryImplementation_v2';
default{m,1}.runfuncinput = {SCRPTPATHS.outloc};
default{m,1}.runfuncoutput = {''};

m = m+1;
default{m,1}.entrytype = 'UnderFunc';
default{m,1}.labelstr = 'WrtGradfunc';
default{m,1}.entrystr = wrgrad;

m = m+1;
default{m,1}.entrytype = 'UnderFunc';
default{m,1}.labelstr = 'WrtParamfunc';
default{m,1}.entrystr = wrparm;

m = m+1;
default{m,1}.entrytype = 'UnderFunc';
default{m,1}.labelstr = 'WrtRefocusfunc';
default{m,1}.entrystr = wrrefocus;