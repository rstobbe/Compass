%=========================================================
% 
%=========================================================

function AddScriptSelect(tab,panelnum)

global SCRPTPATHS

[SCRPTipt] = LabelGet(tab,panelnum);
Options.panelnum = panelnum;
[Current] = PANlab2CellArray_B9(SCRPTipt,Options);

if isempty(Current{1,1})
    m = 1;
else
    [m,~] = size(Current);
    m = m+1;
end
Current{m,1}.entrytype = 'Scrpt';
Current{m,1}.labelstr = 'Script';
Current{m,1}.entrystr = '';
Current{m,1}.path = '';
Current{m,1}.searchpath = SCRPTPATHS.(tab).rootloc;
Current{m,2}{1,1} = [];

[SCRPTipt] = PanelRoutine(Current,tab,panelnum);
setfunc = 1;
DispScriptParam(SCRPTipt,setfunc,tab,panelnum);