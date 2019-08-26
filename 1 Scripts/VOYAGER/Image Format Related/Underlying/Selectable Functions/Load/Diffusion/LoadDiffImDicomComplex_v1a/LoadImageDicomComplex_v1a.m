%=========================================================
% 
%=========================================================

function [SCRPTipt,SCRPTGBL,err] = LoadImageDicomComplex_v1a(SCRPTipt,SCRPTGBL)

global IMTc
global IMINFO
global CURFIG

IMTc = cell(1,3);

err.flag = 0;
err.msg = '';

%-------------------------------------
% Load Script
%-------------------------------------
locA = SCRPTipt(strcmp('DicomFile_Abs',{SCRPTipt.labelstr})).runfuncoutput{1};
locP = SCRPTipt(strcmp('DicomFile_Phase',{SCRPTipt.labelstr})).runfuncoutput{1};
fig = str2double(SCRPTipt(strcmp('Figure',{SCRPTipt.labelstr})).entrystr); 
DCMstart = str2double(SCRPTipt(strcmp('SliceStart',{SCRPTipt.labelstr})).entrystr); 
numslices = str2double(SCRPTipt(strcmp('NumSlices',{SCRPTipt.labelstr})).entrystr); 

%-------------------------------------
% Load Image Info
%-------------------------------------
dinfo = dicominfo(locA)
IMINFO(fig).dicominfo = dinfo;
pix = dinfo.PixelSpacing;
wid = dinfo.SpacingBetweenSlices;
IMINFO(fig).pixdim = [pix' wid];
IMINFO(fig).vox = IMINFO(fig).pixdim(1)*IMINFO(fig).pixdim(2)*IMINFO(fig).pixdim(3);

%---------------------------------------------------------
% load Mag Image
%---------------------------------------------------------
dots = strfind(locA,'\');
file = locA(dots(length(dots))+1:length(locA));
path = locA(1:dots(length(dots)));

file = file(1:strfind(file,'.IMA')-1);
dots = strfind(file,'.');
file = file(1:dots(length(dots))-1);

test = exist([path,file,'.',num2str(1,'%2.2i'),'.IMA'],'file');
if test == 2
    numres = 2;
    M = 100;
else
    test = exist([path,file,'.',num2str(1,'%2.3i'),'.IMA'],'file');
    if test == 2
        numres = 3;
        M = 1000;
    else
        test = exist([path,file,'.',num2str(1,'%2.4i'),'.IMA'],'file');
        if test == 2
            numres = 4;
            M = 10000;
        end
    end
end    
n = DCMstart;
m = 0;
IM_mag = zeros(dinfo.Rows,dinfo.Columns,numslices);
while true
    m = m+1;
    Status('busy',['Load Slice ',num2str(m)]);
    if numres == 2
        test = exist([path,file,'.',num2str(n,'%2.2i'),'.IMA'],'file');
        if test == 2
            IM_mag(:,:,m) = dicomread([path,file,'.',num2str(n,'%2.2i'),'.IMA']);
            n = n+1;
        else
            error('file does not exist');
        end
    elseif numres == 3
        test = exist([path,file,'.',num2str(n,'%2.3i'),'.IMA'],'file');
        if test == 2
            IM_mag(:,:,m) = dicomread([path,file,'.',num2str(n,'%2.3i'),'.IMA']);
            n = n+1;
        else
            error('file does not exist');
        end
    elseif numres == 4
        test = exist([path,file,'.',num2str(n,'%2.4i'),'.IMA'],'file');
        if test == 2
            IM_mag(:,:,m) = dicomread([path,file,'.',num2str(n,'%2.4i'),'.IMA']);
            n = n+1;
        else
            error('file does not exist');
        end
    end
    if m == numslices
        break
    end
    if m == M
        break
    end
end

%---------------------------------------------------------
% load Phase Image
%---------------------------------------------------------
dots = strfind(locP,'\');
file = locP(dots(length(dots))+1:length(locP));
path = locP(1:dots(length(dots)));

file = file(1:strfind(file,'.IMA')-1);
dots = strfind(file,'.');
file = file(1:dots(length(dots))-1);

test = exist([path,file,'.',num2str(1,'%2.2i'),'.IMA'],'file');
if test == 2
    numres = 2;
    M = 100;
else
    test = exist([path,file,'.',num2str(1,'%2.3i'),'.IMA'],'file');
    if test == 2
        numres = 3;
        M = 1000;
    else
        test = exist([path,file,'.',num2str(1,'%2.4i'),'.IMA'],'file');
        if test == 2
            numres = 4;
            M = 10000;
        end
    end
end    
n = DCMstart;
m = 0;
IM_phase = zeros(dinfo.Rows,dinfo.Columns,numslices);
while true
    m = m+1;
    Status('busy',['Load Slice ',num2str(m)]);
    if numres == 2
        test = exist([path,file,'.',num2str(n,'%2.2i'),'.IMA'],'file');
        if test == 2
            IM_phase(:,:,m) = dicomread([path,file,'.',num2str(n,'%2.2i'),'.IMA']);
            n = n+1;
        else
            error('file does not exist');
        end
    elseif numres == 3
        test = exist([path,file,'.',num2str(n,'%2.3i'),'.IMA'],'file');
        if test == 2
            IM_phase(:,:,m) = dicomread([path,file,'.',num2str(n,'%2.3i'),'.IMA']);
            n = n+1;
        else
            error('file does not exist');
        end
    elseif numres == 4
        test = exist([path,file,'.',num2str(n,'%2.4i'),'.IMA'],'file');
        if test == 2
            IM_phase(:,:,m) = dicomread([path,file,'.',num2str(n,'%2.4i'),'.IMA']);
            n = n+1;
        else
            error('file does not exist');
        end
    end
    if m == numslices
        break
    end
    if m == M
        break
    end
end

IM_phase = 2*pi*IM_phase/4096 - pi;
IM = IM_mag .* exp(1i*IM_phase);

%-------------------------------------
% Where to Load
%-------------------------------------
if fig == 0
    fig = CURFIG;
end
CURFIG = fig;
IMTc(fig) = {IM};




