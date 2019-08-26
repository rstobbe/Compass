%====================================================
%  
%====================================================

function [IMG,err] = SelectCreate_v1b_Func(INPUT,IMG)

Status('busy','Create Image');
Status2('done','',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Get Input
%---------------------------------------------
FIDpath = INPUT.FID.path;
RWSUI = INPUT.RWSUI;
CellArray = INPUT.CellArray;
clear INPUT;

%---------------------------------------------
% Determine System
%---------------------------------------------
if exist([FIDpath,'fid'],'file')
    system = 'Varian';
else
    system = 'MRS';
end
    
%---------------------------------------------
% Get Info
%---------------------------------------------
if strcmp(system,'Varian')
    [Text,err] = Load_ProcparV_v1a([FIDpath,'procpar']);
    if err.flag 
        return
    end
    params = {'seqfil','acqtype','protocol','comment','recondef','savename'};
    out = Parse_ProcparV_v1a(Text,params);
    ExpPars = cell2struct(out,params,2);
    if strcmp(ExpPars.acqtype,'RWS') || strcmp(ExpPars.acqtype,'NaPA_v1')           % NaPA_v1 for old sodium
        if isempty(ExpPars.recondef)
            ExpPars.recondef = 'NaPA_v1';
        end
        if isempty(ExpPars.savename)
            ExpPars.savename = ExpPars.protocol;
        end
        SaveName = ExpPars.savename;    
        Default = ExpPars.recondef;
    else
        SaveName = [ExpPars.seqfil,'_',ExpPars.comment];
        Default = [ExpPars.seqfil,'_',ExpPars.comment];
    end
end

%---------------------------------------------
% Determine If Previous Recon
%---------------------------------------------    
if strcmp(IMG.func,'Run');
    if exist([FIDpath,'\IMG_',SaveName,'.mat'],'file')
        button = questdlg('Recon Exists:','Recon','Abort','Rewrite','NewRecon','Rewrite');
        if isempty(button) || strcmp(button,'Abort')
            return
        elseif strcmp(button,'NewRecon')
            SaveName = [SaveName,'_02'];
        end
    end
end

%---------------------------------------------
% Test for Default 
%---------------------------------------------
if not(exist([Default,'_Def'],'file'))
    err.flag = 1;
    err.msg = [Default,'_Def does not exist'];
    return
end

%---------------------------------------------
% Create Structure
%---------------------------------------------
AutoRecon.AutoRecon = 'yes';
AutoRecon.AutoSave = 'yes';
AutoRecon.SaveName = SaveName;
AutoRecon.FIDpath = FIDpath;

%---------------------------------------------
% Write FID path to Default
%---------------------------------------------
RWSUI.SaveGlobal = 'yes';
RWSUI.SaveGlobalNames = 'AutoRecon';
RWSUI.SaveVariables = {AutoRecon};

%---------------------------------------------
% Run Image Construction Default 
%---------------------------------------------
func = str2func([Default,'_Def']);
err = func(IMG,FIDpath,RWSUI,CellArray);

Status('done','');
Status2('done','',2);
Status2('done','',3);

