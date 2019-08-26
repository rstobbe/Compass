%===========================================
% (v1a)
%    
%===========================================

function [SCRPTipt,SCRPTGBL,err] = B1Mapping_v1a(SCRPTipt,SCRPTGBL)

Status('busy','Map B1');
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
inds = strcmp('Image_Name',{SCRPTipt.labelstr});
indnum = find(inds==1);
if length(indnum) > 1
    indnum = indnum(SCRPTGBL.RWSUI.scrptnum);
end
SCRPTipt(indnum).entrystr = '';
setfunc = 1;
DispScriptParam_B9(SCRPTipt,setfunc,SCRPTGBL.RWSUI.panel);

%---------------------------------------------
% Return Panel Input
%---------------------------------------------
B1MAP.method = SCRPTGBL.CurrentTree.Func;
B1MAP.load = SCRPTGBL.CurrentScript.('Load');
B1MAP.mapfunc = SCRPTGBL.CurrentTree.('B1Mapfunc').Func;
B1MAP.dispfunc = SCRPTGBL.CurrentTree.('Dispfunc').Func;

%---------------------------------------------
% Get Image
%---------------------------------------------
auto = 0;
if strcmp(B1MAP.load,'Local')
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
            SCRPTGBL.CurrentTree.('Image_File_Data').Struct.selectedfile = file;
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
    B1MAP.impath = SCRPTGBL.('Image_File_Data').path;
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
MAPipt = SCRPTGBL.CurrentTree.('B1Mapfunc');
if isfield(SCRPTGBL,('B1Mapfunc_Data'))
    MAPipt.B1Mapfunc_Data = SCRPTGBL.B1Mapfunc_Data;
end
DISPipt = SCRPTGBL.CurrentTree.('Dispfunc');
if isfield(SCRPTGBL,('Dispfunc_Data'))
    DISPipt.Dispfunc_Data = SCRPTGBL.Dispfunc_Data;
end

%------------------------------------------
% Get Mapping Function Info
%------------------------------------------
func = str2func(B1MAP.mapfunc);           
[SCRPTipt,MAP,err] = func(SCRPTipt,MAPipt);
if err.flag
    return
end

%------------------------------------------
% Get Display Function Info
%------------------------------------------
func = str2func(B1MAP.dispfunc);           
[SCRPTipt,DISP,err] = func(SCRPTipt,DISPipt);
if err.flag
    return
end

%---------------------------------------------
% B1 Map
%---------------------------------------------
func = str2func([B1MAP.method,'_Func']);
INPUT.IMG = IMG;
INPUT.MAP = MAP;
INPUT.DISP = DISP;
[B1MAP,err] = func(B1MAP,INPUT);
if err.flag
    return
end

%--------------------------------------------
% Output to TextBox
%--------------------------------------------
B1MAP.ExpDisp = PanelStruct2Text(B1MAP.PanelOutput);
set(findobj('tag','TestBox'),'string',B1MAP.ExpDisp);

%--------------------------------------------
% Determine if AutoSave
%--------------------------------------------
if auto == 1;
    SCRPTGBL.RWSUI.SaveScript = 'yes';
    name = ['B1MAP_',Gbl.SaveName];
end

%--------------------------------------------
% Name
%--------------------------------------------
if auto == 0;
    ind = strfind(IMG.name,'IMG');
    if not(isempty(ind))
        name0 = ['B1MAP_',IMG.name(5:end)];
    else
        name0 = 'B1MAP_';
    end
    if strcmp(B1MAP.load,'File')
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
B1MAP.name = name;

%--------------------------------------------
% Return
%--------------------------------------------
SCRPTipt(indnum).entrystr = name;
SCRPTGBL.RWSUI.SaveVariables = {B1MAP};
SCRPTGBL.RWSUI.SaveVariableNames = 'IMG';
SCRPTGBL.RWSUI.SaveGlobal = 'yes';
SCRPTGBL.RWSUI.SaveGlobalNames = name;
SCRPTGBL.RWSUI.SaveScriptOption = 'yes';
SCRPTGBL.RWSUI.SaveScriptPath = 'outloc';
SCRPTGBL.RWSUI.SaveScriptName = name;

Status('done','');
Status2('done','',2);
Status2('done','',3);

