%=========================================================
% (v1a)
%       
%=========================================================

function [SCRPTipt,IMAT,err] = LoadASLImNifti_v1a(SCRPTipt,IMATipt)

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
    if isfield(IMATipt.('Nifti_File').Struct,'selectedfile')
        file = IMATipt.('Nifti_File').Struct.selectedfile;
        if not(exist(file,'file'))
            err.flag = 1;
            err.msg = '(Re) Nifti File';
            ErrDisp(err);
            return
        else
            IMATipt.([CallingLabel,'_Data']).('Nifti_File_Data').file = file;
        end
    else
        err.flag = 1;
        err.msg = '(Re) Load First Dicom File';
        ErrDisp(err);
        return
    end
end

%---------------------------------------------
% Load Panel Input
%---------------------------------------------
IMAT.loc = IMATipt.([CallingLabel,'_Data']).('Nifti_File_Data').file;

Status2('done','',2);
Status2('done','',3);

