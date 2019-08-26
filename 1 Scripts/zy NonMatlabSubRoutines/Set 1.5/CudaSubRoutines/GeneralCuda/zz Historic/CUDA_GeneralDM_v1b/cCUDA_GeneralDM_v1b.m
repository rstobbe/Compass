function cCUDA_GeneralDM_v1b

!"%VCVARSALL%vcvarsall.bat" amd64 & nvcc -c -arch compute_35 -code sm_35 -code sm_52 --ptxas-options="-v" CUDA_GeneralDM_v1b.cu
%   - VCVARSALL an environment variable I created (folder contains 'vcvarsall.bat')
%   - enclosure in the '%' signs is used to return the path specified by the environment variable...
%   - quotation marks to enclose a path with spaces in it (I think...)
%	- vcvarsall.bat sets up the environment variables to enable command-line builds
%   - amd64 is for 64bit compiler (http://msdn.microsoft.com/en-us/library/x4d2c09s(v=vs.110).aspx)
%   - (nvcc) "-c" compilation to an object file
%   - (nvcc) "-arch compute_35" compile for compute_35 (which is Titan Black) - should be dropped eventually...
%   - (nvcc) "-code sm_35" build for Titan Black
%   - (nvcc) "-code sm_52" build for 970

!"%VCVARSALL%vcvarsall.bat" amd64 & nvcc -lib CUDA_GeneralDM_v1b.obj -o CUDA_GeneralDM_v1b.lib