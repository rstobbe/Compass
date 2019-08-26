%=====================================================
% 
%=====================================================

function [SYSRESP,err] = SysResp_Testing_v1a_Func(SYSRESP,INPUT)

Status2('busy','Include System Response',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Get Input
%---------------------------------------------
G = INPUT.G0;
T = INPUT.T;
SYS = INPUT.SYS;
clear INPUT

[nProj,~,~] = size(G);
%---------------------------------------------
% Interpolate G 
%---------------------------------------------
interval = 0.001;                  % 10x subsamp for Siemens (i.e. 1us interval)
iT = (0:interval:T(length(T)));
iG = zeros(nProj,length(iT),3);

for n = 1:length(T)-1
    iG(:,(n-1)*10+(1:10),:) = cat(2,G(:,n,:),G(:,n,:),G(:,n,:),G(:,n,:),G(:,n,:),G(:,n,:),G(:,n,:),G(:,n,:),G(:,n,:),G(:,n,:));
end

%---------------------------------------------
% Filter
%---------------------------------------------
filt = dsp.FIRFilter;
reset(filt);
filt.Numerator = fir1(100,0.01);                 % will depend on subsamp 
Gfilt = zeros(size(iG));
for n = 1:nProj
    for d = 1:3
        reset(filt);
        Gfilt(n,:,d) = step(filt,squeeze(iG(n,:,d)).');
    end
end

G = Gfilt(:,1:length(Gfilt)-1,:);
T = iT;

%---------------------------------------------
% Shift for actual Gradient Delay
%---------------------------------------------
GroupDelay = interval*grpdelay(filt,1);                  
ExtraGradDel = 0;                                             % Delay Difference from Group Delay - will be part of measurement                                                              

% G = cat(2,zeros(nProj,round(ExtraGradDel/interval),3),G);
% T = [(0:interval:ExtraGradDel-interval+0.000001) ExtraGradDel+T];

SYSRESP.GradDelEff = GroupDelay + ExtraGradDel;
SYSRESP.G = G;
SYSRESP.T = T;

Status2('done','',3);
