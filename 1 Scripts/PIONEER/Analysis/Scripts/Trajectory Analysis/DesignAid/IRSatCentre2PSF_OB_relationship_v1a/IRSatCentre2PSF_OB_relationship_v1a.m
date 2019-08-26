%=====================================================
% (v1a) 
%        
%=====================================================

function [SCRPTipt,SCRPTGBL,err] = IRSatCentre2PSF_OB_relationship_v1a(SCRPTipt,SCRPTGBL)

Status('busy','IRS 2PSF @ Centre - Object Relationship');
Status2('done','',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Clear Naming
%---------------------------------------------
inds = strcmp('Analysis_Name',{SCRPTipt.labelstr});
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
if not(isfield(SCRPTGBL,'PSFob_File_Data'))
    if isfield(SCRPTGBL.CurrentTree.('PSFob_File').Struct,'selectedfile')
    file = SCRPTGBL.CurrentTree.('PSFob_File').Struct.selectedfile;
        if not(exist(file,'file'))
            err.flag = 1;
            err.msg = '(Re) Load PSFob_File - path no longer valid';
            ErrDisp(err);
            return
        else
            Status('busy','Load PSFob_File');
            load(file);
            saveData.path = file;
            SCRPTGBL.('PSFob_File_Data') = saveData;
        end
    else
        err.flag = 1;
        err.msg = '(Re) Load PSFob_File';
        ErrDisp(err);
        return
    end
end
if not(isfield(SCRPTGBL,'PSFbg_File_Data'))
    if isfield(SCRPTGBL.CurrentTree.('PSFbg_File').Struct,'selectedfile')
    file = SCRPTGBL.CurrentTree.('PSFbg_File').Struct.selectedfile;
        if not(exist(file,'file'))
            err.flag = 1;
            err.msg = '(Re) Load PSFbg_File - path no longer valid';
            ErrDisp(err);
            return
        else
            Status('busy','Load PSFbg_File');
            load(file);
            saveData.path = file;
            SCRPTGBL.('PSFbg_File_Data') = saveData;
        end
    else
        err.flag = 1;
        err.msg = '(Re) Load PSFbg_File';
        ErrDisp(err);
        return
    end
end


%---------------------------------------------
% Get Input
%---------------------------------------------
ANLZ.method = SCRPTGBL.CurrentTree.Func;
ANLZ.zf = str2double(SCRPTGBL.CurrentTree.('ZeroFill'));
ANLZ.objectfunc = SCRPTGBL.CurrentTree.('OBfunc').Func; 

%---------------------------------------------
% Load Implementation and Kernel
%---------------------------------------------
PSFob = SCRPTGBL.PSFob_File_Data.PSF;
PSFbg = SCRPTGBL.PSFbg_File_Data.PSF;

%---------------------------------------------
% Get Working Structures from Sub Functions
%---------------------------------------------
OBipt = SCRPTGBL.CurrentTree.('OBfunc');
if isfield(SCRPTGBL,('OBfunc_Data'))
    OBipt.Objectfunc_Data = SCRPTGBL.Objectfunc_Data;
end

%------------------------------------------
% Get Function Info
%------------------------------------------
func = str2func(ANLZ.objectfunc);           
[SCRPTipt,OB,err] = func(SCRPTipt,OBipt);
if err.flag
    return
end

%---------------------------------------------
% Perform Analysis
%---------------------------------------------
func = str2func([ANLZ.method,'_Func']);
INPUT.PSFob = PSFob;
INPUT.PSFbg = PSFbg;
INPUT.OB = OB;
[ANLZ,err] = func(ANLZ,INPUT);
if err.flag
    return
end
clear INPUT;

%--------------------------------------------
% Output to TextBox
%--------------------------------------------
global FIGOBJS
FIGOBJS.(SCRPTGBL.RWSUI.tab).Info.String = ANLZ.ExpDisp;

%--------------------------------------------
% Name
%--------------------------------------------
name = 'OBarr_';

%--------------------------------------------
% Return
%--------------------------------------------
name = inputdlg('Name Analysis:','Name',1,{name});
if isempty(name)
    SCRPTGBL.RWSUI.SaveGlobal = 'no';
    return
end
ANLZ.name = name{1};
ANLZ.structname = 'ANLZ';

SCRPTipt(indnum).entrystr = name;
SCRPTGBL.RWSUI.SaveVariables = {ANLZ};
SCRPTGBL.RWSUI.SaveVariableNames = {'ANLZ'};
SCRPTGBL.RWSUI.SaveGlobal = 'yes';
SCRPTGBL.RWSUI.SaveGlobalNames = name;
SCRPTGBL.RWSUI.SaveScriptOption = 'yes';
SCRPTGBL.RWSUI.SaveScriptPath = 'outloc';
SCRPTGBL.RWSUI.SaveScriptName = name;

Status('done','');
Status2('done','',2);
Status2('done','',3);
