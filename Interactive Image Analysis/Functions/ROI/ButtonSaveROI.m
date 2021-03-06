%===================================================
% 
%===================================================
function ButtonSaveROI(src,event)

global IMAGEANLZ

tab = src.Parent.Parent.Parent.Tag;
axnum = str2double(src.Tag);
switch IMAGEANLZ.(tab)(axnum).presentation
    case 'Standard'
        SetFocus(tab,axnum);
    case 'Ortho'
        axnum = GetFocus(tab);
        SetFocus(tab,axnum);
end
if not(IMAGEANLZ.(tab)(axnum).TestAxisActive);
    return
end

if IMAGEANLZ.(tab)(axnum).GETROIS ~= 1
    return
end       
CompleteCurrentROI(tab,axnum)


