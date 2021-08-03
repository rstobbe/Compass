%===================================================
% Load Image
%===================================================

function [IMG,Name,ImType,err] = Import_Image(impath,imfile0)

Num = 1;
if iscell(imfile0)
    Num = length(imfile0);
end

%---------------------------------------------------------
% Determine Image Type
%---------------------------------------------------------
for n = 1:Num
    if Num == 1
        Status2('busy','Load Image',1);
        imfile = imfile0;
    else
        Status2('busy',['Load Image ',num2str(n)],1);
        imfile = imfile0{n};
    end
    ext = imfile;
    while true
        [fileext,ext] = strtok(ext,'.');
        if isempty(ext)
            break
        end
    end
    if strcmp(fileext,'hdr')
        [IMG{n},ImInfo{n},err] = Load_Analyze([impath,imfile]); 
        ImType{n} = 'Analyze';
        Name{n} = imfile;
    elseif strcmp(fileext,'nii')
        [IMG{n},ImInfo{n},err] = Load_Nifti([impath,imfile]); 
        ImType{n} = 'Nifti';
        Name{n} = imfile;
    elseif strcmp(fileext,'dcm')
        [IMG{n},ImInfo{n},err] = Load_Dicom2b(impath,imfile);
        inds = strfind(impath,'\');
        Name{n} = impath(inds(end-1)+1:inds(end)-1);
        ImType{n} = 'Dicom2';
    elseif strcmp(fileext,'mat')
        [IMG{n},ImInfo{n},ImType{n},err] = Load_Mat([impath,imfile]);
        %[Name,~] = strtok(imfile,'.');
        Name{n} = imfile;
    else
        %---
        [IMG{n},ImInfo{n},err] = Load_Dicom2b(impath,imfile);
        inds = strfind(impath,'\');
        Name{n} = impath(inds(end-1)+1:inds(end)-1);
        ImType{n} = 'Dicom3';    
        %---  
        %err.flag = 1;
        %err.msg = 'Image Type Not Supported';    
    end
    if err.flag
        %ErrDisp(err);
        return
    end
    IMG{n}.name = Name{n};
    IMG{n}.path = impath;

    %---------------------------------------------------------
    % Remove NaN
    %---------------------------------------------------------
    %IMG.Im(logical(isnan(IMG.Im))) = 0;

    %---------------------------------------------------------
    % Make Sure Double
    %---------------------------------------------------------
    IMG{n}.Im = double(IMG{n}.Im);

    %---------------------------------------------------------
    % Display Setup
    %---------------------------------------------------------
    if not(isfield(IMG{n},'IMDISP'))
        INPUT.Image = IMG{n}.Im;
        INPUT.MSTRCT.type = 'abs';
        INPUT.MSTRCT.dispwid = [0 max(abs(IMG{n}.Im(:)))];
        INPUT.MSTRCT.ImInfo = ImInfo{n};
        IMDISP = ImagingPlotSetup(INPUT);
        IMG{n}.IMDISP = IMDISP;
    end
end    
    
Status2('done','',1);


