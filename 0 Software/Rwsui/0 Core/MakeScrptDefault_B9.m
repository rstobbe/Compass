%====================================================
%
%====================================================

function MakeScrptDefault_B9(panelnum,tab,scrptnum)

Status('busy','Save Script');

global SCRPTPATHS
global SCRPTIPTGBL

if isempty(SCRPTPATHS.(tab)(panelnum).defloc)
    SCRPTPATHS.(tab)(panelnum).defloc = SCRPTPATHS.(tab)(panelnum).defrootloc;
end
if SCRPTPATHS.(tab)(panelnum).defloc == 0
    SCRPTPATHS.(tab)(panelnum).defloc = '';
end

%----------------------------------------------------
% Select Output Data
%----------------------------------------------------
[file,path] = uiputfile('*.mat','Save Script',SCRPTPATHS.(tab)(panelnum).defloc);
if path == 0
    err.flag = 4;
    err.msg = 'Script not saved';
    ErrDisp(err);
    return
end
defloc = path;
SCRPTPATHS.(tab)(panelnum).defloc = defloc;

%---------------------------------------------
% Write Naming
%---------------------------------------------
[SCRPTipt] = LabelGet(tab,panelnum);
inds = strcmp('Script_Name',{SCRPTipt.labelstr});
indnum = find(inds==1);
if length(indnum) > 1
    indnum = indnum(SCRPTGBL.RWSUI.scrptnum);
end
if not(isempty(indnum))
    SCRPTipt(indnum).entrystr = file(1:end-4);
    SCRPTipt(indnum).entrystruct.entrytype = 'ScriptName';
end

%----------------------------------------------------
% Update
%----------------------------------------------------
Options.scrptnum = scrptnum;
Options.makelocalcurrent = 'yes';
Options.excludelocaloutput = 'yes';
[Current] = PANlab2CellArray_B9(SCRPTipt,Options);

%----------------------------------------------------
% Display
%----------------------------------------------------
[SCRPTipt] = PanelRoutine(Current,tab,panelnum);   
setfunc = 1;
DispScriptParam(SCRPTipt,setfunc,tab,panelnum);

%--------------------------------------------
% Assign New Default Parameters
%--------------------------------------------
SCRPTIPTGBL.(tab)(panelnum).default(scrptnum,:) = Current(scrptnum,:);

%--------------------------------------------
% Save
%--------------------------------------------
ScrptCellArray = Current(scrptnum,:);
save([path,file],'ScrptCellArray');

Status('done','');
