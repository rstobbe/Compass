%=========================================================
% (v1a) 
%       
%=========================================================

function [SCRPTipt,SCRPTGBL,err] = Create3DSurface_v1a(SCRPTipt,SCRPTGBL)

Status('busy','Plot Image Montage');
Status2('done','',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Get Input
%---------------------------------------------
PLOT.method = SCRPTGBL.CurrentScript.Func;
PLOT.type = SCRPTGBL.CurrentScript.('Type');
PLOT.insets = SCRPTGBL.CurrentScript.('Inset');
PLOT.scalefunc = SCRPTGBL.CurrentTree.('ImScalefunc').Func;      
PLOT.colour = SCRPTGBL.CurrentScript.('Colour');
PLOT.imsize = SCRPTGBL.CurrentScript.('imSize');
PLOT.figno = SCRPTGBL.CurrentScript.('FigNo');

%---------------------------------------------
% Get Input
%---------------------------------------------
if isfield(SCRPTGBL.('Image_File_Data'),'IMG');
    IMG = SCRPTGBL.('Image_File_Data').IMG;
elseif isfield(SCRPTGBL.('Image_File_Data'),'FTK');
    IMG.Im = SCRPTGBL.('Image_File_Data').FTK;
end

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

