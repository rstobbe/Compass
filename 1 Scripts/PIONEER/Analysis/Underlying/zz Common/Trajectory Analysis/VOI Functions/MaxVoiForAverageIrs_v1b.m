%==============================================
% v1b -> same as v1a
%==============================================

function [ROI,err] = MaxVoiForAverageIrs_v1b(ROI,INPUT)

Status2('busy','Find ROI in Object',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Common Variables
%---------------------------------------------
Im = INPUT.SmearIm;
ZF = INPUT.zf;
Vis = INPUT.Vis;
clear INPUT

%--------------------------------------
% Determine Nroi
%--------------------------------------  
aveROI = 0;
aveROI0 = 0;
de = ROI.aveirs;
destep = 0.1;
dir = -1;
Im = abs(Im);
while true
    roi = logical(Im >= de);
%     if strcmp(Vis,'On')
%         VisualizeROI(Im,roi,ZF);
%     end
    MROI = Im(roi);
    vinROI = length(MROI(:));
    if vinROI == 0
        roi = NaN;
        break
    end
    aveROI00 = aveROI0;
    aveROI0 = aveROI;
    aveROI = mean(MROI(:));
    if aveROI0 ~= 0
        if aveROI == aveROI0
            if dir == -1
                de = de - destep;
            elseif dir == 1
                de = de + destep;
            end
            continue
        elseif aveROI == aveROI00
            destep = destep*0.1;
        end
    end
    if round(aveROI*1e4) > round(ROI.aveirs*1e4) 
        dir = -1;
        de = de - destep;
    elseif round(aveROI*1e4) < round(ROI.aveirs*1e4)
        dir = 1;
        de = de + destep;
    elseif round(aveROI*1e4) == round(ROI.aveirs*1e4)
        break
    end
    if destep < 1e-6
        break
    end
    Status2('busy',['Minimum IRS in VOI:  ',num2str(de)],3);
end

if strcmp(Vis,'On')
    VisualizeROI(Im,roi,ZF);
end

ROI.Mask = roi;
ROI.aveirsout = aveROI;

Status2('done','',2);
Status2('done','',3);



%==============================================
% Visualize ROI
%==============================================

function VisualizeROI(Im,roi,ZF)

adim1 = find(roi(:,((ZF/2)+1),((ZF/2)+1)),1,'first');
adim2 = find(roi(:,((ZF/2)+1),((ZF/2)+1)),1,'last');
bdim1 = find(roi(((ZF/2)+1),:,((ZF/2)+1)),1,'first');
bdim2 = find(roi(((ZF/2)+1),:,((ZF/2)+1)),1,'last');
cdim1 = find(roi(((ZF/2)+1),((ZF/2)+1),:),1,'first');
cdim2 = find(roi(((ZF/2)+1),((ZF/2)+1),:),1,'last');
if (isempty(adim1) || isempty(bdim1) || isempty(cdim1)) && not(isnan(vinROI))
    adim1 = ((ZF/2)+1)-x;          % regions may be in corners of anisotropic objects and not center
    adim2 = ((ZF/2)+1)+x;
    bdim1 = ((ZF/2)+1)-x;          
    bdim2 = ((ZF/2)+1)+x;
    cdim1 = ((ZF/2)+1)-x*2;          
    cdim2 = ((ZF/2)+1)+x*2;
end
mask = zeros(ZF,ZF,ZF);
for a = adim1-1:adim2+1
    for b = bdim1-1:bdim2+1
        for c = cdim1-1:cdim2+1
            test2 = sum(sum(sum(roi(a-1:a+1,b-1:b+1,c-1:c+1))));
            if test2 < 24
                mask(a,b,c) = 1;
            end
        end
    end
end
mask = mask.*roi;
figure(103);
tstim = Im;
tstim(logical(mask)) = 1;
image(squeeze(tstim(((ZF/2)+1),:,:))*128);
colormap(gray(128));
axis equal;
drawnow;
clear tstim
clear mask
