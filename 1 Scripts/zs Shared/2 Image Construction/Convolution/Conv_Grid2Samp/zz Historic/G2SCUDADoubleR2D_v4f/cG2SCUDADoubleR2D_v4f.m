function cG2SCUDADoubleR2D_v4f

% CUDA Path
CUDApath = getenv('CUDA_LIB_PATH');      
if CUDApath(1) == '"' 
    CUDApath = CUDApath(2:end); 
end, 
if CUDApath(end) == '"'
    CUDApath = CUDApath(1:end-1);
end

% CUDA Lib Path
CUDAlib = 'D:\1 Scripts\zy NonMatlabSubRoutines\Set 1.4\CudaSubRoutines\zz Library';

mex('-largeArrayDims',...                                     
    ['-I',CUDAlib], ...
    ['-L',CUDApath],'-lcudart','-lcufft', ... 
    ['-L',CUDAlib], ...
    '-lCUDA_2DGeneralD_v1a', ...
    '-lCUDA_ConvGrid2SampSplitRD2D_v1c', ...
    '-lCUDA_DeviceManage_v1a', ...     
    'G2SCUDADoubleR2D_v4f.cpp');

 % -O = compile with opitmization         library to link with... (the "cudart" library is the CUDA runtime library)