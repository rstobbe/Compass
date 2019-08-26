%====================================================
%  
%====================================================

function [err] = NaShimV_Def(IMG,FIDpath,RWSUI,CellArray)

error %need to finish

%---------------------------------------------
% Test for First of Split
%---------------------------------------------
[params,err] = Load_ParamsV_v1a([FIDpath,'params']);
if err.flag 
    err.flag = 0;
    return
end

%---------------------------------------------
% Test if all splits loaded
%---------------------------------------------
[procpar,err] = Load_ProcparV_v1a([FIDpath,'procpar']);
if err.flag 
    return
end
[output] = Parse_ProcparV_v1a(procpar,{'split'});
split = output{1};
temp1 = strtok(FIDpath,'.');
temp2 = [temp1(1:length(temp1)-2),num2str(str2double(temp1(length(temp1)-1:length(temp1)))+(split-1),'%02d'),'.fid'];
if not(exist(temp2,'file'))
    return
end

%---------------------------------------------
% Find Construction Defaults
%---------------------------------------------
%params = {'imcreate','shimprocess'};
params = {'physrfcoil','shimprocess'};
out = Parse_ProcparV_v1a(Text,params);
ReconDefs = cell2struct(out,params,2);

%---------------------------------------------
% Find Defaults
%---------------------------------------------
%file.ic = ['IC_',ReconDefs.imcreate,'.mat'];
[projset] = Parse_ParamsV_v1a(params,'projection set');
file.ic = ['IC_NaShim_',projset,'_v1a.mat'];
[err,path.ic] = FindDefaults(RWSUI,file.ic);
if err.flag
    return
end
%file.prc = ['PLT_',ReconDefs.implot,'.mat'];
file.prc = ['SHIM_',rfcoil,'_',shimprocess,'.mat'];
[err,path.plt] = FindDefaults(RWSUI,file.plt);
if err.flag
    return
end
file.plt = ['PLT_',ReconDefs.implot,'.mat'];
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
    DeleteAutoReconGlobal('end',tab);
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
% Set AutoRecon Global
%---------------------------------------------
saveData = RWSUI.SaveVariables{1};
saveData.saveSCRPTcellarray = CellArray(RWSUI.scrptnum,:);
totalgbl = [RWSUI.SaveGlobalNames;{saveData}];
Load_TOTALGBL(totalgbl,tab);

%---------------------------------------------
% Done if Load Defaults Only
%---------------------------------------------
if strcmp(IMG.func,'LoadDefs');
    DeleteAutoReconGlobal('end');
    return
end

%---------------------------------------------
% Run
%---------------------------------------------
err = ExtRunScrptDefault(tab,panelnum.ic,scrptnum.ic);
DeleteAutoReconGlobal('prev');
if err.flag
    ErrDisp(err);
    return
end
Load_TOTALGBL(totalgbl,tab);
err = ExtRunScrptDefault(tab,panelnum.plt,scrptnum.plt);
DeleteAutoReconGlobal('prev');
if err.flag
    ErrDisp(err);
end
