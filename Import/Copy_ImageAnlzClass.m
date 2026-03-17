%===================================================
% 
%===================================================
function newIMAGEANLZ = Copy_ImageAnlzClass(tab,axnum)

global IMAGEANLZ

newIMAGEANLZ = ImageAnlzClass([],'Script',[]); 
newIMAGEANLZ.Copy4Export(IMAGEANLZ.(tab)(axnum));