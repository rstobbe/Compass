%====================================================
% (v1A)
%      - Start RFPreSingleGrad_v1A     
%====================================================

function [SCRPTipt,TF,err] = RFPreSingleGradDbl_v1A(SCRPTipt,TFipt)

Status2('busy','Get Transient Field Calculation Info',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Tests
%---------------------------------------------
CallingLabel = TFipt.Struct.labelstr;
if not(isfield(TFipt,[CallingLabel,'_Data']))
    if isfield(TFipt.('File_Grad1A').Struct,'selectedfile')
        file = TFipt.('File_Grad1A').Struct.selectedfile;
        if not(exist(file,'file'))
            err.flag = 1;
            err.msg = '(Re) Load File_Grad1A';
            ErrDisp(err);
            return
        else
            TFipt.([CallingLabel,'_Data']).('File_Grad1A_Data').path = file;
        end
    else
        err.flag = 1;
        err.msg = '(Re) Load File_Grad1A';
        ErrDisp(err);
        return
    end
    if isfield(TFipt.('File_Grad2A').Struct,'selectedfile')
        file = TFipt.('File_Grad2A').Struct.selectedfile;
        if not(exist(file,'file'))
            err.flag = 1;
            err.msg = '(Re) Load File_Grad2A';
            ErrDisp(err);
            return
        else
            TFipt.([CallingLabel,'_Data']).('File_Grad2A_Data').path = file;
        end
    else
        err.flag = 1;
        err.msg = '(Re) Load File_Grad2A';
        ErrDisp(err);
        return
    end
    if isfield(TFipt.('File_Grad1B').Struct,'selectedfile')
        file = TFipt.('File_Grad1B').Struct.selectedfile;
        if not(exist(file,'file'))
            err.flag = 1;
            err.msg = '(Re) Load File_Grad1B';
            ErrDisp(err);
            return
        else
            TFipt.([CallingLabel,'_Data']).('File_Grad1B_Data').path = file;
        end
    else
        err.flag = 1;
        err.msg = '(Re) Load File_Grad1B';
        ErrDisp(err);
        return
    end
    if isfield(TFipt.('File_Grad2B').Struct,'selectedfile')
        file = TFipt.('File_Grad2B').Struct.selectedfile;
        if not(exist(file,'file'))
            err.flag = 1;
            err.msg = '(Re) Load File_Grad2B';
            ErrDisp(err);
            return
        else
            TFipt.([CallingLabel,'_Data']).('File_Grad2B_Data').path = file;
        end
    else
        err.flag = 1;
        err.msg = '(Re) Load File_Grad2B';
        ErrDisp(err);
        return
    end
    if isfield(TFipt.('File_GradA1').Struct,'selectedfile')
        file = TFipt.('File_GradA1').Struct.selectedfile;
        if not(exist(file,'file'))
            err.flag = 1;
            err.msg = '(Re) Load File_GradA1';
            ErrDisp(err);
            return
        else
            TFipt.([CallingLabel,'_Data']).('File_GradA1_Data').path = file;
        end
    else
        err.flag = 1;
        err.msg = '(Re) Load File_GradA1';
        ErrDisp(err);
        return
    end
    if isfield(TFipt.('File_GradA2').Struct,'selectedfile')
        file = TFipt.('File_GradA2').Struct.selectedfile;
        if not(exist(file,'file'))
            err.flag = 1;
            err.msg = '(Re) Load File_GradA2';
            ErrDisp(err);
            return
        else
            TFipt.([CallingLabel,'_Data']).('File_GradA2_Data').path = file;
        end
    else
        err.flag = 1;
        err.msg = '(Re) Load File_GradA2';
        ErrDisp(err);
        return
    end
    if isfield(TFipt.('File_GradB1').Struct,'selectedfile')
        file = TFipt.('File_GradB1').Struct.selectedfile;
        if not(exist(file,'file'))
            err.flag = 1;
            err.msg = '(Re) Load File_GradB1';
            ErrDisp(err);
            return
        else
            TFipt.([CallingLabel,'_Data']).('File_GradB1_Data').path = file;
        end
    else
        err.flag = 1;
        err.msg = '(Re) Load File_GradB1';
        ErrDisp(err);
        return
    end
    if isfield(TFipt.('File_GradB2').Struct,'selectedfile')
        file = TFipt.('File_GradB2').Struct.selectedfile;
        if not(exist(file,'file'))
            err.flag = 1;
            err.msg = '(Re) Load File_GradB2';
            ErrDisp(err);
            return
        else
            TFipt.([CallingLabel,'_Data']).('File_GradB2_Data').path = file;
        end
    else
        err.flag = 1;
        err.msg = '(Re) Load File_GradB2';
        ErrDisp(err);
        return
    end     
end

%---------------------------------------------
% Return Panel Input
%---------------------------------------------
TF.method = TFipt.Func;
TF.FileGrad1A = TFipt.([CallingLabel,'_Data']).('File_Grad1A_Data').path;
TF.FileGrad2A = TFipt.([CallingLabel,'_Data']).('File_Grad2A_Data').path;
TF.FileGrad1B = TFipt.([CallingLabel,'_Data']).('File_Grad1B_Data').path;
TF.FileGrad2B = TFipt.([CallingLabel,'_Data']).('File_Grad2B_Data').path;
TF.FileGradA1 = TFipt.([CallingLabel,'_Data']).('File_GradA1_Data').path;
TF.FileGradA2 = TFipt.([CallingLabel,'_Data']).('File_GradA2_Data').path;
TF.FileGradB1 = TFipt.([CallingLabel,'_Data']).('File_GradB1_Data').path;
TF.FileGradB2 = TFipt.([CallingLabel,'_Data']).('File_GradB2_Data').path;

Status2('done','',2);
Status2('done','',3);
