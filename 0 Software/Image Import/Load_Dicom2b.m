%===================================================
% 
%===================================================

function [IMG,ImInfo,err] = Load_Dicom2b(impath,imfile)

err.flag = 0;
err.msg = '';
ImInfo = '';
IMG = struct();

init = 0;
files = dir(impath);
imnoarr = [];
series = 0;
for n = 3:length(files)
    if files(n).isdir
        continue
    end
    if not(isdicom([impath,'\',files(n).name]))
        continue
    end        
    dinfo = dicominfo([impath,'\',files(n).name]);
    imno = dinfo.InstanceNumber;
    ind = find(imnoarr == imno,1);
    if not(isempty(ind))
        err.flag = 1; 
        err.msg = 'Images from multiple series in folder';
        return
    end
    if init == 1 && series ~= dinfo.SeriesNumber
        err.flag = 1; 
        err.msg = 'Images from multiple series in folder';
        return
    end
    if init == 0
        %instance0 = dinfo.InstanceNumber
        %series0 = dinfo.SeriesNumber
        if dinfo.InstanceNumber ~= 1
            err.flag = 1; 
            err.msg = 'Folder missing beginning images';
            return
        end
        series = dinfo.SeriesNumber;
        if isfield(dinfo,'Private_0051_100e')
            orient = dinfo.Private_0051_100e;                       % Not sure about this always existing
        else
            orient = 'Tra';
        end
        Im = zeros(dinfo.Rows,dinfo.Columns,500);
        if isfield(dinfo,'PixelSpacing')
            pix = dinfo.PixelSpacing;
        else
            pix = [1;1];
        end
        if isfield(dinfo,'SpacingBetweenSlices')
            wid = dinfo.SpacingBetweenSlices;
        elseif isfield(dinfo,'SliceThickness')
            wid = dinfo.SliceThickness;
        else
            error;
            %wid = dinfo.Private_0051_1017;
        end
        pixdim = [pix' wid];
        ImInfo.vox = pixdim(1)*pixdim(2)*pixdim(3);
        init = 1;
    end
    Im(:,:,imno) = dicomread([impath,'\',files(n).name]);
    imnoarr = cat(1,imnoarr,imno);
end 

if max(imnoarr) ~= length(imnoarr)
    error;  %fix for error handling
end
Im = Im(:,:,1:max(imnoarr));

%----------------------------------------------
% Orient Properly
%----------------------------------------------
sz = size(Im);
if length(sz) > 2
    if strcmp(orient(1:3),'Sag')
        Im = permute(Im,[2 3 1 4 5 6]);                 
        ImInfo.pixdim = pixdim([2 3 1]);
        Im = flip(Im,3);         
        %ReconPars.ImvoxTB = round(ImInfo.pixdim(1)*100)/100;
        %ReconPars.ImvoxLR = round(ImInfo.pixdim(2)*100)/100;  
        %ReconPars.ImvoxIO = round(ImInfo.pixdim(3)*100)/100; 
        ImInfo.acqorient = 'Sagittal';
        ImInfo.baseorient = 'Axial';
    elseif strcmp(orient(1:3),'Cor')
        Im = permute(Im,[3 2 1 4 5 6]);
        ImInfo.pixdim = pixdim([3 2 1]);
        Im = flip(Im,3);        
        %ReconPars.ImvoxTB = round(ImInfo.pixdim(1)*100)/100;
        %ReconPars.ImvoxLR = round(ImInfo.pixdim(2)*100)/100;  
        %ReconPars.ImvoxIO = round(ImInfo.pixdim(3)*100)/100;  
        ImInfo.acqorient = 'Coronal';
        ImInfo.baseorient = 'Axial'; 
    elseif strcmp(orient(1:3),'Tra')               
        ImInfo.pixdim = pixdim;
        %----
        %Im = flip(Im,3);                     % don't know if should be here
        %----      
        ImInfo.acqorient = 'Axial';  
        ImInfo.baseorient = 'Axial';  
    end
else
    ImInfo.acqorient = 'Axial';               % for now
    ImInfo.baseorient = 'Axial';
    ImInfo.pixdim = pixdim;
end

%----------------------------------------------
% Display Info
%----------------------------------------------
Panel(1,:) = {'','','Output'};
Panel(2,:) = {'Volunteer',dinfo.PatientName.FamilyName,'Output'};
Panel(3,:) = {'Date',dinfo.AcquisitionDate,'Output'};
Panel(4,:) = {'Time',dinfo.AcquisitionTime,'Output'};
Panel(5,:) = {'Protocol Name',dinfo.ProtocolName,'Output'};
Panel(6,:) = {'Sequence Name',dinfo.SequenceName,'Output'};
Panel(7,:) = {'Acq Orientation',ImInfo.acqorient,'Output'};
Panel(8,:) = {'Voxel (mm)',[num2str(pixdim(1),'%2.2f'),' x ',num2str(pixdim(2),'%2.2f'),' x ',num2str(pixdim(3),'%2.2f')],'Output'};
Panel(9,:) = {'TR',dinfo.RepetitionTime,'Output'};
Panel(10,:) = {'TE',dinfo.EchoTime,'Output'};
m = 11;
if isfield(dinfo,'FlipAngle')
    Panel(m,:) = {'Flip',dinfo.FlipAngle,'Output'};
    m = m+1; 
end
if isfield(dinfo,'InversionTime')
    Panel(12,:) = {'TI',dinfo.InversionTime,'Output'};
    m = m+1; 
end
Panel(m,:) = {'PixelBandwidth',dinfo.PixelBandwidth,'Output'};
PanelOutput = cell2struct(Panel,{'label','value','type'},2);

IMG.Im = Im;
%IMG.ReconPars = ReconPars;
IMG.PanelOutput = PanelOutput;
IMG.ExpDisp = PanelStruct2Text(PanelOutput);
ImInfo.info = IMG.ExpDisp;




