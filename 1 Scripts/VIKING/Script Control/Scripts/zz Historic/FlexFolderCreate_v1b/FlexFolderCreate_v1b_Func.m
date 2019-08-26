%====================================================
%  
%====================================================

function [RECON,err] = FlexFolderCreate_v1b_Func(INPUT,RECON)

Status('busy','Create Images In Folder');
Status2('done','',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Get Input
%---------------------------------------------
RWSUI = INPUT.RWSUI;
clear INPUT;

%---------------------------------------------
% Get All Folders
%---------------------------------------------
path = RECON.folder.path;
listing = dir(path);
Totalfolders{1} = path;
m = 2;
for n = 3:length(listing)                                       % note that first 2 are '\.' and '\..' folders
    if listing(n).isdir
        Totalfolders{m} = [path,'\',listing(n).name];
        m = m+1;
    end
end

%---------------------------------------------
% Get all Data to be Reconstructed / Determine System
%---------------------------------------------
m = 1;
for n = 1:length(Totalfolders)
    if exist([Totalfolders{n},'\params'],'file')
        Recon.system = 'Varian';
        Recon.fidpath = [Totalfolders{n},'\'];
        Recon.save = 'all';                                 % put to selector?
        Recon.path = Recon.fidpath;
        Recon.name = RECON.name;
        Recon.savepath = RECON.folder.path;
        Recon.savepathoption = 'spec';
        ExtRunInfoArray{m} = Recon;
        m = m+1;
    elseif exist([Totalfolders{n},'\*.MRD'],'file')
        error       % finish
    end 
end

%---------------------------------------------
% Run
%---------------------------------------------
for m = 1:1
%for m = 1:length(ExtRunInfoArray)	
    clear ExtRunInfo;
    ExtRunInfo = ExtRunInfoArray{m};
    scrptnum = 1;           % one script per panel
    for n = 2:4;
        panelnum = n;
        ExtRunInfo.name = ExtRunInfoArray{m}.name;
        [ExtRunInfo,err] = ExtRunScrptDefault(RWSUI.tab,panelnum,scrptnum,ExtRunInfo);
        if err.flag
            continue
        end
    end
end
  
Status('done','');
Status2('done','',2);
Status2('done','',3);

