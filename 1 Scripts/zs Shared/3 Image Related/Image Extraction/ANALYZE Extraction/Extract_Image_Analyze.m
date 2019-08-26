%===================================================
% 
%===================================================

function Extract_Image_Analyze(IM,meth)

[path] = uigetdir('','Select Directory to Put Image');

IM = flipdim(IM,3);
[x,y,z] = size(IM);

avw = avw_hdr_make_rob(x,y,z,1,1,1,max(IM(:)),0);

if strcmp(meth,'abs')
    avw.img = abs(IM);
else
    return
end

avw_img_write(avw,path,[],'ieee-le',1);



