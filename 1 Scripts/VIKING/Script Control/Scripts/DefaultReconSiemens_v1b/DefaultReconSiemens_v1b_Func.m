%====================================================
%  
%====================================================

function [RECON,err] = DefaultReconSiemens_v1b_Func(INPUT,RECON)

Status('busy','Run Siemens Recon Scripts');
Status2('done','',2);
Status2('done','',3);

global COMPASSINFO

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Get Input
%---------------------------------------------
Data = INPUT.Data;
clear INPUT;

%---------------------------------------------
% Run Info
%---------------------------------------------
ExtRunInfo.saveData = Data;
ExtRunInfo.save = 'all';                                 
ExtRunInfo.name = [Data.VolunteerID,'_',Data.Protocol];

%---------------------------------------------
% Load Script
%---------------------------------------------
defaultrecon = [COMPASSINFO.USERGBL.siemensdefaultloc,'\',Data.Protocol,'.mat'];
if exist(defaultrecon,'file')
    load(defaultrecon);
    Recon.file = [Data.Protocol,'.mat']; 
    Recon.path = COMPASSINFO.USERGBL.siemensdefaultloc;   
else
    [file,path] = uigetfile('*.mat','Select Recon Script',COMPASSINFO.USERGBL.siemensdefaultloc);
    if path == 0
        return
    end
    load([path,file]);
    Recon.file = file; 
    Recon.path = path; 
end
if exist('ScrptCellArray','var')
    Recon.ScrptCellArray = ScrptCellArray;
elseif exist('CompCellArray','var')   
    Recon.ScrptCellArray = CompCellArray;
end

%---------------------------------------------
% Run
%---------------------------------------------
ScrptCellArray0 = Recon.ScrptCellArray;
numscripts = length(ScrptCellArray0(:,1,1));
for n = 1:numscripts
    Recon.ScrptCellArray = ScrptCellArray0(n,:,:);
    if isempty(Recon.ScrptCellArray{1}.entrystr)
        continue
    end
    [ExtRunInfo,err] = ExtRunScrptFunc2(Recon,ExtRunInfo);
    if err.flag
        return
    end
end

err.flag = 0;
err.msg = '';

Status('done','');
Status2('done','',2);
Status2('done','',3);


