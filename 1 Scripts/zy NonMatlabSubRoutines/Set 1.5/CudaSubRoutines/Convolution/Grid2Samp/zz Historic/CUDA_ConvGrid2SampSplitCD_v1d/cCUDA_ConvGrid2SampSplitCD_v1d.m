function cCUDA_ConvGrid2SampSplitCD_v1d

!"%VS120COMNTOOLS%vsvars32.bat" amd64 & nvcc -c -arch compute_35 -code sm_35 -code sm_52 --ptxas-options="-v" CUDA_ConvGrid2SampSplitCD_v1d.cu
%   - VS120COMNTOOLS is an environment variable (access from system properties - path visual studio 2013 tools...
%   - enclosure in the '%' signs is used to return the path specified by the environment variable...
%   - quotation marks to enclose a path with spaces in it (I think...)
%	- vcvarsall.bat sets up the environment variables to enable command-line builds
%   - amd64 is for 64bit compiler (http://msdn.microsoft.com/en-us/library/x4d2c09s(v=vs.110).aspx)
%   - (nvcc) "-c" compilation to an object file
%   - (nvcc) "-arch compute_35" compile for compute_35 (which is Titan Black) - should be dropped eventually...
%   - (nvcc) "-code sm_35" build for Titan Black
%   - (nvcc) "-code sm_52" build for 970

!"%VS120COMNTOOLS%vsvars32.bat" amd64 & nvcc -lib CUDA_ConvGrid2SampSplitCD_v1d.obj -o CUDA_ConvGrid2SampSplitCD_v1d.lib