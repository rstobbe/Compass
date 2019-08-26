%====================================================
% 
%====================================================

function [OPT,err] = Options_ReducedFovSupport_v1b_Func(OPT,INPUT)

Status2('done','Options with reduced FoV support',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Get Input
%---------------------------------------------
KRNprms = INPUT.KRNprms;
SDCS = INPUT.SDCS;
IMP = INPUT.IMP;
clear INPUT;

%---------------------------------------------
% Set SDCS
%---------------------------------------------
SDCS.SubSamp = KRNprms.DesforSS;
SDCS.precision = OPT.precision;

%--------------------------------------
% Test (unnecessary) 
%--------------------------------------
if rem(round(1e9*(1/(KRNprms.DblKern.res*SDCS.SubSamp)))/1e9,1)
    err.flag = 1;
    err.msg = '1/(KernRes*SS) not an integer';
    return
end

%--------------------------------------
% Reset Gpus
%--------------------------------------
OPT.ResetGpus = 'Yes';
if strcmp(OPT.ResetGpus,'Yes')
    Status2('busy','Reset GPUs',3);
    NoGPUs = gpuDeviceCount;
    for n = 1:NoGPUs
        CudaDevice = gpuDevice(n);               % Cuda initialization (i.e. a Cuda reset).  'CudaDevice' not needed down pipe... (historic)
    end
end

%--------------------------------------
% Use Reduced FoV
%--------------------------------------
FovReduction = IMP.PROJdgn.fovsupported/IMP.PROJdgn.fov;
IMP.PROJdgn.kstep = 1000/IMP.PROJdgn.fovsupported;
IMP.impPROJdgn.kstep = 1000/IMP.PROJdgn.fovsupported;
IMP.PROJdgn.fov = IMP.PROJdgn.fovsupported;
IMP.impPROJdgn.fov = IMP.PROJdgn.fovsupported;
IMP.PROJdgn.rad = IMP.PROJdgn.fovsupported/IMP.PROJdgn.vox;
IMP.impPROJdgn.rad = (IMP.PROJdgn.fovsupported/IMP.PROJdgn.vox)/2;

%--------------------------------------
% Return
%--------------------------------------
OPT.SDCS = SDCS;
OPT.IMP = IMP;
OPT.Scale = 1/(FovReduction^3);

Status2('done','',2);
Status2('done','',3);



