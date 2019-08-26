%=========================================================
% (v1a) 
%   
%=========================================================

function [SCRPTipt,SCRPTGBL,err] = Match2Images_v1a(SCRPTipt,SCRPTGBL)

Status('busy','Match 2 Images (FoV / Matrix)');
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
% Load Panel Input
%---------------------------------------------
MATCH.method = SCRPTGBL.CurrentTree.Func;
MATCH.loadfunc = SCRPTGBL.CurrentTree.('ImLoadfunc').Func;
MATCH.resizefunc = SCRPTGBL.CurrentTree.('Matchfunc').Func;
MATCH.dispfunc = SCRPTGBL.CurrentTree.('Dispfunc').Func;

%---------------------------------------------
% Get Working Structures from Sub Functions
%---------------------------------------------
LOADipt = SCRPTGBL.CurrentTree.('ImLoadfunc');
if isfield(SCRPTGBL,('ImLoadfunc_Data'))
    LOADipt.ImLoadfunc_Data = SCRPTGBL.ImLoadfunc_Data;
end
RSZipt = SCRPTGBL.CurrentTree.('Matchfunc');
if isfield(SCRPTGBL,('Matchfunc_Data'))
    RSZipt.Matchfunc_Data = SCRPTGBL.Matchfunc_Data;
end
DISPipt = SCRPTGBL.CurrentTree.('Dispfunc');
if isfield(SCRPTGBL,('Dispfunc_Data'))
    DISPipt.Dispfunc_Data = SCRPTGBL.Dispfunc_Data;
end

%------------------------------------------
% Get Function Info
%------------------------------------------
func = str2func(MATCH.loadfunc);           
[SCRPTipt,SCRPTGBL,LOAD,err] = func(SCRPTipt,SCRPTGBL,LOADipt);
if err.flag
    return
end
IMG = LOAD.IMG;
clear LOAD;
func = str2func(MATCH.resizefunc);           
[SCRPTipt,RSZ,err] = func(SCRPTipt,RSZipt);
if err.flag
    return
end
func = str2func(MATCH.dispfunc);           
[SCRPTipt,DISP,err] = func(SCRPTipt,DISPipt);
if err.flag
    return
end

%---------------------------------------------
% Match Images
%---------------------------------------------
func = str2func([MATCH.method,'_Func']);
INPUT.IMG = IMG;
INPUT.RSZ = RSZ;
INPUT.DISP = DISP;
[MATCH,err] = func(MATCH,INPUT);
if err.flag
    return
end
IMG = MATCH.IMG;

%--------------------------------------------
% Return
%--------------------------------------------
name = inputdlg('Name Image:');
if isempty(name)
    SCRPTGBL.RWSUI.SaveGlobal = 'no';
    return
end
SCRPTipt(indnum).entrystr = cell2mat(name);

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