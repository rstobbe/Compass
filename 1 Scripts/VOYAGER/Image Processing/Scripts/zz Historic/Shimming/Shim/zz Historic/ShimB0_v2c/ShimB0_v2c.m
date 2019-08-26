%===========================================
% (v2c)
%       - Remove Writing
%===========================================

function [SCRPTipt,SCRPTGBL,err] = ShimB0_v2c(SCRPTipt,SCRPTGBL)

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
        Status('busy','Load Trajectory Implementation');
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
set(findobj('tag','TestBox'),'string','');

%---------------------------------------------
% Load Input
%---------------------------------------------
SHIM.method = SCRPTGBL.CurrentTree.Func;
SHIM.shimfunc = SCRPTGBL.CurrentTree.('B0Shimfunc').Func;

%---------------------------------------------
% Load Image
%---------------------------------------------
Im = SCRPTGBL.Image_File_Data.IMG.Im;
ReconPars = SCRPTGBL.Image_File_Data.IMG.ReconPars;
Shims = SCRPTGBL.Image_File_Data.IMG.FID.Shim;

%---------------------------------------------
% Get Working Structures from Sub Functions
%---------------------------------------------
B0SHIMipt = SCRPTGBL.CurrentTree.('B0Shimfunc');
if isfield(SCRPTGBL,('B0Shimfunc_Data'))
    B0SHIMipt.B0Shimfunc_Data = SCRPTGBL.B0Shimfunc_Data;
end

%------------------------------------------
% Get Shim Function Info
%------------------------------------------
func = str2func(SHIM.shimfunc);           
[SCRPTipt,B0SHIM,err] = func(SCRPTipt,B0SHIMipt);
if err.flag
    return
end

%---------------------------------------------
% Shim
%---------------------------------------------
func = str2func([SHIM.method,'_Func']);
INPUT.Im = Im;
INPUT.ReconPars = ReconPars;
INPUT.Shims = Shims;
INPUT.B0SHIM = B0SHIM;
[SHIM,err] = func(SHIM,INPUT);
if err.flag
    return
end

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
    name = ['SHIM_',Gbl.SaveName];
end

%--------------------------------------------
% Name
%--------------------------------------------
if auto == 0;
    name = inputdlg('Name Shim:','Name Shim',1,{'SHIM_'});
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
