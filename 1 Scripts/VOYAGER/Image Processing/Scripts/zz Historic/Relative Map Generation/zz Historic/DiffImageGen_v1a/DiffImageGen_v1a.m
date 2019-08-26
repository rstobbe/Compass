%===========================================
% 
%===========================================

function [SCRPTipt,SCRPTGBL,err] = DiffImageGen_v1a(SCRPTipt,SCRPTGBL)

global SCRPTPATHS
global RWSUIGBL

Status('busy','Create Difference Image');
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
        COMP.path = Gbl.FIDpath;
        COMP.file = ['IMG_',Gbl.SaveName,'.mat'];
        loc = [COMP.path,COMP.file];
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
        SCRPTPATHS(RWSUI.panelnum).outloc = COMP.path;
        setfunc = 1;
        DispScriptParam_B9(SCRPTipt,setfunc,RWSUI.panel);
        auto = 1;
        Status('busy','Load Image');
        load([COMP.path,COMP.file]);
        saveData.path = COMP.path;
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

%---------------------------------------------
% Clear Naming
%---------------------------------------------
inds = strcmp('Image_Name',{SCRPTipt.labelstr});
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
COMP.method = SCRPTGBL.CurrentTree.Func;

%---------------------------------------------
% Load Image 
%---------------------------------------------
IMG = SCRPTGBL.Image_File_Data.IMG;

%---------------------------------------------
% Create Difference Image
%---------------------------------------------
func = str2func([COMP.method,'_Func']);
INPUT.IMG = IMG;
[COMP,err] = func(COMP,INPUT);
if err.flag
    return
end

%--------------------------------------------
% Output to TextBox
%--------------------------------------------
COMP.ExpDisp = PanelStruct2Text(COMP.PanelOutput);
set(findobj('tag','TestBox'),'string',COMP.ExpDisp);

%--------------------------------------------
% Determine if AutoSave
%--------------------------------------------
if auto == 1;
    SCRPTGBL.RWSUI.SaveScript = 'yes';
    name = ['COMP_',Gbl.SaveName];
end

%--------------------------------------------
% Name
%--------------------------------------------
if auto == 0;
    name = inputdlg('Name Shim:','Name Shim',1,{'COMP_'});
    name = cell2mat(name);
    if isempty(name)
        SCRPTGBL.RWSUI.KeepEdit = 'yes';
        return
    end
end
COMP.name = name;
if not(isfield(COMP,'path'))
    COMP.path = 'outloc';
end

%--------------------------------------------
% Return
%--------------------------------------------
SCRPTipt(indnum).entrystr = name;
SCRPTGBL.RWSUI.SaveVariables = {COMP};
SCRPTGBL.RWSUI.SaveVariableNames = {'COMP'};
SCRPTGBL.RWSUI.SaveGlobal = 'yes';
SCRPTGBL.RWSUI.SaveGlobalNames = name;
SCRPTGBL.RWSUI.SaveScriptOption = 'yes';
SCRPTGBL.RWSUI.SaveScriptPath = COMP.path;
SCRPTGBL.RWSUI.SaveScriptName = name;

Status('done','');
Status2('done','',2);
Status2('done','',3);
