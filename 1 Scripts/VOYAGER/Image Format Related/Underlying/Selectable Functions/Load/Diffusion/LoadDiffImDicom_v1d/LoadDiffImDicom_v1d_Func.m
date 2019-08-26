%=========================================================
% - Matrix Output:  (x,y,slices,b-values,dirs,aves)
% - 
%=========================================================

function [IMAT,err] = LoadDiffImDicom_v1d_Func(IMAT,INPUT)

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

%---------------------------------------------
% Common Images
%---------------------------------------------
init = 0;
files = dir(locm);
filecnt = 0;
for n = 3:length(files)
    if files(n).isdir
        continue
    end
    if not(isdicom([locm,'\',files(n).name]))
        continue
    end        
    dinfo = dicominfo([locm,'\',files(n).name]);
    imno = dinfo.InstanceNumber;
    if init == 0
        IM = zeros(dinfo.Rows,dinfo.Columns,length(files));
        pix = dinfo.PixelSpacing;
        wid = dinfo.SpacingBetweenSlices;
        iminfo.pixdim = [pix' wid];
        iminfo.vox = iminfo.pixdim(1)*iminfo.pixdim(2)*iminfo.pixdim(3);
        iminfo.info = dinfo;
        init = 1;
    end
    IM(:,:,imno) = dicomread([locm,'\',files(n).name]);
    Status2('busy',['Loading: Dicom File Number ',num2str(n)],3);
    filecnt = filecnt+1;
end    
IM = IM(:,:,1:filecnt);

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
            b0im(:,:,b0imnum,slice) = IM(:,:,m);   
            m = m + totslices;
        end    
    end
    Status2('busy',['Segment: Slice Number ',num2str(slice),'  b0'],3);    
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
                    dwims(:,:,slice,a,d,nave) = IM(:,:,m);
                    m = m + totslices*totdirs;
                end
            end
            Status2('busy',['Segment: Slice Number ',num2str(slice),'  Direction ',num2str(d)],3);    
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
