%====================================================
%  
%====================================================

function [IMG,err] = PopCreateVarian_v1a_Func(INPUT,IMG)

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
if strcmp(IMG.function,'PopCreate')
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
        elseif exist([Totalfolders{n},'\IMG_empty.mat'],'file')
            continue
        end

        %---------------------------------------------
        % Test for Default 
        %---------------------------------------------
        if not(exist([Default,'.mat'],'file'))
            Default
            continue
        end
 
        %---------------------------------------------
        % Load Default 
        %---------------------------------------------        
        load([Default,'.mat']);
        Recon.path = [Totalfolders{n},'\']; 
        if exist('ScrptCellArray','var')
            Recon.ScrptCellArray = ScrptCellArray;
        elseif exist('CompCellArray','var')   
            Recon.ScrptCellArray = CompCellArray;
        end        

        %---------------------------------------------
        % Run Info
        %---------------------------------------------
        ExtRunInfo.saveData.TrajName = [];                              % Coding on Varian not set up for this
        ExtRunInfo.save = 'all';                                 
        ExtRunInfo.name = SaveName;
        ExtRunInfo.fidpath = [Totalfolders{n},'\'];        
        
        %---------------------------------------------
        % Run
        %---------------------------------------------
        ScrptCellArray0 = Recon.ScrptCellArray;
        numscripts = length(ScrptCellArray0(:,1,1));
        for m = 1:numscripts
            Recon.ScrptCellArray = ScrptCellArray0(m,:,:);
            if isempty(Recon.ScrptCellArray{1}.entrystr)
                continue
            end
            [ExtRunInfo,err] = ExtRunScrptFunc2(Recon,ExtRunInfo);
            if err.flag
                return
            end
        end
        
    end
end
    
Status('done','');
Status2('done','',2);
Status2('done','',3);

