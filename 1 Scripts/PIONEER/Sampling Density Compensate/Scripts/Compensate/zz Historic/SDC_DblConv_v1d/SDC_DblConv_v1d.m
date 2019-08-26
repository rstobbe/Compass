%===========================================================================================
% (v1d)
%     - update for RWSUI_BA 
%===========================================================================================

function [SCRPTipt,SCRPTGBL,err] = SDC_DblConv_v1d(SCRPTipt,SCRPTGBL)

Status('busy','Compensate Sampling Density');
Status2('done','',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Tests
%---------------------------------------------
if not(isfield(SCRPTGBL,'Imp_File_Data'))
    err.flag = 1;
    err.msg = '(Re) Load Imp_File';
    ErrDisp(err);
    return
end
if not(isfield(SCRPTGBL,'Kern_File_Data'))
    file = SCRPTGBL.CurrentTree.('Kern_File').Struct.selectedfile;
    if not(exist(file,'file'))
        err.flag = 1;
        err.msg = '(Re) Load Kern_File';
        ErrDisp(err);
        return
    else
        load(file);
        saveData.path = file;
        SCRPTGBL.('Kern_File_Data') = saveData;
    end
end

%---------------------------------------------
% Load Input
%---------------------------------------------
SDCS = struct();
SDCS.method = SCRPTGBL.CurrentTree.Func;
SDCS.Name = SCRPTGBL.CurrentTree.('SDC_Name');
SDCS.ImpFile = SCRPTGBL.CurrentTree.('Imp_File').Struct.selectedfile;
SDCS.compkmaxsel = SCRPTGBL.CurrentTree.('Comp_kmax');
SDCS.SubSamp = str2double(SCRPTGBL.CurrentTree.('SubSamp'));
SDCS.KernFile = SCRPTGBL.CurrentTree.('Kern_File').Struct.selectedfile;
SDCS.TFfunc = SCRPTGBL.CurrentTree.('TFfunc').Func;
SDCS.CTFfunc = SCRPTGBL.CurrentTree.('CTFVatSPfunc').Func;
SDCS.InitialEstfunc = SCRPTGBL.CurrentTree.('InitialEstfunc').Func;
SDCS.Iteratefunc = SCRPTGBL.CurrentTree.('Iteratefunc').Func;

PROJdgn = SCRPTGBL.Imp_File_Data.IMP.PROJdgn;
PROJimp = SCRPTGBL.Imp_File_Data.IMP.PROJimp;
Kmat = SCRPTGBL.Imp_File_Data.IMP.Kmat;
KRNprms = SCRPTGBL.Kern_File_Data.KRNprms;

%--------------------------------------
% PROJdgn to be removed...
%--------------------------------------
if not(isfield(PROJimp,'kstep'))
    PROJimp.kstep = PROJdgn.kstep;
end
if not(isfield(PROJimp,'elip'))
    PROJimp.elip = PROJdgn.elip;
end

%--------------------------------------
% Tests
%--------------------------------------
if rem(round(1e9*(1/(KRNprms.DblKern.res*SDCS.SubSamp)))/1e9,1)
    err.flag = 1;
    err.msg = '1/(KernRes*SS) not an integer';
    return
end

%--------------------------------------
% Select Max Value for SDC
%--------------------------------------
if strcmp(SDCS.compkmaxsel,'Design')
    SDCS.compkmax = PROJdgn.kmax;
elseif strcmp(SDCS.compkmaxsel,'Implementation')
    SDCS.compkmax = PROJimp.meanrelkmax*PROJdgn.kmax;
end
    
%--------------------------------------
% Load Desired Output Transfer Function
%--------------------------------------
Status('busy','Load Desired Output Transfer Function');
Status2('busy','',2);
Status2('busy','',3);
func = str2func(SDCS.TFfunc);
[TF,SDCS,err] = func(PROJdgn,SDCS,SCRPTipt);
for n = 1:length(err)
    if err(n).flag == 1
        return
    end
end

%--------------------------------------
% Initial Estimate
%--------------------------------------
Status('busy','Initial Estimate');
Status2('busy','',2);
Status2('busy','',3);
func = str2func(SDCS.InitialEstfunc);
[iSDC,SDCS,SCRPTipt,err] = func(Kmat,PROJdgn,PROJimp,SDCS,SCRPTipt,SCRPTGBL,err);
for n = 1:length(err)
    if err(n).flag == 1
        return
    end
end

%--------------------------------------
% Determine Convolved Transfer Function Values at Sampling Points
%--------------------------------------
Status('busy','Determine Convolved Transfer Function Values at Samp');
Status2('busy','',2);
Status2('busy','',3);
func = str2func(SDCS.CTFfunc);
[DOV,SDCS,SCRPTipt,err] = func(Kmat,PROJimp,TF,KRNprms,SDCS,SCRPTipt,SCRPTGBL,err);
for n = 1:length(err)
    if err(n).flag == 1
        return
    end
end

%--------------------------------------
% Sampling Density Compensate
%--------------------------------------
Status('busy','Perform SDC Iterations');
Status2('busy','',2);
Status2('busy','',3);
func = str2func(SDCS.Iteratefunc); 
[SDCarr,SDCS,SCRPTipt,err] = func(Kmat,PROJimp,iSDC,DOV,KRNprms,SDCS,SCRPTipt,err);
for n = 1:length(err)
    if err(n).flag == 1
        return
    end
end

%--------------------------------------------
% Display
%--------------------------------------------
%SCRPTGBL.RWSUI.LocalOutput(1).label = 'Ksz';
%SCRPTGBL.RWSUI.LocalOutput(1).value = num2str(Ksz);

%--------------------------------------------
% Output
%--------------------------------------------
SDC.SDC = SDCarr;
SDC.SDCS = SDCS;
SDC.DOV = DOV;

%--------------------------------------------
% Return
%--------------------------------------------
name = inputdlg('Name SDC:');
if isempty(name)
    SCRPTGBL.RWSUI.SaveGlobal = 'no';
    return
end
SCRPTipt(strcmp('SDC_Name',{SCRPTipt.labelstr})).entrystr = cell2mat(name);

SCRPTGBL.RWSUI.SaveVariables = {SDC};
SCRPTGBL.RWSUI.SaveVariableNames = 'SDC';

SCRPTGBL.RWSUI.SaveGlobal = 'yes';
SCRPTGBL.RWSUI.SaveGlobalNames = name;
SCRPTGBL.RWSUI.SaveScriptOption = 'yes';
SCRPTGBL.RWSUI.SaveScriptPath = 'outloc';
SCRPTGBL.RWSUI.SaveScriptName = 'SDC';

Status('done','');
Status2('done','',2);
Status2('done','',3);


