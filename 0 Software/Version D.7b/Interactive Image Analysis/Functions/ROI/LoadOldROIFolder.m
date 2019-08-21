%============================================
%
%============================================
function LoadOldROIFolder(tab,axnum,roinum)

global IMAGEANLZ
global SCRPTPATHS

if not(isempty(IMAGEANLZ.(tab)(axnum).movefunction))
    error;          % shouldn't get here
end

roisloc = SCRPTPATHS.(tab)(1).roisloc;
path = uigetdir(roisloc,'Select ROI Folder');
if path == 0
    return;
end
SCRPTPATHS.(tab)(1).roisloc = path;

ROIs = ls(path);
sz = size(ROIs);
ROIs = ROIs(3:sz(1),:);

for p = 1:(sz(1)-2) 
    [name,ext] = strtok(ROIs(p,:),'.');
    if isempty(strfind(ext,'.mat'))
        continue
    end
    load([path,'\',ROIs(p,:)]);
    
    loadedimsize = IMAGEANLZ.(tab)(axnum).GetBaseImageSize([]);
    for n = 1:3
        if ImSize(n) ~= loadedimsize(n);
            Status2('error','ROI and Image Dimensions Incompatible',1);
            return
        end
    end

    if IMAGEANLZ.(tab)(axnum).ROITIE == 1
        start = 1;    
        stop = IMAGEANLZ.(tab)(axnum).axeslen;
    else
        start = axnum;
        stop = axnum;
    end

    for r = start:stop
        if IMAGEANLZ.(tab)(r).TestAxisActive
            IMAGEANLZ.(tab)(r).SAVEDROISFLAG = 1;
            IMAGEANLZ.(tab)(r).CreateEmptySavedROI(roinum);
            IMAGEANLZ.(tab)(r).SAVEDROIS(roinum).SetROIName(ROINAME);
            IMAGEANLZ.(tab)(r).SAVEDROIS(roinum).AddNewRegion('');
            IMAGEANLZ.(tab)(r).SAVEDROIS(roinum).LoadOldROIs(SAVEDXLOC,SAVEDYLOC,SAVEDZLOC);
            IMAGEANLZ.(tab)(r).DrawSavedROIs([]);
            IMAGEANLZ.(tab)(r).SAVEDROIS(roinum).CreateBaseROIMask;
            IMAGEANLZ.(tab)(r).SAVEDROIS(roinum).ComputeROI(IMAGEANLZ.(tab)(r));
            IMAGEANLZ.(tab)(r).SetSavedROIValues;
        end
    end
    roinum = roinum + 1;
end
    
Status2('done','',1);