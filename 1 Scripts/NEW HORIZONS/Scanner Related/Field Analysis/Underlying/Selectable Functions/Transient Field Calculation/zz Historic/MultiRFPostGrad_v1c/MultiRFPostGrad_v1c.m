%====================================================
% (v1c) 
%       - update for function splitting
%====================================================

function [SCRPTipt,TF,err] = MultiRFPostGrad_v1c(SCRPTipt,TFipt)

Status2('busy','Get Info for Transient Field Calculation',2);
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
TF.FileGrad1 = TFipt.([CallingLabel,'_Data']).File_Grad1_Data.path;
TF.FileGrad2 = TFipt.([CallingLabel,'_Data']).File_Grad2_Data.path;
TF.gstart = str2double(TFipt.('Gstart'));
TF.gstop = str2double(TFipt.('Gstop'));
TF.timestart = TFipt.('Timing_Start');

Status2('done','',2);
Status2('done','',3);