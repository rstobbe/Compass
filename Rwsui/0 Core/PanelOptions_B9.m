%=========================================================
% 
%=========================================================

function [err] = PanelOptions_B9(panelnum,panel)

err.flag = 0;
err.msg = '';

[s,v] = listdlg('PromptString','Script Action:','SelectionMode','single','ListString',{'New Script Search Paths'});

if isempty(s)
    return
end

switch s    
case 1
    NewScriptSearchPaths_B9(panelnum,panel);
end




