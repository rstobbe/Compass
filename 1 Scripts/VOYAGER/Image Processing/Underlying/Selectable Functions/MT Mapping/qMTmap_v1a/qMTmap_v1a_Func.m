%====================================================
%  
%====================================================

function [MAP,err] = qMTmap_v1a_Func(MAP,INPUT)

Status2('busy','Generate qMTmap',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Get Input
%---------------------------------------------
Im = INPUT.Im;
Mask = INPUT.Mask;
SeqPrms = INPUT.SeqPrms;
SimPrms = INPUT.SimPrms;
clear INPUT;

%---------------------------------------------
% Background Mask
%---------------------------------------------
%Mask - create function...

%---------------------------------------------
% Regression Setup
%---------------------------------------------
regfunc = str2func('qMTmap_v1a_Reg');
options = optimset( 'Algorithm','trust-region-reflective',...
                    'Display','iter','Diagnostics','on',...
                    'FinDiffType','forward',...                  % forward    
                    'DiffMinChange',0.001,...                    % 0.01 (0.025)
                    'TolFun',1e-12,...
                    'TolX',1e-12);
lb = [];
ub = [];

%---------------------------------------------
% qMT Fit
%---------------------------------------------
tic
[nx,ny,nz,N] = size(Im);
qMT = zeros([nx,ny,nz,N]);
for z = 1:nz
    for y = 1:ny
        for x = 1:nx
            if Mask(x,y,z) == 1
                INPUT.Vals = permute(squeeze(Im(x,y,z,:)),[2 1]);
                INPUT.SeqPrms = SeqPrms;
                INPUT.SimPrms = SimPrms;
                INPUT.MAP = MAP;
                func = @(V)regfunc(V,INPUT);
                V0 = [0.10 1200 1000 40 0.01 0.030 10];
                [V,resnorm,residual,exitflag,output,~,jacobian] = lsqnonlin(func,V0,lb,ub,options);
                qMT(x,y,z,:) = V;   
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

