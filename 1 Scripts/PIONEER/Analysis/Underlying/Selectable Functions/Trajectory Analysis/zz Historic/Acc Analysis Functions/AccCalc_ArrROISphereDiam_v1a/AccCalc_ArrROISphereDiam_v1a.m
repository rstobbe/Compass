%===========================================
% (v1a)
%    
%===========================================

function [SCRPTipt,CALC,err] = AccCalc_ArrROISphereDiam_v1a(SCRPTipt,CALCipt)

Status2('done','CALC Function Input',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Return Panel Input
%---------------------------------------------
CALC.method = CALCipt.Func;
CALC.diam = CALCipt.('Diam');
CALC.roifunc = CALCipt.('ROIfunc').Func;

CallingLabel = CALCipt.Struct.labelstr;
%---------------------------------------------
% Get Working Structures from Sub Functions
%---------------------------------------------
ROIipt = CALCipt.('ROIfunc');
if isfield(CALCipt,([CallingLabel,'_Data']))
    if isfield(CALCipt.([CallingLabel,'_Data']),'ROIfunc_Data')
        ROIipt.('ROIfunc_Data') = CALCipt.([CallingLabel,'_Data']).('ROIfunc_Data');
    end
end

%------------------------------------------
% Get Info
%------------------------------------------
func = str2func(CALC.roifunc);           
[SCRPTipt,ROI,err] = func(SCRPTipt,ROIipt);
if err.flag
    return
end

%------------------------------------------
% Return
%------------------------------------------
CALC.ROI = ROI;


Status2('done','',2);
Status2('done','',3);




