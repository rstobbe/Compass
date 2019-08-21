%=========================================================
% 
%=========================================================

function [err] = CompositeOptions_B9(panelnum,panel)

err.flag = 0;
err.msg = '';

[s,v] = listdlg('PromptString','Script Action:','SelectionMode','single','ListString',{'Make Composite'});

if isempty(s)
    return
end

switch s    
case 1
    MakeComposite_B9(panelnum,panel);
end




