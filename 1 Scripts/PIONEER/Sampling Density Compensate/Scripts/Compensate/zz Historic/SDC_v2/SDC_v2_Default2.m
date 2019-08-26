%=========================================================
% 
%=========================================================

function [default] = SDC_v2_Default2(SCRPTPATHS)

if strcmp(filesep,'\')
    addpath(genpath([SCRPTPATHS.rootloc,'Sampling Density Compensate\Underlying\zz Common\']));
    IEPath = [SCRPTPATHS.rootloc,'Sampling Density Compensate\Underlying\Selectable Functions\IE Functions\'];
    KernPath = [SCRPTPATHS.scrptshareloc,'2 Image Creation\Selectable Functions\Convolution Kernel Select\'];
    TFPath = [SCRPTPATHS.rootloc,'Sampling Density Compensate\Underlying\Selectable Functions\TF Functions\'];
    CTFPath = [SCRPTPATHS.rootloc,'Sampling Density Compensate\Underlying\Selectable Functions\Convolved TF Shape\'];
    ITPath = [SCRPTPATHS.rootloc,'Sampling Density Compensate\Underlying\Selectable Functions\SDC Functions\'];
elseif strcmp(filesep,'/')
end
addpath(genpath(IEPath));
addpath(genpath(KernPath));
addpath(genpath(TFPath));
addpath(genpath(CTFPath));
addpath(genpath(ITPath));

SDC_Name = 'TPI_largevolume';
IEfunc = 'RadialEst_v1';
subsamp = '2.5';
Kernfunc = 'FiltSinc_v2';
TFfunc = 'MatchSD_v1';
CTFfunc = 'ConvTF_vE1a';
ITfunc = 'mG02a_v1';

m = 1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'SDC_Name';
default{m,1}.entrystr = SDC_Name;

m = m+1;
default{m,1}.entrytype = 'RunFunc';
default{m,1}.labelstr = 'Imp_File';
default{m,1}.entrystr = '';
default{m,1}.buttonname = 'Load';
default{m,1}.runfunc = 'LoadTrajectoryImplementation_v2';
default{m,1}.runfuncinput = {SCRPTPATHS.outloc};
default{m,1}.runfuncoutput = {''};

m = m+1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'SubSamp';
default{m,1}.entrystr = subsamp;

m = m+1;
default{m,1}.entrytype = 'ScrptFunc';
default{m,1}.labelstr = 'KernelFunc';
default{m,1}.entrystr = Kernfunc;
default{m,1}.searchpath = KernPath;

m = m+1;
default{m,1}.entrytype = 'ScrptFunc';
default{m,1}.labelstr = 'TFFunc';
default{m,1}.entrystr = TFfunc;
default{m,1}.searchpath = TFPath;

m = m+1;
default{m,1}.entrytype = 'UnderFunc';
default{m,1}.labelstr = 'ConvTFFunc';
default{m,1}.entrystr = CTFfunc;

m = m+1;
default{m,1}.entrytype = 'ScrptFunc';
default{m,1}.labelstr = 'InitialEst';
default{m,1}.entrystr = IEfunc;
default{m,1}.searchpath = IEPath;

m = m+1;
default{m,1}.entrytype = 'UnderFunc';
default{m,1}.labelstr = 'IterateFunc';
default{m,1}.entrystr = ITfunc;


