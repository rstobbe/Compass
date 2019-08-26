%====================================================
%  
%====================================================

function [err] = PwrCalV_Def(IMG,FIDpath,RWSUI,CellArray)

%---------------------------------------------
% Find Construction Defaults
%---------------------------------------------
[Text,err] = Load_ProcparV_v1a([FIDpath,'\procpar']);
if err.flag 
    return
end
params = {'imcreate','b1process','pwrcal'};
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
file.b1map = ['B1MAP_',ReconDefs.b1process,'.mat'];
[err,path.b1map] = FindDefaults(file.b1map);
if err.flag
    return
end

%---------------------------------------------
% Setup B1 Map
%---------------------------------------------
panelnum.b1map = 2;
scrptnum.b1map = 1;
err = ExtLoadScrptDefault(panelnum.b1map,scrptnum.b1map,file.b1map,path.b1map);
if err.flag
    DeleteAutoReconGlobal('end');
    return
end

%---------------------------------------------
% Find Default
%---------------------------------------------
file.pcal = ['PCAL_',ReconDefs.pwrcal,'.mat'];
[err,path.pcal] = FindDefaults(file.pcal);
if err.flag
    return
end

%---------------------------------------------
% Setup Power Cal
%---------------------------------------------
panelnum.pcal = 3;
scrptnum.pcal = 1;
err = ExtLoadScrptDefault(panelnum.pcal,scrptnum.pcal,file.pcal,path.pcal);
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
% Run Image
%---------------------------------------------
err = ExtRunScrptDefault(panelnum.ic,scrptnum.ic,[file.ic,'.mat'],path.ic);
DeleteAutoReconGlobal('prev');
if err.flag
    ErrDisp(err);
    return
end
Save_Global(RWSUI,CellArray);
err = ExtRunScrptDefault(panelnum.b1map,scrptnum.b1map,[file.b1map,'.mat'],path.b1map);
DeleteAutoReconGlobal('prev');
if err.flag
    ErrDisp(err);
end

%---------------------------------------------
% Power Cal to Search for Image 'B1Map'
%---------------------------------------------
RWSUI.SaveVariables{1}.SaveName = 'B1Map';

%---------------------------------------------
% Continue
%---------------------------------------------
Save_Global(RWSUI,CellArray);
err = ExtRunScrptDefault(panelnum.pcal,scrptnum.pcal,[file.pcal,'.mat'],path.pcal);
if err.flag
    ErrDisp(err);
    DeleteAutoReconGlobal('end');    
else
    DeleteAutoReconGlobal('prev');
end
