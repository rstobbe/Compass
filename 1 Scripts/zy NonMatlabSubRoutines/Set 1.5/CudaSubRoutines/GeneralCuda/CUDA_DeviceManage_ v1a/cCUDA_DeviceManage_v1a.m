function cCUDA_DeviceManage_v1a

!"%VS120COMNTOOLS%vcvarsall.bat" amd64 & nvcc -c -arch sm_35 --ptxas-options="-v" CUDA_DeviceManage_v1a.cu
%   - VS120COMNTOOLS is an environment variable (access from system properties - path visual studio 2013 tools...
%   - enclosure in the '%' signs is used to return the path specified by the environment variable...
%   - quotation marks to enclose a path with spaces in it (I think...)
%   - a batch file is a text file containing a series of commands intended to be executed by the command interpreter. 
%	- vcvarsall.bat sets up the environment variables to enable command-line builds
%   - amd64 is for 64bit compiler (http://msdn.microsoft.com/en-us/library/x4d2c09s(v=vs.110).aspx)
%   - (nvcc) "-c" compilation to an object file
%   - (nvcc) "-arch sm_35" specifies build for compute 3.5 capable GPU i.e. the Titan Black

!"%VS110COMNTOOLS%vcvarsall.bat" amd64 & nvcc -lib CUDA_DeviceManage_v1a.obj -o CUDA_DeviceManage_v1a.lib