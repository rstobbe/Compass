%===================================================
%
%===================================================
function DeleteAllOverlays(tab,axnum)

global IMAGEANLZ

if strcmp(IMAGEANLZ.(tab)(axnum).presentation,'Standard')
    for m = 1:4
        IMAGEANLZ.(tab)(axnum).DeleteOverlay(m);
    end
elseif strcmp(IMAGEANLZ.(tab)(axnum).presentation,'Ortho')
    for m = 1:4
        for axnum = 1:3
            IMAGEANLZ.(tab)(axnum).DeleteOverlay(m);
        end
    end
end

