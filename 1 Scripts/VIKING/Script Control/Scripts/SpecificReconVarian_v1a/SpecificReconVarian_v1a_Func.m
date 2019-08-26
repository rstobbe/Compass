%====================================================
%  
%====================================================

function [RECON,err] = SpecificReconVarian_v1a_Func(INPUT,RECON)

Status('busy','Run Varian Recon Scripts');
Status2('done','',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Get Input
%---------------------------------------------
Data = INPUT.Data;
Recon = INPUT.Recon;
clear INPUT;

%---------------------------------------------
% Run Info
%---------------------------------------------
ExtRunInfo.saveData = Data;
ExtRunInfo.save = 'all';                                 
ExtRunInfo.name = Data.DatName;
ExtRunInfo.fidpath = Data.path;

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

