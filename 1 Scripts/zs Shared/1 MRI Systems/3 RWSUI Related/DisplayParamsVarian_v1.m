%=====================================================
% 
%=====================================================

function [err] = DisplayParamsVarian_v1(path,tab)

global FIGOBJS

[Text,err] = Load_ParamsV_v1a(path);
if err.flag
    return
end

FIGOBJS.(tab).Info.String = Text;
