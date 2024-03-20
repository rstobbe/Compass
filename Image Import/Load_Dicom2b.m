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
numimages = 1;
for n = 3:length(files)     
    dinfo = dicominfo([impath,'\',files(n).name]);
    imno = dinfo.InstanceNumber;
    ind = find(imnoarr == imno,1);
    if not(isempty(ind))
        numimages = numimages + 1;
    else
        if n == 3
            imnoarr = 1;
            continue
        else
            break
        end
    end
end

dinfo = dicominfo([impath,'\',files(3).name]);
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
    wid = 1;
    %error;
    %wid = dinfo.Private_0051_1017;
end
pixdim = [pix' wid];
ImInfo.vox = pixdim(1)*pixdim(2)*pixdim(3);

%------------
Image = 1;
%Image = 2;          % ASL
%------------
dinfo = dicominfo([impath,'\',files(Image+2).name]);
if strcmp(dinfo.ColorType,'truecolor')
    Im = zeros(dinfo.Rows,dinfo.Columns,500,3);
else
    Im = zeros(dinfo.Rows,dinfo.Columns,500);
end

for n = Image+2:numimages:length(files)       
    [path,name,ext] = fileparts(files(n).name);
    if ~strcmp(ext,'.dcm')
        continue
    end
    dinfo = dicominfo([impath,'\',files(n).name]);
    imno = dinfo.InstanceNumber;
    Im(:,:,imno,:) = dicomread([impath,'\',files(n).name]);
end 
Im = Im(:,:,1:imno,:);

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
Panel(3,:) = {'Birth',dinfo.PatientBirthDate,'Output'};
Panel(4,:) = {'Sex',dinfo.PatientSex,'Output'};
Panel(5,:) = {'Age',dinfo.PatientAge,'Output'};
Panel(6,:) = {'Date',dinfo.AcquisitionDate,'Output'};
Panel(7,:) = {'Time',dinfo.AcquisitionTime,'Output'};
Panel(8,:) = {'Protocol Name',dinfo.ProtocolName,'Output'};
Panel(9,:) = {'Series Description',dinfo.SeriesDescription,'Output'};
Panel(10,:) = {'Acq Orientation',ImInfo.acqorient,'Output'};
Panel(11,:) = {'Voxel (mm)',[num2str(pixdim(1),'%2.2f'),' x ',num2str(pixdim(2),'%2.2f'),' x ',num2str(pixdim(3),'%2.2f')],'Output'};
m = 12;
if isfield(dinfo,'RepetitionTime')
    Panel(m,:) = {'TR',dinfo.RepetitionTime,'Output'};
    m = m+1; 
end
if isfield(dinfo,'EchoTime')
    Panel(m,:) = {'TE',dinfo.EchoTime,'Output'};
    m = m+1; 
end
if isfield(dinfo,'FlipAngle')
    Panel(m,:) = {'Flip',dinfo.FlipAngle,'Output'};
    m = m+1; 
end
if isfield(dinfo,'InversionTime')
    Panel(m,:) = {'TI',dinfo.InversionTime,'Output'};
    m = m+1; 
end
if isfield(dinfo,'PixelBandwidth')
    Panel(m,:) = {'PixelBandwidth',dinfo.PixelBandwidth,'Output'};
    m = m+1; 
end
%Panel(m,:) = {'Coil',dinfo.Private_0051_100f,'Output'};
PanelOutput = cell2struct(Panel,{'label','value','type'},2);

IMG.Im = Im;
%IMG.ReconPars = ReconPars;
IMG.PanelOutput = PanelOutput;
IMG.ExpDisp = PanelStruct2Text(PanelOutput);
ImInfo.info = IMG.ExpDisp;




