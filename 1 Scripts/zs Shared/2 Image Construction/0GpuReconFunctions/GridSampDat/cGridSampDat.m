function cGridSampDat

% CUDA Path
CUDApath = getenv('CUDA_PATH');      
CUDApath = [CUDApath,'\lib\x64'];

% CUDA Lib Path
CUDAlib = 'D:\Cuda\zz Library';

mex('-R2018a',...                                     
    ['-I',CUDAlib], ...
    ['-L',CUDApath],'-lcudart', ... 
    ['-L',CUDAlib], ...
    '-lCUDA61_ConvSamp2GridComplex_v11a', ...
    '-output','GridSampDat61', ...
    'GridSampDat.cpp');

% mex('-R2018a',...                                     
%     ['-I',CUDAlib], ...
%     ['-L',CUDApath],'-lcudart', ... 
%     ['-L',CUDAlib], ...
%     '-lCUDA75_ConvSamp2GridComplex_v11a', ...
%     '-output','GridSampDat75', ...
%     'GridSampDat.cpp');

