%===================================================
% 
%===================================================
function [totgblnum] = Find_ActiveImage(tab,axnum)

global IMAGEANLZ

%---------------------------------------------
% Find ROIs
%---------------------------------------------
totgblnum = IMAGEANLZ.(tab)(axnum).totgblnum;