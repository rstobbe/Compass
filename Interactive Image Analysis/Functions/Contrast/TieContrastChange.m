%===================================================
% 
%===================================================
function TieContrastChange(src,event)

global IMAGEANLZ

tab = src.Parent.Parent.Parent.Tag;

if isempty(tab)
    tab = src.Parent.Parent.Parent.Parent.Parent.Tag;
end
axnum = str2double(src.Tag);
SetFocus(tab,axnum);

if not(IMAGEANLZ.(tab)(axnum).TestAxisActive);
    return
end

if not(isempty(IMAGEANLZ.(tab)(axnum).buttonfunction))
    error;          % shouldn't get here
end

%--------------------------------------------
% Toggle Contrast Hold
%--------------------------------------------
if strcmp(IMAGEANLZ.(tab)(axnum).presentation,'Standard')
    IMAGEANLZ.(tab)(axnum).ToggleTieContrast(src.Value); 
    otherax = 1;
    if axnum == 1
        otherax = 2;
    end

    if src.Value == 1
        IMAGEANLZ.(tab)(otherax).ChangeMaxContrastRel(IMAGEANLZ.(tab)(axnum).RelContrast(2));
        IMAGEANLZ.(tab)(otherax).ChangeMinContrastRel(IMAGEANLZ.(tab)(axnum).RelContrast(1));
    end
    IMAGEANLZ.(tab)(otherax).CopyTieContrast(IMAGEANLZ.(tab)(axnum))

end