%============================================
% 
%============================================
function IMAGEANLZ = ImAnlz_MultiDimSetup(IMAGEANLZ)

if IMAGEANLZ.DIMSHOLD == 0
    IMAGEANLZ.DIM4 = 1;
    IMAGEANLZ.FIGOBJS.Dim4.Max = 1;
    IMAGEANLZ.FIGOBJS.Dim4.Value = 1;
    IMAGEANLZ.FIGOBJS.Dim4.Enable = 'off';
    IMAGEANLZ.DIM5 = 1;
    IMAGEANLZ.FIGOBJS.Dim5.Max = 1;
    IMAGEANLZ.FIGOBJS.Dim5.Value = 1;
    IMAGEANLZ.FIGOBJS.Dim5.Enable = 'off';
    IMAGEANLZ.DIM6 = 1;
    IMAGEANLZ.FIGOBJS.Dim6.Max = 1;
    IMAGEANLZ.FIGOBJS.Dim6.Value = 1;
    IMAGEANLZ.FIGOBJS.Dim6.Enable = 'off';
    imsize = IMAGEANLZ.GetBaseImageSize([]);
    if imsize(4) > 1
        IMAGEANLZ.FIGOBJS.Dim4.Min = 1;
        IMAGEANLZ.FIGOBJS.Dim4.Max = imsize(4);
        IMAGEANLZ.FIGOBJS.Dim4.Enable = 'on';
        IMAGEANLZ.FIGOBJS.Dim4.Value = 1;
        IMAGEANLZ.FIGOBJS.Dim4.SliderStep = [1/(imsize(4)-1) 1/(imsize(4)-1)];
    end
    if imsize(5) > 1
        IMAGEANLZ.FIGOBJS.Dim5.Min = 1;
        IMAGEANLZ.FIGOBJS.Dim5.Max = imsize(5);
        IMAGEANLZ.FIGOBJS.Dim5.Enable = 'on';
        IMAGEANLZ.FIGOBJS.Dim5.Value = 1;
        IMAGEANLZ.FIGOBJS.Dim5.SliderStep = [1/(imsize(5)-1) 1/(imsize(5)-1)];
    end
    if imsize(6) > 1
        IMAGEANLZ.FIGOBJS.Dim6.Min = 1;
        IMAGEANLZ.FIGOBJS.Dim6.Max = imsize(6);
        IMAGEANLZ.FIGOBJS.Dim6.Enable = 'on';
        IMAGEANLZ.FIGOBJS.Dim6.Value = 1;
        IMAGEANLZ.FIGOBJS.Dim6.SliderStep = [1/(imsize(6)-1) 1/(imsize(6)-1)];
    end
end

