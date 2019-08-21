%============================================
% New_ROI
%============================================
function IMAGEROI = ImRoi_Initialize(IMAGEROI,IMAGEANLZ)

imsize = IMAGEANLZ.GetBaseImageSize([]);
if not(isempty(imsize))
    IMAGEROI.roiimsize = imsize(1:3);
end
IMAGEROI.baseroiorient = IMAGEANLZ.GetBaseOrient([]);
IMAGEROI.drawroiorient = IMAGEANLZ.ORIENT;
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
IMAGEROI.shadehandle = gobjects(0); 
IMAGEROI.contextmenu = gobjects(0); 
IMAGEROI.roimask = [];  
IMAGEROI.CREATEMETHOD = cell(0);

%IMAGEROI.CREATEMETHOD = IMAGEANLZ.(IMAGEANLZ.activeroi);
%IMAGEROI.CREATEMETHOD.Initialize;





