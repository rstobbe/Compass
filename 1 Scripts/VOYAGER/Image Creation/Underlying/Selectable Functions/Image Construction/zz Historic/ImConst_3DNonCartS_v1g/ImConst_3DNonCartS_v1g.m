%=========================================================
% (v1g) 
%   - Update Call to: 'GridkSpace_LclKern_v1k'
%   - This kernel allows selection for multiple GPU code
%=========================================================

function [SCRPTipt,SCRPTGBL,IC,ReturnData,err] = ImConst_3DNonCartS_v1g(SCRPTipt,SCRPTGBL,ICipt,FID)

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
imkernloc = COMPASSINFO.USERGBL.imkernloc;
invfiltloc = COMPASSINFO.USERGBL.invfiltloc;
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
IC.kernselfunc = ICipt.('KernSlctfunc').Func;

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
    elseif strcmp(FID.DatName,'PSF')
        AcqTraj = PreSelTraj; 
    end
    if strcmp(PreSelTraj,AcqTraj)
        if isfield(ICipt,[CallingLabel,'_Data'])
            if isfield(ICipt.([CallingLabel,'_Data']),'Recon_File_Data')
                reconloaded = 1;
            else
                LoadTraj = AcqTraj;
            end
        else
            LoadTraj = AcqTraj;
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
        saveData.label = TruncFileNameForDisp_v1(saveData.loc,DropExt);
        [SCRPTipt,~,err] = Recon2Panel(SCRPTipt,SCRPTGBL,CallingLabel,PanelLabel,saveData);
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
        saveData.label = TruncFileNameForDisp_v1(saveData.loc,DropExt);
        [SCRPTipt,~,err] = Recon2Panel(SCRPTipt,SCRPTGBL,CallingLabel,PanelLabel,saveData);
        ICipt.([CallingLabel,'_Data']).('Recon_File_Data') = saveData;
    end
end
ReturnData.('Recon_File_Data') = ICipt.([CallingLabel,'_Data']).('Recon_File_Data');

%---------------------------------------------
% Get Working Structures from Sub Functions
%---------------------------------------------
RFOVipt = ICipt.('ReturnFovfunc');
if isfield(ICipt,([CallingLabel,'_Data']))
    if isfield(ICipt.([CallingLabel,'_Data']),'ReturnFovfunc_Data')
        RFOVipt.('ReturnFovfunc_Data') = ICipt.([CallingLabel,'_Data']).('ReturnFovfunc_Data');
        ReturnData.('ReturnFovfunc_Data') = ICipt.([CallingLabel,'_Data']).('ReturnFovfunc_Data');
    end
end
RECONipt = ICipt.('Reconfunc');
if isfield(ICipt,([CallingLabel,'_Data']))
    if isfield(ICipt.([CallingLabel,'_Data']),'Reconfunc_Data')
        RECONipt.('Reconfunc_Data') = ICipt.([CallingLabel,'_Data']).('Reconfunc_Data');
        ReturnData.('Reconfunc_Data') = ICipt.([CallingLabel,'_Data']).('Reconfunc_Data');
    end
end
DATORGipt = ICipt.('DataOrgfunc');
if isfield(ICipt,([CallingLabel,'_Data']))
    if isfield(ICipt.([CallingLabel,'_Data']),'DataOrgfunc_Data')
        DATORGipt.('DataOrgfunc_Data') = ICipt.([CallingLabel,'_Data']).('DataOrgfunc_Data');
        ReturnData.('DataOrgfunc_Data') = ICipt.([CallingLabel,'_Data']).('DataOrgfunc_Data');
    end
end
ZFILipt = ICipt.('ZeroFillfunc');
if isfield(ICipt,([CallingLabel,'_Data']))
    if isfield(ICipt.([CallingLabel,'_Data']),'ZeroFillfunc_Data')
        ZFILipt.('ZeroFillfunc_Data') = ICipt.([CallingLabel,'_Data']).('ZeroFillfunc_Data');
        ReturnData.('ZeroFillfunc_Data') = ICipt.([CallingLabel,'_Data']).('ZeroFillfunc_Data');
    end
end
KSLCTipt = ICipt.('KernSlctfunc');
if isfield(ICipt,([CallingLabel,'_Data']))
    if isfield(ICipt.([CallingLabel,'_Data']),'KernSlctfunc_Data')
        KSLCTipt.('KernSlctfunc_Data') = ICipt.([CallingLabel,'_Data']).('KernSlctfunc_Data');
        ReturnData.('KernSlctfunc_Data') = ICipt.([CallingLabel,'_Data']).('KernSlctfunc_Data');
    end
end

%---------------------------------------------
% Load Kernel
%---------------------------------------------
func = str2func(IC.kernselfunc);           
[SCRPTipt,KSLCT,err] = func(SCRPTipt,KSLCTipt);
if err.flag
    return
end
LoadAll = 0;
if not(isfield(ICipt,[CallingLabel,'_Data']))
    LoadAll = 1;
end
if LoadAll == 1 || not(isfield(ICipt.([CallingLabel,'_Data']),'Kern_File_Data'))
    Status2('busy','Load Gridding Kernel',2);
    file = [imkernloc,'Kern_',KSLCT.kern];
    load(file);
    saveData.path = file;
    ICipt.([CallingLabel,'_Data']).('Kern_File_Data') = saveData;   
else
    kernloaded = ICipt.([CallingLabel,'_Data']).('Kern_File_Data').KRNprms;
    if not(strcmp(kernloaded.name,['Kern_',KSLCT.kern]))
        Status2('busy','Load Gridding Kernel',2);
        file = [imkernloc,'Kern_',KSLCT.kern];
        load(file);
        saveData.path = file;
        ICipt.([CallingLabel,'_Data']).('Kern_File_Data') = saveData;
        LoadAll = 1;
    end
end
        
ReturnData.('Kern_File_Data') = ICipt.([CallingLabel,'_Data']).('Kern_File_Data');

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
GRD.method = 'GridkSpace_LclKernS_v1k';
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
    file = [invfiltloc,'IF_',KSLCT.kern,'zf',ZFIL.zf];
    load(file);
    saveData.path = file;
    ICipt.([CallingLabel,'_Data']).('InvFilt_File_Data') = saveData;
else
    zfloaded = ICipt.([CallingLabel,'_Data']).('InvFilt_File_Data').IFprms.ZF;
    if zfloaded ~= str2double(ZFIL.zf)
        Status2('busy','Load Inversion Filter',2);
        file = [invfiltloc,'IF_',KSLCT.kern,'zf',ZFIL.zf];
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
IC.ZFIL = ZFIL;
IC.GRD = GRD;
IC.ORNT = ORNT;
IC.RFOV = RFOV;
IC.RECON = RECON;
IC.DATORG = DATORG;
IC.IMPLD = IMPLD;

Status2('done','',2);
Status2('done','',3);

