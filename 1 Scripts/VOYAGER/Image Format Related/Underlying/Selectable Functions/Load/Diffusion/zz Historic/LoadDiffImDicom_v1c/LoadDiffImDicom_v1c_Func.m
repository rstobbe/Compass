%=========================================================
% - Matrix Output:  (x,y,slices,b-values,dirs,aves)
% - b0 images are averaged (i.e. same b0 image for each 'dir' and 'ave')
%=========================================================

function [IMAT,err] = LoadDiffImDicom_v1c_Func(IMAT,INPUT)

Status2('busy','Load DW Dicom Images',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Common Variables
%---------------------------------------------
locm = IMAT.locm;
totb0ims = IMAT.totb0ims;
totslices = IMAT.totslices;
totdirs = IMAT.totdirs;
numaverages = IMAT.numaverages;
numbvalues = IMAT.numbvalues;

%-------------------------------------
% Get Dicom Info
%-------------------------------------
filem = locm(1:strfind(locm,'.IMA')-1);
dots = strfind(filem,'.');
filem = filem(1:dots(length(dots))-1);

test = exist([filem,'.',num2str(1,'%2.2i'),'.IMA'],'file');
if test == 2
    dinfo = dicominfo([filem,'.',num2str(1,'%2.2i'),'.IMA']);
    numres = 2;
else
    test = exist([filem,'.',num2str(1,'%2.3i'),'.IMA'],'file');
    if test == 2
        dinfo = dicominfo([filem,'.',num2str(1,'%2.3i'),'.IMA']);
        numres = 3;
    else
        test = exist([filem,'.',num2str(1,'%2.4i'),'.IMA'],'file');
        if test == 2
            dinfo = dicominfo([filem,'.',num2str(1,'%2.4i'),'.IMA']);
            numres = 4;
        end
    end
end    
pix = dinfo.PixelSpacing;
wid = dinfo.SpacingBetweenSlices;
iminfo.pixdim = [pix' wid];
iminfo.vox = iminfo.pixdim(1)*iminfo.pixdim(2)*iminfo.pixdim(3);
iminfo.info = dinfo;

%-------------------------------------
% Load b0 Images
%-------------------------------------
b0im = zeros(dinfo.Rows,dinfo.Columns,totb0ims*numaverages,totslices);
for slice = 1:totslices
    b0imnum = 0;
    for nave = 1:numaverages
        m = slice + (nave-1)*((numbvalues-1)*totdirs*totslices + totb0ims*totslices);
        for a = 1:totb0ims
            b0imnum = b0imnum + 1;
            if numres == 2
                b0im(:,:,b0imnum,slice) = dicomread([filem,'.',num2str(m,'%2.2i'),'.IMA']);
            elseif numres == 3
                b0im(:,:,b0imnum,slice) = dicomread([filem,'.',num2str(m,'%2.3i'),'.IMA']);
            elseif numres == 4
                b0im(:,:,b0imnum,slice) = dicomread([filem,'.',num2str(m,'%2.4i'),'.IMA']);
            end    
            m = m + totslices;
        end    
    end
    Status2('busy',['Loading: Slice Number ',num2str(slice),'  B0'],3);    
end
%-------------------------------------
% Average
%-------------------------------------
aveb0im = squeeze(mean(b0im,3));

%-------------------------------------
% Load b0 > 0 Images
%-------------------------------------
dwims = zeros(dinfo.Rows,dinfo.Columns,totslices,numbvalues,totdirs,numaverages);
for slice = 1:totslices
    for nave = 1:numaverages
        for d = 1:totdirs        
            m = totb0ims*totslices + (d-1)*totslices + slice + (nave-1)*((numbvalues-1)*totdirs*totslices + totb0ims*totslices);
            for a = 1:numbvalues
                if a == 1
                    dwims(:,:,slice,1,d,nave) = aveb0im(:,:,slice);
                else
                    if numres == 2
                        dwims(:,:,slice,a,d,nave) = dicomread([filem,'.',num2str(m,'%2.2i'),'.IMA']);
                    elseif numres == 3
                        dwims(:,:,slice,a,d,nave) = dicomread([filem,'.',num2str(m,'%2.3i'),'.IMA']);
                    elseif numres == 4
                        dwims(:,:,slice,a,d,nave) = dicomread([filem,'.',num2str(m,'%2.4i'),'.IMA']);
                    end
                    m = m + totslices*totdirs;
                end
            end
        Status2('busy',['Loading: Slice Number ',num2str(slice),'  Direction ',num2str(d)],3);    
        end
    end
end

%---------------------------------------------
% Return
%---------------------------------------------
IMAT.dwims = dwims;
IMAT.iminfo = iminfo;
IMAT.dims = {'x','y','slice','bvalue','dir','ave'};

%---------------------------------------------
% Panel Output
%--------------------------------------------- 
%PanelOutput = cell2struct(Panel,{'label','value','type'},2);
%IMAT.PanelOutput = PanelOutput;

Status2('done','',2);
Status2('done','',3);
