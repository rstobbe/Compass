%=========================================================
% (v1d) 
%     - ZeroFill to SubFunction
%     - FID data input
%     - auto Recon loading
%=========================================================

function [SCRPTipt,SCRPTGBL,IC,ReturnData,err] = ImConst_3DNonCart_v1d(SCRPTipt,SCRPTGBL,ICipt,FID)

Status2('busy','Get Info for Image Creation',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Defaults
%---------------------------------------------
global COMPASSINFO
LOCS = COMPASSINFO.LOCS;
trajreconloc = COMPASSINFO.USERGBL.trajreconloc;
imkernloc = LOCS.imkernloc;
invfiltloc = LOCS.invfiltloc;
CallingLabel = ICipt.Struct.labelstr;
ReturnData = struct();

%---------------------------------------------
% Load Panel Input
%---------------------------------------------
IC.method = ICipt.Func;
IC.reconfunc = ICipt.('Reconfunc').Func;
IC.dataorgfunc = ICipt.('DataOrgfunc').Func;
IC.zerofillfunc = ICipt.('ZeroFillfunc').Func;
IC.returnfovfunc = ICipt.('ReturnFovfunc').Func;
IC.zerofillfunc = ICipt.('ZeroFillfunc').Func;

%---------------------------------------------
% Test for PreSelected Recon
%---------------------------------------------
if isfield(ICipt.('Recon_File').Struct,'filename')
    PreSelTraj = ICipt.('Recon_File').Struct.filename;
else
    PreSelTraj = '';
end
    
%---------------------------------------------
% Test Recon
%---------------------------------------------
reconloaded = 0;
RWSUI = SCRPTGBL.RWSUI;
if isfield(RWSUI,'ExtRunInfo')
    ExtRunInfo = RWSUI.ExtRunInfo;
    AcqTraj = ExtRunInfo.saveData.TrajName;
    if strcmp(PreSelTraj,AcqTraj)
        if isfield(ICipt,[CallingLabel,'_Data'])
            if isfield(ICipt.([CallingLabel,'_Data']),'Recon_File_Data')
                reconloaded = 1;
            end
        end
    else
        LoadTraj = AcqTraj;
    end
else
    if isfield(FID,'DATA')
        AcqTraj = FID.DATA.TrajName;
    elseif isfield(FID,'SAMP')
        AcqTraj = FID.SAMP.ImpFile;
    end
    if strcmp(PreSelTraj,AcqTraj)
        if isfield(ICipt,[CallingLabel,'_Data'])
            if isfield(ICipt.([CallingLabel,'_Data']),'Recon_File_Data')
                reconloaded = 1;
            end
        end
    elseif isempty(PreSelTraj)
        LoadTraj = AcqTraj;
    else
        val = questdlg('Data and Recon files do not match','Select','Keep Recon','Update Recon','Exit','Keep Recon');
        if strcmp(val,'Exit') || isempty(val)
            err.flag = 4;
            err.msg = '';
            return
        elseif strcmp(val,'Update Recon')
            LoadTraj = AcqTraj;
        else
            if isfield(ICipt,[CallingLabel,'_Data'])
                if isfield(ICipt.([CallingLabel,'_Data']),'Recon_File_Data')
                    reconloaded = 1;
                end
            end
        end
    end
end

%---------------------------------------------
% Load Recon
%---------------------------------------------
if reconloaded == 0
    saveData = [];
    PanelLabel = 'Recon_File';
    Status2('busy','Load Reconstruction Data',2);
    file2load = [trajreconloc,'\',LoadTraj,'.mat'];
    if exist(file2load,'file')
        load(file2load);
        saveData.file = [LoadTraj,'.mat'];
        saveData.path = trajreconloc;
        saveData.loc = file2load;
        DropExt = 'Yes';
        saveData.label = TruncFileNameForDisp_v1(saveData.file,DropExt);
        [SCRPTipt,SCRPTGBL,err] = Recon2Panel(SCRPTipt,SCRPTGBL,CallingLabel,PanelLabel,saveData);
        ICipt.([CallingLabel,'_Data']).('Recon_File_Data') = saveData;
    else
        [file,path] = uigetfile('*.mat','Find Recon File',file2load);
        if file == 0
            err.flag = 4;
            err.msg = '';
            return
        end
        file2load = [path,file];
        load(file2load);
        saveData.file = file;
        saveData.path = path;
        saveData.loc = file2load;
        DropExt = 'Yes';
        saveData.label = TruncFileNameForDisp_v1(saveData.file,DropExt);
        [SCRPTipt,SCRPTGBL,err] = Recon2Panel(SCRPTipt,SCRPTGBL,CallingLabel,PanelLabel,saveData);
        ICipt.([CallingLabel,'_Data']).('Recon_File_Data') = saveData;
    end
end
ReturnData.('Recon_File_Data') = ICipt.([CallingLabel,'_Data']).('Recon_File_Data');

%---------------------------------------------
% Load Kernel
%---------------------------------------------
LoadAll = 0;
if not(isfield(ICipt,[CallingLabel,'_Data']))
    LoadAll = 1;
end
if LoadAll == 1 || not(isfield(ICipt.([CallingLabel,'_Data']),'Kern_File_Data'))
    Status2('busy','Load Gridding Kernel',2);
    file = [imkernloc,'Kern_KBCw2b5p5ss1p6'];
    load(file);
    saveData.path = file;
    ICipt.([CallingLabel,'_Data']).('Kern_File_Data') = saveData;
    
end
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
ZFILipt = ICipt.('ZeroFillfunc');
if isfield(ICipt,([CallingLabel,'_Data']))
    if isfield(ICipt.([CallingLabel,'_Data']),'ZeroFillfunc_Data')
        ZFILipt.('ZeroFillfunc_Data') = ICipt.([CallingLabel,'_Data']).('ZeroFillfunc_Data');
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

%---------------------------------------------
% Orientation
%---------------------------------------------
ORNT.method = 'Orient_Standard_v1b';

%------------------------------------------
% Zero Fill
%------------------------------------------
func = str2func(IC.zerofillfunc);
IMP = ICipt.([CallingLabel,'_Data']).('Recon_File_Data').IMP;
[SCRPTipt,ZFIL,err] = func(SCRPTipt,ZFILipt,IMP,GRD);
if err.flag
    return
end
if LoadAll == 1 || not(isfield(ICipt.([CallingLabel,'_Data']),'InvFilt_File_Data'))
    Status2('busy','Load Inversion Filter',2);
    file = [invfiltloc,'IF_KBCw2b5p5ss1p6zf',ZFIL.zf];
    load(file);
    saveData.path = file;
    ICipt.([CallingLabel,'_Data']).('InvFilt_File_Data') = saveData;
else
    zfloaded = ICipt.([CallingLabel,'_Data']).('InvFilt_File_Data').IFprms.ZF;
    if zfloaded ~= str2double(ZFIL.zf)
        Status2('busy','Load Inversion Filter',2);
        file = [invfiltloc,'IF_KBCw2b5p5ss1p6zf',ZFIL.zf];
        load(file);
        saveData.path = file;
        ICipt.([CallingLabel,'_Data']).('InvFilt_File_Data') = saveData; 
    end
end
ReturnData.('InvFilt_File_Data') = ICipt.([CallingLabel,'_Data']).('InvFilt_File_Data');
IC.IFprms = ICipt.([CallingLabel,'_Data']).('InvFilt_File_Data').IFprms;

%------------------------------------------
% Return
%------------------------------------------
IC.zf = ZFIL.zf;
IC.GRD = GRD;
IC.ORNT = ORNT;
IC.RFOV = RFOV;
IC.RECON = RECON;
IC.DATORG = DATORG;
IC.IMPLD = IMPLD;

Status2('done','',2);
Status2('done','',3);

