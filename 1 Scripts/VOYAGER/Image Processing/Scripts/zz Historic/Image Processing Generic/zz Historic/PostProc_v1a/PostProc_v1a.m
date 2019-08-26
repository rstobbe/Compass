%===========================================
% (v1a)
%    
%===========================================

function [SCRPTipt,SCRPTGBL,err] = SeqSpecProc_v1a(SCRPTipt,SCRPTGBL)

Status('busy','Sequence Specific Processing');
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
%setfunc = 1;
%DispScriptParam_B9(SCRPTipt,setfunc,SCRPTGBL.RWSUI.panel);

%---------------------------------------------
% Return Panel Input
%---------------------------------------------
PROC.method = SCRPTGBL.CurrentTree.Func;
PROC.load = SCRPTGBL.CurrentScript.('Load');
PROC.procfunc = SCRPTGBL.CurrentTree.('PostProcfunc').Func;

%---------------------------------------------
% Get Image
%---------------------------------------------
auto = 0;
if strcmp(PROC.load,'Local')
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
    PROC.impath = SCRPTGBL.('Image_File_Data').path;
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
FUNCipt = SCRPTGBL.CurrentTree.('PostProcfunc');
if isfield(SCRPTGBL,('PostProcfunc_Data'))
    FUNCipt.PostProcfunc_Data = SCRPTGBL.PostProcfunc_Data;
end

%------------------------------------------
% Get Function Info
%------------------------------------------
func = str2func(PROC.procfunc);           
[SCRPTipt,FUNC,err] = func(SCRPTipt,FUNCipt);
if err.flag
    return
end

%---------------------------------------------
% Post Process
%---------------------------------------------
func = str2func([PROC.method,'_Func']);
INPUT.IMG = IMG;
INPUT.FUNC = FUNC;
[PROC,err] = func(PROC,INPUT);
if err.flag
    return
end

%--------------------------------------------
% Output to TextBox
%--------------------------------------------
PROC.ExpDisp = PanelStruct2Text(IMG.PanelOutput);
set(findobj('tag','TestBox'),'string',PROC.ExpDisp);

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
    ind = strfind(IMG.name,'IMG');
    if not(isempty(ind))
        name0 = ['PROC_',IMG.name(5:end)];
    else
        name0 = 'PROC_';
    end
    if strcmp(PROC.load,'File')
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
PROC.name = name;

%--------------------------------------------
% Return
%--------------------------------------------
SCRPTipt(indnum).entrystr = name;
SCRPTGBL.RWSUI.SaveVariables = {PROC};
SCRPTGBL.RWSUI.SaveVariableNames = 'IMG';
SCRPTGBL.RWSUI.SaveGlobal = 'yes';
SCRPTGBL.RWSUI.SaveGlobalNames = name;
SCRPTGBL.RWSUI.SaveScriptOption = 'yes';
SCRPTGBL.RWSUI.SaveScriptPath = PROC.impath;
SCRPTGBL.RWSUI.SaveScriptName = name;

Status('done','');
Status2('done','',2);
Status2('done','',3);

