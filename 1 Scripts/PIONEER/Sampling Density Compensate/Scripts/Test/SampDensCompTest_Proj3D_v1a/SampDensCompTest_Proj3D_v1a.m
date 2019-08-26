%=========================================================
% (v1a) 
%      
%=========================================================

function [SCRPTipt,SCRPTGBL,err] = SampDensCompTest_Proj3D_v1a(SCRPTipt,SCRPTGBL)

Status('busy','SampDensComp Test');
Status2('done','',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Clear Naming
%---------------------------------------------
inds = strcmp('Test_Name',{SCRPTipt.labelstr});
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
if not(isfield(SCRPTGBL,'SDC_File_Data'))
    if isfield(SCRPTGBL.CurrentTree.('SDC_File').Struct,'selectedfile')
    file = SCRPTGBL.CurrentTree.('SDC_File').Struct.selectedfile;
        if not(exist(file,'file'))
            SCRPTGBL.('SDC_File_Data').SDCS = [];
        else
            Status('busy','Load Sampling Density Compensation');
            load(file);
            saveData.path = file;
            SCRPTGBL.('SDC_File_Data') = saveData;
        end
    else
        SCRPTGBL.('SDC_File_Data').SDCS = [];
    end
end

%---------------------------------------------
% Get Input
%---------------------------------------------
TSTTOP.method = SCRPTGBL.CurrentScript.Func;
TSTTOP.testfunc = SCRPTGBL.CurrentTree.('Testfunc').Func;
SDCS = SCRPTGBL.SDC_File_Data.SDCS;

%---------------------------------------------
% Get Working Structures from Sub Functions
%---------------------------------------------
TSTipt = SCRPTGBL.CurrentTree.('Testfunc');
if isfield(SCRPTGBL,('Testfunc_Data'))
    TSTipt.Testfunc_Data = SCRPTGBL.Testfunc_Data;
end

%------------------------------------------
% Get TST Function Info
%------------------------------------------
func = str2func(TSTTOP.testfunc);           
[SCRPTipt,TST,err] = func(SCRPTipt,TSTipt);
if err.flag
    return
end

%---------------------------------------------
% TSTulate
%---------------------------------------------
func = str2func([TSTTOP.method,'_Func']);
INPUT.SDCS = SDCS;
INPUT.TST = TST;
[TSTTOP,err] = func(TSTTOP,INPUT);
if err.flag
    return
end

TST = TSTTOP;

%---------------------------------------------
% Panel Output
%--------------------------------------------- 
%IMG.ExpDisp = PanelStruct2Text(IMG.PanelOutput);
%global FIGOBJS
%FIGOBJS.(SCRPTGBL.RWSUI.tab).Info.String = IMG.ExpDisp;

%--------------------------------------------
% Name
%--------------------------------------------
name0 = '';
if isfield(DES,'name')
    name0 = DES.name(5:end);
end
name = inputdlg('Name Test:','Name Test',1,{['Test_',name0]});
name = cell2mat(name);
if isempty(name)
    SCRPTGBL.RWSUI.SaveVariables = {TST};
    SCRPTGBL.RWSUI.KeepEdit = 'yes';
    return
end
TST.name = name;
TST.path = DES.path;
TST.type = 'Data';   
TST.structname = 'TST';

%---------------------------------------------
% Return
%---------------------------------------------
SCRPTipt(indnum).entrystr = name;
SCRPTGBL.RWSUI.SaveVariables = TST;
SCRPTGBL.RWSUI.SaveVariableNames = 'TST';
SCRPTGBL.RWSUI.SaveGlobal = 'yes';
SCRPTGBL.RWSUI.SaveGlobalNames = name;
SCRPTGBL.RWSUI.SaveScriptOption = 'yes';
SCRPTGBL.RWSUI.SaveScriptPath = TST.path;
SCRPTGBL.RWSUI.SaveScriptName = name;

Status('done','');
Status2('done','',2);
Status2('done','',3);


