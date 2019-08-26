%====================================================
% (v1c)
%       - calculate and return Nproj
%       - use p & nproj from SPIN function (if calculated)
%====================================================

function [SCRPTipt,SCRPTGBL,err] = YarnBall_v1c(SCRPTipt,SCRPTGBL)

Status('busy','Create Design');
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
% Describe Trajectory
%---------------------------------------------
DES.type = 'YB';

%---------------------------------------------
% Load Input
%---------------------------------------------
DES.method = SCRPTGBL.CurrentTree.Func;
DES.fov = str2double(SCRPTGBL.CurrentTree.FoV);
DES.vox = str2double(SCRPTGBL.CurrentTree.Vox);
DES.tro = str2double(SCRPTGBL.CurrentTree.Tro);
DES.nproj = str2double(SCRPTGBL.CurrentTree.Nproj);
DES.elipfunc = SCRPTGBL.CurrentTree.Elipfunc.Func;
DES.spinfunc = SCRPTGBL.CurrentTree.Spinfunc.Func;
DES.desoltimfunc = SCRPTGBL.CurrentTree.DeSolTimfunc.Func;
DES.accconstfunc = SCRPTGBL.CurrentTree.ConstEvolfunc.Func;

%---------------------------------------------
% Get Working Structures from Sub Functions
%---------------------------------------------
ELIPipt = SCRPTGBL.CurrentTree.('Elipfunc');
if isfield(SCRPTGBL,('Elipfunc_Data'))
    ELIPipt.Elipfunc_Data = SCRPTGBL.Elipfunc_Data;
end
SPINipt = SCRPTGBL.CurrentTree.('Spinfunc');
if isfield(SCRPTGBL,('Spinfunc_Data'))
    SPINipt.Spinfunc_Data = SCRPTGBL.Spinfunc_Data;
end
DESOLipt = SCRPTGBL.CurrentTree.('DeSolTimfunc');
if isfield(SCRPTGBL,('DeSolTimfunc_Data'))
    DESOLipt.DeSolTimfunc_Data = SCRPTGBL.DeSolTimfunc_Data;
end
CACCipt = SCRPTGBL.CurrentTree.('ConstEvolfunc');
if isfield(SCRPTGBL,('ConstEvolfunc_Data'))
    CACCipt.ConstEvolfunc_Data = SCRPTGBL.ConstEvolfunc_Data;
end

%------------------------------------------
% Get Elip Function Info
%------------------------------------------
func = str2func(DES.elipfunc);           
[SCRPTipt,ELIP,err] = func(SCRPTipt,ELIPipt);
if err.flag
    return
end

%------------------------------------------
% Get Spinning Function Info
%------------------------------------------
func = str2func(DES.spinfunc);           
[SCRPTipt,SPIN,err] = func(SCRPTipt,SPINipt);
if err.flag
    return
end

%------------------------------------------
% Get DE Solution Timing Function Info
%------------------------------------------
func = str2func(DES.desoltimfunc);           
[SCRPTipt,DESOL,err] = func(SCRPTipt,DESOLipt);
if err.flag
    return
end

%------------------------------------------
% Get Acceleration Constraint Info
%------------------------------------------
func = str2func(DES.accconstfunc);           
[SCRPTipt,CACC,err] = func(SCRPTipt,CACCipt);
if err.flag
    return
end

%---------------------------------------------
% Generate YarnBall Design
%---------------------------------------------
func = str2func([DES.method,'_Func']);
INPUT.ELIP = ELIP;
INPUT.SPIN = SPIN;
INPUT.DESOL = DESOL;
INPUT.CACC = CACC;
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
DES.ExpDisp = [char(10) DES.ExpDisp];
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

SCRPTipt(indnum).entrystr = name;
SCRPTGBL.RWSUI.SaveVariables = {DES};
SCRPTGBL.RWSUI.SaveVariableNames = {'DES'};
SCRPTGBL.RWSUI.SaveGlobal = 'yes';
SCRPTGBL.RWSUI.SaveGlobalNames = name;
SCRPTGBL.RWSUI.SaveScriptOption = 'yes';
SCRPTGBL.RWSUI.SaveScriptPath = 'outloc';
SCRPTGBL.RWSUI.SaveScriptName = name;

Status('done','');
Status2('done','',2);
Status2('done','',3);

