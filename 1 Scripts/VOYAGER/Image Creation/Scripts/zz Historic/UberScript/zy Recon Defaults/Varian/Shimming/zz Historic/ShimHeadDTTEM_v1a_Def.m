%====================================================
%  
%====================================================

function [err] = ShimHeadDTTEM_v1a_Def(IMG,FIDpath,RWSUI,CellArray)

global SCRPTPATHS

%---------------------------------------------
% Setup Image Construction
%---------------------------------------------
file.ic = 'IC_ShimHeadDTTEM_v1a.mat';
%file.ic = 'IC_ShimHeadDTTEM_v1b.mat';
path.ic = [SCRPTPATHS(5).defrootloc,'\VOYAGER\Select\Image Creation\Shimming\'];
panelnum.ic = 1;
scrptnum.ic = 1;
err = ExtLoadScrptDefault(panelnum.ic,scrptnum.ic,file.ic,path.ic);
if err.flag
    DeleteAutoReconGlobal('end');
    return
end

%---------------------------------------------
% Setup B0 Shim
%---------------------------------------------
file.prc = 'SHIM_ShimHeadDTTEM_v1a.mat';
path.prc = [SCRPTPATHS(5).defrootloc,'\VOYAGER\Select\Image Processing\Shimming\'];
panelnum.prc = 2;
scrptnum.prc = 1;
err = ExtLoadScrptDefault(panelnum.prc,scrptnum.prc,file.prc,path.prc);
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
    return
end
ExtRunScrptDefault(panelnum.prc,scrptnum.prc,file.prc,path.prc);
%ExtRunScrptDefault(panelnum.ex,scrptnum.ex,file.ex,path.ex);
