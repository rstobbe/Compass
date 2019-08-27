%============================================
% 
%============================================
function abort = ImAnlz_RoiSizeTest(IMAGEANLZ,totgblnum)

test = 0;
abort = 0;

if isempty(IMAGEANLZ.totgblnum)
    return
end

curimsize = IMAGEANLZ.GetBaseImageSize([]);
newimsize = IMAGEANLZ.GetBaseImageSize(totgblnum);
for n = 1:3
    if newimsize ~= curimsize(n)
        test = 1;
    end
end

curbaseorient = IMAGEANLZ.GetBaseOrient([]);                   
newbaseorient = IMAGEANLZ.GetBaseOrient(totgblnum);
if not(strcmp(curbaseorient,newbaseorient))
   test = 1;
end

if test == 1
    if IMAGEANLZ.SAVEDROISFLAG ~= 0 || IMAGEANLZ.GETROIS ~= 0
        button = questdlg('Image Dimensions/Orientation Incompatible with ROIs: Continue and Delete ROIs?');
        if isempty(button) || strcmp(button,'No') || strcmp(button,'Cancel') 
            abort = 1;
            return
        else
            IMAGEANLZ.DiscardCurrentROI;
            IMAGEANLZ.DeleteAllSavedROIs;
            IMAGEANLZ.GETROIS = 0;
        end
    end
end


    
    
    