%====================================================
%  
%====================================================

function [err] = ShimSPGR_v1b_Def(IMG,FIDpath,RWSUI,CellArray)

global SCRPTPATHS

%---------------------------------------------
% Check Parameters For Recon
%---------------------------------------------
[procpar,err] = Load_ProcparV_v1a([FIDpath,'procpar']);
if err.flag 
    ErrDisp(err);
    return
end
[output] = Parse_ProcparV_v1a(procpar,{'physrfcoil','shimdefault'});
rfcoil = output{1};
shimdefault = output{2};

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
file.prc = ['SHIM_',rfcoil,'_ShimCal3_',shimdefault,'_v1b.mat'];
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
% Setup Shim Dispaly
%---------------------------------------------
%file.disp = 'DISP_Shim_v1a.mat';
%path.disp = [SCRPTPATHS(5).defrootloc,'\VOYAGER\Select\Image Processing\Shimming\'];
%panelnum.disp = 3;
%scrptnum.disp = 2;
%err = ExtLoadScrptDefault(panelnum.disp,scrptnum.disp,file.disp,path.disp);
%if err.flag
%    ErrDisp(err);
%    return
%end

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
%Save_Global(RWSUI,CellArray);
err = ExtRunScrptDefault(panelnum.wrt,scrptnum.wrt,file.wrt,path.wrt);
%DeleteAutoReconGlobal('prev');
if err.flag
    ErrDisp(err);
end
