%===================================================
% Select Image
%===================================================

function [imfile,impath,err] = Select_Image(DefPath,DefFileType)

err.flag = 0;
err.msg = 0;

%---------------------------------------------------------
% Select Image File
%---------------------------------------------------------
Status2('busy','Select Images',1); 
[imfile,impath] = uigetfile(['*.nii',';*.hdr',';*.dcm',';*.mat',';*.gz'],'Select Images',DefPath,'MultiSelect','on');
if impath == 0
    err.flag = 4;
    err.msg = 'Image Not Selected';
    ErrDisp(err);
    return
end

global COMPASSINFO
Text = fileread(COMPASSINFO.USERGBL.userinfofile);
ind1 = strfind(Text,'User.experimentsloc');
ind2 = strfind(Text,'User.trajdevloc');
Text = [Text(1:ind1+22),impath,Text(ind2-4:end)];
fid = fopen([COMPASSINFO.USERGBL.userinfofile],'w+');
fwrite(fid,Text);
fclose('all');
Status2('done','',1);


