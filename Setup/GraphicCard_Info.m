function [CudaDevice] = GraphicCard_Info(USERGBL)

%-----------------------------------
% CUDA
%-----------------------------------
doCuda = USERGBL.doCuda;
NoGPUs = gpuDeviceCount;
Setup = USERGBL.setup;
if doCuda == 0 || NoGPUs == 0
    CudaDevice = cell(1);
elseif doCuda == 1 && NoGPUs > 1
    disp('Initialize GPUs');
    for n = 1:NoGPUs
        CudaDevice = gpuDevice(n)               % Cuda initialization (i.e. a Cuda reset).  'CudaDevice' not needed down pipe... (historic)
    end
    if ~strcmp(Setup,'Scripts')
        opengl hardware
        OpenGlInfo = opengl('data')
    end
else
    disp('Initialize GPU');
    CudaDevice = gpuDevice(doCuda)
    if ~strcmp(Setup,'Scripts')
        opengl hardware
        OpenGlInfo = opengl('data')
    end
end





