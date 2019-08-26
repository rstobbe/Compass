function cGridSampDat

% CUDA Path
CUDApath = getenv('CUDA_PATH');      
CUDApath = [CUDApath,'\lib\x64'];

% CUDA Lib Path
CUDAlib = 'D:\Compass\1 Scripts\zy NonMatlabSubRoutines\Set 1.5\CudaSubRoutines\zz Library';

mex('-R2018a',...                                     
    ['-I',CUDAlib], ...
    ['-L',CUDApath],'-lcudart', ... 
    ['-L',CUDAlib], ...
    '-lCUDA_ConvSamp2GridComplex_v11a', ...
    'GridSampDat.cpp');

 % -O = compile with opitmization         library to link with... (the "cudart" library is the CUDA runtime library)