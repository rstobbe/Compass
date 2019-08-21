function [CudaDevice] = GraphicCard_Info(doCuda)

%-----------------------------------
% CUDA
%-----------------------------------
NoGPUs = gpuDeviceCount;
if doCuda == 0 || NoGPUs == 0
    CudaDevice = cell(1);
elseif doCuda == 1 && NoGPUs > 1
    disp('Initialize GPUs');
    for n = 1:NoGPUs
        CudaDevice = gpuDevice(n)               % Cuda initialization (i.e. a Cuda reset).  'CudaDevice' not needed down pipe... (historic)
    end
    %opengl software
    opengl hardware
    OpenGlInfo = opengl('data')
else
    disp('Initialize GPU');
    CudaDevice = gpuDevice(doCuda)
    opengl hardware
    OpenGlInfo = opengl('data')
end





