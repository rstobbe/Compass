%=========================================================
% (v1c) 
%       - Recon File
%       - Kmat array facilitate
%=========================================================

function [SCRPTipt,SCRPTGBL,err] = Grid_SDC_v1c(SCRPTipt,SCRPTGBL)

Status('busy','Grid Data with SDC');
Status2('done','',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Clear Naming
%---------------------------------------------
inds = strcmp('Grid_Name',{SCRPTipt.labelstr});
indnum = find(inds==1);
if length(indnum) > 1
    indnum = indnum(SCRPTGBL.RWSUI.scrptnum);
end
SCRPTipt(indnum).entrystr = '';
setfunc = 1;
DispScriptParam(SCRPTipt,setfunc,SCRPTGBL.RWSUI.tab,SCRPTGBL.RWSUI.panelnum);

%---------------------------------------------
% Tests
%---------------------------------------------
if not(isfield(SCRPTGBL,'Recon_File_Data'))
    if isfield(SCRPTGBL.CurrentTree.('Recon_File').Struct,'selectedfile')
        file = SCRPTGBL.CurrentTree.('Recon_File').Struct.selectedfile;
        if not(exist(file,'file'))
            err.flag = 1;
            err.msg = '(Re) Load Recon_File';
            ErrDisp(err);
            return
        else
            load(file);
            saveData.path = file;
            SCRPTGBL.('Recon_File_Data') = saveData;
        end
    else
        err.flag = 1;
        err.msg = '(Re) Load Recon_File';
        ErrDisp(err);
        return
    end
end

%---------------------------------------------
% Load Input
%---------------------------------------------
GRD.script = SCRPTGBL.CurrentTree.Func;
GRD.gridfunc = SCRPTGBL.CurrentTree.('Gridfunc').Func;
IMP = SCRPTGBL.Recon_File_Data.IMP;

%---------------------------------------------
% Get Working Structures from Sub Functions
%---------------------------------------------
GRDUipt = SCRPTGBL.CurrentTree.('Gridfunc');
if isfield(SCRPTGBL,('Gridfunc_Data'))
    GRDUipt.Gridfunc_Data = SCRPTGBL.Gridfunc_Data;
end

%------------------------------------------
% Get Gridding Function Info
%------------------------------------------
func = str2func(GRD.gridfunc);           
[SCRPTipt,GRDU,GRDU_Data,err] = func(SCRPTipt,GRDUipt);
if err.flag
    return
end
SCRPTGBL.Gridfunc_Data = GRDU_Data;

%---------------------------------------------
% Grid
%---------------------------------------------
func = str2func([GRD.script,'_Func']);
INPUT.IMP = IMP;
INPUT.GRDU = GRDU;
[GRD,err] = func(INPUT,GRD);
if err.flag
    return
end

%--------------------------------------------
% Name
%--------------------------------------------
if isfield(IMP,'name')
    name = ['GRDsdc_',IMP.name(5:end)];
else
    name = 'GRDsdc_';
end

%--------------------------------------------
% Return
%--------------------------------------------
name = inputdlg('Name Gridding:','Name',1,{name});
if isempty(name)
    SCRPTGBL.RWSUI.SaveGlobal = 'no';
    return
end
IMP.name = name{1};

SCRPTipt(indnum).entrystr = IMP.name;
SCRPTGBL.RWSUI.SaveVariables = GRD;
SCRPTGBL.RWSUI.SaveVariableNames = 'GRD';
SCRPTGBL.RWSUI.SaveGlobal = 'yes';
SCRPTGBL.RWSUI.SaveGlobalNames = IMP.name;
SCRPTGBL.RWSUI.SaveScriptOption = 'yes';
SCRPTGBL.RWSUI.SaveScriptPath = 'outloc';
SCRPTGBL.RWSUI.SaveScriptName = IMP.name;

Status('done','');
Status2('done','',2);
Status2('done','',3);

