%=========================================================
% 
%=========================================================

function [COMP,err] = DiffImage2Gen_v1a_Func(INPUT,COMP)

Status('busy','Difference Image Generation');
Status2('done','',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Get Input
%---------------------------------------------
Ims = INPUT.Ims;
clear INPUT;

%---------------------------------------------
% Calculate
%---------------------------------------------
%ImDif = squeeze(Ims(:,:,:,2) - Ims(:,:,:,1));
%ImDif = squeeze(abs(Ims(:,:,:,2,2)) - abs(Ims(:,:,:,3,2)));
%ImDif = squeeze(real(Ims(:,:,:,2,2)) - real(Ims(:,:,:,3,2)));
%ImDif = squeeze(imag(Ims(:,:,:,2,2)) - imag(Ims(:,:,:,3,2)));
%ImDif = squeeze(angle(Ims(:,:,:,2,1)) - angle(Ims(:,:,:,2,2)));
%ImDif = squeeze(Ims(:,:,:,2,1) - Ims(:,:,:,3,1));
%ImDif = squeeze(abs(Ims(:,:,:,2,1)));

%ImDif = squeeze(Ims(:,:,:,1) - Ims(:,:,:,2));
%ImDif = squeeze(real(Ims(:,:,:,1)) - real(Ims(:,:,:,2)));
%ImDif = squeeze(imag(Ims(:,:,:,1)) - imag(Ims(:,:,:,2)));
%ImDif = squeeze(abs(Ims(:,:,:,1)) - abs(Ims(:,:,:,2)));

%Im1 = squeeze(abs(Ims(:,:,:,1,1)) + abs(Ims(:,:,:,2,1)) + abs(Ims(:,:,:,3,1)))/3;
%Im2 = squeeze(abs(Ims(:,:,:,1,2)) + abs(Ims(:,:,:,2,2)) + abs(Ims(:,:,:,3,2)))/3;
%ImDif = Im1 - Im2;

sz = size(Ims);
Angle = zeros([sz(1) sz(2) sz(3) 6]);
Angle(:,:,:,1) = squeeze(abs(Ims(:,:,:,1,1)));
Angle(:,:,:,2) = squeeze(abs(Ims(:,:,:,2,1)));
Angle(:,:,:,3) = squeeze(abs(Ims(:,:,:,3,1)));
Angle(:,:,:,4) = squeeze(abs(Ims(:,:,:,1,2)));
Angle(:,:,:,5) = squeeze(abs(Ims(:,:,:,2,2)));
Angle(:,:,:,6) = squeeze(abs(Ims(:,:,:,3,2)));
MeanAngle = mean(Angle,4);

ImDif = zeros([sz(1) sz(2) sz(3) 6]);
for n = 1:6
    %ImDif(:,:,:,n) = Angle(:,:,:,n) - MeanAngle;
    ImDif(:,:,:,n) = (Angle(:,:,:,n) - MeanAngle) ./ MeanAngle;
end

%---------------------------------------------
% Plot
%---------------------------------------------
%Scale = max(abs(Ims(:)))/100;
%Scale = 3.14;
%Scale = 3;
ImDif = 100*ImDif;
Scale = 2;
ImDif(abs(ImDif)>Scale) = NaN; 
ImDif = squeeze(ImDif(17:60,:,4,:));
%ImDif = 180*ImDif/pi
%ImDif = 100*ImDif/mean(abs(MeanAngle(:)));


sz = size(ImDif);
IMSTRCT.type = 'real'; IMSTRCT.start = 1; IMSTRCT.step = 1; IMSTRCT.stop = 6; 
IMSTRCT.rows = 6; IMSTRCT.lvl = [-Scale Scale]; IMSTRCT.SLab = 0; IMSTRCT.figno = figure(); 
IMSTRCT.docolor = 1; IMSTRCT.ColorMap = 'ColorMap4'; IMSTRCT.figsize = [];
AxialMontage_v2a(ImDif,IMSTRCT);

%---------------------------------------------
% Return
%---------------------------------------------
COMP.ImDif = ImDif;

error();

Status('done','');
Status2('done','',2);
Status2('done','',3);
