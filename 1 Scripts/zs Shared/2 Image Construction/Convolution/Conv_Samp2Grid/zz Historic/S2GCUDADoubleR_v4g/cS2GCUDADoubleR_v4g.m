function cS2GCUDADoubleR_v4g

% CUDA Path
CUDApath = getenv('CUDA_LIB_PATH');      
if CUDApath(1) == '"' 
    CUDApath = CUDApath(2:end); 
end, 
if CUDApath(end) == '"'
    CUDApath = CUDApath(1:end-1);
end
CUDApath = CUDApath(1:end-1);                  % remove last backslash

% CUDA Lib Path
CUDAlib = 'D:\1 Scripts\zy NonMatlabSubRoutines\Set 1.4\CudaSubRoutines\zz Library';

mex('-largeArrayDims',...                                     
    ['-I',CUDAlib], ...
    ['-L',CUDApath],'-lcudart','-lcufft', ... 
    ['-L',CUDAlib], ...
    '-lCUDA_GeneralD_v1a', ...
    '-lCUDA_ConvSamp2GridSplitRD_v1c', ...
    '-lCUDA_DeviceManage_v1a', ... 
    'S2GCUDADoubleR_v4g.cpp');

 % -O = compile with opitmization         library to link with... (the "cudart" library is the CUDA runtime library)