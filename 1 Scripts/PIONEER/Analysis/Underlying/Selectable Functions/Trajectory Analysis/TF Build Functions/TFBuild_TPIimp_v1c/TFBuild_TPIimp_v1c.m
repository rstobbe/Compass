%===========================================
% (v1c)
%    - include orientation and figure saving
%===========================================

function [SCRPTipt,TF,err] = TFBuild_TPIimp_v1c(SCRPTipt,TFipt)

Status2('done','TF Build Function Input',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Return Panel Input
%---------------------------------------------
TF.method = TFipt.Func;
TF.sigdecfunc = TFipt.('SigDecfunc').Func; 

%---------------------------------------------
% Get Working Structures from Sub Functions
%---------------------------------------------
CallingFunction = TFipt.Struct.labelstr;
RLXipt = TFipt.('SigDecfunc');
if isfield(TF,([CallingFunction,'_Data']))
    if isfield(TFipt.TFfunc_Data,('SigDecfunc_Data'))
        RLXipt.SigDecfunc_Data = TFipt.TFfunc_Data.SigDecfunc_Data;
    end
end

%------------------------------------------
% Get Signal Decay Function Info
%------------------------------------------
func = str2func(TF.sigdecfunc);           
[SCRPTipt,RLX,err] = func(SCRPTipt,RLXipt);
if err.flag
    return
end

%------------------------------------------
% Return
%------------------------------------------
TF.RLX = RLX;

Status2('done','',2);
Status2('done','',3);
