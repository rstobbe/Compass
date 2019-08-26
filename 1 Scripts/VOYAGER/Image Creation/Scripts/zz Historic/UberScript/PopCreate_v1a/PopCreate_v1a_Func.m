%====================================================
%  
%====================================================

function [IMG,err] = PopCreate_v1a_Func(INPUT,IMG)

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
inds = strfind(IMG.SysFolder,'\');
sysfolder = IMG.SysFolder(inds(end)+1:end);
mkdir(IMG.localfolder,sysfolder);
localfolder = [IMG.localfolder,'\',sysfolder];

%---------------------------------------------
% Check and Pop
%---------------------------------------------
Status2('busy','Pop Images',1);
Ssubfolders = dir(IMG.SysFolder);
Lsubfolders = dir(localfolder);
Totalfolders.localfolder{1} = localfolder;
Totalfolders.sysfolder{1} = IMG.SysFolder;
i = 2;
for n = 3:length(Ssubfolders)
    have = 0;
    Sname = Ssubfolders(n).name;
    for m = 1:length(Lsubfolders);
        if strcmp(Sname,Lsubfolders(m).name)
%             if strcmp(Ssubfolders(n).date,Lsubfolders(m).date)
%                 have = 1;
%                 break
%             else
%                 answer = questdlg(['Update ',Sname],'Copy Files','Yes','No','Yes');
%                 if isempty(answer)
%                     have = 1;
%                     break
%                 else
%                     if strcmp(answer,'No')
%                         have = 1;
%                         break;
%                     end
%                 end                
%             end
            have = 1;
            break
        end
    end
    if have == 0
        copyfile([IMG.SysFolder,'\',Sname],[localfolder,'\',Sname]);
    end
    if Ssubfolders(n).isdir
        Totalfolders.localfolder{i} = [localfolder,'\',Sname];
        Totalfolders.sysfolder{i} = [IMG.SysFolder,'\',Sname];
        i = i+1;
    end
end
%---- fix ----
% for n = 2:length(Totalfolders)
%     have = 0;
%     Ssubfolders = dir(Totalfolders{n});
%     Sname = Ssubfolders(n).name;
%     for m = 1:length(Lsubdatafolders);
%         if strcmp(Sname,Lsubdatafolders(m).name)
%             have = 1;
%             break
%         end
%     end
%     if have == 0
%         copyfile([IMG.SysFolder,'\data\',Sname],[localfolder,'\data\',Sname]);
%     end
%     Totalfolders{i} = [localfolder,'\data\',Sname];
%     i = i+1;        
% end

%---------------------------------------------
% Get all Data to be Reconstructed / Determine System
%---------------------------------------------
m = 1;
for n = 1:length(Totalfolders)
    if exist([Totalfolders.localfolder{n},'\fid'],'file')
        TotalRecon(m).Folder = Totalfolders.localfolder{n};
        TotalRecon(m).Data = Totalfolders.localfolder{n};
        TotalRecon(m).system = 'Varian';
        TotalRecon(m).Name = '';
        TotalRecon(m).SysFolder = Totalfolders.sysfolder{n};
        m = m+1;
    else
        listing = dir(Totalfolders.localfolder{n});
        for p = 3:length(listing)
            if not(listing(p).isdir)
                file = listing(p).name;
                if strfind(file,'.MRD')
                    TotalRecon(m).Folder = Totalfolders.localfolder{n};
                    TotalRecon(m).Data = [Totalfolders.localfolder{n},'\',file];
                    TotalRecon(m).system = 'MRS';
                    TotalRecon(m).Name = file(1:end-4);
                    TotalRecon(m).SysFolder = Totalfolders.sysfolder{n};
                    m = m+1;
                end
            end
        end
    end
end

%---------------------------------------------
% Test and Recon
%---------------------------------------------
if strcmp(IMG.function,'PopCreate')
    for n = 1:length(TotalRecon)

        %---------------------------------------------
        % Get Info
        %---------------------------------------------
        if strcmp(TotalRecon(n).system,'Varian')
            [Text,err] = Load_ProcparV_v1a([TotalRecon{n}.Folder,'\procpar']);
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
            ReconMRS = '';    
        elseif strcmp(TotalRecon(n).system,'MRS')
            ind = strfind(TotalRecon(n).Name,'_');
            Default = [TotalRecon(n).Name(1:ind(1)-1),'_MRS'];
            SaveName = TotalRecon(n).Name;
            if length(ind) >= 2
                ReconMRS = TotalRecon(n).Name(1:ind(2)-1);
            else
                ReconMRS = TotalRecon(n).Name(1:end);
            end
        end

        %---------------------------------------------
        % Determine If Previous Recon
        %---------------------------------------------    
        if exist([TotalRecon(n).Folder,'\IMG_',SaveName,'.mat'],'file')
            continue
        end

        %---------------------------------------------
        % Test for Default 
        %---------------------------------------------
        if not(exist([Default,'_Def'],'file'))
            answer = inputdlg(['Enter valid recon for: ',SaveName],'Recon Default',1);
            if isempty(answer)
                continue
            else
                answer = answer{1};
                ind = strfind(answer,'_');
                Default = [answer(1:ind-1),'_MRS'];
                ReconMRS = answer;
            end
        end

        %---------------------------------------------
        % Create Structure
        %---------------------------------------------
        AutoRecon.AutoRecon = 'yes';
        AutoRecon.AutoSave = 'yes';
        AutoRecon.ReconMRS = ReconMRS;
        AutoRecon.SaveName = SaveName;
        AutoRecon.FIDpath = [TotalRecon(n).Folder,'\'];
        AutoRecon.SYSpath = [TotalRecon(n).SysFolder,'\'];
        
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
        err = func(IMG,[TotalRecon(n).Folder,'\'],RWSUI,CellArray);
        if err.flag
            ErrDisp(err);
            err.flag = 0;
            err.msg = '';
            pause(1);
            continue
        end
    end
end
    
Status('done','');
Status2('done','',2);
Status2('done','',3);

