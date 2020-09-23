%===================================================
%
%===================================================
function AutoUpdateChange(src,event)

global IMAGEANLZ

tab = src.Parent.Parent.Parent.Tag;
axnum = str2double(src.Tag);
SetFocus(tab,axnum);

switch IMAGEANLZ.(tab)(axnum).presentation
    case 'Standard'
        if IMAGEANLZ.(tab)(axnum).ROITIE == 1
            for n = 1:IMAGEANLZ.(tab)(axnum).axeslen
                IMAGEANLZ.(tab)(n).AutoUpdateROIChange(src.Value);
            end
        else
            IMAGEANLZ.(tab)(axnum).AutoUpdateROIChange(src.Value);
        end
    case 'Ortho'
        IMAGEANLZ.(tab)(1).AutoUpdateROIChange(src.Value);
end




