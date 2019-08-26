%===========================================
% (v1b)
%       - (include test/update for image size)
%===========================================

function [SCRPTipt,SCRPTGBL,err] = B0ShimHead3TE_v1b(SCRPTipt,SCRPTGBL)

global SCRPTPATHS
global RWSUIGBL

Status('busy','Shim B0');
Status2('done','',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Tests
%---------------------------------------------
RWSUI = SCRPTGBL.RWSUI;
global TOTALGBL
val = get(findobj('tag','totalgbl'),'value');
auto = 0;
if not(isempty(val)) && val ~= 0
    Gbl = TOTALGBL{2,val};
    if isfield(Gbl,'AutoRecon')
        SHIM.path = Gbl.FIDpath;
        SHIM.file = ['IMG_',Gbl.SaveName,'.mat'];
        loc = [SHIM.path,SHIM.file];
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
        SCRPTipt(indnum).entrystruct.('LoadImageCur_v4').curloc = loc; 
        SCRPTPATHS(RWSUI.panelnum).outloc = SHIM.path;
        setfunc = 1;
        DispScriptParam_B9(SCRPTipt,setfunc,RWSUI.panel);
        auto = 1;
        Status('busy','Load Image');
        load([SHIM.path,SHIM.file]);
        saveData.path = SHIM.path;
        SCRPTGBL.('Image_File_Data') = saveData;  
    end
end
if auto ~= 1
    if not(isfield(SCRPTGBL,'Image_File_Data'))
        if isfield(SCRPTGBL.CurrentTree.('Image_File').Struct,'selectedfile')
        file = SCRPTGBL.CurrentTree.('Image_File').Struct.selectedfile;
            if not(exist(file,'file'))
                err.flag = 1;
                err.msg = '(Re) Load Image_File - path no longer valid';
                ErrDisp(err);
                return
            else
                Status('busy','Load Image');
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
end
if not(isfield(SCRPTGBL,'Cal_File_Data'))
    if isfield(SCRPTGBL.CurrentTree.('Cal_File').Struct,'selectedfile')
    file = SCRPTGBL.CurrentTree.('Cal_File').Struct.selectedfile;
        if not(exist(file,'file'))
            err.flag = 1;
            err.msg = '(Re) Load Cal_File - path no longer valid';
            ErrDisp(err);
            return
        else
            Status('busy','Load Calibration File');
            load(file);
            saveData.path = file;
            SCRPTGBL.('Cal_File_Data') = saveData;
        end
    else
        err.flag = 1;
        err.msg = '(Re) Load Cal_File';
        ErrDisp(err);
        return
    end
end  

%---------------------------------------------
% Clear Naming
%---------------------------------------------
inds = strcmp('Shim_Name',{SCRPTipt.labelstr});
indnum = find(inds==1);
if length(indnum) > 1
    indnum = indnum(SCRPTGBL.RWSUI.scrptnum);
end
SCRPTipt(indnum).entrystr = '';
setfunc = 1;
DispScriptParam_B9(SCRPTipt,setfunc,SCRPTGBL.RWSUI.panel);

%---------------------------------------------
% Clear Text Box
%---------------------------------------------
%set(findobj('tag','TestBox'),'string','');

%---------------------------------------------
% Load Input
%---------------------------------------------
SHIM.method = SCRPTGBL.CurrentTree.Func;
SHIM.mapfunc = SCRPTGBL.CurrentTree.('B0Mapfunc').Func;
SHIM.maskfunc = SCRPTGBL.CurrentTree.('Maskfunc').Func;
SHIM.fitfunc = SCRPTGBL.CurrentTree.('Shimfunc').Func;
SHIM.dispfunc = SCRPTGBL.CurrentTree.('Dispfunc').Func;

%---------------------------------------------
% Load Image and Calibration
%---------------------------------------------
IMG = SCRPTGBL.Image_File_Data.IMG;
CAL = SCRPTGBL.Cal_File_Data.CAL;

%---------------------------------------------
% Get Working Structures from Sub Functions
%---------------------------------------------
MAPipt = SCRPTGBL.CurrentTree.('B0Mapfunc');
if isfield(SCRPTGBL,('B0Mapfunc_Data'))
    MAPipt.B0Mapfunc_Data = SCRPTGBL.B0Mapfunc_Data;
end
MASKipt = SCRPTGBL.CurrentTree.('Maskfunc');
if isfield(SCRPTGBL,('Maskfunc_Data'))
    MASKipt.Maskfunc_Data = SCRPTGBL.Maskfunc_Data;
end
FITipt = SCRPTGBL.CurrentTree.('Shimfunc');
if isfield(SCRPTGBL,('Shimfunc_Data'))
    FITipt.Shimfunc_Data = SCRPTGBL.Shimfunc_Data;
end
DISPipt = SCRPTGBL.CurrentTree.('Dispfunc');
if isfield(SCRPTGBL,('Dispfunc_Data'))
    DISPipt.Dispfunc_Data = SCRPTGBL.Dispfunc_Data;
end

%------------------------------------------
% Get Function Info
%------------------------------------------
func = str2func(SHIM.mapfunc);           
[SCRPTipt,MAP,err] = func(SCRPTipt,MAPipt);
if err.flag
    return
end
func = str2func(SHIM.maskfunc);           
[SCRPTipt,MASK,err] = func(SCRPTipt,MASKipt);
if err.flag
    return
end
func = str2func(SHIM.fitfunc);           
[SCRPTipt,FIT,err] = func(SCRPTipt,FITipt);
if err.flag
    return
end
func = str2func(SHIM.dispfunc);
[SCRPTipt,DISP,err] = func(SCRPTipt,DISPipt);
if err.flag
    return
end

%---------------------------------------------
% Shim
%---------------------------------------------
func = str2func([SHIM.method,'_Func']);
INPUT.IMG = IMG;
INPUT.CAL = CAL;
INPUT.MAP = MAP;
INPUT.MASK = MASK;
INPUT.FIT = FIT;
INPUT.DISP = DISP;
INPUT.SCRPTipt = SCRPTipt;
INPUT.SCRPTGBL = SCRPTGBL;
[SHIM,err] = func(SHIM,INPUT);
if err.flag
    return
end
SCRPTipt = SHIM.SCRPTipt;

%--------------------------------------------
% Output to TextBox
%--------------------------------------------
SHIM.ExpDisp = PanelStruct2Text(SHIM.PanelOutput);
set(findobj('tag','TestBox'),'string',SHIM.ExpDisp);

%--------------------------------------------
% Determine if AutoSave
%--------------------------------------------
if auto == 1;
    SCRPTGBL.RWSUI.SaveScript = 'yes';
    name = ['PROC_',Gbl.SaveName];
end

%--------------------------------------------
% Name
%--------------------------------------------
if auto == 0;
    name = inputdlg('Name Shim:','Name Shim',1,{'PROC_'});
    name = cell2mat(name);
    if isempty(name)
        SCRPTGBL.RWSUI.KeepEdit = 'yes';
        return
    end
end
SHIM.name = name;
if not(isfield(SHIM,'path'))
    SHIM.path = 'outloc';
end

%--------------------------------------------
% Return
%--------------------------------------------
SCRPTipt(indnum).entrystr = name;
SCRPTGBL.RWSUI.SaveVariables = {SHIM};
SCRPTGBL.RWSUI.SaveVariableNames = {'SHIM'};
SCRPTGBL.RWSUI.SaveGlobal = 'yes';
SCRPTGBL.RWSUI.SaveGlobalNames = name;
SCRPTGBL.RWSUI.SaveScriptOption = 'yes';
SCRPTGBL.RWSUI.SaveScriptPath = SHIM.path;
SCRPTGBL.RWSUI.SaveScriptName = name;

Status('done','');
Status2('done','',2);
Status2('done','',3);
