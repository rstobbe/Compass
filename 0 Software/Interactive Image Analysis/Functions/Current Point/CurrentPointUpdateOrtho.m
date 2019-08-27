%============================================
% 
%============================================
function CurrentPointUpdateOrtho(tab,axnum,x,y)

global IMAGEANLZ

if IMAGEANLZ.(tab)(axnum).TestMouseInImage([round(x),round(y)]) == 1
    set(gcf,'pointer',IMAGEANLZ.(tab)(axnum).pointer);   
    Data = IMAGEANLZ.(tab)(axnum).GetCurrentPointData(x,y); 
    IMAGEANLZ.(tab)(1).SetCurrentPointInfoOrtho(Data)
else
    set(gcf,'pointer','arrow');
    IMAGEANLZ.(tab)(1).ClearCurrentPointInfoOrtho;
end
