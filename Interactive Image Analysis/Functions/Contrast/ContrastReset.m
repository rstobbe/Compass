%===================================================
% Slice_Change
%===================================================
function err = ContrastReset(tab,axnum,Image)

global FIGOBJS
global IMAGEANLZ

if strcmp(IMAGEANLZ.(tab)(axnum).IMTYPE,'abs')
    IMAGEANLZ.(tab)(axnum).MAXCONTRAST = max(abs(Image(:)));
    IMAGEANLZ.(tab)(axnum).RELCONTRAST = [0 1];
    FIGOBJS.(tab).ContrastMax(axnum).Min = 0;
    FIGOBJS.(tab).ContrastMin(axnum).Min = 0;
    FIGOBJS.(tab).ContrastMax(axnum).Value = 1;
    FIGOBJS.(tab).ContrastMin(axnum).Value = 0;
    FIGOBJS.(tab).CMaxVal(axnum).String = num2str(max(abs(Image(:))),'%4.3f');
    FIGOBJS.(tab).CMinVal(axnum).String = 0;
elseif strcmp(IMAGEANLZ.(tab)(axnum).IMTYPE,'real')
    IMAGEANLZ.(tab)(axnum).MAXCONTRAST = max(abs(Image(:)));
    IMAGEANLZ.(tab)(axnum).RELCONTRAST = [-1 1];
    FIGOBJS.(tab).ContrastMax(axnum).Min = -1;
    FIGOBJS.(tab).ContrastMin(axnum).Min = -1;
    FIGOBJS.(tab).ContrastMax(axnum).Value = 1;
    FIGOBJS.(tab).ContrastMin(axnum).Value = -1;
    FIGOBJS.(tab).CMaxVal(axnum).String = num2str(max(abs(Image(:))),'%4.3f');
    FIGOBJS.(tab).CMinVal(axnum).String = num2str(-max(abs(Image(:))),'%4.3f');
elseif strcmp(IMAGEANLZ.(tab)(axnum).IMTYPE,'imag')
    IMAGEANLZ.(tab)(axnum).MAXCONTRAST = max(abs(Image(:)));
    IMAGEANLZ.(tab)(axnum).RELCONTRAST = [-1 1];
    FIGOBJS.(tab).ContrastMax(axnum).Min = -1;
    FIGOBJS.(tab).ContrastMin(axnum).Min = -1;
    FIGOBJS.(tab).ContrastMax(axnum).Value = 1;
    FIGOBJS.(tab).ContrastMin(axnum).Value = -1;
    FIGOBJS.(tab).CMaxVal(axnum).String = num2str(max(abs(Image(:))),'%4.3f');
    FIGOBJS.(tab).CMinVal(axnum).String = num2str(-max(abs(Image(:))),'%4.3f');
elseif strcmp(IMAGEANLZ.(tab)(axnum).IMTYPE,'phase')
    IMAGEANLZ.(tab)(axnum).MAXCONTRAST = pi;
    IMAGEANLZ.(tab)(axnum).RELCONTRAST = [-1 1];
    FIGOBJS.(tab).ContrastMax(axnum).Min = -1;
    FIGOBJS.(tab).ContrastMin(axnum).Min = -1;
    FIGOBJS.(tab).ContrastMax(axnum).Value = 1;
    FIGOBJS.(tab).ContrastMin(axnum).Value = -1;
    FIGOBJS.(tab).CMaxVal(axnum).String = num2str(pi,'%4.3f');
    FIGOBJS.(tab).CMinVal(axnum).String = num2str(-pi,'%4.3f');
elseif strcmp(IMAGEANLZ.(tab)(axnum).IMTYPE,'map')
    if sum(imag(Image(:))) ~= 0
        error;          % fix handling
        err.msg = 'Type ''map'' incompatible with complex images';
        err.flag = 1;
    end
    Image(Image == 0) = NaN;
    IMAGEANLZ.(tab)(axnum).MAXCONTRAST = max(Image(:));
    IMAGEANLZ.(tab)(axnum).RELCONTRAST = [min(Image(:))/max(Image(:)) 1];
    FIGOBJS.(tab).ContrastMax(axnum).Min = min(Image(:))/max(Image(:));
    FIGOBJS.(tab).ContrastMin(axnum).Min = min(Image(:))/max(Image(:));
    FIGOBJS.(tab).ContrastMax(axnum).Value = 1;
    FIGOBJS.(tab).ContrastMin(axnum).Value = min(Image(:))/max(Image(:));
    FIGOBJS.(tab).CMaxVal(axnum).String = num2str(max(Image(:)),'%4.3f');
    FIGOBJS.(tab).CMinVal(axnum).String = num2str(min(Image(:)),'%4.3f');
end
