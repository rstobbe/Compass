%============================================
% 
%============================================
function IMAGEROI = ImRoi_CopyRoiInfo(IMAGEROI,ROI)

IMAGEROI.roimean = [];
IMAGEROI.roisdv = [];
IMAGEROI.roivol = ROI.roivol;
IMAGEROI.linehandles = gobjects(0); 
IMAGEROI.roiimsize = ROI.roiimsize;
IMAGEROI.baseroiorient = ROI.baseroiorient;
IMAGEROI.drawroiorient = ROI.drawroiorient;
IMAGEROI.roiname = ROI.roiname;
IMAGEROI.locnum = ROI.locnum;
IMAGEROI.xlocarr = ROI.xlocarr;                      
IMAGEROI.ylocarr = ROI.ylocarr;                         
IMAGEROI.zlocarr = ROI.zlocarr;    
IMAGEROI.xloc0arr = ROI.xloc0arr;                     
IMAGEROI.yloc0arr = ROI.yloc0arr;                        
IMAGEROI.zloc0arr = ROI.zloc0arr; 
IMAGEROI.roimask = ROI.roimask;
IMAGEROI.CREATEMETHOD = ROI.CREATEMETHOD;



