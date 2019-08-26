%====================================================
%  
%====================================================

function [err] = ShimV_Def(IMG,FIDpath,RWSUI,CellArray)

%---------------------------------------------
% Find Construction Defaults
%---------------------------------------------
[Text,err] = Load_ProcparV_v1a([FIDpath,'\procpar']);
if err.flag 
    return
end
params = {'imcreate','shimprocess','physrfcoil'};
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
file.shim = ['SHIM_',ReconDefs.physrfcoil,'_',ReconDefs.shimprocess,'.mat'];
[err,path.shim] = FindDefaults(file.shim);
if err.flag
    return
end

%---------------------------------------------
% Setup Image Shimming
%---------------------------------------------
panelnum.shim = 2;
scrptnum.shim = 1;
err = ExtLoadScrptDefault(panelnum.shim,scrptnum.shim,file.shim,path.shim);
if err.flag
    DeleteAutoReconGlobal('end');
    return
end

%---------------------------------------------
% Find Default
%---------------------------------------------
file.wrt = 'WRT_ShimV_v1a.mat';
[err,path.wrt] = FindDefaults(file.wrt);
if err.flag
    return
end

%---------------------------------------------
% Setup Shim Write
%---------------------------------------------
panelnum.wrt = 3;
scrptnum.wrt = 1;
err = ExtLoadScrptDefault(panelnum.wrt,scrptnum.wrt,file.wrt,path.wrt);
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
err = ExtRunScrptDefault(panelnum.shim,scrptnum.shim,file.shim,path.shim);
if err.flag
    ErrDisp(err);
    DeleteAutoReconGlobal('end');
    return
end
DeleteAutoReconGlobal('prev');
err = ExtRunScrptDefault(panelnum.wrt,scrptnum.wrt,file.wrt,path.wrt);
if err.flag
    ErrDisp(err);
end
