%====================================================
%  
%====================================================

function [B1MAP,err] = B1map5angle_v1a_Func(B1MAP,INPUT)

Status('busy','Generate B1map');
Status2('done','',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Get Input
%---------------------------------------------
IMG = INPUT.IMG;
clear INPUT;


for n = 1:5
    Im0 = IMG{n}.Im;
    val(n) = mean(mean(mean(mean(Im0(19:21,15:17,15:16,1:3)))))
end

figure(1000);
plot(B1MAP.specflip,val)



Status('done','');
Status2('done','',2);
Status2('done','',3);

