%===========================================
% (v1a)
%    
%===========================================

function [SCRPTipt,SCRPTGBL,err] = ConcMapping_v1a(SCRPTipt,SCRPTGBL)

Status('busy','Map Concentration');
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
DispScriptParam_B9(SCRPTipt,setfunc,SCRPTGBL.RWSUI.panel);

%---------------------------------------------
% Get Panel Input
%---------------------------------------------
CMAP.method = SCRPTGBL.CurrentTree.Func;
CMAP.loadfunc = SCRPTGBL.CurrentTree.('ImLoadfunc').Func;
CMAP.mapfunc = SCRPTGBL.CurrentTree.('ConcMapfunc').Func;
CMAP.dispfunc = SCRPTGBL.CurrentTree.('Dispfunc').Func;

%---------------------------------------------
% Get Working Structures from Sub Functions
%---------------------------------------------
LOADipt = SCRPTGBL.CurrentTree.('ImLoadfunc');
if isfield(SCRPTGBL,('ImLoadfunc_Data'))
    LOADipt.ImLoadfunc_Data = SCRPTGBL.ImLoadfunc_Data;
end
MAPipt = SCRPTGBL.CurrentTree.('ConcMapfunc');
if isfield(SCRPTGBL,('ConcMapfunc_Data'))
    MAPipt.ConcMapfunc_Data = SCRPTGBL.ConcMapfunc_Data;
end
DISPipt = SCRPTGBL.CurrentTree.('Dispfunc');
if isfield(SCRPTGBL,('Dispfunc_Data'))
    DISPipt.Dispfunc_Data = SCRPTGBL.Dispfunc_Data;
end

%------------------------------------------
% Get  Function Info
%------------------------------------------
func = str2func(CMAP.loadfunc);           
[SCRPTipt,SCRPTGBL,LOAD,err] = func(SCRPTipt,SCRPTGBL,LOADipt);
if err.flag
    return
end
IMG = LOAD.IMG;
clear LOAD;
func = str2func(CMAP.mapfunc);           
[SCRPTipt,MAP,err] = func(SCRPTipt,MAPipt);
if err.flag
    return
end
func = str2func(CMAP.dispfunc);           
[SCRPTipt,DISP,err] = func(SCRPTipt,DISPipt);
if err.flag
    return
end

%---------------------------------------------
% B0 Map
%---------------------------------------------
func = str2func([CMAP.method,'_Func']);
INPUT.IMG = IMG;
INPUT.MAP = MAP;
INPUT.DISP = DISP;
[CMAP,err] = func(CMAP,INPUT);
if err.flag
    return
end
IMG = CMAP.IMG;

%--------------------------------------------
% Output to TextBox
%--------------------------------------------
set(findobj('tag','TestBox'),'string',IMG.ExpDisp);

%--------------------------------------------
% Name
%--------------------------------------------
name0 = 'CMAP_';
name = inputdlg('Name Image:','Name Image',1,{name0});
    name = cell2mat(name);
    if isempty(name)
        SCRPTGBL.RWSUI.KeepEdit = 'yes';
        return
    end
IMG.name = name;

%--------------------------------------------
% Return
%--------------------------------------------
SCRPTipt(indnum).entrystr = name;
SCRPTGBL.RWSUI.SaveVariables = {IMG};
SCRPTGBL.RWSUI.SaveVariableNames = 'IMG';
SCRPTGBL.RWSUI.SaveGlobal = 'yes';
SCRPTGBL.RWSUI.SaveGlobalNames = name;
SCRPTGBL.RWSUI.SaveScriptOption = 'yes';
SCRPTGBL.RWSUI.SaveScriptPath = 'outloc';
SCRPTGBL.RWSUI.SaveScriptName = name;

Status('done','');
Status2('done','',2);
Status2('done','',3);

