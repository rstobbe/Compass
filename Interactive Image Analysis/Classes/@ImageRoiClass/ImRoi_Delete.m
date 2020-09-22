%============================================
% New_ROI
%============================================
function IMAGEROI = ImRoi_Delete(IMAGEROI)

IMAGEROI.roimean = [];
IMAGEROI.roisdv = [];
IMAGEROI.roivol = [];
IMAGEROI.roiname = '';
IMAGEROI.locnum = 0;
IMAGEROI.xlocarr = [];                      
IMAGEROI.ylocarr = [];                         
IMAGEROI.zlocarr = [];    
IMAGEROI.xloc0arr = [];                      
IMAGEROI.yloc0arr = [];                         
IMAGEROI.zloc0arr = [];  
IMAGEROI.linehandles = gobjects(0); 
IMAGEROI.roimask = [];





