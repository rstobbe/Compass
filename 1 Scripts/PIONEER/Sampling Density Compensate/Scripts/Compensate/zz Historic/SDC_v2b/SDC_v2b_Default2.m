%=========================================================
% 
%=========================================================

function [default] = SDC_v2b_Default2(SCRPTPATHS)

if strcmp(filesep,'\')
    addpath(genpath([SCRPTPATHS.rootloc,'Sampling Density Compensate\Underlying\zz Common\']));
    IEPath = [SCRPTPATHS.rootloc,'Sampling Density Compensate\Underlying\Selectable Functions\InitialEst Functions\'];
    KernLoadPath = [SCRPTPATHS.scrptshareloc,'2 Convolution\Selectable Functions\Convolution Kernel Select\'];
    TFPath = [SCRPTPATHS.rootloc,'Sampling Density Compensate\Underlying\Selectable Functions\TF Functions\'];
    CTFPath = [SCRPTPATHS.rootloc,'Sampling Density Compensate\Underlying\Selectable Functions\CTFVatSP Functions\'];
    ITPath = [SCRPTPATHS.rootloc,'Sampling Density Compensate\Underlying\Selectable Functions\Iterate Functions\'];
elseif strcmp(filesep,'/')
end
addpath(genpath(IEPath));
addpath(genpath(KernLoadPath));
addpath(genpath(TFPath));
addpath(genpath(CTFPath));
addpath(genpath(ITPath));

SDC_Name = 'SDC';
IEfunc = 'InitialEst_Radial_v1a';
subsamp = '2.5';
KernLoadfunc = 'LoadFiltSincKern_v1a';
TFfunc = 'TF_MatchSD_v1b';
CTFfunc = 'CTFgrid_v1a';
ITfunc = 'Iterate_InterpError_v1a';

m = 1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'SDC_Name';
default{m,1}.entrystr = SDC_Name;

m = m+1;
default{m,1}.entrytype = 'RunExtFunc';
default{m,1}.labelstr = 'Imp_File';
default{m,1}.entrystr = '';
default{m,1}.buttonname = 'Load';
default{m,1}.runfunc = 'LoadTrajectoryImplementation_v3';
default{m,1}.runfuncinput = {SCRPTPATHS.outloc};
default{m,1}.runfuncoutput = {''};

m = m+1;
default{m,1}.entrytype = 'Choose';
default{m,1}.labelstr = 'Comp_kmax';
default{m,1}.entrystr = 'Design';
default{m,1}.options = {'Implementation','Design'};

m = m+1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'SubSamp';
default{m,1}.entrystr = subsamp;

m = m+1;
default{m,1}.entrytype = 'ScrptFunc';
default{m,1}.labelstr = 'KernLoadfunc';
default{m,1}.entrystr = KernLoadfunc;
default{m,1}.searchpath = KernLoadPath;

m = m+1;
default{m,1}.entrytype = 'ScrptFunc';
default{m,1}.labelstr = 'TFfunc';
default{m,1}.entrystr = TFfunc;
default{m,1}.searchpath = TFPath;

m = m+1;
default{m,1}.entrytype = 'ScrptFunc';
default{m,1}.labelstr = 'CTFfunc';
default{m,1}.entrystr = CTFfunc;
default{m,1}.searchpath = CTFPath;

m = m+1;
default{m,1}.entrytype = 'ScrptFunc';
default{m,1}.labelstr = 'InitialEstfunc';
default{m,1}.entrystr = IEfunc;
default{m,1}.searchpath = IEPath;

m = m+1;
default{m,1}.entrytype = 'ScrptFunc';
default{m,1}.labelstr = 'Iteratefunc';
default{m,1}.entrystr = ITfunc;
default{m,1}.searchpath = ITPath;

