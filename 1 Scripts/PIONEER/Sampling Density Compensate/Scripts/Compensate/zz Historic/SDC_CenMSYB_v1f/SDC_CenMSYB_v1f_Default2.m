%=========================================================
% 
%=========================================================

function [default] = SDC_CenMSYB_v1f_Default2(SCRPTPATHS)

if strcmp(filesep,'\')
    addpath(genpath([SCRPTPATHS.pioneerloc,'Sampling Density Compensate\Underlying\zz Common\']));
    IEPath = [SCRPTPATHS.pioneerloc,'Sampling Density Compensate\Underlying\Selectable Functions\InitialEst Functions\'];
    TFPath = [SCRPTPATHS.pioneerloc,'Sampling Density Compensate\Underlying\Selectable Functions\TF Functions\'];
    CTFPath = [SCRPTPATHS.pioneerloc,'Sampling Density Compensate\Underlying\Selectable Functions\CTFVatSP Functions\'];
    ITPath = [SCRPTPATHS.pioneerloc,'Sampling Density Compensate\Underlying\Selectable Functions\Iterate Functions\'];
elseif strcmp(filesep,'/')
end
TFfunc = 'TF_Uniform_v1a';
CTFfunc = 'CTFVatSP_DblConv_kSphere_v1g';
IEfunc = 'InitialEst_SDestDes_v1d';
ITfunc = 'Iterate_DblConv_v1f';
addpath([IEPath,IEfunc]);
addpath([TFPath,TFfunc]);
addpath([CTFPath,CTFfunc]);
addpath([ITPath,ITfunc]);

SDC_Name = 'SDC';
subsamp = '2.0';

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
default{m,1}.(default{m,1}.runfunc1).loadpanel = 'No';
default{m,1}.runfunc2 = 'LoadTrajImpDef_v4';
default{m,1}.(default{m,1}.runfunc2).defloc = SCRPTPATHS.outloc;
default{m,1}.(default{m,1}.runfunc2).loadpanel = 'No';
default{m,1}.searchpath = SCRPTPATHS.scrptshareloc;
default{m,1}.path = SCRPTPATHS.scrptshareloc;

m = m+1;
default{m,1}.entrytype = 'RunExtFunc';
default{m,1}.labelstr = 'Kern_File';
default{m,1}.entrystr = '';
default{m,1}.buttonname = 'Load';
default{m,1}.runfunc1 = 'LoadConvKernCur_v4b';
default{m,1}.(default{m,1}.runfunc1).curloc = 'D:\1 Scripts\zs Shared\zy Convolution Kernels';
default{m,1}.runfunc2 = 'LoadConvKernDef_v4b';
default{m,1}.(default{m,1}.runfunc2).defloc = 'D:\1 Scripts\zs Shared\zy Convolution Kernels';
default{m,1}.searchpath = SCRPTPATHS.scrptshareloc;
default{m,1}.path = SCRPTPATHS.scrptshareloc;

m = m+1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'SubSamp';
default{m,1}.entrystr = subsamp;

m = m+1;
default{m,1}.entrytype = 'ScrptFunc';
default{m,1}.labelstr = 'TFfunc';
default{m,1}.entrystr = TFfunc;
default{m,1}.searchpath = TFPath;
default{m,1}.path = [TFPath,TFfunc];

m = m+1;
default{m,1}.entrytype = 'ScrptFunc';
default{m,1}.labelstr = 'CTFVatSPfunc';
default{m,1}.entrystr = CTFfunc;
default{m,1}.searchpath = CTFPath;
default{m,1}.path = [CTFPath,CTFfunc];

m = m+1;
default{m,1}.entrytype = 'ScrptFunc';
default{m,1}.labelstr = 'InitialEstfunc';
default{m,1}.entrystr = IEfunc;
default{m,1}.searchpath = IEPath;
default{m,1}.path = [IEPath,IEfunc];

m = m+1;
default{m,1}.entrytype = 'ScrptFunc';
default{m,1}.labelstr = 'Iteratefunc';
default{m,1}.entrystr = ITfunc;
default{m,1}.searchpath = ITPath;
default{m,1}.path = [ITPath,ITfunc];

m = m+1;
default{m,1}.entrytype = 'RunScrptFunc';
default{m,1}.scrpttype = 'SDC';
default{m,1}.labelstr = 'CreateSDC';
default{m,1}.entrystr = '';
default{m,1}.buttonname = 'Run';

