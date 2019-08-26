%=========================================================
% (v1a) 
%      
%=========================================================

function [SCRPTipt,SCRPTGBL,err] = Test_Proj3D_v1a(SCRPTipt,SCRPTGBL)

Status('busy','Test Implementation');
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
if not(isfield(SCRPTGBL,'Imp_File_Data'))
    if isfield(SCRPTGBL.CurrentTree.('Imp_File').Struct,'selectedfile')
        file = SCRPTGBL.CurrentTree.('Imp_File').Struct.selectedfile;
        if not(exist(file,'file'))
            err.flag = 1;
            err.msg = '(Re) Load Imp_File';
            ErrDisp(err);
            return
        else
            load(file);
            SCRPTGBL.('Imp_File_Data') = saveData;
        end
    else
        err.flag = 1;
        err.msg = '(Re) Load Imp_File';
        ErrDisp(err);
        return
    end
end

%---------------------------------------------
% Get Input
%---------------------------------------------
TSTTOP.method = SCRPTGBL.CurrentScript.Func;
TSTTOP.testfunc = SCRPTGBL.CurrentTree.('Testfunc').Func;
IMP = SCRPTGBL.('Imp_File_Data').IMP;

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
% Test
%---------------------------------------------
func = str2func([TSTTOP.method,'_Func']);
INPUT.IMP = IMP;
INPUT.TST = TST;
[TSTTOP,err] = func(TSTTOP,INPUT);
if err.flag
    return
end

%--------------------------------------------
% Output to TextBox
%--------------------------------------------
global FIGOBJS
FIGOBJS.(SCRPTGBL.RWSUI.tab).Info.String = TSTTOP.ExpDisp;

%--------------------------------------------
% Return
%--------------------------------------------
name = inputdlg('Name Study:','Name',1,{['PLOT_',TSTTOP.name]});
if isempty(name)
    SCRPTGBL.RWSUI.SaveVariables = {TSTTOP};
    SCRPTGBL.RWSUI.SaveGlobal = 'no';
    return
end
TSTTOP.name = name{1};

SCRPTipt(indnum).entrystr = TSTTOP.name;
SCRPTGBL.RWSUI.SaveVariables = TSTTOP;
SCRPTGBL.RWSUI.SaveVariableNames = 'TSTTOP';
SCRPTGBL.RWSUI.SaveGlobal = 'yes';
SCRPTGBL.RWSUI.SaveGlobalNames = TSTTOP.name;
SCRPTGBL.RWSUI.SaveScriptOption = 'yes';
SCRPTGBL.RWSUI.SaveScriptPath = 'outloc';
SCRPTGBL.RWSUI.SaveScriptName = TSTTOP.name;

Status('done','');
Status2('done','',2);
Status2('done','',3);

