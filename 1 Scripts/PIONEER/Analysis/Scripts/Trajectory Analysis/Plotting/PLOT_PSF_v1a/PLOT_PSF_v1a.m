%=====================================================
% (v1a) 
%        
%=====================================================

function [SCRPTipt,SCRPTGBL,err] = PLOT_PSF_v1a(SCRPTipt,SCRPTGBL)

Status('busy','Plot PSF');
Status2('done','',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Clear Naming
%---------------------------------------------
inds = strcmp('Plot_Name',{SCRPTipt.labelstr});
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
if not(isfield(SCRPTGBL,'PSF_File_Data'))
    if isfield(SCRPTGBL.CurrentTree.('PSF_File').Struct,'selectedfile')
    file = SCRPTGBL.CurrentTree.('PSF_File').Struct.selectedfile;
        if not(exist(file,'file'))
            err.flag = 1;
            err.msg = '(Re) Load PSF_File - path no longer valid';
            ErrDisp(err);
            return
        else
            Status('busy','Load PSF_File');
            load(file);
            saveData.path = file;
            SCRPTGBL.('PSF_File_Data') = saveData;
        end
    else
        err.flag = 1;
        err.msg = '(Re) Load PSF_File';
        ErrDisp(err);
        return
    end
end

%---------------------------------------------
% Get Input
%---------------------------------------------
PLOT.method = SCRPTGBL.CurrentTree.Func;

%---------------------------------------------
% Load Implementation
%---------------------------------------------
PSF = SCRPTGBL.PSF_File_Data.PSF;

%---------------------------------------------
% Perform Analysis
%---------------------------------------------
func = str2func([PLOT.method,'_Func']);
INPUT.PSF = PSF;
[PLOT,err] = func(PLOT,INPUT);
if err.flag
    return
end
clear INPUT;

%--------------------------------------------
% Output to TextBox
%--------------------------------------------
global FIGOBJS
FIGOBJS.(SCRPTGBL.RWSUI.tab).Info.String = PLOT.ExpDisp;

%--------------------------------------------
% Name
%--------------------------------------------
name = ['PlotPSF_',PSF.name(5:end)];

%--------------------------------------------
% Return
%--------------------------------------------
name = inputdlg('Name Plot:','Name',1,{name});
if isempty(name)
    SCRPTGBL.RWSUI.SaveGlobal = 'no';
    return
end
PLOT.name = name{1};

SCRPTipt(indnum).entrystr = name;
SCRPTGBL.RWSUI.SaveVariables = {PLOT};
SCRPTGBL.RWSUI.SaveVariableNames = {'PLOT'};
SCRPTGBL.RWSUI.SaveGlobal = 'yes';
SCRPTGBL.RWSUI.SaveGlobalNames = name;
SCRPTGBL.RWSUI.SaveScriptOption = 'yes';
SCRPTGBL.RWSUI.SaveScriptPath = 'outloc';
SCRPTGBL.RWSUI.SaveScriptName = name;

Status('done','');
Status2('done','',2);
Status2('done','',3);
