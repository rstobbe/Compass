%============================================
% Initialize
%============================================
function IMAGEROI = ImRoi_Initialize(IMAGEROI,IMAGEANLZ)

imsize = IMAGEANLZ.GetBaseImageSize([]);
if not(isempty(imsize))
    IMAGEROI.roiimsize = imsize(1:3);
end
IMAGEROI.baseroiorient = IMAGEANLZ.GetBaseOrient([]);
IMAGEROI.pixdim = IMAGEANLZ.GetBasePixelDimensions([]);
IMAGEROI.drawroiorient = IMAGEANLZ.ORIENT;
IMAGEROI.drawroiorientarray = [];
IMAGEROI.roimean = [];
IMAGEROI.roisdv = [];
IMAGEROI.roivol = [];
IMAGEROI.roiname = '';
IMAGEROI.savepath = '';

IMAGEROI.locnum = 0;
IMAGEROI.lastlocnumadded = 0;
IMAGEROI.xlocarr = [];                      
IMAGEROI.ylocarr = [];                         
IMAGEROI.zlocarr = [];    
IMAGEROI.xloc0arr = [];                      
IMAGEROI.yloc0arr = [];                         
IMAGEROI.zloc0arr = []; 
IMAGEROI.eventarr = [];   
IMAGEROI.alphadata = [];   
IMAGEROI.linehandles = gobjects(0); 
IMAGEROI.shadehandle = gobjects(0); 
IMAGEROI.contextmenu = gobjects(0); 
IMAGEROI.info = '';      
IMAGEROI.CREATEMETHOD = cell(0);

%IMAGEROI.CREATEMETHOD = IMAGEANLZ.(IMAGEANLZ.activeroi);
%IMAGEROI.CREATEMETHOD.Initialize;

%IMAGEROI.roimask = [];  
if strcmp(IMAGEROI.baseroiorient,'Axial')
    if strcmp(IMAGEROI.drawroiorient,'Axial')
        drawroiimsize = IMAGEROI.roiimsize;
    elseif strcmp(IMAGEROI.drawroiorient,'Sagittal')
        drawroiimsize = IMAGEROI.roiimsize([3 1 2]);
    elseif strcmp(IMAGEROI.drawroiorient,'Coronal')
        drawroiimsize = IMAGEROI.roiimsize([3 2 1]);
    end
end
IMAGEROI.roimask = gpuArray(zeros(drawroiimsize,'single'));                        
IMAGEROI.roimasksarr2d = cell(0);


