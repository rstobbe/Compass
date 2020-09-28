%=========================================================
% Select a Script
%=========================================================

function SelectScript_B9(panelnum,tab,scrptnum)

Status2('busy','Select a Script to Build',1);

global DEFFILEGBL
global SCRPTPATHS
global SCRPTIPTGBL
global SCRPTGBL

if isempty(SCRPTPATHS.(tab)(panelnum).loc)
    SCRPTPATHS.(tab)(panelnum).loc = SCRPTPATHS.(tab)(panelnum).rootloc;
end

SCRPTGBL.(tab){panelnum,scrptnum} = [];
%----------------------------------------------------
% Select Folder
%----------------------------------------------------
path = uigetdir(SCRPTPATHS.(tab)(panelnum).loc,'Select Script to Build');
if path == 0
    err.flag = 4;
    err.msg = 'Script Not Selected';
    ErrDisp(err);
    return
end

%----------------------------------------------------
% Update SCRPTPATHS
%----------------------------------------------------
SCRPTPATHS.(tab)(panelnum).loc = path;
ind = strfind(path,'\Scripts');
temppath = path(1:ind(1)-1);
ind = strfind(temppath,'\');
Container = temppath(1:ind(end));

SCRPTPATHS.(tab)(panelnum).pioneerloc = Container;
SCRPTPATHS.(tab)(panelnum).newhorizonsloc = Container;
SCRPTPATHS.(tab)(panelnum).voyagerloc = Container;
SCRPTPATHS.(tab)(panelnum).galileoloc = Container;
SCRPTPATHS.(tab)(panelnum).apolloloc = Container;
SCRPTPATHS.(tab)(panelnum).mercuryloc = Container;
SCRPTPATHS.(tab)(panelnum).vikingloc = Container;

%----------------------------------------------------
% Test
%----------------------------------------------------
tok = strfind(path,filesep);
script = path(tok(length(tok))+1:length(path));
if not(exist([script,'_Default2'],'file'))
    rmpath(genpath(path));
    err.flag = 1;
    err.msg = 'Check if script on path';
    ErrDisp(err);
    return 
end

%----------------------------------------------------
% Load Current Panel
%----------------------------------------------------
[SCRPTipt] = LabelGet(tab,panelnum);
Options.scrptnum = scrptnum;
[Current] = PANlab2CellArray_B9(SCRPTipt,Options);

%----------------------------------------------------
% Add Script
%----------------------------------------------------
Current{scrptnum,1}.entrystr = script;
Current{scrptnum,1}.path = path;
func = str2func([script,'_Default2']);
ScrptDefaults = func(SCRPTPATHS.(tab)(panelnum));
[ScrptDefaults,err] = GetSubFunctions_B9(ScrptDefaults,tab,panelnum);
if err.flag
    ErrDisp(err);
    return
end
Current{scrptnum,2} = ScrptDefaults;
[SCRPTipt] = PanelRoutine(Current,tab,panelnum);
setfunc = 1;
DispScriptParam(SCRPTipt,setfunc,tab,panelnum);

%----------------------------------------------------
% Assign Default Values
%----------------------------------------------------
SCRPTIPTGBL.(tab)(panelnum).default(scrptnum,:) = Current(scrptnum,:);
DEFFILEGBL.(tab)(panelnum,scrptnum).file = '';
DEFFILEGBL.(tab)(panelnum,scrptnum).runfunc = '';

Status('done','Script Selected');
