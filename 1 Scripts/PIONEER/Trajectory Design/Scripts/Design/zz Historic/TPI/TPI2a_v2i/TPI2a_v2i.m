%====================================================
% (TPI2)
%       - 'iseg' is selector
% (a)
%       - no k-space overshoot for spiral effect
% (v2i)
%       - function calling update (match other)
%====================================================

function [SCRPTipt,SCRPTGBL,err] = TPI2a_v2i(SCRPTipt,SCRPTGBL)

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
DES.type = 'TPI2a';

%---------------------------------------------
% Load Input
%---------------------------------------------
DES.method = SCRPTGBL.CurrentTree.Func;
DES.fov = str2double(SCRPTGBL.CurrentTree.FoV);
DES.vox = str2double(SCRPTGBL.CurrentTree.Vox);
DES.tro = str2double(SCRPTGBL.CurrentTree.Tro);
DES.nproj = str2double(SCRPTGBL.CurrentTree.Nproj);
DES.iseg = str2double(SCRPTGBL.CurrentTree.iSeg);
DES.elip = str2double(SCRPTGBL.CurrentTree.Elip);
DES.gamfunc = SCRPTGBL.CurrentTree.Gamfunc.Func;

%---------------------------------------------
% Get Working Structures from Sub Functions
%---------------------------------------------
GAMFUNCipt = SCRPTGBL.CurrentTree.('Gamfunc');
if isfield(SCRPTGBL,('Gamfunc_Data'))
    GAMFUNCipt.Gamfunc_Data = SCRPTGBL.Gamfunc_Data;
end

%------------------------------------------
% Get Gamma Function Info
%------------------------------------------
func = str2func(DES.gamfunc);           
[SCRPTipt,GAMFUNC,err] = func(SCRPTipt,GAMFUNCipt);
if err.flag
    return
end

%---------------------------------------------
% Generate TPI Design parameters
%---------------------------------------------
func = str2func([DES.method,'_Func']);
DES.GAMFUNC = GAMFUNC;                      % should be how goes rather than in 'input'
INPUT = struct();
[DES,err] = func(INPUT,DES);
if err.flag
    return
end

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
svox = num2str((PROJdgn.vox^3)/PROJdgn.elip,'%3.0f');
selip = num2str(100*PROJdgn.elip,'%03.0f');
stro = num2str(PROJdgn.tro,'%02.0f');
snproj = num2str(PROJdgn.nproj/100,'%03.0f');
srsnr = num2str(PROJdgn.rSNR,'%3.0f');
name = ['DES_F',sfov,'_V',svox,'_E',selip,'_T',stro,'_N',snproj,'_S',srsnr];

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

