%============================================
% 
%============================================
function CurrentPointUpdate(tab,axnum0,x,y)

global IMAGEANLZ
global TOTALGBL
global FIGOBJS

IMDIM = TOTALGBL{2,IMAGEANLZ.(tab)(axnum0).totgblnum}.IMDISP.IMDIM;

x1 = round(x);
y1 = round(y);

if IMAGEANLZ.(tab)(axnum0).DATVALTIE == 1
    start = 1;    
    stop = IMAGEANLZ.(tab)(axnum0).axeslen;
else
    start = axnum0;
    stop = axnum0;
end

if IMAGEANLZ.(tab)(axnum0).TestMouseInImage([x1,y1]) == 1
    set(gcf,'pointer',IMAGEANLZ.(tab)(axnum0).pointer);
    for axnum = start:stop
        if not(IMAGEANLZ.(tab)(axnum).TestAxisActive)
            continue
        end
        switch IMAGEANLZ.(tab)(axnum).ORIENT
            case 'Axial'
                idx = [y1,x1,IMAGEANLZ.(tab)(axnum).SLICE,IMAGEANLZ.(tab)(axnum).DIM4,IMAGEANLZ.(tab)(axnum).DIM5,IMAGEANLZ.(tab)(axnum).DIM6];
                Xdim = TOTALGBL{2,IMAGEANLZ.(tab)(axnum).totgblnum}.IMDISP.ImInfo.pixdim(2);
                Ydim = TOTALGBL{2,IMAGEANLZ.(tab)(axnum).totgblnum}.IMDISP.ImInfo.pixdim(1);
                Zdim = TOTALGBL{2,IMAGEANLZ.(tab)(axnum).totgblnum}.IMDISP.ImInfo.pixdim(3);
            case 'Sagittal'
                idx = [x1,IMAGEANLZ.(tab)(axnum).SLICE,(IMDIM.z2-y1+1),IMAGEANLZ.(tab)(axnum).DIM4,IMAGEANLZ.(tab)(axnum).DIM5,IMAGEANLZ.(tab)(axnum).DIM6];
                Xdim = TOTALGBL{2,IMAGEANLZ.(tab)(axnum).totgblnum}.IMDISP.ImInfo.pixdim(2);    
                Ydim = TOTALGBL{2,IMAGEANLZ.(tab)(axnum).totgblnum}.IMDISP.ImInfo.pixdim(3);
                Zdim = TOTALGBL{2,IMAGEANLZ.(tab)(axnum).totgblnum}.IMDISP.ImInfo.pixdim(1);
            case 'Coronal'
                idx = [IMAGEANLZ.(tab)(axnum).SLICE,x1,(IMDIM.z2-y1+1),IMAGEANLZ.(tab)(axnum).DIM4,IMAGEANLZ.(tab)(axnum).DIM5,IMAGEANLZ.(tab)(axnum).DIM6];
                Xdim = TOTALGBL{2,IMAGEANLZ.(tab)(axnum).totgblnum}.IMDISP.ImInfo.pixdim(2);    
                Ydim = TOTALGBL{2,IMAGEANLZ.(tab)(axnum).totgblnum}.IMDISP.ImInfo.pixdim(3);
                Zdim = TOTALGBL{2,IMAGEANLZ.(tab)(axnum).totgblnum}.IMDISP.ImInfo.pixdim(1);
        end
        image = TOTALGBL{2,IMAGEANLZ.(tab)(axnum).totgblnum}.Im;
        val = image(idx(1),idx(2),idx(3),idx(4),idx(5),idx(6));
        switch IMAGEANLZ.(tab)(axnum).ImType
            case 'abs'
                if abs(val) < 0.01
                    num = num2str(abs(val),3);
                else
                    num = num2str(abs(val),4);
                end
            case 'real'
                if abs(real(val)) < 0.01
                    num = num2str(real(val),3);
                else
                    num = num2str(real(val),4);
                end
            case 'imag'
                if abs(imag(val)) < 0.01
                    num = num2str(imag(val),3);
                else
                    num = num2str(imag(val),4);
                end
            case 'phase'
                num = num2str(angle(val),4);
            case 'map'
                if abs(val) < 0.01
                    num = num2str(val,3);
                else
                    num = num2str(val,4);
                end
            case 'colour'
                val = squeeze(image(idx(1),idx(2),idx(3),:,idx(5),idx(6)));
                num = [num2str(val(1),'%3.2f'),',',num2str(val(2),'%3.2f'),',',num2str(val(3),'%3.2f')];
        end
        FIGOBJS.(tab).CURVAL(axnum).String = num;
        FIGOBJS.(tab).X(axnum).String = num2str((x-0.5)*Xdim,'%3.1f');
        FIGOBJS.(tab).Y(axnum).String = num2str((y-0.5)*Ydim,'%3.1f'); 
        FIGOBJS.(tab).Z(axnum).String = num2str((IMAGEANLZ.(tab)(axnum).SLICE-0.5)*Zdim,'%3.1f'); 
        FIGOBJS.(tab).XPix(axnum).String = num2str(round(x),'%3.0f');
        FIGOBJS.(tab).YPix(axnum).String = num2str(round(y),'%3.0f'); 
        FIGOBJS.(tab).ZPix(axnum).String = num2str(IMAGEANLZ.(tab)(axnum).SLICE);
    end
else
    set(gcf,'pointer','arrow');
    for axnum = start:stop
        FIGOBJS.(tab).CURVAL(axnum).String = '';
        FIGOBJS.(tab).X(axnum).String = '';
        FIGOBJS.(tab).Y(axnum).String = '';
        FIGOBJS.(tab).Z(axnum).String = '';
        FIGOBJS.(tab).XPix(axnum).String = '';
        FIGOBJS.(tab).YPix(axnum).String = '';
    end
end

if IMAGEANLZ.(tab)(axnum0).CURSORTIE == 1
    for axnum = start:stop
        if not(IMAGEANLZ.(tab)(axnum).TestAxisActive)
            continue
        end
        if axnum ~= axnum0
            if not(strcmp(IMAGEANLZ.(tab)(axnum).movefunction,'DrawROI'))
                if IMAGEANLZ.(tab)(axnum0).TestMouseInImage([x,y]) == 1
                    IMAGEANLZ.(tab)(axnum).SetMark([x,y]);
                else
                    IMAGEANLZ.(tab)(axnum).DeleteMark;
                end
            end
        end
    end
end
   

