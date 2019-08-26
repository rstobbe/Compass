%====================================================
%  
%====================================================

function [err] = fsemsuf_FullBrain_Def(IMG,FIDpath)

global SCRPTPATHS

%---------------------------------------------
% Setup Image Construction
%---------------------------------------------
file.ic = 'IC_fsemsuf_FullBrain_v1a';
path.ic = [SCRPTPATHS(5).defrootloc,'\VOYAGER\Select\Image Creation\Standard1H\'];
panelnum.ic = 1;
scrptnum.ic = 1;
err = ExtLoadScrptDefault(panelnum.ic,scrptnum.ic,[file.ic,'.mat'],path.ic);
if err.flag
    DeleteAutoReconGlobal('end');
    return
end

%---------------------------------------------
% Setup Image Plotting
%---------------------------------------------
file.plt = 'PLT_fsemsuf_FullBrain_v1a';
path.plt = [SCRPTPATHS(5).defrootloc,'\VOYAGER\Select\Image Plotting\Standard1H\'];
panelnum.plt = 2;
scrptnum.plt = 1;
err = ExtLoadScrptDefault(panelnum.plt,scrptnum.plt,[file.plt,'.mat'],path.plt);
if err.flag
    DeleteAutoReconGlobal('end');
    return
end

%---------------------------------------------
% Setup Image Export
%---------------------------------------------
file.ex = 'ExportDicom';
path.ex = [SCRPTPATHS(5).defrootloc,'\VOYAGER\Select\Image Export\'];
panelnum.ex = 3;
scrptnum.ex = 1;
ExtLoadScrptDefault(panelnum.ex,scrptnum.ex,[file.ex,'.mat'],path.ex);

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
ExtRunScrptDefault(panelnum.ic,scrptnum.ic,[file.ic,'.mat'],path.ic);
DeleteAutoReconGlobal('prev');
ExtRunScrptDefault(panelnum.plt,scrptnum.plt,[file.plt,'.mat'],path.plt);
ExtRunScrptDefault(panelnum.ex,scrptnum.ex,[file.ex,'.mat'],path.ex);

