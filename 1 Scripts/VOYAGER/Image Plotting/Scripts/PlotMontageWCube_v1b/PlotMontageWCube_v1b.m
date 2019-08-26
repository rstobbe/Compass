%=========================================================
% (v1d) 
%       - loading changes    
%       - saving option
%=========================================================

function [SCRPTipt,SCRPTGBL,err] = PlotMontageWCube_v1b(SCRPTipt,SCRPTGBL)

Status('busy','Plot Image Montage');
Status2('done','',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';
global TOTALGBL
global SCRPTPATHS
global RWSUIGBL
RWSUI = SCRPTGBL.RWSUI;

%---------------------------------------------
% Clear Naming
%---------------------------------------------
inds = strcmp('Plot_Name',{SCRPTipt.labelstr});
indnum = find(inds==1);
if length(indnum) > 1
    indnum = indnum(SCRPTGBL.RWSUI.scrptnum);
end
SCRPTipt(indnum).entrystr = '';
setfunc = 1;
DispScriptParam_B9(SCRPTipt,setfunc,SCRPTGBL.RWSUI.panel);

%---------------------------------------------
% Get Input
%---------------------------------------------
PLOT.method = SCRPTGBL.CurrentScript.Func;
PLOT.load = SCRPTGBL.CurrentScript.('Load');
PLOT.type = SCRPTGBL.CurrentScript.('Type');
PLOT.orient = SCRPTGBL.CurrentScript.('Orientation');
PLOT.rotation = SCRPTGBL.CurrentScript.('Rotation');
PLOT.imnum = str2double(SCRPTGBL.CurrentScript.('ImNum'));
PLOT.slices = SCRPTGBL.CurrentScript.('Slices');
PLOT.insets = SCRPTGBL.CurrentScript.('Inset');
PLOT.scalefunc = SCRPTGBL.CurrentTree.('ImScalefunc').Func;      
PLOT.colour = SCRPTGBL.CurrentScript.('Colour');
PLOT.nRows = str2double(SCRPTGBL.CurrentScript.('nRows'));
PLOT.imsize = SCRPTGBL.CurrentScript.('imSize');
PLOT.slclbl = SCRPTGBL.CurrentScript.('SliceLabel');
PLOT.figno = SCRPTGBL.CurrentScript.('FigNo');

%---------------------------------------------
% Get Image
%---------------------------------------------
auto = 0;
if strcmp(PLOT.load,'Local')
    val = get(findobj('tag','totalgbl'),'value');
    if isempty(val) || val == 0
        err.flag = 1;
        err.msg = 'No Image in Global Memory';
        return  
    end
    IMG = TOTALGBL{2,val};
    if not(isfield(IMG,'Im'))
        err.flag = 1;
        err.msg = 'Global Does Not Contain Image';
        return
    end
else
    val = get(findobj('tag','totalgbl'),'value');
    if not(isempty(val)) && val ~= 0
        Gbl = TOTALGBL{2,val};
        if isfield(Gbl,'AutoRecon')
            IMG.path = Gbl.FIDpath;
            loc = Gbl.FIDpath;
            label = loc;
            if length(label) > RWSUIGBL.fullwid
                ind = strfind(loc,filesep);
                n = 1;
                while true
                    label = ['...',loc(ind(n)+1:length(loc))];
                    if length(label) <= RWSUIGBL.fullwid
                        break
                    end
                    n = n+1;
                end
            end
            inds = strcmp('Image_File',{SCRPTipt.labelstr});
            indnum = find(inds==1);
            if length(indnum) > 1
                indnum = indnum(SCRPTGBL.RWSUI.scrptnum);
            end
            SCRPTipt(indnum).entrystr = label;
            SCRPTipt(indnum).entrystruct.entrystr = label;
            SCRPTipt(indnum).entrystruct.altval = 1;
            SCRPTipt(indnum).entrystruct.selectedfile = loc;
            SCRPTipt(indnum).entrystruct.('LoadMatFileCur_v4').curloc = loc; 
            SCRPTPATHS(RWSUI.panelnum).outloc = loc;
            setfunc = 1;
            DispScriptParam_B9(SCRPTipt,setfunc,RWSUI.panel);
            file = [loc,'IMG_',Gbl.SaveName];
            SCRPTGBL.CurrentTree.('IMG_File_Data').Struct.selectedfile = file;
            load(file);
            saveData.path = loc;
            SCRPTGBL.('Image_File_Data') = saveData;
            auto = 1;
        end
    end
    if not(isfield(SCRPTGBL,'Image_File_Data'))
        if isfield(SCRPTGBL.CurrentTree.('Image_File').Struct,'selectedfile')
        file = SCRPTGBL.CurrentTree.('Image_File').Struct.selectedfile;
            if not(exist(file,'file'))
                err.flag = 1;
                err.msg = '(Re) Load Image_File - path no longer valid';
                ErrDisp(err);
                return
            else
                Status('busy','Loading Image');
                load(file);
                saveData.path = file;
                SCRPTGBL.('Image_File_Data') = saveData;
            end
        else
            err.flag = 1;
            err.msg = '(Re) Load Image_File';
            return
        end
    end
    PLOT.impath = SCRPTGBL.('Image_File_Data').path;
    if isfield(SCRPTGBL.('Image_File_Data'),'IMG');
        IMG = SCRPTGBL.('Image_File_Data').IMG;
    elseif isfield(SCRPTGBL.('Image_File_Data'),'FTK');
        IMG.Im = SCRPTGBL.('Image_File_Data').FTK;
    else
        err.flag = 1;
        err.msg = 'Image_File Selection Does Not Contain An Image';
        return
    end
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
% Output to TextBox
%--------------------------------------------
IMG.ExpDisp = PanelStruct2Text(IMG.PanelOutput);
set(findobj('tag','TestBox'),'string',IMG.ExpDisp);

%--------------------------------------------
% Determine if AutoSave
%--------------------------------------------
if auto == 1;
    SCRPTGBL.RWSUI.SaveScript = 'yes';
    name = ['PLOT_',Gbl.SaveName];
end

%--------------------------------------------
% Name
%--------------------------------------------
if auto == 0;
    ind = strfind(IMG.name,'IMG');
    if not(isempty(ind))
        name0 = ['PLOT_',IMG.name(5:end)];
    else
        name0 = 'PLOT_';
    end
    if strcmp(PLOT.load,'File')
    name = inputdlg('Name Image:','Name Image',1,{name0});
        name = cell2mat(name);
        if isempty(name)
            SCRPTGBL.RWSUI.KeepEdit = 'yes';
            return
        end
    else
        SCRPTGBL.RWSUI.KeepEdit = 'yes';
        return
    end
end
PLOT.name = name;

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
