%====================================================
%  
%====================================================

function [err] = CreatePlotV_Def(IMG,FIDpath,RWSUI,CellArray)

%---------------------------------------------
% Find Construction Defaults
%---------------------------------------------
[Text,err] = Load_ProcparV_v1a([FIDpath,'\procpar']);
if err.flag 
    return
end
params = {'imcreate','implot'};
out = Parse_ProcparV_v1a(Text,params);
ReconDefs = cell2struct(out,params,2);

%---------------------------------------------
% Find Image Create Defaults
%---------------------------------------------
ind = strfind(ReconDefs.imcreate,'_v');
imcreate = ['IC_',ReconDefs.imcreate(1:ind-1)];
if exist(imcreate,'file')
    func = str2func(imcreate);
    file.ic = func();
else
    file.ic = ['IC_',ReconDefs.imcreate,'.mat'];
end
[err,path.ic] = FindDefaults(RWSUI,file.ic);
if err.flag
    return
end

%---------------------------------------------
% Find Image Plot Defaults
%---------------------------------------------
ind = strfind(ReconDefs.implot,'_v');
implot = ['PLT_',ReconDefs.implot(1:ind-1)];
if exist(implot,'file')
    func = str2func(implot);
    file.plt = func();
else
    file.plt = ['PLT_',ReconDefs.implot,'.mat'];
end
[err,path.plt] = FindDefaults(RWSUI,file.plt);
if err.flag
    return
end

%--------------------------------------------
% Determine Where to Load Scripts
%--------------------------------------------
if strcmp(RWSUI.tab,'IM') || strcmp(RWSUI.tab,'ACC')
    tab = 'ACC';
end

%---------------------------------------------
% Setup Image Construction
%---------------------------------------------
panelnum.ic = 1;
scrptnum.ic = 1;
err = ExtLoadScrptDefault(tab,panelnum.ic,scrptnum.ic,file.ic,path.ic);
if err.flag
    DeleteAutoReconGlobal('end');
    return
end

%---------------------------------------------
% Setup Image Plotting
%---------------------------------------------
panelnum.plt = 2;
scrptnum.plt = 1;
err = ExtLoadScrptDefault(tab,panelnum.plt,scrptnum.plt,file.plt,path.plt);
if err.flag
    DeleteAutoReconGlobal('end');
    return
end

%---------------------------------------------
% Done if Load Defaults Only
%---------------------------------------------
if strcmp(IMG.func,'LoadDefs');
    return
end

%---------------------------------------------
% Set AutoRecon Global
%---------------------------------------------
saveData = RWSUI.SaveVariables{1};
saveData.saveSCRPTcellarray = CellArray(RWSUI.scrptnum,:);
totalgbl = [RWSUI.SaveGlobalNames;{saveData}];
from = 'Script';
Load_TOTALGBL(totalgbl,tab,from);

%---------------------------------------------
% Run
%---------------------------------------------
err = ExtRunScrptDefault(tab,panelnum.ic,scrptnum.ic);
DeleteAutoReconGlobal('prev');
if err.flag
    ErrDisp(err);
    return
end
Load_TOTALGBL(totalgbl,tab,from);
err = ExtRunScrptDefault(tab,panelnum.plt,scrptnum.plt);
DeleteAutoReconGlobal('prev');
if err.flag
    ErrDisp(err);
end
