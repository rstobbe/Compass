%=========================================================
% (v1c) 
%     - 'Default' version
%=========================================================

function [SCRPTipt,SCRPTGBL,IC,ReturnData,err] = ImCon3DNonCart_v1c(SCRPTipt,SCRPTGBL,ICipt)

Status2('busy','Get Info for Image Creation',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Defaults
%---------------------------------------------
global COMPASSINFO
LOCS = COMPASSINFO.LOCS;
imkernloc = LOCS.imkernloc;
invfiltloc = LOCS.invfiltloc;

%---------------------------------------------
% Load Panel Input
%---------------------------------------------
IC.method = ICipt.Func;
IC.reconfunc = ICipt.('Reconfunc').Func;
IC.dataorgfunc = ICipt.('DataOrgfunc').Func;
IC.returnfovfunc = ICipt.('ReturnFovfunc').Func;
IC.zf = ICipt.('ZeroFill');

ReturnData = struct();
CallingLabel = ICipt.Struct.labelstr;
%---------------------------------------------
% Tests
%---------------------------------------------
LoadAll = 0;
if not(isfield(ICipt,[CallingLabel,'_Data']))
    LoadAll = 1;
end
if LoadAll == 1 || not(isfield(ICipt.([CallingLabel,'_Data']),'Recon_File_Data'))
    if isfield(ICipt.('Recon_File').Struct,'selectedfile')
        file = ICipt.('Recon_File').Struct.selectedfile;
        if not(exist(file,'file'))
            err.flag = 1;
            err.msg = '(Re) Load Recon_File';
            ErrDisp(err);
            return
        else
            Status2('busy','Load Reconstruction Data',2);
            load(file);
            saveData.path = file;
            ICipt.([CallingLabel,'_Data']).('Recon_File_Data') = saveData;
        end
    else
        err.flag = 1;
        err.msg = '(Re) Load Recon_File';
        ErrDisp(err);
        return
    end
end
if LoadAll == 1 || not(isfield(ICipt.([CallingLabel,'_Data']),'Kern_File_Data'))
    Status2('busy','Load Gridding Kernel',2);
    file = [imkernloc,'Kern_KBCw2b5p5ss1p6'];
    load(file);
    saveData.path = file;
    ICipt.([CallingLabel,'_Data']).('Kern_File_Data') = saveData;
    
end
if LoadAll == 1 || not(isfield(ICipt.([CallingLabel,'_Data']),'InvFilt_File_Data'))
    Status2('busy','Load Inversion Filter',2);
    file = [invfiltloc,'IF_KBCw2b5p5ss1p6zf',IC.zf];
    load(file);
    saveData.path = file;
    ICipt.([CallingLabel,'_Data']).('InvFilt_File_Data') = saveData;
else
    zfloaded = ICipt.([CallingLabel,'_Data']).('InvFilt_File_Data').IFprms.ZF;
    if zfloaded ~= str2double(IC.zf)
        Status2('busy','Load Inversion Filter',2);
        file = [invfiltloc,'IF_KBCw2b5p5ss1p6zf',IC.zf];
        load(file);
        saveData.path = file;
        ICipt.([CallingLabel,'_Data']).('InvFilt_File_Data') = saveData; 
    end
end
ReturnData.('Recon_File_Data') = ICipt.([CallingLabel,'_Data']).('Recon_File_Data');
ReturnData.('InvFilt_File_Data') = ICipt.([CallingLabel,'_Data']).('InvFilt_File_Data');
ReturnData.('Kern_File_Data') = ICipt.([CallingLabel,'_Data']).('Kern_File_Data');

%---------------------------------------------
% Get Working Structures from Sub Functions
%---------------------------------------------
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
DATORGipt = ICipt.('DataOrgfunc');
if isfield(ICipt,([CallingLabel,'_Data']))
    if isfield(ICipt.([CallingLabel,'_Data']),'DataOrgfunc_Data')
        DATORGipt.('DataOrgfunc_Data') = ICipt.([CallingLabel,'_Data']).('DataOrgfunc_Data');
    end
end

%------------------------------------------
% Get  Info
%------------------------------------------
func = str2func(IC.returnfovfunc);           
[SCRPTipt,RFOV,err] = func(SCRPTipt,RFOVipt);
if err.flag
    return
end
func = str2func(IC.reconfunc);           
[SCRPTipt,RECON,err] = func(SCRPTipt,RECONipt);
if err.flag
    return
end
func = str2func(IC.dataorgfunc);           
[SCRPTipt,DATORG,err] = func(SCRPTipt,DATORGipt);
if err.flag
    return
end

%---------------------------------------------
% Implementation Loading
%---------------------------------------------
IMPLD.method = 'ImpLoadCombined_v1a';
IMPLD.IMP = ICipt.([CallingLabel,'_Data']).('Recon_File_Data').IMP;

%---------------------------------------------
% Gridding
%---------------------------------------------
GRD.method = 'GridkSpace_LclKern_v1j';
IC.gridfunc = GRD.method;
GRD.KRNprms = ICipt.([CallingLabel,'_Data']).('Kern_File_Data').KRNprms;
IC.IFprms = ICipt.([CallingLabel,'_Data']).('InvFilt_File_Data').IFprms;

%---------------------------------------------
% Orientation
%---------------------------------------------
ORNT.method = 'Orient_Standard_v1b';

%------------------------------------------
% Return
%------------------------------------------
IC.GRD = GRD;
IC.ORNT = ORNT;
IC.RFOV = RFOV;
IC.RECON = RECON;
IC.DATORG = DATORG;
IC.IMPLD = IMPLD;

Status2('done','',2);
Status2('done','',3);

