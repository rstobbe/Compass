%====================================================
% (v1b)
%    - change 'Rearrange' to 'Proc' 
%====================================================

function [SCRPTipt,SCRPTGBL,err] = FidPreload_v1b(SCRPTipt,SCRPTGBL)

Status('busy','Create Image');
Status2('done','',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Clear Naming
%---------------------------------------------
inds = strcmp('Image_Name',{SCRPTipt.labelstr});
indnum = find(inds==1);
if length(indnum) > 1
    indnum = indnum(SCRPTGBL.RWSUI.scrptnum);
end
SCRPTipt(indnum).entrystr = '';
setfunc = 1;
DispScriptParam(SCRPTipt,setfunc,SCRPTGBL.RWSUI.tab,SCRPTGBL.RWSUI.panelnum);
SCRPTipt0 = SCRPTipt;

%---------------------------------------------
% Load Input
%---------------------------------------------
PLFID.method = SCRPTGBL.CurrentTree.Func;
PLFID.fidloadfunc = SCRPTGBL.CurrentTree.('FidLoadfunc').Func;
PLFID.fidprocfunc = SCRPTGBL.CurrentTree.('FidProcessfunc').Func;

%---------------------------------------------
% Get Working Structures from Sub Functions
%---------------------------------------------
FIDipt = SCRPTGBL.CurrentTree.('FidLoadfunc');
if isfield(SCRPTGBL,('FidLoadfunc_Data'))
    FIDipt.FidLoadfunc_Data = SCRPTGBL.FidLoadfunc_Data;
end
FIDPipt = SCRPTGBL.CurrentTree.('FidProcessfunc');
if isfield(SCRPTGBL,('FidProcessfunc_Data'))
    FIDPipt.FidProcessfunc_Data = SCRPTGBL.FidProcessfunc_Data;
end

%------------------------------------------
% Get Function Info
%------------------------------------------
func = str2func(PLFID.fidloadfunc); 
[SCRPTipt,SCRPTGBL,FID,err] = func(SCRPTipt,SCRPTGBL,FIDipt);
if err.flag
    return
end
func = str2func(PLFID.fidprocfunc);           
[SCRPTipt,FIDP,err] = func(SCRPTipt,FIDPipt);
if err.flag
    return
end

%---------------------------------------------
% PreLoad Fid
%---------------------------------------------
func = str2func([PLFID.method,'_Func']);
INPUT.FID = FID;
INPUT.FIDP = FIDP;
[PLFID,err] = func(INPUT,PLFID);
if err.flag
    return
end

%--------------------------------------------
% Output to TextBox
%--------------------------------------------
PLFID.ExpDisp = PanelStruct2Text(PLFID.PanelOutput);
global FIGOBJS
FIGOBJS.(SCRPTGBL.RWSUI.tab).Info.String = PLFID.ExpDisp;

%--------------------------------------------
% Determine if AutoSave
%--------------------------------------------
auto = 0;
RWSUI = SCRPTGBL.RWSUI;
if isfield(RWSUI,'ExtRunInfo')
    auto = 1;
    if strcmp(RWSUI.ExtRunInfo.save,'no')
        SCRPTGBL.RWSUI.SaveScript = 'no';
        SCRPTGBL.RWSUI.SaveGlobal = 'no';
    elseif strcmp(RWSUI.ExtRunInfo.save,'all')
        SCRPTGBL.RWSUI.SaveScript = 'yes';
        SCRPTGBL.RWSUI.SaveGlobal = 'yes';
    elseif strcmp(RWSUI.ExtRunInfo.save,'global')
        SCRPTGBL.RWSUI.SaveScript = 'no';
        SCRPTGBL.RWSUI.SaveGlobal = 'yes';
    end
    name = ['PLFID_',RWSUI.ExtRunInfo.name];
else
    SCRPTGBL.RWSUI.SaveScriptOption = 'yes';
    SCRPTGBL.RWSUI.SaveGlobal = 'yes';
end

%--------------------------------------------
% Name
%--------------------------------------------
if auto == 0
    if isfield(FID,'DATA')
        name = inputdlg('Name Image:','Name Image',1,{['PLFID_',FID.DATA.VolunteerID,'_',FID.DATA.Protocol]});
    elseif isfield(FID,'SAMP')
        name = inputdlg('Name Image:','Name Image',1,{['PLFID_',FID.SAMP.OB.name]});
    else
        name = inputdlg('Name Image:','Name Image',1,{['PLFID_',FID.DatName]});
    end
    name = cell2mat(name);
    if isempty(name)
        SCRPTipt = SCRPTipt0;
        setfunc = 1;
        DispScriptParam(SCRPTipt,setfunc,SCRPTGBL.RWSUI.tab,SCRPTGBL.RWSUI.panelnum);
        SCRPTGBL.RWSUI.SaveVariables = {PLFID};
        SCRPTGBL.RWSUI.KeepEdit = 'yes';
        return
    end
end
PLFID.name = name;
PLFID.path = PLFID.path;
PLFID.type = 'Fid';   

%---------------------------------------------
% Return
%---------------------------------------------
SCRPTipt(indnum).entrystr = name;
SCRPTGBL.RWSUI.SaveVariables = {PLFID};
SCRPTGBL.RWSUI.SaveVariableNames = {'PLFID'};
SCRPTGBL.RWSUI.SaveGlobalNames = name;
SCRPTGBL.RWSUI.SaveScriptPath = PLFID.path;
SCRPTGBL.RWSUI.SaveScriptName = [name,'.mat'];

Status('done','');
Status2('done','',2);
Status2('done','',3);
