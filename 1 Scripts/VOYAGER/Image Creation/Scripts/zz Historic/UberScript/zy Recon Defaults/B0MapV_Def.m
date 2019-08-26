%====================================================
%  
%====================================================

function [err] = B0MapV_Def(IMG,FIDpath,RWSUI,CellArray)

%---------------------------------------------
% Find Construction Defaults
%---------------------------------------------
[Text,err] = Load_ProcparV_v1a([FIDpath,'\procpar']);
if err.flag 
    return
end
params = {'imcreate','physrfcoil','b0mapprocess','b0mapplot'};
out = Parse_ProcparV_v1a(Text,params);
ReconDefs = cell2struct(out,params,2);

%---------------------------------------------
% Find Default
%---------------------------------------------
file.ic = ['IC_',ReconDefs.imcreate,'.mat'];
[err,path.ic] = FindDefaults(file.ic);
if err.flag
    return
end
    
%---------------------------------------------
% Setup Image Construction
%---------------------------------------------
panelnum.ic = 1;
scrptnum.ic = 1;
err = ExtLoadScrptDefault(panelnum.ic,scrptnum.ic,file.ic,path.ic);
if err.flag
    DeleteAutoReconGlobal('end');
    return
end

%---------------------------------------------
% Find Default
%---------------------------------------------
file.b0map = ['B0MAP_',ReconDefs.physrfcoil,'_',ReconDefs.b0mapprocess,'.mat'];
[err,path.b0map] = FindDefaults(file.b0map);
if err.flag
    return
end

%---------------------------------------------
% Setup B0 Mapping
%---------------------------------------------
panelnum.b0map = 2;
scrptnum.b0map = 1;
err = ExtLoadScrptDefault(panelnum.b0map,scrptnum.b0map,file.b0map,path.b0map);
if err.flag
    DeleteAutoReconGlobal('end');
    return
end

%---------------------------------------------
% Find Default
%---------------------------------------------
file.plt = ['PLT_',ReconDefs.b0mapplot,'.mat'];
[err,path.plt] = FindDefaults(file.plt);
if err.flag
    return
end

%---------------------------------------------
% Setup B0 Mapping
%---------------------------------------------
panelnum.plt = 3;
scrptnum.plt = 1;
err = ExtLoadScrptDefault(panelnum.plt,scrptnum.plt,file.plt,path.plt);
if err.flag
    DeleteAutoReconGlobal('end');
    return
end

%---------------------------------------------
% Set AutoRecon Global
%---------------------------------------------
Save_Global(RWSUI,CellArray);

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
err = ExtRunScrptDefault(panelnum.ic,scrptnum.ic,file.ic,path.ic);
DeleteAutoReconGlobal('prev');
if err.flag
    ErrDisp(err);
    return
end
Save_Global(RWSUI,CellArray);
err = ExtRunScrptDefault(panelnum.b0map,scrptnum.b0map,file.b0map,path.b0map);
if err.flag
    ErrDisp(err);
    DeleteAutoReconGlobal('end');
    return
end
DeleteAutoReconGlobal('prev');
err = ExtRunScrptDefault(panelnum.plt,scrptnum.plt,file.plt,path.plt);
if err.flag
    ErrDisp(err);
end
