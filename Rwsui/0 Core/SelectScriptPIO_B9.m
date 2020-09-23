%=========================================================
% Select a Script
%=========================================================

function SelectScriptPIO_B9(panelnum,tab,scrptnum)

error;          %fix

Status('busy','Select a Script');

global SCRPTPATHS
global SCRPTIPTGBL
global SCRPTGBL

err.flag = 0;
err.msg = '';

if isempty(SCRPTPATHS(scrptnum).loc)
    SCRPTPATHS(scrptnum).loc = SCRPTPATHS(scrptnum).rootloc;
end

SCRPTGBL{panelnum,scrptnum} = struct();
%----------------------------------------------------
% Select Folder
%----------------------------------------------------
path = uigetdir(SCRPTPATHS(panelnum).loc,'Select Script');
if path == 0
    err.flag = 4;
    err.msg = 'Script Not Selected';
    ErrDisp(err);
    return
end
addpath(genpath(path));
SCRPTPATHS(scrptnum).loc = path;

%----------------------------------------------------
% Test
%----------------------------------------------------
tok = strfind(path,filesep);
script = path(tok(length(tok))+1:length(path));
if not(exist([script,'_Default2'],'file'))
    rmpath(genpath(path));
    err.flag = 1;
    err.msg = 'Folder Does Not Contain Selectable Script';
    ErrDisp(err);
    return 
end

%----------------------------------------------------
% Set Script
%----------------------------------------------------
tok = strfind(path,filesep);
script = path(tok(length(tok))+1:length(path));
set(findobj('type','uicontrol','tag',[panel,'scriptentry']),'string',script);
set(findobj('type','uicontrol','tag',[panel,'scriptentry']),'visible','on');

%----------------------------------------------------
% Load Current Panel
%----------------------------------------------------
[SCRPTipt] = LabelGet_B9(panel);
Options.scrptnum = scrptnum;
[Current] = PANlab2CellArray_B9(SCRPTipt,Options);

%----------------------------------------------------
% Add Script
%----------------------------------------------------
Current{scrptnum,1}.entrytype = 'Scrpt';
Current{scrptnum,1}.labelstr = 'Script';
Current{scrptnum,1}.entrystr = script;
Current{scrptnum,1}.searchpath = SCRPTPATHS.rootloc;
Current{scrptnum,1}.path = path;
func = str2func([script,'_Default2']);
[ScrptDefaults] = func(SCRPTPATHS(panelnum));
ScrptDefaults = GetSubFunctions_B9(ScrptDefaults,panelnum);
Current{scrptnum,2} = ScrptDefaults;
[SCRPTipt] = PanelRoutine_B9(Current,panel,panelnum);
setfunc = 1;
DispScriptParam_B9(SCRPTipt,setfunc,panel);

%----------------------------------------------------
% Assign Default Values
%----------------------------------------------------
SCRPTIPTGBL(panelnum).default(scrptnum,:) = Current(scrptnum,:);

Status('done','Script Selected');
