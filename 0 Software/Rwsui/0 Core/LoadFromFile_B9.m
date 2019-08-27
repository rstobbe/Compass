%====================================================
%
%====================================================

function LoadFromFile_B9(panelnum,tab,scrptnum)

Status2('busy','Load Script',1);

err.flag = 0;
err.msg = '';

global SCRPTPATHS

%----------------------------------------------------
% Select Output Data
%----------------------------------------------------
if isempty(SCRPTPATHS.(tab)(panelnum).outloc)
    SCRPTPATHS.(tab)(panelnum).outloc = SCRPTPATHS.(tab)(panelnum).outrootloc;
end
[file,path] = uigetfile('*.mat','Select Saved Script',SCRPTPATHS.(tab)(panelnum).outloc);
if path == 0
    err.flag = 4;
    err.msg = 'Output Not Selected';
    ErrDisp(err);
    return
end
outloc = path;
SCRPTPATHS.(tab)(panelnum).outloc = outloc;

%----------------------------------------------------
% Load
%----------------------------------------------------
[saveData,saveSCRPTcellarray,saveGlobalNames,err] = LoadSelectedFile_B9(panelnum,tab,scrptnum,path,file);
if err.flag
    return
end

%----------------------------------------------------
% Assign TOTALGBL
%----------------------------------------------------
names = fieldnames(saveData);
if length(names) > 1 
    error;      % no longer supported
end
fields{1} = saveData.(names{1});
fields{1}.path = path;
fields{1}.name = file;
if exist('saveGlobalNames','var')
    totalgbl = [saveGlobalNames;fields];
else
    totalgbl = [names;fields];
end
totalgbl{2,1}.saveSCRPTcellarray = saveSCRPTcellarray;
from = 'Script';
Load_TOTALGBL(totalgbl,tab,from);

%----------------------------------------------------
% Check if TripleS Simulation
%----------------------------------------------------
if isfield(saveData.(names{1}),'SavedModelTripleS')
    SavedModelTripleS = saveData.(names{1}).SavedModelTripleS;
    SavedSeqTripleS = saveData.(names{1}).SavedSeqTripleS;
    LoadTripleS(SavedModelTripleS,SavedSeqTripleS);
end
    
Status2('done','Script Loaded',1);


