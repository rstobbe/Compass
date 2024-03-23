%===================================================
%
%===================================================
function LoadImage2Tab(src,event)

global IMAGEANLZ

tab = src.Parent.Parent.Tag;
axnum = str2double(src.Tag);
SetFocus(tab,axnum);
IMAGEANLZ.(tab)(axnum).Highlight;

if isempty(IMAGEANLZ.(tab)(axnum).totgblnumhl)
    return
end

global TOTALGBL
if isgpuarray(TOTALGBL{2,IMAGEANLZ.(tab)(axnum).totgblnumhl}.Im)
    if ~existsOnGPU(TOTALGBL{2,IMAGEANLZ.(tab)(axnum).totgblnumhl}.Im)
        TOTALGBL{2,IMAGEANLZ.(tab)(axnum).totgblnumhl}.Im = gpuArray(TOTALGBL{2,IMAGEANLZ.(tab)(axnum).totgblnumhl}.ImRam);
    end
end
for overlaynum = 1:length(length(IMAGEANLZ.(tab)(axnum).overtotgblnum))
    if IMAGEANLZ.(tab)(axnum).overtotgblnum ~= 0
        if isgpuarray(TOTALGBL{2,IMAGEANLZ.(tab)(axnum).overtotgblnum(overlaynum)}.Im)
            if ~existsOnGPU(TOTALGBL{2,IMAGEANLZ.(tab)(axnum).overtotgblnum(overlaynum)}.Im)
                TOTALGBL{2,IMAGEANLZ.(tab)(axnum).overtotgblnum(overlaynum)}.Im = gpuArray(TOTALGBL{2,IMAGEANLZ.(tab)(axnum).overtotgblnum(overlaynum)}.ImRam);
            end
        end
    end
end

% global TOTALGBLHOLD
% TOTALGBL{2,IMAGEANLZ.(tab)(axnum).totgblnumhl} = TOTALGBLHOLD{2,IMAGEANLZ.(tab)(axnum).totgblnumhl};  

%--------------------------------------------
% Load
%--------------------------------------------
if strcmp(IMAGEANLZ.(tab)(axnum).presentation,'Standard')
    Gbl2Image(tab,axnum,IMAGEANLZ.(tab)(axnum).totgblnumhl);
elseif strcmp(IMAGEANLZ.(tab)(axnum).presentation,'Ortho')
    Gbl2ImageOrtho(tab,IMAGEANLZ.(tab)(axnum).totgblnumhl);
end
