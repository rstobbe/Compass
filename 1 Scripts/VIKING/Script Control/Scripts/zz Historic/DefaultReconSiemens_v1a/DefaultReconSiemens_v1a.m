%====================================================
% (v1b)
%      
%====================================================
 
function [SCRPTipt,SCRPTGBL,err] = DefaultReconSiemens_v1a(SCRPTipt,SCRPTGBL)

Status('busy','Create Siemens Image');
Status2('done','',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Where to Load
%-------------------------------------------
RWSUI = SCRPTGBL.RWSUI;
if RWSUI.panelnum ~= 5;
    err.flag = 1;
    err.msg = 'Run Composite Script Panel';
    return
end
if strcmp(RWSUI.tab,'IM')
    RWSUI.tab = 'ACC';
end

%---------------------------------------------
% Tests
%---------------------------------------------
if not(isfield(SCRPTGBL,'Data_File_Data'))
    if isfield(SCRPTGBL.CurrentTree.('Data_File').Struct,'selectedpath')
        path = SCRPTGBL.CurrentTree.('Data_File').Struct.selectedpath;
        if not(exist(path,'dir'))
            err.flag = 1;
            err.msg = '(Re) Load Data_File';
            ErrDisp(err);
            return
        else
            saveData.path = path;
            SCRPTGBL.('Data_File_Data') = saveData;
        end
    else
        err.flag = 1;
        err.msg = '(Re) Load Data_File';
        ErrDisp(err);
        return
    end
end

%---------------------------------------------
% Load Input
%---------------------------------------------
RECON.method = SCRPTGBL.CurrentTree.Func;
RECON.file = SCRPTGBL.('Data_File_Data');

%---------------------------------------------
% Load Composite Script
%---------------------------------------------
global SCRPTPATHS
path = [SCRPTPATHS.(RWSUI.tab)(RWSUI.panelnum).defrootloc,'Protocols\PRISMA\'];
file = [RECON.file.Protocol,'.mat'];

listing = dir(path);
Totalfolders{1} = path;
m = 2;
for n = 3:length(listing)                                      
    if listing(n).isdir
        Totalfolders{m} = [path,listing(n).name];
        m = m+1;
    end
end

for m = 1:length(Totalfolders)
    listing = dir(Totalfolders{m});
    for n = 1:length(listing)
        if strcmp(listing(n).name,file)
            path = [Totalfolders{m},'\'];
            break
        end
    end
end

[err] = ExtLoadComposite(RWSUI.tab,file,path);
if err.flag
    [file,path] = uigetfile('*.mat','Select Recon Script',path);
    if file == 0
        err.flag = 4;
        err.msg = '';
        return
    end
    [err] = ExtLoadComposite(RWSUI.tab,file,path);
    if err.flag
        return
    end
end

%---------------------------------------------
% Run
%---------------------------------------------
func = str2func([RECON.method,'_Func']);
INPUT.RWSUI = SCRPTGBL.RWSUI;
INPUT.SCRPTipt = SCRPTipt;
[RECON,err] = func(INPUT,RECON);
if err.flag
    return
end

Status('done','');
Status2('done','',2);
Status2('done','',3);



