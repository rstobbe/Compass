%====================================================
%  
%====================================================

function [err] = mp_flash3d_MPRAGE_Def(IMG,FIDpath,RWSUI,CellArray)

global SCRPTPATHS

%---------------------------------------------
% Setup Image Construction
%---------------------------------------------
file.ic = 'IC_mp_flash3d_v1a.mat';
path.ic = [SCRPTPATHS(5).defrootloc,'\VOYAGER\Select\Image Creation\Standard1H\'];
panelnum.ic = 1;
scrptnum.ic = 1;
err = ExtLoadScrptDefault(panelnum.ic,scrptnum.ic,file.ic,path.ic);
if err.flag
    DeleteAutoReconGlobal('end');
    return
end

%---------------------------------------------
% Setup Image Plotting
%---------------------------------------------
file.plt = 'PLT_mp_flash3d_v1a.mat';
path.plt = [SCRPTPATHS(5).defrootloc,'\VOYAGER\Select\Image Plotting\Standard1H\'];
panelnum.plt = 2;
scrptnum.plt = 1;
err = ExtLoadScrptDefault(panelnum.plt,scrptnum.plt,file.plt,path.plt);
if err.flag
    DeleteAutoReconGlobal('end');
    return
end

%---------------------------------------------
% Setup Image Export
%---------------------------------------------
%file.ex = 'ExportDicom';
%path.ex = [SCRPTPATHS(5).defrootloc,'\VOYAGER\Select\Image Export\'];
%panelnum.ex = 3;
%scrptnum.ex = 1;
%ExtLoadScrptDefault(panelnum.ex,scrptnum.ex,file.ex,path.ex);

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
err = ExtRunScrptDefault(panelnum.plt,scrptnum.plt,file.plt,path.plt);
DeleteAutoReconGlobal('prev');
if err.flag
    ErrDisp(err);
end

