%====================================================
% (v1c)
%       - start EddyCurrents_v1c
%====================================================

function [SCRPTipt,SCRPTGBL,err] = EddyCurrentsCross_v1c(SCRPTipt,SCRPTGBL)

Status('busy','Determine Gradient Eddies (RF pulse after gradient)');
Status2('done','',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Clear Naming
%---------------------------------------------
inds = strcmp('Eddy_Name',{SCRPTipt.labelstr});
indnum = find(inds==1);
if length(indnum) > 1
    indnum = indnum(SCRPTGBL.RWSUI.scrptnum);
end
SCRPTipt(indnum).entrystr = '';

%---------------------------------------------
% Get Input
%---------------------------------------------
EDDY.method = SCRPTGBL.CurrentTree.Func;
EDDY.Sys = SCRPTGBL.CurrentTree.('System');
EDDY.B0cal = str2double(SCRPTGBL.CurrentTree.('B0'));
EDDY.Gcal = str2double(SCRPTGBL.CurrentTree.('G'));
EDDY.psbgfunc = SCRPTGBL.CurrentTree.('PosBgrndfunc').Func;
EDDY.tffunc = SCRPTGBL.CurrentTree.('TransFieldfunc').Func;

%---------------------------------------------
% Get Working Structures
%---------------------------------------------
PBG1ipt = SCRPTGBL.CurrentTree.('PosBgrndfunc');
if isfield(SCRPTGBL,('PosBgrndfunc_Data'))
    PBG1ipt.PosBgrndfunc_Data = SCRPTGBL.PosBgrndfunc_Data;
end
TFipt = SCRPTGBL.CurrentTree.('TransFieldfunc');
if isfield(SCRPTGBL,('TransFieldfunc_Data'))
    TFipt.TransFieldfunc_Data = SCRPTGBL.TransFieldfunc_Data;
end

%------------------------------------------
%  Function Info
%------------------------------------------
func = str2func(EDDY.psbgfunc);           
[SCRPTipt,PBG1,err] = func(SCRPTipt,PBG1ipt);
if err.flag
    return
end
func = str2func(EDDY.tffunc);           
[SCRPTipt,TF,err] = func(SCRPTipt,TFipt);
if err.flag
    return
end

%---------------------------------------------
% Determine Eddy Currents
%---------------------------------------------
func = str2func([EDDY.method,'_Func']);
INPUT.PBG1 = PBG1;
INPUT.TF = TF;
[EDDY,err] = func(EDDY,INPUT);
if err.flag
    return
end

%--------------------------------------------
% Output to TextBox
%--------------------------------------------
set(findobj('tag','TestBox'),'string',EDDY.ExpDisp);

%--------------------------------------------
% Determine if AutoSave
%--------------------------------------------
global TOTALGBL
val = get(findobj('tag','totalgbl'),'value');
auto = 0;
if not(isempty(val)) && val ~= 0
    Gbl = TOTALGBL{2,val};
    if isfield(Gbl,'AutoRecon')
        if strcmp(Gbl.AutoSave,'yes')
            auto = 1;
            SCRPTGBL.RWSUI.SaveScript = 'yes';
            name = Gbl.SaveName;
        end
    end
end

%--------------------------------------------
% Name
%--------------------------------------------
if auto == 0;
    name = inputdlg('Name Analysis:');
    name = cell2mat(name);
    if isempty(name)
        SCRPTGBL.RWSUI.KeepEdit = 'yes';
        return
    end
end

%---------------------------------------------
% Return
%---------------------------------------------
SCRPTipt(indnum).entrystr = name;
SCRPTGBL.RWSUI.SaveVariables = {EDDY};
SCRPTGBL.RWSUI.SaveVariableNames = {'EDDY'};
SCRPTGBL.RWSUI.SaveGlobal = 'yes';
SCRPTGBL.RWSUI.SaveGlobalNames = name;
SCRPTGBL.RWSUI.SaveScriptOption = 'yes';
SCRPTGBL.RWSUI.SaveScriptPath = 'outloc';
SCRPTGBL.RWSUI.SaveScriptName = name;

Status('done','');
Status2('done','',2);
Status2('done','',3);


