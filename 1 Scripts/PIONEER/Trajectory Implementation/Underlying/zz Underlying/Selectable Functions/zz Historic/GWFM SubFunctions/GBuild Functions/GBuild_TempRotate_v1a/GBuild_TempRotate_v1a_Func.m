%=====================================================
% 
%=====================================================

function [GBLD,err] = GBuild_TempRotate_v1a_Func(GBLD,INPUT)

Status2('busy','Build Gradients from Templates Info',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Get Input
%---------------------------------------------
G = INPUT.G0;
PSMP = INPUT.PSMP;
clear INPUT

%---------------------------------------------
% Test
%---------------------------------------------
if not(isfield(PSMP,'rottemptheta'))
    err.flag = 1;
    err.msg = 'Rotated Trajectory Template Not Used';
    return
end
theta = PSMP.rottemptheta;

%---------------------------------------------
% Rotate
%---------------------------------------------
[N,L,~] = size(G);
Gout = zeros(PSMP.nproj,L,3);
Gout(1:N,:,:) = G;
for m = 2:length(theta)
    for n = 1:N
        Gout((m-1)*N+n,:,:) = Rotate3DPointsAboutZ_v1a(squeeze(G(n,:,:)),theta(m)-theta(1));
    end
end
        
%---------------------------------------------
% Return
%---------------------------------------------
GBLD.Gout = Gout;

Status2('done','',3);
