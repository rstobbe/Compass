%=========================================================
% (v1a) 
%     
%=========================================================

function [SCRPTipt,IC,err] = ImageViaGriddingStandard_v1a(SCRPTipt,ICipt)

Status2('busy','Get Info for Image Creation',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

IC = struct();
CallingLabel = ICipt.Struct.labelstr;
%---------------------------------------------
% Tests
%---------------------------------------------
if not(isfield(ICipt,[CallingLabel,'_Data']))
    if isfield(ICipt.('InvFilt_File').Struct,'selectedfile')
        file = ICipt.('InvFilt_File').Struct.selectedfile;
        if not(exist(file,'file'))
            err.flag = 1;
            err.msg = '(Re) Load InvFilt_File';
            ErrDisp(err);
            return
        else
            load(file);
            saveData.path = file;
            ICipt.([CallingLabel,'_Data']).('InvFilt_File_Data') = saveData;
        end
    else
        err.flag = 1;
        err.msg = '(Re) Load InvFilt_File';
        ErrDisp(err);
        return
    end
end

%---------------------------------------------
% Load Panel Input
%---------------------------------------------
IC.method = ICipt.Func;
IC.gridfunc = ICipt.Gridfunc.Func;
IC.zf = str2double(ICipt.('ZeroFill'));
IC.returnfov = ICipt.('ReturnFoV');
IC.IFprms = ICipt.([CallingLabel,'_Data']).('InvFilt_File_Data').IFprms;

%---------------------------------------------
% Get Working Structures from Sub Functions
%---------------------------------------------
GRDipt = ICipt.('Gridfunc');
if isfield(ICipt,([CallingLabel,'_Data']))
    if isfield(ICipt.([CallingLabel,'_Data']),'Gridfunc_Data')
        GRDipt.('Gridfunc_Data') = ICipt.([CallingLabel,'_Data']).('Gridfunc_Data');
    end
end

%------------------------------------------
% Get Gridding Info
%------------------------------------------
func = str2func(IC.gridfunc);           
[SCRPTipt,GRD,err] = func(SCRPTipt,GRDipt);
if err.flag
    return
end

%------------------------------------------
% Return
%------------------------------------------
IC.GRD = GRD;

Status2('done','',2);
Status2('done','',3);

