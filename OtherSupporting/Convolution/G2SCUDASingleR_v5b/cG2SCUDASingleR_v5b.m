function cG2SCUDASingleR_v5b

% CUDA Path
CUDApath = getenv('CUDA_PATH');      
CUDApath = [CUDApath,'\lib\x64'];

% CUDA Lib Path
CUDAlib = 'D:\Compass\1 Scripts\zy NonMatlabSubRoutines\Set 1.5\CudaSubRoutines\zz Library';

mex('-largeArrayDims',...                                     
    ['-I',CUDAlib], ...
    ['-L',CUDApath],'-lcudart', ... 
    ['-L',CUDAlib], ...
    '-lCUDA_DeviceManage_v1c', ... 
    '-lCUDA_GeneralSM_v1c', ...
    '-lCUDA_ConvGrid2SampSplitRSM_v1a', ...
    '-lCUDA_MultiDevSampArrCombS_v1a', ...
    'G2SCUDASingleR_v5b.cpp');

 % -O = compile with opitmization         library to link with... (the "cudart" library is the CUDA runtime library)
