%============================================
% ROI Dist_Fit
%============================================

function [val,error,errorflag] = ROI_Ral_Fit(x,y)

[ROI_Arr] = Extract_ROI_Array_v2a(1,1);

% sample every nth point (account for resolution)

%n = 16;                                             % 16 = relative between FWHM-Na (stroke protocol no relax) and image voxel size.  
%n = 8;                                               % 8 = relative between FWHM-Na (stroke protocol no relax) and 128 ZF^3 voxel size. (must be integer)
%n = 32;
n = 1;
ROI_Arr2 = [];
for i = 1:length(ROI_Arr)
    if rem(i,n) == 0
        if not(ROI_Arr(i) == 0)
            ROI_Arr2 = [ROI_Arr2 ROI_Arr(i)];       % want to estimate a Rician distribution which can't handle zeros.
        end
    end
end
length(ROI_Arr2)

[sd,ci] = raylfit(ROI_Arr2)
pm = sd-ci(1)

%dfittool(ROI_Arr2)


