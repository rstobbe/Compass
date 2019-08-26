%==================================================
% FFT CUDA
%==================================================

function [kDat,err] = mFFTCUDASingle_v1a(Im)

err.flag = 0;
err.msg = '';

%------------------------------------
% Input
%------------------------------------
Im = single(Im);
if isreal(Im)
    Im = complex(Im,zeros(size(Im)));
end

%------------------------------------
% FFT
%------------------------------------
[kDat,Test,Error] = FFTCUDASingle_v1a(Im);

%------------------------------------
% Check Error - Return
%------------------------------------
if not(strcmp(Error,'no error'))
    CUDAerror = Error
    error();
end
