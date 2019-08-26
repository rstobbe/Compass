%====================================================
%  
%====================================================

function [IMG,err] = FolderCreate_v1c_Func(INPUT,IMG)

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
listing = dir(path);
Totalfolders{1} = path;
m = 2;
for n = 3:length(listing)                               % note that first 2 are '\.' and '\..' folders
    if listing(n).isdir
        Totalfolders{m} = [path,'\',listing(n).name];
        m = m+1;
    end
end
%--- fix to test for all buried ---
%subdatafolders = dir([path,'\data']);
%for n = 1:length(subdatafolders)
%    if subdatafolders(n).isdir
%        Totalfolders{m} = [path,'\data\',subdatafolders(n).name];
%        m = m+1;
%    end
%end

%---------------------------------------------
% Get all Data to be Reconstructed / Determine System
%---------------------------------------------
m = 1;
for n = 1:length(Totalfolders)
    if exist([Totalfolders{n},'\fid'],'file')
        TotalRecon(m).Data = Totalfolders{n};
        TotalRecon(m).system = 'Varian';
        TotalRecon(m).Name = '';
        m = m+1;
    else
        listing = dir(Totalfolders{n});
        for p = 3:length(listing)
            if not(listing(p).isdir)
                file = listing(p).name;
                if strfind(file,'.MRD')
                    TotalRecon(m).Data = [Totalfolders{n},'\',file];
                    TotalRecon(m).system = 'MRS';
                    TotalRecon(m).Name = file(1:end-4);
                    m = m+1;
                end
            end
        end
    end
end
    
%---------------------------------------------
% Test and Recon
%---------------------------------------------
for n = 1:length(TotalRecon)

    %---------------------------------------------
    % Get Info
    %---------------------------------------------
    if strcmp(TotalRecon(n).system,'Varian')
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
    elseif strcmp(TotalRecon(n).system,'MRS')
        ind = strfind(TotalRecon(n).Name,'_');
        Default = [TotalRecon(n).Name(1:ind-1),'_MRS'];
        SaveName = TotalRecon(n).Name;
    end
    
    %---------------------------------------------
    % Determine If Previous Recon
    %---------------------------------------------    
    if exist([Totalfolders{n},'\IMG_',SaveName,'.mat'],'file')
        button = questdlg('Recon Exists:','Recon','Abort','Rewrite','NewRecon','Rewrite');
        if isempty(button) || strcmp(button,'Abort')
            return
        elseif strcmp(button,'NewRecon')
            SaveName = [SaveName,'_02'];
            if exist([Totalfolders{n},'\IMG_',SaveName,'.mat'],'file')
                SaveName = [SaveName,'_03'];
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
    AutoRecon.SaveName = SaveName;
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
        pause(1.5);
        err.flag = 0;
        err.msg = '';
        continue
    end
end
    
Status('done','');
Status2('done','',2);
Status2('done','',3);

