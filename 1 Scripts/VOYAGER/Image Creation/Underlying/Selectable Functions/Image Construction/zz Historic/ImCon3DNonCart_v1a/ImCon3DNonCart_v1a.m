%=========================================================
% (v1a) 
%     
%=========================================================

function [SCRPTipt,SCRPTGBL,IC,ReturnData,err] = ImCon3DNonCart_v1a(SCRPTipt,SCRPTGBL,ICipt)

Status2('busy','Get Info for Image Creation',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

IC = struct();
ReturnData = struct();
CallingLabel = ICipt.Struct.labelstr;
%---------------------------------------------
% Tests
%---------------------------------------------
LoadAll = 0;
if not(isfield(ICipt,[CallingLabel,'_Data']))
    LoadAll = 1;
end
if LoadAll == 1 || not(isfield(ICipt.([CallingLabel,'_Data']),'InvFilt_File_Data'))
    if isfield(ICipt.('InvFilt_File').Struct,'selectedfile')
        file = ICipt.('InvFilt_File').Struct.selectedfile;
        if not(exist(file,'file'))
            err.flag = 1;
            err.msg = '(Re) Load InvFilt_File';
            ErrDisp(err);
            return
        else
            Status2('busy','Load Inversion Filter Data',2);
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
IC.imploadfunc = ICipt.('ImpLoadfunc').Func;
IC.reconfunc = ICipt.('Reconfunc').Func;
IC.gridfunc = ICipt.('Gridfunc').Func;
IC.orientfunc = ICipt.('Orientfunc').Func;
IC.returnfovfunc = ICipt.('ReturnFovfunc').Func;
IC.IFprms = ICipt.([CallingLabel,'_Data']).('InvFilt_File_Data').IFprms;

%---------------------------------------------
% Get Working Structures from Sub Functions
%---------------------------------------------
IMPLDipt = ICipt.('ImpLoadfunc');
if isfield(ICipt,([CallingLabel,'_Data']))
    if isfield(ICipt.([CallingLabel,'_Data']),'ImpLoadfunc_Data')
        IMPLDipt.('ImpLoadfunc_Data') = ICipt.([CallingLabel,'_Data']).('ImpLoadfunc_Data');
    end
end
GRDipt = ICipt.('Gridfunc');
if isfield(ICipt,([CallingLabel,'_Data']))
    if isfield(ICipt.([CallingLabel,'_Data']),'Gridfunc_Data')
        GRDipt.('Gridfunc_Data') = ICipt.([CallingLabel,'_Data']).('Gridfunc_Data');
    end
end
ORNTipt = ICipt.('Orientfunc');
if isfield(ICipt,([CallingLabel,'_Data']))
    if isfield(ICipt.([CallingLabel,'_Data']),'Orientfunc_Data')
        ORNTipt.('Orientfunc_Data') = ICipt.([CallingLabel,'_Data']).('Orientfunc_Data');
    end
end
RFOVipt = ICipt.('ReturnFovfunc');
if isfield(ICipt,([CallingLabel,'_Data']))
    if isfield(ICipt.([CallingLabel,'_Data']),'ReturnFovfunc_Data')
        RFOVipt.('ReturnFovfunc_Data') = ICipt.([CallingLabel,'_Data']).('ReturnFovfunc_Data');
    end
end
RECONipt = ICipt.('Reconfunc');
if isfield(ICipt,([CallingLabel,'_Data']))
    if isfield(ICipt.([CallingLabel,'_Data']),'Reconfunc_Data')
        RECONipt.('Reconfunc_Data') = ICipt.([CallingLabel,'_Data']).('Reconfunc_Data');
    end
end

%------------------------------------------
% Get  Info
%------------------------------------------
func = str2func(IC.gridfunc);           
[SCRPTipt,GRD,GRD_Data,err] = func(SCRPTipt,GRDipt);
if err.flag
    return
end
func = str2func(IC.orientfunc);           
[SCRPTipt,ORNT,err] = func(SCRPTipt,ORNTipt);
if err.flag
    return
end
func = str2func(IC.returnfovfunc);           
[SCRPTipt,RFOV,err] = func(SCRPTipt,RFOVipt);
if err.flag
    return
end
func = str2func(IC.imploadfunc);           
[SCRPTipt,IMPLD,IMPLD_Data,err] = func(SCRPTipt,IMPLDipt);
if err.flag
    return
end
func = str2func(IC.reconfunc);           
[SCRPTipt,RECON,err] = func(SCRPTipt,RECONipt);
if err.flag
    return
end

%------------------------------------------
% Return
%------------------------------------------
ReturnData.('Gridfunc_Data') = GRD_Data;
ReturnData.('ImpLoadfunc_Data') = IMPLD_Data;
ReturnData.('InvFilt_File_Data') = ICipt.([CallingLabel,'_Data']).('InvFilt_File_Data');
IC.GRD = GRD;
IC.ORNT = ORNT;
IC.RFOV = RFOV;
IC.RECON = RECON;
IC.IMPLD = IMPLD;

Status2('done','',2);
Status2('done','',3);

