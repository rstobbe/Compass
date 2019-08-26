%=========================================================
% 
%=========================================================

function [MANIP,err] = FullManipulate_v1a_Func(MANIP,INPUT)

Status2('busy','Manipulate Images',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Input
%---------------------------------------------
IMG = INPUT.IMG;
clear INPUT

%---------------------------------------------
% Permute
%---------------------------------------------
ind = strfind(MANIP.permute,',');
pmt(1) = str2double(MANIP.permute(2));
for n = 1:length(ind)
    pmt(n+1) = str2double(MANIP.permute(ind(n)+1));
end
IMG.Im = permute(IMG.Im,pmt);       
IMG.IMDISP.ImInfo.pixdim = IMG.IMDISP.ImInfo.pixdim(pmt);

%---------------------------------------------
% Flip
%---------------------------------------------
if strcmp(MANIP.flipLR,'Yes')
    IMG.Im = flip(IMG.Im,2);
end
if strcmp(MANIP.flipTB,'Yes')
    IMG.Im = flip(IMG.Im,1);
end
if strcmp(MANIP.flipIO,'Yes')
    IMG.Im = flip(IMG.Im,3);
end

%---------------------------------------------
% Return
%---------------------------------------------
MANIP.IMG = IMG;

Status2('done','',2);
Status2('done','',3);
