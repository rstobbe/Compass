function cG2SCUDADoubleR_v5b

% CUDA Path
CUDApath = getenv('CUDA_PATH');      
CUDApath = [CUDApath,'\lib\x64'];

% CUDA Lib Path
CUDAlib = 'D:\Cuda\zz Library';

% mex('-largeArrayDims',...                                     
%     ['-I',CUDAlib], ...
%     ['-L',CUDApath],'-lcudart', ... 
%     ['-L',CUDAlib], ...
%     '-lCUDA_DeviceManage_v1c', ... 
%     '-lCUDA_GeneralDM_v1c', ...
%     '-lCUDA_ConvGrid2SampSplitRDM_v1a', ...
%     '-lCUDA_MultiDevSampArrComb_v1a', ...
%     'G2SCUDADoubleR_v5b.cpp');

% mex('-R2017b', ...                              % need old API                                   
%     ['-I',CUDAlib], ...
%     ['-L',CUDApath],'-lcudart', ... 
%     ['-L',CUDAlib], ...
%     '-lCUDA_DeviceManage_v1c', ... 
%     '-lCUDA_GeneralDM_v1c', ...
%     '-lCUDA61_ConvGrid2SampSplitRDM_v1a', ...
%     '-lCUDA61_MultiDevSampArrComb_v1a', ...
%     '-output','G2SCUDADoubleR61_v5b', ...
%     'G2SCUDADoubleR_v5b.cpp');

% mex('-R2017b', ...                              % need old API                                   
%     ['-I',CUDAlib], ...
%     ['-L',CUDApath],'-lcudart', ... 
%     ['-L',CUDAlib], ...
%     '-lCUDA_DeviceManage_v1c', ... 
%     '-lCUDA_GeneralDM_v1c', ...
%     '-lCUDA75_ConvGrid2SampSplitRDM_v1a', ...
%     '-lCUDA75_MultiDevSampArrComb_v1a', ...
%     '-output','G2SCUDADoubleR75_v5b', ...
%     'G2SCUDADoubleR_v5b.cpp');

mex('-R2017b', ...                              % need old API                                   
    ['-I',CUDAlib], ...
    ['-L',CUDApath],'-lcudart', ... 
    ['-L',CUDAlib], ...
    '-lCUDA_DeviceManage_v1c', ... 
    '-lCUDA_GeneralDM_v1c', ...
    '-lCUDA86_ConvGrid2SampSplitRDM_v1a', ...
    '-lCUDA86_MultiDevSampArrComb_v1a', ...
    '-output','G2SCUDADoubleR86_v5b', ...
    'G2SCUDADoubleR_v5b.cpp');