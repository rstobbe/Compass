%===================================================
% 
%===================================================
function [totgblnums] = Find_SelectedImages(tab)

global IMAGEANLZ

%---------------------------------------------
% Find ROIs
%---------------------------------------------
totgblnums = IMAGEANLZ.(tab)(1).GetTOTALGBLselected;