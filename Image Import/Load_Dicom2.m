%===================================================
% 
%===================================================

function [IM,ImInfo] = Load_Dicom2(impath,imfile,fileext)

files = dir(impath);
dinfo = dicominfo([impath,files(3).name]);
IM = zeros(dinfo.Rows,dinfo.Columns,length(files)-2);
pix = dinfo.PixelSpacing;
wid = dinfo.SpacingBetweenSlices;
ImInfo.pixdim = [pix' wid];
ImInfo.vox = ImInfo.pixdim(1)*ImInfo.pixdim(2)*ImInfo.pixdim(3);
ImInfo.info = '';

for n = 1:length(files)-2
    IM(:,:,n) = dicomread([impath,files(n+2).name]);
end

% test = max(abs(IM(:)));
% if test > 100000
%     IM = IM/1000;
% elseif test > 10000
%     IM = IM/100; 
% elseif test > 1000
%     IM = IM/10; 
% end

% IM = flipdim(IM,1);