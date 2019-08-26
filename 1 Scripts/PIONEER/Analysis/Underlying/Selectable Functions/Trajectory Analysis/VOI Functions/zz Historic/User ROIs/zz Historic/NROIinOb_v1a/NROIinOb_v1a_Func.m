%==============================================
% 
%==============================================

function [NROI,err] = NROIinOb_v1a_Func(NROI,INPUT)

Status2('busy','Find NROI in Object',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Common Variables
%---------------------------------------------
M = INPUT.M;
acc = INPUT.acc;
vinvox = INPUT.vinvox;
clear INPUT

%--------------------------------------
% Determine Nroi
%--------------------------------------  
aveROI = 0;
aveROI0 = 0;
de = acc;
Vis = 'Off';
destep = 0.1;
dir = -1;
M = abs(M);
while true
    ROI = logical(M >= de);
    if strcmp(Vis,'On')
        VisualizeROI(M,ROI,ZF);
    end
    MROI = M(ROI);
    vinROI = length(MROI(:));
    if vinROI == 0
        vinROI = NaN;
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
    if round(aveROI*1e4) > round(acc*1e4) 
        dir = -1;
        de = de - destep;
    elseif round(aveROI*1e4) < round(acc*1e4)
        dir = 1;
        de = de + destep;
    elseif round(aveROI*1e4) == round(acc*1e4)
        break
    end
    if destep < 1e-6
        break
    end
    Status2('busy',['Min Rel Val in ROI: ',num2str(de)],3);
end

NROI.Nroi = vinROI/vinvox;
NROI.ROI = ROI;

Status2('done','',2);
Status2('done','',3);



%==============================================
% Visualize ROI
%==============================================

function VisualizeROI(M,ROI,ZF)

adim1 = find(ROI(:,((ZF/2)+1),((ZF/2)+1)),1,'first');
adim2 = find(ROI(:,((ZF/2)+1),((ZF/2)+1)),1,'last');
bdim1 = find(ROI(((ZF/2)+1),:,((ZF/2)+1)),1,'first');
bdim2 = find(ROI(((ZF/2)+1),:,((ZF/2)+1)),1,'last');
cdim1 = find(ROI(((ZF/2)+1),((ZF/2)+1),:),1,'first');
cdim2 = find(ROI(((ZF/2)+1),((ZF/2)+1),:),1,'last');
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
            test2 = sum(sum(sum(ROI(a-1:a+1,b-1:b+1,c-1:c+1))));
            if test2 < 24
                mask(a,b,c) = 1;
            end
        end
    end
end
mask = mask.*ROI;
figure(103);
tstim = M;
tstim(logical(mask)) = 1;
image(squeeze(tstim(((ZF/2)+1),:,:))*128);
colormap(gray(128));
axis equal;
drawnow;
clear tstim
clear mask
