%============================================
% 
%============================================
function CurrentPointUpdateOrtho(tab,axnum,x,y)

global IMAGEANLZ

if IMAGEANLZ.(tab)(axnum).TestMouseInImage([round(x),round(y)]) == 1
    set(gcf,'pointer',IMAGEANLZ.(tab)(axnum).pointer);   
    Data = IMAGEANLZ.(tab)(axnum).GetCurrentPointData(x,y); 
    IMAGEANLZ.(tab)(1).SetCurrentPointInfoOrtho(Data);
    for m = 1:4
        if IMAGEANLZ.(tab)(1).TestForOverlay(m)
            Data = IMAGEANLZ.(tab)(axnum).GetCurrentPointDataOverlay(m,x,y); 
            IMAGEANLZ.(tab)(1).SetCurrentPointInfoOrthoOverlay(m,Data);
        end
    end
else
    set(gcf,'pointer','arrow');
    IMAGEANLZ.(tab)(1).ClearCurrentPointInfoOrtho;
    for m = 1:4
        if IMAGEANLZ.(tab)(1).TestForOverlay(m)
            IMAGEANLZ.(tab)(1).ClearCurrentPointInfoOrthoOverlay(m);
        end
    end
end
