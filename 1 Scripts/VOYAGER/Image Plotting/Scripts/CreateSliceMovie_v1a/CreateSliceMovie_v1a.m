%=========================================================
% (v1a) 
%       
%=========================================================

function [SCRPTipt,SCRPTGBL,err] = CreateSliceMovie_v1a(SCRPTipt,SCRPTGBL)

Status('busy','Plot Image Montage');
Status2('done','',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Clear Naming
%---------------------------------------------
inds = strcmp('Movie_Name',{SCRPTipt.labelstr});
indnum = find(inds==1);
if length(indnum) > 1
    indnum = indnum(SCRPTGBL.RWSUI.scrptnum);
end
SCRPTipt(indnum).entrystr = '';
setfunc = 1;
DispScriptParam_B9(SCRPTipt,setfunc,SCRPTGBL.RWSUI.panel);

%---------------------------------------------
% Test for File
%---------------------------------------------
if not(isfield(SCRPTGBL,'Image_File_Data'))
    if isfield(SCRPTGBL.CurrentTree.('Image_File').Struct,'selectedfile')
    file = SCRPTGBL.CurrentTree.('Image_File').Struct.selectedfile;
        if not(exist(file,'file'))
            err.flag = 1;
            err.msg = '(Re) Load Image_File - path no longer valid';
            ErrDisp(err);
            return
        else
            Status('busy','Load Trajectory Implementation');
            load(file);
            saveData.path = file;
            SCRPTGBL.('Image_File_Data') = saveData;
        end
    else
        err.flag = 1;
        err.msg = '(Re) Load Image_File';
        ErrDisp(err);
        return
    end
end

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
PLOT.imsize = SCRPTGBL.CurrentScript.('imSize');
PLOT.slclbl = SCRPTGBL.CurrentScript.('SliceLabel');
PLOT.figno = SCRPTGBL.CurrentScript.('FigNo');
PLOT.impath = SCRPTGBL.('Image_File_Data').path;

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

%--------------------------------------------
% Name
%--------------------------------------------
name = inputdlg('Name Movie:');
name = cell2mat(name);
if isempty(name)
    SCRPTGBL.RWSUI.KeepEdit = 'yes';
    return
end

%---------------------------------------------
% Return
%---------------------------------------------
SCRPTipt(indnum).entrystr = name;
SCRPTGBL.RWSUI.SaveVariables = {PLOT};
SCRPTGBL.RWSUI.SaveVariableNames = {'PLOT'};
SCRPTGBL.RWSUI.SaveGlobal = 'yes';
SCRPTGBL.RWSUI.SaveGlobalNames = name;
SCRPTGBL.RWSUI.SaveScriptOption = 'yes';
SCRPTGBL.RWSUI.SaveScriptPath = PLOT.impath;
SCRPTGBL.RWSUI.SaveScriptName = name;

Status('done','');
Status2('done','',2);
Status2('done','',3);

