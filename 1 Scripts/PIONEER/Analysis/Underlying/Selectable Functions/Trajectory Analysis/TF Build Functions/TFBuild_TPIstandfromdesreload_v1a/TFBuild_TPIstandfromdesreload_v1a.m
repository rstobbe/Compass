%===========================================
% (v1a)
%    
%===========================================

function [SCRPTipt,TF,err] = TFBuild_TPIstandfromdesreload_v1a(SCRPTipt,TFipt)

Status2('done','TF Build Function Input',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

TF = struct();
CallingLabel = TFipt.Struct.labelstr;
%---------------------------------------------
% Tests
%---------------------------------------------
LoadAll = 0;
if not(isfield(TFipt,[CallingLabel,'_Data']))
    LoadAll = 1;
end
if LoadAll == 1 || not(isfield(TFipt.([CallingLabel,'_Data']),'DES_File_Data'))
    if isfield(TFipt.('DES_File').Struct,'selectedfile')
        file = TFipt.('DES_File').Struct.selectedfile;
        if not(exist(file,'file'))
            err.flag = 1;
            err.msg = '(Re) Load DES_File';
            ErrDisp(err);
            return
        else
            Status2('busy','Load DES Data',2);            
            load(file);
            saveData.path = file;
            TFipt.([CallingLabel,'_Data']).('DES_File_Data') = saveData;
        end
    else
        err.flag = 1;
        err.msg = '(Re) Load DES_File';
        ErrDisp(err);
        return
    end
end

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
TF.DES = TFipt.([CallingLabel,'_Data']).('DES_File_Data').DES;

Status2('done','',2);
Status2('done','',3);
