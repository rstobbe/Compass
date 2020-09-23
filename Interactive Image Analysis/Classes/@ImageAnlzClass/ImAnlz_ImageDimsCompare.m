%============================================
% 
%============================================
function test = ImAnlz_ImageDimsCompare(IMAGEANLZ,totgblnum)

test = 1;

if isempty(IMAGEANLZ.totgblnum)
    test = [];
    return
end

curimsize = IMAGEANLZ.GetBaseImageSize([]);
newimsize = IMAGEANLZ.GetBaseImageSize(totgblnum);
for n = 1:3
    if newimsize ~= curimsize(n)
        test = 0;
    end
end

curbaseorient = IMAGEANLZ.GetBaseOrient([]);                   
newbaseorient = IMAGEANLZ.GetBaseOrient(totgblnum);
if not(strcmp(curbaseorient,newbaseorient))
   test = 0;
end


    
    