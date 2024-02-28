%============================================
% ReSlice
%============================================
function ReSlice(src,event)

global IMAGEANLZ
global TOTALGBL
global TOTALGBLHOLD

tab = src.Parent.Parent.Parent.Tag;

% Coronal Case
Slicing = [3 2 4 1 5 6]; 
TOTALGBL{2,IMAGEANLZ.(tab)(1).totgblnum} = TOTALGBLHOLD{2,IMAGEANLZ.(tab)(1).totgblnum};
TOTALGBL{2,IMAGEANLZ.(tab)(1).totgblnum}.Im = permute(TOTALGBL{2,IMAGEANLZ.(tab)(1).totgblnum}.Im,Slicing);
TOTALGBL{2,IMAGEANLZ.(tab)(1).totgblnum}.Im = flip(TOTALGBL{2,IMAGEANLZ.(tab)(1).totgblnum}.Im,1);
sz = size(TOTALGBL{2,IMAGEANLZ.(tab)(1).totgblnum}.Im);
TOTALGBL{2,IMAGEANLZ.(tab)(1).totgblnum}.IMDISP.SCALE.zmax = sz(3) + 0.5;
TOTALGBL{2,IMAGEANLZ.(tab)(1).totgblnum}.IMDISP.ImInfo.pixdim(3) = 0.5*(sz(2)/sz(3))*TOTALGBL{2,IMAGEANLZ.(tab)(1).totgblnum}.IMDISP.ImInfo.pixdim(2);
totgblnum = IMAGEANLZ.(tab)(1).totgblnum;
TabReset(tab);

switch IMAGEANLZ.(tab)(1).presentation
    case 'Standard'

    case 'Ortho'
        Gbl2ImageOrtho(tab,totgblnum);
end
        
