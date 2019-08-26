%====================================================
% (v1a)
%      - Start RFPreSingleGrad_v1a     
%====================================================

function [SCRPTipt,TF,err] = RFPreSingleGradDbl_v1a(SCRPTipt,TFipt)

Status2('busy','Get Transient Field Calculation Info',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Tests
%---------------------------------------------
CallingLabel = TFipt.Struct.labelstr;
if not(isfield(TFipt,[CallingLabel,'_Data']))
    if isfield(TFipt.('File_Grad1a').Struct,'selectedfile')
        file = TFipt.('File_Grad1a').Struct.selectedfile;
        if not(exist(file,'file'))
            err.flag = 1;
            err.msg = '(Re) Load File_Grad1a';
            ErrDisp(err);
            return
        else
            TFipt.([CallingLabel,'_Data']).('File_Grad1a_Data').path = file;
        end
    else
        err.flag = 1;
        err.msg = '(Re) Load File_Grad1a';
        ErrDisp(err);
        return
    end
    if isfield(TFipt.('File_Grad2a').Struct,'selectedfile')
        file = TFipt.('File_Grad2a').Struct.selectedfile;
        if not(exist(file,'file'))
            err.flag = 1;
            err.msg = '(Re) Load File_Grad2a';
            ErrDisp(err);
            return
        else
            TFipt.([CallingLabel,'_Data']).('File_Grad2a_Data').path = file;
        end
    else
        err.flag = 1;
        err.msg = '(Re) Load File_Grad2a';
        ErrDisp(err);
        return
    end
    if isfield(TFipt.('File_Grad1b').Struct,'selectedfile')
        file = TFipt.('File_Grad1b').Struct.selectedfile;
        if not(exist(file,'file'))
            err.flag = 1;
            err.msg = '(Re) Load File_Grad1b';
            ErrDisp(err);
            return
        else
            TFipt.([CallingLabel,'_Data']).('File_Grad1b_Data').path = file;
        end
    else
        err.flag = 1;
        err.msg = '(Re) Load File_Grad1b';
        ErrDisp(err);
        return
    end
    if isfield(TFipt.('File_Grad2b').Struct,'selectedfile')
        file = TFipt.('File_Grad2b').Struct.selectedfile;
        if not(exist(file,'file'))
            err.flag = 1;
            err.msg = '(Re) Load File_Grad2b';
            ErrDisp(err);
            return
        else
            TFipt.([CallingLabel,'_Data']).('File_Grad2b_Data').path = file;
        end
    else
        err.flag = 1;
        err.msg = '(Re) Load File_Grad2b';
        ErrDisp(err);
        return
    end    
end

%---------------------------------------------
% Return Panel Input
%---------------------------------------------
TF.method = TFipt.Func;
TF.FileGrad1a = TFipt.([CallingLabel,'_Data']).('File_Grad1a_Data').path;
TF.FileGrad2a = TFipt.([CallingLabel,'_Data']).('File_Grad2a_Data').path;
TF.FileGrad1b = TFipt.([CallingLabel,'_Data']).('File_Grad1b_Data').path;
TF.FileGrad2b = TFipt.([CallingLabel,'_Data']).('File_Grad2b_Data').path;

Status2('done','',2);
Status2('done','',3);
