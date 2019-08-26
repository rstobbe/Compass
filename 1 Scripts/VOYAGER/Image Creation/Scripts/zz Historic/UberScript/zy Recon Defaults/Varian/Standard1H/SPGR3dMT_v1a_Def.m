%====================================================
%  
%====================================================

function [err] = SPGR3dMT_v1a_Def(IMG,FIDpath,RWSUI,CellArray)

global SCRPTPATHS

%---------------------------------------------
% Setup Image Construction
%---------------------------------------------
file.ic = 'IC_SPGR3dMT_v1a';
path.ic = [SCRPTPATHS(5).defrootloc,'\VOYAGER\Select\Image Creation\Standard1H\'];
panelnum.ic = 1;
scrptnum.ic = 1;
err = ExtLoadScrptDefault(panelnum.ic,scrptnum.ic,[file.ic,'.mat'],path.ic);
if err.flag
    ErrDisp(err);
    return
end

%---------------------------------------------
% Create Difference Image
%---------------------------------------------
file.prc = 'DiffImage';
path.prc = [SCRPTPATHS(5).defrootloc,'\VOYAGER\Select\Image Processing\Relative Image\'];
panelnum.prc = 2;
scrptnum.prc = 1;
err = ExtLoadScrptDefault(panelnum.prc,scrptnum.prc,[file.prc,'.mat'],path.prc);
if err.flag
    DeleteAutoReconGlobal('end');
    return
end

%---------------------------------------------
% Setup Image Plotting
%---------------------------------------------
file.plt = 'PLT_SPGR3dMTcomp_v1a';
path.plt = [SCRPTPATHS(5).defrootloc,'\VOYAGER\Select\Image Plotting\Standard1H\'];
panelnum.plt = 3;
scrptnum.plt = 1;
err = ExtLoadScrptDefault(panelnum.plt,scrptnum.plt,[file.plt,'.mat'],path.plt);
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
err = ExtRunScrptDefault(panelnum.prc,scrptnum.prc,file.prc,path.prc);
DeleteAutoReconGlobal('prev');
if err.flag
    ErrDisp(err);
end
Save_Global(RWSUI,CellArray);
err = ExtRunScrptDefault(panelnum.plt,scrptnum.plt,file.plt,path.plt);
DeleteAutoReconGlobal('prev');
if err.flag
    ErrDisp(err);
end
