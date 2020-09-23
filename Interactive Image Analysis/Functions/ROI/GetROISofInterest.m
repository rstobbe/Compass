%===================================================
% 
%===================================================
function [ROIS,axnum,err] = GetROISofInterest(tab,roinums)

global IMAGEANLZ

err.flag = 0;
err.msg = '';
ROIS = ImageRoiClass.empty;

%---------------------------------------------
% Inpute
%---------------------------------------------
currentax = gca;
axnum = str2double(currentax.Tag);

%---------------------------------------------
% Find ROIs
%---------------------------------------------
if isempty(roinums)
    ROISofInterest = IMAGEANLZ.(tab)(axnum).ROISOFINTEREST;
    if sum(ROISofInterest) == 0
        err.flag = 1;
        err.msg = 'An ROI must be activated';
        return
    end
    roinums = find(ROISofInterest == 1);
end

%---------------------------------------------
% Get ROIs
%---------------------------------------------
for n = 1:length(roinums)
    ROIS(n) = ImageRoiClass(IMAGEANLZ.(tab)(axnum));
    ROIS(n).CopyRoiInfo(IMAGEANLZ.(tab)(axnum).SAVEDROIS(roinums(n)));
end

