%============================================
% 
%============================================
function reset = ImAnlz_TieTest(IMAGEANLZ,othersize)

curimsize = IMAGEANLZ.GetBaseImageSize([]);

reset = 0;
for n = 1:3
    if curimsize(n) ~= othersize(n)
        IMAGEANLZ.UnTieAll;
        reset = 2;
        return
    end
end
for n = 4:6
    if curimsize(n) ~= othersize(n)
        reset = 1;
    end
end