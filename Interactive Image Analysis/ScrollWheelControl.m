%============================================
% What to do about scroll wheel
%============================================
function ScrollWheelControl(src,event)

global IMAGEANLZ
global RWSUIGBL
global FIGOBJS

currentob = gco;
if not(isempty(currentob))
    test = currentob.Type;
    if strcmp(test,'uitab') || strcmp(test,'uipanel')  || strcmp(test,'uicontrol')
        return
    end
end
currentax = gca;

tab = currentax.Parent.Parent.Tag;
if not(isfield(IMAGEANLZ,tab))
    tab = currentax.Parent.Parent.Parent.Parent.Tag;
end
axnum = str2double(currentax.Tag);
if isnan(axnum)
    return
end
if not(IMAGEANLZ.(tab)(axnum).TestAxisActive)
    return
end

pt = currentax.CurrentPoint;
X = pt(1,1);
Y = pt(1,2);
if not(IMAGEANLZ.(tab)(axnum).TestMouseInImage([X,Y]))
    return
end

switch RWSUIGBL.Key
    case ''
        Slice_Change(currentax,tab,axnum,event.VerticalScrollCount);
    case 'shift'
        if event.VerticalScrollCount > 0
            if(strcmp(IMAGEANLZ.(tab)(axnum).presentation,'Ortho'))
                Zoom_OutOrtho(tab,axnum);
            else
                Zoom_Out3(currentax,tab,axnum);
            end
        else
            if(strcmp(IMAGEANLZ.(tab)(axnum).presentation,'Ortho'))
                Zoom_InOrtho(tab,axnum);
            else
                Zoom_In3(currentax,tab,axnum);
            end
        end
    case '4'
        imsize = IMAGEANLZ.(tab)(axnum).GetBaseImageSize([]);
        dim4 = IMAGEANLZ.(tab)(axnum).DIM4 - event.VerticalScrollCount;
        if dim4 > imsize(4)
            dim4 = dim4 - imsize(4);
        elseif dim4 < 1
            dim4 = imsize(4) - dim4;
        end
        Dim4_Change(currentax,tab,axnum,dim4);
        if strcmp(IMAGEANLZ.(tab)(axnum).presentation,'Ortho')
            FIGOBJS.(tab).Dim4(1).Value = dim4;
        else
            FIGOBJS.(tab).Dim4(axnum).Value = dim4;
        end
    case '5'
        imsize = IMAGEANLZ.(tab)(axnum).GetBaseImageSize([]);
        dim5 = IMAGEANLZ.(tab)(axnum).DIM5 - event.VerticalScrollCount;
        if dim5 > imsize(5)
            dim5 = dim5 - imsize(5);
        elseif dim5 < 1
            dim5 = imsize(5) - dim5;
        end
        Dim5_Change(currentax,tab,axnum,dim5);
        if strcmp(IMAGEANLZ.(tab)(axnum).presentation,'Ortho')
            FIGOBJS.(tab).Dim5(1).Value = dim5;
        else
            FIGOBJS.(tab).Dim5(axnum).Value = dim5;
        end
    case '6'
        imsize = IMAGEANLZ.(tab)(axnum).GetBaseImageSize([]);
        dim6 = IMAGEANLZ.(tab)(axnum).DIM6 - event.VerticalScrollCount;
        if dim6 > imsize(6)
            dim6 = dim6 - imsize(6);
        elseif dim6 < 1
            dim6 = imsize(6) - dim6;
        end
        Dim6_Change(currentax,tab,axnum,dim6);
        if strcmp(IMAGEANLZ.(tab)(axnum).presentation,'Ortho')
            FIGOBJS.(tab).Dim6(1).Value = dim6;
        else
            FIGOBJS.(tab).Dim6(axnum).Value = dim6;
        end
end

