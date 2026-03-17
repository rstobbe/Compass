%===================================================
% 
%===================================================

function [IMG,ImInfo,err] = Load_Dicom(impath,imfile)

err.flag = 0;
err.msg = '';
ImInfo = '';

init = 0;
files = dir(impath);
for n = 3:length(files)
    if files(n).isdir
        continue
    end
    if not(isdicom([impath,'\',files(n).name]))
        continue
    end        
    dinfo = dicominfo([impath,'\',files(n).name]);
    imno = dinfo.InstanceNumber;
    if init == 0
        Im = zeros(dinfo.Rows,dinfo.Columns,length(files)-2);
        pix = dinfo.PixelSpacing;
        wid = dinfo.SpacingBetweenSlices;
        ImInfo.pixdim = [pix' wid];
        ImInfo.vox = ImInfo.pixdim(1)*ImInfo.pixdim(2)*ImInfo.pixdim(3);
        ImInfo.info = '';
        init = 1;
    end
    Im(:,:,imno) = dicomread([impath,'\',files(n).name]);
end    
IMG.Im = Im;
ImInfo.acqorient = 'Axial';  
ImInfo.baseorient = 'Axial';  

%----           % to be deleted
ReconPars.ImvoxTB = round(ImInfo.pixdim(1)*100)/100;
ReconPars.ImvoxLR = round(ImInfo.pixdim(2)*100)/100;  
ReconPars.ImvoxIO = round(ImInfo.pixdim(3)*100)/100; 
IMG.ReconPars = ReconPars;
%----