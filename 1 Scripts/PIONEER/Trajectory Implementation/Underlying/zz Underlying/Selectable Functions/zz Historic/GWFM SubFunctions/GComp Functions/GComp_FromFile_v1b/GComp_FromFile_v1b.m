%=====================================================
% (v1b)
%       - Include Delay in Comp File
%=====================================================

function [SCRPTipt,GComp,err] = GComp_FromFile_v1b(SCRPTipt,GCompipt)

Status2('busy','Get ECC Infro',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Get Panel Input
%---------------------------------------------
GComp.method = GCompipt.Func;
GComp.ctrfunc = GCompipt.('CTRfunc').Func;

%---------------------------------------------
% Tests
%---------------------------------------------
CallingLabel = GCompipt.Struct.labelstr;
if not(isfield(GCompipt,[CallingLabel,'_Data']))
    if isfield(GCompipt.('Comp_File').Struct,'selectedfile')
        file = GCompipt.('Comp_File').Struct.selectedfile;
        if not(exist(file,'file'))
            err.flag = 1;
            err.msg = '(Re) Load Comp_File';
            ErrDisp(err);
            return
        else
            load(file);
            GCompipt.([CallingLabel,'_Data']).('Comp_File_Data') = saveData;
        end
    else
        err.flag = 1;
        err.msg = '(Re) Load Comp_File';
        ErrDisp(err);
        return
    end
end

%---------------------------------------------
% Get Working Structures from Sub Functions
%---------------------------------------------
CallingFunction = GCompipt.Struct.labelstr;
CTRipt = GCompipt.('CTRfunc');
if isfield(GCompipt,([CallingFunction,'_Data']))
    if isfield(GCompipt.GCompfunc_Data,('CTRfunc_Data'))
        CTRipt.CTRfunc_Data = GCompipt.GCompfunc_Data.CTRfunc_Data;
    end
end

%------------------------------------------
% CTR Function Info
%------------------------------------------
func = str2func(GComp.ctrfunc);           
[SCRPTipt,CTR,err] = func(SCRPTipt,CTRipt);
if err.flag
    return
end

%---------------------------------------------
% Return Panel Input
%---------------------------------------------
GComp.Comp = GCompipt.([CallingLabel,'_Data']).('Comp_File_Data').COMP;
GComp.CTR = CTR;

Status2('done','',2);
Status2('done','',3);