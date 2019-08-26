%====================================================
%  
%====================================================

function [err] = LRPA_Def(IMG,FIDpath,RWSUI,CellArray)

global SCRPTPATHS

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
% Setup Image Construction
%---------------------------------------------
[projset] = Parse_ParamsV_v1a(params,'projection set');
file.ic = ['IC_MSYB_',projset,'.mat'];
path.ic = [SCRPTPATHS(5).defrootloc,'\VOYAGER\Select\Image Creation\MSYB\'];
panelnum.ic = 1;
scrptnum.ic = 1;
err = ExtLoadScrptDefault(panelnum.ic,scrptnum.ic,file.ic,path.ic);
if err.flag
    ErrDisp(err);
    return
end

%---------------------------------------------
% Setup Image Plotting
%---------------------------------------------
file.plt = ['PLT_MSYB_',projset,'.mat'];
path.plt = [SCRPTPATHS(5).defrootloc,'\VOYAGER\Select\Image Plotting\MSYB\'];
panelnum.plt = 2;
scrptnum.plt = 1;
err = ExtLoadScrptDefault(panelnum.plt,scrptnum.plt,file.plt,path.plt);
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
ExtRunScrptDefault(panelnum.ic,scrptnum.ic,file.ic,path.ic);
DeleteAutoReconGlobal('prev');
if err.flag
    ErrDisp(err);
    return
end
ExtRunScrptDefault(panelnum.plt,scrptnum.plt,file.plt,path.plt);
DeleteAutoReconGlobal('prev');
if err.flag
    ErrDisp(err);
end
