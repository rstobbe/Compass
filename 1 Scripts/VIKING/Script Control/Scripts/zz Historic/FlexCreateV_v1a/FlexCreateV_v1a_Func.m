%====================================================
%  
%====================================================

function [IMG,err] = FlexCreateV_v1a_Func(INPUT,IMG)

Status('busy','Create Image');
Status2('done','',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Get Input
%---------------------------------------------
IC = INPUT.IC;
clear INPUT;

%---------------------------------------------
% Test
%---------------------------------------------
if not(exist([IMG.fid.path,'fid'],'file'))
    err.flag = 1;
    err.msg = 'Varian data not selected';
    return
end

%---------------------------------------------
% Get Info
%---------------------------------------------
[Text,err] = Load_ProcparV_v1a([IMG.fid.path,'procpar']);
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
    
%---------------------------------------------
% Determine If Previous Recon
%---------------------------------------------    
if exist([IMG.fid.path,'IMG_',SaveName,'.mat'],'file')
    button = questdlg('Recon Exists:','Recon','Abort','Rewrite','NewRecon','Rewrite');
    if isempty(button) || strcmp(button,'Abort')
        return
    elseif strcmp(button,'NewRecon')
        SaveName = [SaveName,'_02'];
        if exist([IMG.fid.path,'IMG_',SaveName,'.mat'],'file')
            SaveName = [SaveName,'_03'];
        end
    end
end    

%---------------------------------------------
% Create Structure
%---------------------------------------------
AutoRecon.AutoRecon = 'yes';
AutoRecon.AutoSave = 'yes';
AutoRecon.SaveName = SaveName;
AutoRecon.FIDpath = IMG.fid.path;

%---------------------------------------------
% Write FID path to Default
%---------------------------------------------
RWSUI.SaveGlobal = 'yes';
RWSUI.SaveGlobalNames = 'AutoRecon';
RWSUI.SaveVariables = {AutoRecon};

%---------------------------------------------
% Run Script
%---------------------------------------------
func = str2func([IMG.createfunc,'_Func']); 
INPUT.RWSUI = RWSUI;
[IC,err] = func(IC,INPUT);
if err.flag
    return
end
clear INPUT;

%---------------------------------------------
% Run Image Construction Default 
%---------------------------------------------
func = str2func([Default,'_Def']);
IMG.func = 'run';
err = func(IMG,[Totalfolders{n},'\'],RWSUI,CellArray);
if err.flag
    pause(1.5);
    err.flag = 0;
    err.msg = '';
end

    
Status('done','');
Status2('done','',2);
Status2('done','',3);

