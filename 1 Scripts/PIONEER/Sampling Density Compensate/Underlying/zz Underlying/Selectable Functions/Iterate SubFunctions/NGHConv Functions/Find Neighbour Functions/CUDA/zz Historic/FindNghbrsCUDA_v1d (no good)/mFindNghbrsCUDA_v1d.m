%==================================================
% 
%==================================================

function [NGH,error,errorflag] = mFindNghbrsCUDA_v1d(Kmat,SDCS,AIDrp) 

errorflag = 0;
Status2('busy','',2);
Status2('busy','',3);
Stathands(1) = findobj('type','uicontrol','tag','ind2');
Stathands(2) = findobj('type','uicontrol','tag','ind3');

W = SDCS.W/2;                        % W = width from centre to edge of kernel...
npro = AIDrp.npro;
nproj = AIDrp.nproj;

Kx = Kmat(:,:,1)/AIDrp.kstep;                 
Ky = Kmat(:,:,2)/AIDrp.kstep;  
Kz = Kmat(:,:,3)/AIDrp.kstep;

%-----------------------------------------
% Calculate Search Annuli
%-----------------------------------------
rad = mean(sqrt(Kx.^2 + Ky.^2 + Kz.^2));

Radinds = zeros(2,AIDrp.npro);
radsep = zeros(1,npro);
for i = 1:npro
    ind1 = find((rad(i)-(W*1.8) <= rad) & (rad <= rad(i)+(W*1.8)),1,'first');
    Radinds(1,i) = ind1;                                   
    ind2 = find((rad(i)-(W*1.8) <= rad) & (rad <= rad(i)+(W*1.8)),1,'last');
    Radinds(2,i) = ind2;
    radsep(i) = ind2 - ind1;
end
Radinds = Radinds - 1;               % for C

%-----------------------------------------
% Testing
%-----------------------------------------
MaxNghbrs = max(radsep)*nproj;
TstIn = [1 0];
[NGH,NGHlens,test,CUDA,error] = FindNghbrsCUDA_v1d(single(Kx),single(Ky),single(Kz),int32(Radinds),...
                                            int32(npro),int32(nproj),single(W),int32(MaxNghbrs),int32(TstIn),Stathands);
test = 0;
                                        
