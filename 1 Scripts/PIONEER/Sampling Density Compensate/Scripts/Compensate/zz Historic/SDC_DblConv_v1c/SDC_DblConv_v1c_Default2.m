%=========================================================
% 
%=========================================================

function [default] = SDC_DblConv_v1c_Default2(SCRPTPATHS)

if strcmp(filesep,'\')
    addpath(genpath([SCRPTPATHS.rootloc,'Sampling Density Compensate\Underlying\zz Common\']));
    IEPath = [SCRPTPATHS.rootloc,'Sampling Density Compensate\Underlying\Selectable Functions\InitialEst Functions\'];
    KernPath = [SCRPTPATHS.scrptshareloc,'zy Convolution Kernels\'];
    TFPath = [SCRPTPATHS.rootloc,'Sampling Density Compensate\Underlying\Selectable Functions\TF Functions\'];
    CTFPath = [SCRPTPATHS.rootloc,'Sampling Density Compensate\Underlying\Selectable Functions\CTFVatSP Functions\'];
    ITPath = [SCRPTPATHS.rootloc,'Sampling Density Compensate\Underlying\Selectable Functions\Iterate Functions\'];
elseif strcmp(filesep,'/')
end
addpath(genpath(IEPath));
addpath(genpath(TFPath));
addpath(genpath(CTFPath));
addpath(genpath(ITPath));

SDC_Name = 'SDC';
subsamp = '2.0';
TFfunc = 'TF_MatchSD_v1b';
CTFfunc = 'CTFVatSP_DblConv_kSphere_v1d';
IEfunc = 'InitialEst_Radial_v1a';
ITfunc = 'Iterate_DblConv_v1c';

m = 1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'SDC_Name';
default{m,1}.entrystr = SDC_Name;

m = m+1;
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
default{m,1}.entrytype = 'Choose';
default{m,1}.labelstr = 'Comp_kmax';
default{m,1}.entrystr = 'Design';
default{m,1}.options = {'Implementation','Design'};

m = m+1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'SubSamp';
default{m,1}.entrystr = subsamp;

m = m+1;
default{m,1}.entrytype = 'RunExtFunc';
default{m,1}.labelstr = 'Kern_File';
default{m,1}.entrystr = '';
default{m,1}.buttonname = 'Load';
default{m,1}.runfunc1 = 'LoadConvKernCur_v4';
default{m,1}.(default{m,1}.runfunc1).curloc = KernPath;
default{m,1}.runfunc2 = 'LoadConvKernDef_v4';
default{m,1}.(default{m,1}.runfunc2).defloc = KernPath;

m = m+1;
default{m,1}.entrytype = 'ScrptFunc';
default{m,1}.labelstr = 'TFfunc';
default{m,1}.entrystr = TFfunc;
default{m,1}.searchpath = TFPath;

m = m+1;
default{m,1}.entrytype = 'ScrptFunc';
default{m,1}.labelstr = 'CTFVatSPfunc';
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

m = m+1;
default{m,1}.entrytype = 'RunScrptFunc';
default{m,1}.scrpttype = 'SDC';
default{m,1}.labelstr = 'CreateSDC';
default{m,1}.entrystr = '';
default{m,1}.buttonname = 'Run';
