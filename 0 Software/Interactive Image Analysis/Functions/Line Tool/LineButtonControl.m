%====================================================
% 
%====================================================
function LineButtonControl(src,event)

global IMAGEANLZ
global RWSUIGBL

tab = src.Parent.Parent.Parent.Tag;
linearr = src.UserData;
axnum = linearr(1);
linenum = linearr(2);

switch IMAGEANLZ.(tab)(axnum).presentation
    case 'Standard'
        SetFocus(tab,axnum);
end

for n = 1:IMAGEANLZ.(tab)(1).axeslen
    if not(isempty(IMAGEANLZ.(tab)(n).buttonfunction))
        return
    end
end	

IMAGEANLZ.(tab)(axnum).HighlightLine(linenum);
switch RWSUIGBL.Character
    case 'a'
        if ~IMAGEANLZ.(tab)(axnum).TestLineActivated(linenum)
            ActivateLine(src,tab,axnum,linenum);
        else
            DeactivateLine(src,tab,axnum,linenum);
        end
        return
    case 'A'
        if ~IMAGEANLZ.(tab)(axnum).TestLineActivated(linenum)
            ActivateAllLines(tab,axnum);
        else
            DeactivateAllLines(tab,axnum);
        end
        return
end
        




