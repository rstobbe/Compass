function cCUDA_ConvGrid2SampSplitCSM_v1b

!"%VS140VC%vcvarsall.bat" amd64 & nvcc -c -arch compute_61 -code sm_61 --ptxas-options="-v" CUDA_ConvGrid2SampSplitCSM_v1b.cu
%   - VS140VC an environment variable I created (access -> search environment variables)
%   - enclosure in the '%' signs is used to return the path specified by the environment variable...
%   - quotation marks to enclose a path with spaces in it (I think...)
%	- vcvarsall.bat sets up the environment variables to enable command-line builds
%   - amd64 is for 64bit compiler (http://msdn.microsoft.com/en-us/library/x4d2c09s(v=vs.110).aspx)
%   - (nvcc) "-c" compilation to an object file
%   - (nvcc) "-arch compute_35" compile for Titan Black
%   - (nvcc) "-arch compute_52" compile for 970
%   - (nvcc) "-arch compute_61" compile for 1080
%   - (nvcc) "-code sm_35" build for Titan Black
%   - (nvcc) "-code sm_52" build for 970
%   - (nvcc) "-code sm_61" build for 1080

!"%VS140VC%vcvarsall.bat" amd64 & nvcc -lib CUDA_ConvGrid2SampSplitCSM_v1b.obj -o CUDA_ConvGrid2SampSplitCSM_v1b.lib