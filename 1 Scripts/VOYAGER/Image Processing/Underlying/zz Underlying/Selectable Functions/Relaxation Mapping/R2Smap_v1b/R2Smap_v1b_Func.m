%====================================================
%  
%====================================================

function [MAP,err] = R2Smap_v1b_Func(MAP,INPUT)

Status2('busy','Generate R2Smap',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Get Input
%---------------------------------------------
Im = INPUT.Im;
TEarr = INPUT.TEarr;
mask = INPUT.mask;
clear INPUT;

%---------------------------------------------
% R2Star Fit
%---------------------------------------------
tic
[nx,ny,nz,nexp] = size(Im);
R2S = NaN*zeros([nx,ny,nz]);
for z = 1:nz
    for y = 1:ny
        for x = 1:nx
            if mask(x,y,z) == 1
                vals = permute(squeeze(Im(x,y,z,:)),[2 1]);
                Est = [vals(1) 0.05];
                beta = nlinfit(TEarr,vals,@Reg_R2S,Est);
                R2S(x,y,z) = beta(2);   
            end       
        end
        Status2('busy',['z: ',num2str(z),'  y: ',num2str(y)],2); 
    end
end
toc

%---------------------------------------------
% Return
%---------------------------------------------
MAP.Im = R2S;

Status2('done','',2);
Status2('done','',3);

