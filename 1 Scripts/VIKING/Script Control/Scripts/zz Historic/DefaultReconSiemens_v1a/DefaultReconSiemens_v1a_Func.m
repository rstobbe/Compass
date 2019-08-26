%====================================================
%  
%====================================================

function [RECON,err] = DefaultReconSiemens_v1a_Func(INPUT,RECON)

Status('busy','Run Siemens Recon Scripts');
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
% Name
%---------------------------------------------
RECON.name = [RECON.file.VolunteerID,'_',RECON.file.Protocol];

%---------------------------------------------
% Run Info
%---------------------------------------------
ExtRunInfo.saveData = RECON.file;
ExtRunInfo.save = 'all';                                 
ExtRunInfo.name = RECON.name;

%---------------------------------------------
% Run
%---------------------------------------------
for n = 1:4;
    [ExtRunInfo,err] = ExtRunScrptDefault(RWSUI.tab,n,1,ExtRunInfo);
    if err.flag
        continue
    end
end

err.flag = 0;
err.msg = '';

Status('done','');
Status2('done','',2);
Status2('done','',3);


