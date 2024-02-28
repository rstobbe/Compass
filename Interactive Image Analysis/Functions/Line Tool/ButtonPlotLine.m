%====================================================
% 
%====================================================
function ButtonPlotLine(src,event)

global IMAGEANLZ


tab = src.Parent.Parent.Parent.Tag;
linearr = src.UserData;
axnum = linearr(1);
linenum = linearr(2);

figure(10000); hold on;
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
            if IMAGEANLZ.(tab)(r).TestAxisActive
                IMAGEANLZ.(tab)(r).PlotSavedLine(linenum);
            end
        end
    case 'Ortho'
        for r = 1:3 
            IMAGEANLZ.(tab)(r).PlotSavedLine(linenum);
        end
end
EndLineTool(tab,axnum);


