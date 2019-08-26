%=========================================================
% 
%=========================================================

function [ALGN,err] = AlignImages_v1b_Func(ALGN,INPUT)

Status2('busy','Align Images',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Get Input
%---------------------------------------------
IMG = INPUT.IMG;
StatIm = abs(IMG{2}.Im);
JiggleIm = abs(IMG{1}.Im);
clear INPUT;

%---------------------------------------------
% Mask Images
%---------------------------------------------
StatIm(StatIm < ALGN.maskthresh*max(StatIm(:))) = 0;
JiggleIm(JiggleIm < ALGN.maskthresh*max(JiggleIm(:))) = 0;
StatIm = StatIm/max(StatIm(:));
JiggleIm = JiggleIm/max(JiggleIm(:));

%---------------------------------------------
% Plot Image
%---------------------------------------------
INPUT.Image = StatIm;
PlotMontage_v1c(INPUT);
INPUT.Image = JiggleIm;
PlotMontage_v1c(INPUT);
button = questdlg('continue?');
if strcmp(button,'No')
    err.flag = 1;
    err.msg = 'Alignment Aborted';
    return
end
clear INPUT;

INPUT.Image(:,:,:,1) = StatIm;
INPUT.Image(:,:,:,2) = JiggleIm;

%---------------------------------------------
% Regression Setup
%---------------------------------------------
regfunc = str2func([ALGN.method,'_Reg']);
options = optimset( 'Algorithm','trust-region-reflective',...
                    'Display','iter','Diagnostics','on',...
                    'FinDiffType','forward',...                  % forward    
                    'DiffMinChange',0.01,...                    % 0.01 (0.025)
                    'TolFun',1e-2,...
                    'TolX',1e-2);
lb = [];
ub = [];

%---------------------------------------------
% Regression Setup
%---------------------------------------------
V0 = [0 0 0 0 0 0 1];
func = @(V)regfunc(V,ALGN,INPUT);
[V,resnorm,residual,exitflag,output,~,jacobian] = lsqnonlin(func,V0,lb,ub,options);
%ci = nlparci(V,residual,jacobian);
%CI(n,:,:) = ci;

%---------------------------------------------
% Scale 'V's
%---------------------------------------------
V(1:3) = V(1:3)/10;
V(4:6) = V(4:6)*10;
V

%---------------------------------------------
% Transform Image
%---------------------------------------------
Image(:,:,:,2) = Transform3DMatrix_v1b(Image(:,:,:,2),V(1),V(2),V(3),V(4),V(5),V(6));

%---------------------------------------------
% Return
%---------------------------------------------
ALGN.Im = Image;
ALGN.V = V;
ALGN.resid = residual;

Status2('done','',2);
Status2('done','',3);

