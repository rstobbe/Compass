%====================================================
% 
%====================================================
function ButtonDeleteBox(src,event)

global IMAGEANLZ


tab = src.Parent.Parent.Parent.Tag;
linearr = src.UserData;
axnum = linearr(1);
linenum = linearr(2);

switch IMAGEANLZ.(tab)(axnum).presentation
    case 'Standard'
        if IMAGEANLZ.(tab)(axnum).ROITIE == 1
            start = 1;    
            stop = IMAGEANLZ.(tab)(axnum).axeslen;
        else
            start = axnum;
            stop = axnum;
        end 
        for r = start:stop
            GlobalSavedBoxsInd = IMAGEANLZ.(tab)(r).DeleteSavedBox(linenum);
            IMAGEANLZ.(tab)(r).UpdateGlobalSavedBoxsInd(GlobalSavedBoxsInd); 
            IMAGEANLZ.(tab)(r).DeleteSavedBoxData(linenum);
        end
    case 'Ortho'
        for r = 1:3
            GlobalSavedBoxsInd = IMAGEANLZ.(tab)(r).DeleteSavedBox(linenum);
            IMAGEANLZ.(tab)(r).UpdateGlobalSavedBoxsInd(GlobalSavedBoxsInd); 
        end
        IMAGEANLZ.(tab)(1).DeleteSavedBoxData(linenum);
end
EndBoxTool(tab,axnum);


