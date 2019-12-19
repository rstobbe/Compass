%=========================================================
% (v1a) 
%      
%=========================================================

function [SCRPTipt,SCRPTGBL,ROILD,err] = LoadActivatedRois_v1a(SCRPTipt,SCRPTGBL,ROILDipt)

Status2('busy','Load Activated Rois',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Get Input
%---------------------------------------------
ROILD.method = ROILDipt.Func;

%---------------------------------------------
% Get ROI info
%---------------------------------------------
tab = SCRPTGBL.RWSUI.tab;
[ROI,axnum,err] = GetROISofInterest(tab,[]);
SCRPTGBL.RWSUI.axnum = axnum;
if err.flag
    return
end

ROILD.ROI = ROI;
ROILD.axnum = axnum;
ROILD.tab = tab;

global SCRPTPATHS
ROILD.path = SCRPTPATHS.(tab)(1).roisloc;

Status2('done','',2);
Status2('done','',3);
