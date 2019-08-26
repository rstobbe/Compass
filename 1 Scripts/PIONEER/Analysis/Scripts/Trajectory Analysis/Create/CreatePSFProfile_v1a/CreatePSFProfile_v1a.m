%=====================================================
% (v1a) 
%        
%=====================================================

function [SCRPTipt,SCRPTGBL,err] = CreatePSF_v1a(SCRPTipt,SCRPTGBL)

Status('busy','Plot PSF');
Status2('done','',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Clear Naming
%---------------------------------------------
inds = strcmp('PSF_Name',{SCRPTipt.labelstr});
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
if not(isfield(SCRPTGBL,'TF_File_Data'))
    if isfield(SCRPTGBL.CurrentTree.('TF_File').Struct,'selectedfile')
    file = SCRPTGBL.CurrentTree.('TF_File').Struct.selectedfile;
        if not(exist(file,'file'))
            err.flag = 1;
            err.msg = '(Re) Load TF_File - path no longer valid';
            ErrDisp(err);
            return
        else
            Status('busy','Load TF_File');
            load(file);
            saveData.path = file;
            SCRPTGBL.('TF_File_Data') = saveData;
        end
    else
        err.flag = 1;
        err.msg = '(Re) Load TF_File';
        ErrDisp(err);
        return
    end
end

%---------------------------------------------
% Get Input
%---------------------------------------------
PSF.method = SCRPTGBL.CurrentTree.Func;
PSF.zf = str2double(SCRPTGBL.CurrentTree.('ZeroFill'));

%---------------------------------------------
% Load Implementation
%---------------------------------------------
TF = SCRPTGBL.TF_File_Data.TF;

%---------------------------------------------
% Perform Analysis
%---------------------------------------------
func = str2func([PSF.method,'_Func']);
INPUT.TF = TF;
[PSF,err] = func(PSF,INPUT);
if err.flag
    return
end
clear INPUT;

%--------------------------------------------
% Output to TextBox
%--------------------------------------------
global FIGOBJS
FIGOBJS.(SCRPTGBL.RWSUI.tab).Info.String = PSF.ExpDisp;

%--------------------------------------------
% Name
%--------------------------------------------
name = ['PSF_',TF.name(5:end)];

%--------------------------------------------
% Return
%--------------------------------------------
name = inputdlg('Name PSF:','Name',1,{name});
if isempty(name)
    SCRPTGBL.RWSUI.SaveGlobal = 'no';
    return
end
PSF.name = name{1};

SCRPTipt(indnum).entrystr = PSF.name;
SCRPTGBL.RWSUI.SaveVariables = PSF;
SCRPTGBL.RWSUI.SaveVariableNames = 'PSF';
SCRPTGBL.RWSUI.SaveGlobal = 'yes';
SCRPTGBL.RWSUI.SaveGlobalNames = PSF.name;
SCRPTGBL.RWSUI.SaveScriptOption = 'yes';
SCRPTGBL.RWSUI.SaveScriptPath = 'outloc';
SCRPTGBL.RWSUI.SaveScriptName = PSF.name;

Status('done','');
Status2('done','',2);
Status2('done','',3);
