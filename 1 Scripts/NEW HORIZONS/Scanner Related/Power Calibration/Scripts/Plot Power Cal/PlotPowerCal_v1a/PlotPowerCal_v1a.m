%=========================================================
% (v1a) 
%      
%=========================================================

function [SCRPTipt,SCRPTGBL,err] = PlotPowerCal_v1a(SCRPTipt,SCRPTGBL)

Status('busy','Plot Image Montage');
Status2('done','',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Get Image
%---------------------------------------------
global TOTALGBL
val = get(findobj('tag','totalgbl'),'value');
if isempty(val) || val == 0
    err.flag = 1;
    err.msg = 'No Image in Global Memory';
    return  
end
IMG = TOTALGBL{2,val};

%---------------------------------------------
% Get Input
%---------------------------------------------
PLOT.method = SCRPTGBL.CurrentScript.Func;
PLOT.type = SCRPTGBL.CurrentScript.('Type');
PLOT.orient = SCRPTGBL.CurrentScript.('Orientation');
PLOT.rotation = SCRPTGBL.CurrentScript.('Rotation');
PLOT.slices = SCRPTGBL.CurrentScript.('Slices');
PLOT.insets = SCRPTGBL.CurrentScript.('Inset');
PLOT.scalefunc = SCRPTGBL.CurrentTree.('ImScalefunc').Func;      
PLOT.colour = SCRPTGBL.CurrentScript.('Colour');
PLOT.nRows = str2double(SCRPTGBL.CurrentScript.('nRows'));
PLOT.imsize = SCRPTGBL.CurrentScript.('imSize');
PLOT.slclbl = SCRPTGBL.CurrentScript.('SliceLabel');
PLOT.figno = SCRPTGBL.CurrentScript.('FigNo');

%---------------------------------------------
% Get Working Structures from Sub Functions
%---------------------------------------------
IMSCLipt = SCRPTGBL.CurrentTree.('ImScalefunc');
if isfield(SCRPTGBL,('ImScalefunc_Data'))
    IMSCLipt.ImScalefunc_Data = SCRPTGBL.ImScalefunc_Data;
end

%------------------------------------------
% Get Image Scale Info
%------------------------------------------
func = str2func(PLOT.scalefunc);           
[SCRPTipt,IMSCL,err] = func(SCRPTipt,IMSCLipt);
if err.flag
    return
end

%---------------------------------------------
% Plot
%---------------------------------------------
func = str2func([PLOT.method,'_Func']);
INPUT.IMG = IMG;
INPUT.IMSCL = IMSCL;
[PLOT,err] = func(PLOT,INPUT);
if err.flag
    return
end

%---------------------------------------------
% Return
%---------------------------------------------
SCRPTGBL.RWSUI.KeepEdit = 'yes';

