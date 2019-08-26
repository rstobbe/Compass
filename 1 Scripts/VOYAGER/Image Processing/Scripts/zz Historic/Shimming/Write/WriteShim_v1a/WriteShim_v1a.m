%===========================================
% (v1a)
%       
%===========================================

function [SCRPTipt,SCRPTGBL,err] = WriteShim_v1a(SCRPTipt,SCRPTGBL)

global SCRPTPATHS
global RWSUIGBL

Status('busy','Write Shim');
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
        WRT.path = Gbl.FIDpath;
        WRT.file = ['SHIM_',Gbl.SaveName,'.mat'];
        loc = [WRT.path,WRT.file];
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
        auto = 1;
        Status('busy','Load Shim');
        load([WRT.path,WRT.file]);
        saveData.path = WRT.path;
        SCRPTGBL.('Shim_File_Data') = saveData;  
    end
end
if auto ~= 1
    if not(isfield(SCRPTGBL,'Shim_File_Data'))
        if isfield(SCRPTGBL.CurrentTree.('Shim_File').Struct,'selectedfile')
        file = SCRPTGBL.CurrentTree.('Shim_File').Struct.selectedfile;
            if not(exist(file,'file'))
                err.flag = 1;
                err.msg = '(Re) Load Shim_File - path no longer valid';
                ErrDisp(err);
                return
            else
                Status('busy','Load Shim');
                load(file);
                saveData.path = file;
                SCRPTGBL.('Shim_File_Data') = saveData;
            end
        else
            err.flag = 1;
            err.msg = '(Re) Load Shim_File';
            ErrDisp(err);
            return
        end
    end
end

%---------------------------------------------
% Clear Naming
%---------------------------------------------
inds = strcmp('Write_Name',{SCRPTipt.labelstr});
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
WRT.method = SCRPTGBL.CurrentTree.Func;
WRT.writefunc = SCRPTGBL.CurrentTree.('Writefunc').Func;

%---------------------------------------------
% Load Image
%---------------------------------------------
SHIM = SCRPTGBL.Shim_File_Data.SHIM;

%---------------------------------------------
% Get Working Structures from Sub Functions
%---------------------------------------------
WRTFipt = SCRPTGBL.CurrentTree.('Writefunc');
if isfield(SCRPTGBL,('Writefunc_Data'))
    WRTFipt.Writefunc_Data = SCRPTGBL.Writefunc_Data;
end

%------------------------------------------
% Get Write Function Info
%------------------------------------------
func = str2func(WRT.writefunc);           
[SCRPTipt,WRTF,err] = func(SCRPTipt,WRTFipt);
if err.flag
    return
end

%---------------------------------------------
% Shim
%---------------------------------------------
func = str2func([WRT.method,'_Func']);
INPUT.SHIM = SHIM;
INPUT.WRTF = WRTF;
[WRT,err] = func(WRT,INPUT);
if err.flag
    return
end

%--------------------------------------------
% Output to TextBox
%--------------------------------------------
WRT.ExpDisp = PanelStruct2Text(WRT.PanelOutput);
set(findobj('tag','TestBox'),'string',WRT.ExpDisp);

%--------------------------------------------
% Determine if AutoSave
%--------------------------------------------
if auto == 1;
    SCRPTGBL.RWSUI.SaveScript = 'yes';
    name = ['WRT_',Gbl.SaveName];
end

%--------------------------------------------
% Name
%--------------------------------------------
if auto == 0;
    name = inputdlg('Name Shim:','Name Shim',1,{'WRT_'});
    name = cell2mat(name);
    if isempty(name)
        SCRPTGBL.RWSUI.KeepEdit = 'yes';
        return
    end
end
WRT.name = name;
if not(isfield(WRT,'path'))
    WRT.path = 'outloc';
end

%--------------------------------------------
% Return
%--------------------------------------------
SCRPTipt(indnum).entrystr = name;
SCRPTGBL.RWSUI.SaveVariables = {WRT};
SCRPTGBL.RWSUI.SaveVariableNames = {'WRT'};
SCRPTGBL.RWSUI.SaveGlobal = 'yes';
SCRPTGBL.RWSUI.SaveGlobalNames = name;
SCRPTGBL.RWSUI.SaveScriptOption = 'yes';
SCRPTGBL.RWSUI.SaveScriptPath = WRT.path;
SCRPTGBL.RWSUI.SaveScriptName = name;

Status('done','');
Status2('done','',2);
Status2('done','',3);
