%=========================================================
% (v1a)
%       
%=========================================================

function [SCRPTipt,IMAT,err] = LoadDiffImMat6D_v1a(SCRPTipt,IMATipt)

Status2('done','Get Nifi Loading Input',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';
IMAT = struct();

%---------------------------------------------
% Tests
%---------------------------------------------
CallingLabel = IMATipt.Struct.labelstr;
if not(isfield(IMATipt,[CallingLabel,'_Data']))
    if isfield(IMATipt.('Diff_File').Struct,'selectedfile')
        file = IMATipt.('Diff_File').Struct.selectedfile;
        if not(exist(file,'file'))
            err.flag = 1;
            err.msg = '(Re) Load Diffusion File';
            ErrDisp(err);
            return
        else
            IMATipt.([CallingLabel,'_Data']).('Diff_File_Data').file = file;
        end
    else
        err.flag = 1;
        err.msg = '(Re) Load Diffusion File';
        ErrDisp(err);
        return
    end
end

%---------------------------------------------
% Load Panel Input
%---------------------------------------------
IMAT = struct();
if not(isfield(IMATipt.('LoadDWIfunc_Data').('Diff_File_Data'),'IMG'))
    err.flag = 1;
    err.msg = 'Matfile Does Not Contain IMG struct';
    Status2('error',err.msg,2);
    return
end
IMAT.IMG = IMATipt.('LoadDWIfunc_Data').('Diff_File_Data').IMG;

Status2('done','',2);
Status2('done','',3);

