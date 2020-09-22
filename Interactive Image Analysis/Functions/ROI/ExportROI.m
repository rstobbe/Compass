%===================================================
% ExportROI
%===================================================
function ExportROI(tab,axnum,roinum)

global IMAGEANLZ
global SCRPTPATHS

if not(isempty(IMAGEANLZ.(tab)(axnum).movefunction))
    error;          % shouldn't get here
end

roisloc = SCRPTPATHS.(tab)(1).roisloc;

%[file,path] = uiputfile('*.mat','Export ROI',[roisloc,'\ROI_SEED_',IMAGEANLZ.(tab)(axnum).SAVEDROIS(roinum).roiname]);
[file,path] = uiputfile('*.mat','Export ROI',[roisloc,'\ROI_AND_',IMAGEANLZ.(tab)(axnum).SAVEDROIS(roinum).roiname]);
if path == 0
    return;
end
SCRPTPATHS.(tab)(1).roisloc = path;

ROI = IMAGEANLZ.(tab)(axnum).SAVEDROIS(roinum);

PixDim = IMAGEANLZ.(tab)(axnum).GetPixelDimensions;

h_ROI = [];
for n = 1:length(ROI.zlocarr)
    h_ROI = [h_ROI;[PixDim(1)*ROI.ylocarr{n}.',PixDim(2)*ROI.xlocarr{n}.',PixDim(3)*ROI.zlocarr{n}*ones(size(ROI.ylocarr{n})).']]
end


[x,y,z] = ind2sub(ROI.roiimsize,find(ROI.roimask));
ROI = [x,y,z];

%ROISem = 'SEED';
ROISem = 'AND';

save([path,file],'h_ROI','ROI','ROISem');





