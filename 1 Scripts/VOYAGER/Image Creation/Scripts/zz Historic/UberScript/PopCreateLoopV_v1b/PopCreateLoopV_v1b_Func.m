%====================================================
%  
%====================================================

function [IMG,err] = PopCreateLoopV_v1b_Func(INPUT,IMG)

Status('busy','Pop and Create Images');
Status2('done','',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Get Input
%---------------------------------------------
RWSUI = INPUT.RWSUI;
CellArray = INPUT.CellArray;
clear INPUT;

%---------------------------------------------
% Create Local Folder
%---------------------------------------------
inds = strfind(IMG.varianfolder,'\');
Vfolder = IMG.varianfolder(inds(end)+1:end);
mkdir(IMG.localfolder,Vfolder);
localfolder = [IMG.localfolder,'\',Vfolder];
mkdir(localfolder,'data');

while true

    %---------------------------------------------
    % Check and Pop
    %---------------------------------------------
    Status2('busy','Pop Images',1);
    Vsubfolders = dir(IMG.varianfolder);
    Lsubfolders = dir(localfolder);
    i = 1;
    Totalfolders = cell(0);
    for n = 1:length(Vsubfolders)
        have = 0;
        Vname = Vsubfolders(n).name;
        for m = 1:length(Lsubfolders);
            if strcmp(Vname,Lsubfolders(m).name)
                have = 1;
                break
            end
        end
        if have == 0
            copyfile([IMG.varianfolder,'\',Vname],[localfolder,'\',Vname]);
        end
        Totalfolders{i} = [localfolder,'\',Vname];
        i = i+1;
    end
    Vsubdatafolders = dir([IMG.varianfolder,'\data']);
    Lsubdatafolders = dir([localfolder,'\data']);
    for n = 1:length(Vsubdatafolders)
        have = 0;
        Vname = Vsubdatafolders(n).name;
        for m = 1:length(Lsubdatafolders);
            if strcmp(Vname,Lsubdatafolders(m).name)
                have = 1;
                break
            end
        end
        if have == 0
            copyfile([IMG.varianfolder,'\data\',Vname],[localfolder,'\data\',Vname]);
        end
        Totalfolders{i} = [localfolder,'\data\',Vname];
        i = i+1;        
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
            continue
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
            err.flag = 0;
            err.msg = '';
            continue
        end
    end
    pause(0.1);    
    if not(err.flag)
        Status2('done','',1);
    end
    pause(1.4);
end
    
Status('done','');
Status2('done','',2);
Status2('done','',3);

