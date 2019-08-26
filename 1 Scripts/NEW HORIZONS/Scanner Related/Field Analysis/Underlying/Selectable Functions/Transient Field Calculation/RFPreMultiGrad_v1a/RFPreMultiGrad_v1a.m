%====================================================
% (v1a)
%           
%====================================================

function [SCRPTipt,TF,err] = RFPreMultiGrad_v1a(SCRPTipt,TFipt)

Status2('busy','Get Transient Field Calculation Info',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Tests
%---------------------------------------------
CallingLabel = TFipt.Struct.labelstr;
if not(isfield(TFipt,[CallingLabel,'_Data']))
    if isfield(TFipt.('File_Grad1').Struct,'selectedfile')
        file = TFipt.('File_Grad1').Struct.selectedfile;
        if not(exist(file,'file'))
            err.flag = 1;
            err.msg = '(Re) Load File_Grad1';
            ErrDisp(err);
            return
        else
            TFipt.([CallingLabel,'_Data']).('File_Grad1_Data').path = file;
        end
    else
        err.flag = 1;
        err.msg = '(Re) Load File_Grad1';
        ErrDisp(err);
        return
    end
    if isfield(TFipt.('File_Grad2').Struct,'selectedfile')
        file = TFipt.('File_Grad2').Struct.selectedfile;
        if not(exist(file,'file'))
            err.flag = 1;
            err.msg = '(Re) Load File_Grad2';
            ErrDisp(err);
            return
        else
            TFipt.([CallingLabel,'_Data']).('File_Grad2_Data').path = file;
        end
    else
        err.flag = 1;
        err.msg = '(Re) Load File_Grad2';
        ErrDisp(err);
        return
    end
end

%---------------------------------------------
% Return Panel Input
%---------------------------------------------
TF.method = TFipt.Func;
TF.FileGrad1 = TFipt.([CallingLabel,'_Data']).('File_Grad1_Data').path;
TF.FileGrad2 = TFipt.([CallingLabel,'_Data']).('File_Grad2_Data').path;

Status2('done','',2);
Status2('done','',3);
