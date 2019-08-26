%====================================================
%  
%====================================================

function [err] = ShimSPGR_v1a_Def(IMG,FIDpath,RWSUI,CellArray)

global SCRPTPATHS

%---------------------------------------------
% Check Parameters For Recon
%  (most of this can get dropped when shim function fixed up...)
%---------------------------------------------
[procpar,err] = Load_ProcparV_v1a([FIDpath,'procpar']);
if err.flag 
    ErrDisp(err);
    return
end
[output] = Parse_ProcparV_v1a(procpar,{'fovro','fovpe1','fovpe2','np','nv1','nv2','rosamp','physrfcoil','shimwid','shimdefault'});
fovro = output{1};
fovpe1 = output{2};
fovpe2 = output{3};
if fovro ~= fovpe1 && fovpe1 ~= fovpe2
    err.flag = 1;
    err.msg = 'FoV Not Supported';
    ErrDisp(err);
    return
end
fov = fovro;
np = output{4}/2;
nv1 = output{5};
nv2 = output{6};
rosamp = output{7};
if np/rosamp ~= nv1 && nv1 ~= nv2
    err.flag = 1;
    err.msg = 'Resolution Not Supported';
    ErrDisp(err);
    return
end
vox = fov/nv1;
rfcoil = output{8};
shimwid = output{9};
shimdefault = output{10};

%---------------------------------------------
% Setup Image Construction
%---------------------------------------------
file.ic = 'IC_ShimZF1_v1a.mat';
path.ic = [SCRPTPATHS(5).defrootloc,'\VOYAGER\Select\Image Creation\Shimming\'];
panelnum.ic = 1;
scrptnum.ic = 1;
err = ExtLoadScrptDefault(panelnum.ic,scrptnum.ic,file.ic,path.ic);
if err.flag
    ErrDisp(err);
    return
end

%---------------------------------------------
% Setup B0 Shim
%---------------------------------------------
file.prc = ['SHIM_',rfcoil,'_ShimCal3_',shimdefault,'_v1a.mat'];
path.prc = [SCRPTPATHS(5).defrootloc,'\VOYAGER\Select\Image Processing\Shimming\'];
panelnum.prc = 2;
scrptnum.prc = 1;
err = ExtLoadScrptDefault(panelnum.prc,scrptnum.prc,file.prc,path.prc);
if err.flag
    ErrDisp(err);
    return
end

%---------------------------------------------
% Setup Shim Write
%---------------------------------------------
file.wrt = 'WRT_ShimV_v1a.mat';
path.wrt = [SCRPTPATHS(5).defrootloc,'\VOYAGER\Select\Image Processing\Shimming\'];
panelnum.wrt = 3;
scrptnum.wrt = 1;
err = ExtLoadScrptDefault(panelnum.wrt,scrptnum.wrt,file.wrt,path.wrt);
if err.flag
    ErrDisp(err);
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
err = ExtRunScrptDefault(panelnum.wrt,scrptnum.wrt,file.wrt,path.wrt);
DeleteAutoReconGlobal('prev');
if err.flag
    ErrDisp(err);
end
