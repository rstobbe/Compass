%====================================================
%  
%====================================================

function [MAP,err] = R2Smap_v1a_Func(MAP,INPUT)

Status('busy','Generate R2Smap');
Status2('done','',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Get Input
%---------------------------------------------
IMG = INPUT.IMG;
Im = abs(IMG.Im);
ExpPars = IMG.ExpPars;
[nx,ny,nz,nexp] = size(Im);
clear INPUT;

%---------------------------------------------
% Get TE
%---------------------------------------------
te = ExpPars.te;
esp = ExpPars.esp;
ne = ExpPars.ne;
TEarr = (te:esp:te+(ne-1)*esp)*1000;

%---------------------------------------------
% Background Mask
%---------------------------------------------
Im1 = squeeze(Im(:,:,:,1));
mask1 = ones(size(Im1));
aveval = mean(mean(mean(Im1(nx/2-nx/4:nx/2+nx/4,ny/2-ny/4:ny/2+ny/4,nz/2-nz/4:nz/2+nz/4))));
mask1(Im1 < aveval*MAP.MV) = 0;
%MAP.Im = mask1;
%return

%---------------------------------------------
% CSF Mask && Skull
%---------------------------------------------
mask2 = ones(size(Im1));
ImN = squeeze(Im(:,:,:,ne));
T2Smax = 100;
relmax = exp(-(TEarr(ne)-TEarr(1))/T2Smax);
%relmax = 0.9;
mask2(ImN > Im1*relmax) = 0;
%MAP.Im = mask2;
%return

%---------------------------------------------
% Skull Mask
%---------------------------------------------
mask3 = ones(size(Im1));
Im2 = squeeze(Im(:,:,:,2));
T2Smin = 25;
relmin = exp(-(TEarr(2)-TEarr(1))/T2Smin);
mask3(Im2 < Im1*relmin) = 0;
%MAP.Im = mask3;
%return

%---------------------------------------------
% T2Star Fit
%---------------------------------------------
tic
T2S = zeros([nx,ny,nz]);
for z = 1:nz
    for y = 1:ny
        for x = 1:nx
            if mask1(x,y,z) == 1 && mask2(x,y,z) == 1 && mask3(x,y,z) == 1
                vals = permute(squeeze(Im(x,y,z,:)),[2 1]);
                Est = [vals(1) 15];
                beta = nlinfit(TEarr,vals,@Reg_T2S,Est);
                T2S(x,y,z) = beta(2);
            elseif mask1(x,y,z) == 1 && mask2(x,y,z) == 1 && mask3(x,y,z) == 0
                vals = permute(squeeze(Im(x,y,z,:)),[2 1]);
                Est = [vals(1) 0.5];
                beta = nlinfit(TEarr,vals,@Reg_T2S,Est);
                T2S(x,y,z) = beta(2);
            end
            %clf(figure(1)); hold on;
            %F = beta(1)*exp(-TEarr/beta(2)); 
            %plot(TEarr,vals,'*');
            %plot(TEarr,F);            
        end
        Status2('busy',['z: ',num2str(z),'  y: ',num2str(y)],2); 
    end
end
MAP.Im = T2S;
toc

%---------------------------------------------
% Return
%---------------------------------------------
Status('done','');
Status2('done','',2);
Status2('done','',3);

