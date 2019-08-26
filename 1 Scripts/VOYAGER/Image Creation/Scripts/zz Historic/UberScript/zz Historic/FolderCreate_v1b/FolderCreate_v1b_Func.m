%====================================================
%  
%====================================================

function [IMG,err] = FolderCreate_v1b_Func(INPUT,IMG)

Status('busy','Create Image');
Status2('done','',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Get Input
%---------------------------------------------
path = INPUT.FID.path;
RWSUI = INPUT.RWSUI;
CellArray = INPUT.CellArray;
clear INPUT;

%---------------------------------------------
% Get All Folders
%---------------------------------------------
subfolders = dir(path);
subdatafolders = dir([path,'\data']);
m = 1;
for n = 1:length(subfolders)
    if subfolders(n).isdir
        Totalfolders{m} = [path,'\',subfolders(n).name];
        m = m+1;
    end
end
for n = 1:length(subdatafolders)
    if subdatafolders(n).isdir
        Totalfolders{m} = [path,'\data\',subdatafolders(n).name];
        m = m+1;
    end
end

%---------------------------------------------
% Test and Recon
%---------------------------------------------
for n = 1:length(Totalfolders)

    %---------------------------------------------
    % Determine System
    %---------------------------------------------
    if exist([Totalfolders{n},'\fid'],'file')
        system = 'Varian';
    elseif exist([Totalfolders{n},'\test.test'],'file')
        system = 'MRS';
    else
        continue
    end

    %---------------------------------------------
    % Get Info
    %---------------------------------------------
    if strcmp(system,'Varian')
        [Text,err] = Load_ProcparV_v1a([Totalfolders{n},'\procpar']);
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
    if exist([Totalfolders{n},'\IMG_',SaveName,'.mat'],'file')
        button = questdlg('Recon Exists:','Recon','Abort','Rewrite','NewRecon','Rewrite');
        if isempty(button) || strcmp(button,'Abort')
            return
        elseif strcmp(button,'NewRecon')
            SaveNameO = [SaveName,'_02'];
            if exist([Totalfolders{n},'\IMG_',SaveNameO,'.mat'],'file')
                SaveNameO = [SaveName,'_03'];
            end
        end
    end    

    %---------------------------------------------
    % Test for Default 
    %---------------------------------------------
    if not(exist([Default,'_Def'],'file'))
        continue
    end

    %---------------------------------------------
    % Create Structure
    %---------------------------------------------
    AutoRecon.AutoRecon = 'yes';
    AutoRecon.AutoSave = 'yes';
    AutoRecon.SaveName = SaveNameO;
    AutoRecon.FIDpath = [Totalfolders{n},'\'];

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
    IMG.func = 'run';
    err = func(IMG,[Totalfolders{n},'\'],RWSUI,CellArray);
    if err.flag
        err.flag = 0;
        err.msg = '';
        continue
    end
end
    
Status('done','');
Status2('done','',2);
Status2('done','',3);

