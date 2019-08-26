function cFindNghbrsCUDA_v1e

%Stick with VS2005 for mex -setup until...

!"%VS80COMNTOOLS%vsvars32.bat" & nvcc FindNghbrsCUDA_v1e.cu -c -arch=sm_21 -m64 -Xptxas -v 
%   - VS80COMNTOOLS is an environment variable (access from system properties - includes the path visual studio tools...
%   - enclosure in the '%' signs is used to return the path specified by the environment variable...
%   - quotation marks to enclose a path with spaces in it (I think...)
%   - a batch file is a text file containing a series of commands intended to be executed by the command interpreter. 
%   - (nvcc) "-c" compilation to an object file
%   - (nvcc) "-arch sm_11" specifies build for compute 1.1 capable GPU i.e. the 9800GT
%   - (nvcc) "-m64" 64-bit architecture
%   - (nvcc) "-Xptxas -v" display summary of registers and memory  

n=getenv('CUDA_LIB_PATH');      % CUDA environment variable
%n = 'C:\Program Files\NVIDIA GPU Computing Toolkit\CUDA\v4.0\lib\x64';

% -L   - directories to search for libraries specified with -1
% -1   - object library to link with... (the "cudart" library is the CUDA runtime library)
mex(['-L',n],'-lcudart','FindNghbrsCUDA_v1e.obj','FindNghbrsCUDA_v1e.cpp');

