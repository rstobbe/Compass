%====================================================
% (v1a)
%      
%====================================================

function [SCRPTipt,SCRPTGBL,err] = Design_Proj3D_v1a(SCRPTipt,SCRPTGBL)

Status('busy','Create Proj3D Design');
Status2('done','',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Clear Naming
%---------------------------------------------
inds = strcmp('Design_Name',{SCRPTipt.labelstr});
indnum = find(inds==1);
if length(indnum) > 1
    indnum = indnum(SCRPTGBL.RWSUI.scrptnum);
end
SCRPTipt(indnum).entrystr = '';
setfunc = 1;
DispScriptParam(SCRPTipt,setfunc,SCRPTGBL.RWSUI.tab,SCRPTGBL.RWSUI.panelnum);

%---------------------------------------------
% Load Input
%---------------------------------------------
DES.method = SCRPTGBL.CurrentTree.Func;
DES.fov = str2double(SCRPTGBL.CurrentTree.FoV);
DES.vox = str2double(SCRPTGBL.CurrentTree.Vox);
DES.tro = str2double(SCRPTGBL.CurrentTree.Tro);
DES.nproj = str2double(SCRPTGBL.CurrentTree.Nproj);
DES.desmethfunc = SCRPTGBL.CurrentTree.('DesMethfunc').Func;

%---------------------------------------------
% Get Working Structures from Sub Functions
%---------------------------------------------
DESMETHipt = SCRPTGBL.CurrentTree.('DesMethfunc');
if isfield(SCRPTGBL,('DesMethfunc_Data'))
    DESMETHipt.DesMethfunc_Data = SCRPTGBL.DesMethfunc_Data;
end

%------------------------------------------
% Get DesMeth Function Info
%------------------------------------------
func = str2func(DES.desmethfunc);           
[SCRPTipt,DESMETH,err] = func(SCRPTipt,DESMETHipt);
if err.flag
    return
end

%---------------------------------------------
% Generate Proj3D Design
%---------------------------------------------
func = str2func([DES.method,'_Func']);
INPUT.DESMETH = DESMETH;
[DES,err] = func(INPUT,DES);
if err.flag
    return
end

%---------------------------------------------
% Update
%---------------------------------------------
SCRPTipt(find(strcmp('Nproj',{SCRPTipt.labelstr})==1)).entrystr = num2str(DES.PROJdgn.nproj);
setfunc = 1;
DispScriptParam(SCRPTipt,setfunc,SCRPTGBL.RWSUI.tab,SCRPTGBL.RWSUI.panelnum);

%--------------------------------------------
% Output to TextBox
%--------------------------------------------
DES.ExpDisp = PanelStruct2Text(DES.PanelOutput);
DES.ExpDisp = [newline DES.ExpDisp];
global FIGOBJS
FIGOBJS.(SCRPTGBL.RWSUI.tab).Info.String = DES.ExpDisp;

%--------------------------------------------
% Name
%--------------------------------------------
PROJdgn = DES.PROJdgn;
sfov = num2str(PROJdgn.fov,'%03.0f');
svox = num2str(10*(PROJdgn.vox^3)/PROJdgn.elip,'%04.0f');
selip = num2str(100*PROJdgn.elip,'%03.0f');
stro = num2str(10*PROJdgn.tro,'%03.0f');
snproj = num2str(PROJdgn.nproj,'%4.0f');
name = ['DES_F',sfov,'_V',svox,'_E',selip,'_T',stro,'_N',snproj,'_S',DES.SPIN.name];

%--------------------------------------------
% Return
%--------------------------------------------
name = inputdlg('Name Design:','Name',1,{name});
if isempty(name)
    SCRPTGBL.RWSUI.SaveVariables = {DES};
    SCRPTGBL.RWSUI.SaveGlobal = 'no';
    return
end
DES.name = name{1};

SCRPTipt(indnum).entrystr = DES.name;
SCRPTGBL.RWSUI.SaveVariables = DES;
SCRPTGBL.RWSUI.SaveVariableNames = 'DES';
SCRPTGBL.RWSUI.SaveGlobal = 'yes';
SCRPTGBL.RWSUI.SaveGlobalNames = DES.name;
SCRPTGBL.RWSUI.SaveScriptOption = 'yes';
SCRPTGBL.RWSUI.SaveScriptPath = 'outloc';
SCRPTGBL.RWSUI.SaveScriptName = DES.name;

Status('done','');
Status2('done','',2);
Status2('done','',3);

