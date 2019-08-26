%=========================================================
% (v1a) 
%      
%=========================================================

function [SCRPTipt,SCRPTGBL,err] = ExportRoiMeanMultiDim_v1a(SCRPTipt,SCRPTGBL)

global IMAGEANLZ

Status('busy','Export ROI Data');
Status2('done','',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Get Input
%---------------------------------------------
EXPORT.method = SCRPTGBL.CurrentScript.Func;

%---------------------------------------------
% Get ROI info
%---------------------------------------------
tab = SCRPTGBL.RWSUI.tab;
[ROIS,axnum,err] = GetROISofInterest(tab,[]);
SCRPTGBL.RWSUI.axnum = axnum;
if err.flag
    return
end

%---------------------------------------------
% Find Selected Images
%---------------------------------------------
totgblnums = Find_SelectedImages(tab);

%---------------------------------------------
% Export
%---------------------------------------------
func = str2func([EXPORT.method,'_Func']);
INPUT.ROIS = ROIS;
INPUT.IMAGEANLZ = IMAGEANLZ.(tab)(axnum);
INPUT.totgblnums = totgblnums;
INPUT.tab = tab;
[EXPORT,err] = func(EXPORT,INPUT);
if err.flag
    return
end

%---------------------------------------------
% Return
%--------------------------------------------
SCRPTGBL.RWSUI.SaveGlobal = 'no';
SCRPTGBL.RWSUI.SaveScriptOption = 'no';

Status('done','');
Status2('done','',2);
Status2('done','',3);
