%====================================================
%  
%====================================================

function [err] = NaPAshim_v1a_Def(IMG,FIDpath,RWSUI,CellArray)

% - use NaShimV_Def instead
%================================
    err.flag = 0;
    return
%================================

global SCRPTPATHS
global USER

%---------------------------------------------
% Test for First of Split
%---------------------------------------------
[params,err] = Load_ParamsV_v1a([FIDpath,'params']);
if err.flag 
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
% Check Parameters For Recon
%---------------------------------------------
[output] = Parse_ProcparV_v1a(procpar,{'physrfcoil','shimprocess'});
rfcoil = output{1};
shimprocess = output{2};

%---------------------------------------------
% Setup Image Construction
%---------------------------------------------
[projset] = Parse_ParamsV_v1a(params,'projection set');
file.ic = ['IC_NaShim_',projset,'_v1a.mat'];
path.ic = [SCRPTPATHS(5).defrootloc,'\VOYAGER\Select\',USER,'\Image Creation\Shimming\'];
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
%file.prc = ['SHIM_',rfcoil,'_',shimprocess,'_v1a.mat'];
file.prc = ['SHIM_',rfcoil,'_',shimprocess,'.mat'];
path.prc = [SCRPTPATHS(5).defrootloc,'\VOYAGER\Select\',USER,'\Image Processing\Shimming\'];
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
path.wrt = [SCRPTPATHS(5).defrootloc,'\VOYAGER\Select\',USER,'\Image Processing\Shimming\'];
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
%Save_Global(RWSUI,CellArray);
err = ExtRunScrptDefault(panelnum.wrt,scrptnum.wrt,file.wrt,path.wrt);
%DeleteAutoReconGlobal('prev');
if err.flag
    ErrDisp(err);
end

