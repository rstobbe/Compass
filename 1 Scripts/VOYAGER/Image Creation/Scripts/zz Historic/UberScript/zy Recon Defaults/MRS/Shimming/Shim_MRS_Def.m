%====================================================
%  
%====================================================

function [err] = Shim_MRS_Def(IMG,FIDpath,RWSUI,CellArray)

global SCRPTPATHS

%---------------------------------------------
% For Recon Defaults
%---------------------------------------------
name = RWSUI.SaveVariables{1}.ReconMRS;
ind = strfind(name,'_');
if length(ind) ~= 1
    err.flag = 1;
    err.msg = 'Not a Valid Recon Name';
    return
else
    Default = name(1:end);
end

%---------------------------------------------
% Setup Image Construction
%---------------------------------------------
file.ic = ['IC_',Default,'.mat'];
path.ic = [SCRPTPATHS(5).defrootloc,'\VOYAGER\Select\Image Creation\MRS\Shimming\'];
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
file.prc = ['PRC_',Default,'.mat'];
path.prc = [SCRPTPATHS(5).defrootloc,'\VOYAGER\Select\Image Processing\MRS\Shimming\'];
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
file.wrt = 'WRT_ShimMRS.mat';
path.wrt = [SCRPTPATHS(5).defrootloc,'\VOYAGER\Select\Image Processing\MRS\Shimming\'];
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
% Select FID
%---------------------------------------------
shimfile = uigetfile('*.SHM',['Select Shim File Associated With ',RWSUI.SaveVariables{1}.SaveName],RWSUI.SaveVariables{1}.SYSpath);
if isempty(shimfile)
    err.flag = 1;
    err.msg = 'No Shim File Selected';
    return
else
    RWSUI.SaveVariables{1}.ShimFile = shimfile;
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
DeleteAutoReconGlobal('end');
if err.flag
    ErrDisp(err);
end
