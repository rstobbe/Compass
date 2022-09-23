%====================================================
% 
%====================================================
function ButtonDeleteLine(src,event)

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
            GlobalSavedLinesInd = IMAGEANLZ.(tab)(r).DeleteSavedLine(linenum);
            IMAGEANLZ.(tab)(r).UpdateGlobalSavedLinesInd(GlobalSavedLinesInd); 
            IMAGEANLZ.(tab)(r).DeleteSavedLineData(linenum);
        end
    case 'Ortho'
        for r = 1:3
            GlobalSavedLinesInd = IMAGEANLZ.(tab)(r).DeleteSavedLine(linenum);
            IMAGEANLZ.(tab)(r).UpdateGlobalSavedLinesInd(GlobalSavedLinesInd); 
        end
        IMAGEANLZ.(tab)(1).DeleteSavedLineData(linenum);
end
EndLineTool(tab,axnum);


