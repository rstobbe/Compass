%==================================================
% 
%==================================================

function [FID,err] = ImportFID_SiemensYBOptionTest_v2f_Func(FID,INPUT)


%---------------------------------------------
% Find Receivers to Test
%---------------------------------------------
if strcmp(FID.rcvrtest,'All') || strcmp(FID.rcvrtest,'all')
    FID.rcvrtest = [];
else
    if isnan(str2double(FID.rcvrtest))
        ind = strfind(FID.rcvrtest,'-');
        if not(isempty(ind))
            FID.rcvrtest = (str2double(FID.rcvrtest(1:ind-1)):1:str2double(FID.rcvrtest(ind+1:end)));
        end
    else
        FID.rcvrtest = str2double(FID.rcvrtest);
    end
end
            
%---------------------------------------------
% Find Receivers to Test
%---------------------------------------------
func = str2func('ImportFID_SiemensYB_v2f_Func');           
[FID,err] = func(FID,INPUT);

