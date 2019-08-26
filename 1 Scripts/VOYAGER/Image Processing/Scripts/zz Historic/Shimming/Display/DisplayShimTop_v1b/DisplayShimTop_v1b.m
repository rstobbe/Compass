%=========================================================
% (v1a) 
%       
%=========================================================

function [SCRPTipt,SCRPTGBL,err] = DisplayShimTop_v1b(SCRPTipt,SCRPTGBL)

Status('busy','Display Shim');
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
DISP.method = SCRPTGBL.CurrentTree.Func;
DISP.load = SCRPTGBL.CurrentScript.('Load');
DISP.plotfunc = SCRPTGBL.CurrentTree.('Dispfunc').Func;

%---------------------------------------------
% Get Shim
%---------------------------------------------
auto = 0;
if strcmp(DISP.load,'Local')
    val = get(findobj('tag','totalgbl'),'value');
    if isempty(val) || val == 0
        err.flag = 1;
        err.msg = 'No Image in Global Memory';
        return  
    end
    SHIM = TOTALGBL{2,val};
    if not(isfield(SHIM,'fMap') && isfield(SHIM,'Prof'))
        err.flag = 1;
        err.msg = 'Global Does Not Contain Shimming Info';
        return
    end
else
    val = get(findobj('tag','totalgbl'),'value');
    if not(isempty(val)) && val ~= 0
        Gbl = TOTALGBL{2,val};
        if isfield(Gbl,'AutoRecon')
            SHIM.path = Gbl.FIDpath;
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
            inds = strcmp('Shim_File',{SCRPTipt.labelstr});
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
            file = [loc,'SHIM_',Gbl.SaveName];
            SCRPTGBL.CurrentTree.('Shim_File_Data').Struct.selectedfile = file;
            load(file);
            saveData.path = loc;
            SCRPTGBL.('Shim_File_Data') = saveData;
            auto = 1;
        end
    end
    if not(isfield(SCRPTGBL,'Shim_File_Data'))
        if isfield(SCRPTGBL.CurrentTree.('Shim_File').Struct,'selectedfile')
        file = SCRPTGBL.CurrentTree.('Shim_File').Struct.selectedfile;
            if not(exist(file,'file'))
                err.flag = 1;
                err.msg = '(Re) Load Shim_File - path no longer valid';
                ErrDisp(err);
                return
            else
                Status('busy','Loading Image');
                load(file);
                saveData.path = file;
                SCRPTGBL.('Shim_File_Data') = saveData;
            end
        else
            err.flag = 1;
            err.msg = '(Re) Load Shim_File';
            return
        end
    end
    DISP.impath = SCRPTGBL.('Shim_File_Data').path;
    if isfield(SCRPTGBL.('Shim_File_Data'),'SHIM');
        SHIM = SCRPTGBL.('Shim_File_Data').SHIM;
    else
        err.flag = 1;
        err.msg = 'Shim_File Selection Does Not Contain Shimming Data';
        return
    end
end

%---------------------------------------------
% Get Working Structures from Sub Functions
%---------------------------------------------
PLOTipt = SCRPTGBL.CurrentTree.('Dispfunc');
if isfield(SCRPTGBL,('Dispfunc_Data'))
    PLOTipt.Dispfunc_Data = SCRPTGBL.Dispfunc_Data;
end

%------------------------------------------
% Get Disp Function Info
%------------------------------------------
func = str2func(DISP.plotfunc);           
[SCRPTipt,PLOT,err] = func(SCRPTipt,PLOTipt);
if err.flag
    return
end

%---------------------------------------------
% Shim
%---------------------------------------------
func = str2func([DISP.method,'_Func']);
INPUT.SHIM = SHIM;
INPUT.PLOT = PLOT;
[DISP,err] = func(DISP,INPUT);
if err.flag
    return
end

%--------------------------------------------
% Output to TextBox
%--------------------------------------------
DISP.ExpDisp = PanelStruct2Text(SHIM.PanelOutput);
set(findobj('tag','TestBox'),'string',DISP.ExpDisp);

%--------------------------------------------
% Determine if AutoSave
%--------------------------------------------
if auto == 1;
    SCRPTGBL.RWSUI.SaveScript = 'yes';
    name = ['DISP_',Gbl.SaveName];
end

%--------------------------------------------
% Name
%--------------------------------------------
if auto == 0;
    ind = strfind(SHIM.name,'SHIM');
    if not(isempty(ind))
        name0 = ['DISP_',SHIM.name(6:end)];
    else
        name0 = 'DISP_';
    end
    if strcmp(DISP.load,'File')
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
DISP.name = name;

%---------------------------------------------
% Return
%---------------------------------------------
SCRPTipt(indnum).entrystr = name;
SCRPTGBL.RWSUI.SaveVariables = {DISP};
SCRPTGBL.RWSUI.SaveVariableNames = {'DISP'};
SCRPTGBL.RWSUI.SaveGlobal = 'yes';
SCRPTGBL.RWSUI.SaveGlobalNames = name;
SCRPTGBL.RWSUI.SaveScriptOption = 'yes';
SCRPTGBL.RWSUI.SaveScriptPath = DISP.impath;
SCRPTGBL.RWSUI.SaveScriptName = name;

Status('done','');
Status2('done','',2);
Status2('done','',3);
