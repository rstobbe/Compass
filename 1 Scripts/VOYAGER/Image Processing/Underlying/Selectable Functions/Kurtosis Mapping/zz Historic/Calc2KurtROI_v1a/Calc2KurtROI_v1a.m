%=========================================================
% 
%=========================================================

function [SCRPTipt,SCRPTGBL,err] = Calc2KurtROI_v1a(SCRPTipt,SCRPTGBL)

global IM

SCRPTGBL.TextBox = '';
SCRPTGBL.Figs = [];
SCRPTGBL.Data = [];
err.flag = 0;
err.msg = '';

options = statset('Robust','off');
%-------------------------------------
% Load Script Info
%-------------------------------------
bvaluesstr = SCRPTipt(strcmp('b-values',{SCRPTipt.labelstr})).entrystr; 
totdirs = str2double(SCRPTipt(strcmp('Tot_Directions',{SCRPTipt.labelstr})).entrystr); 
inds = strfind(bvaluesstr,' ');
if isempty(inds)
    bvalues = str2double(bvaluesstr);
else
    bvalues(1) = str2double(bvaluesstr(1:inds(1)));
    for n = 2:length(inds)
        bvalues(n) = str2double(bvaluesstr(inds(n-1)+1:inds(n)));
    end
    if isempty(n)
        bvalues(2) = str2double(bvaluesstr(inds(1)+1:length(bvaluesstr)));
    else
        bvalues(n+1) = str2double(bvaluesstr(inds(n)+1:length(bvaluesstr)));
    end    
end

%-------------------------------------
% Average
%-------------------------------------
kims = IM{1};
IMave = mean(kims,5);

minK = -2;
anferr = 'no';
minval = 0;
maxconst = 'yes';
fittype = 'exp';

for dir = 1:totdirs
    %-------------------------------------
    % Display Images
    %-------------------------------------
    figno = 1;
    LoadImageGalileo(squeeze(IMave(:,:,:,dir)),figno);
    %-------------------------------------
    % Extract Signal
    %-------------------------------------
    [SROI] = Extract_ROI_Array_Each_Slice_v1a(1,1);
    S0(:,dir) = mean(SROI,2);
end
    
S = mean(S0,2);

%-------------------------------------
% Fit Kurtosis
%-------------------------------------
SCN.Sb0 = S(1);
SCN.b = bvalues;
Est = [0.001 0.5];
if strcmp(fittype,'exp')
    [beta,resid,jacob,sigma,mse] = nlinfit(SCN,S',@Kurtosis,Est,options);
elseif strcmp(fittype,'ln')
    SCN.Sb0 = log(SCN.Sb0);
    lnS = log(S);
    [beta,resid,jacob,sigma,mse] = nlinfit(SCN,lnS',@lnKurtosis,Est,options);  
end
ci = nlparci(beta,resid,'covar',sigma);
Dci = ci(1,:);
Kci = ci(2,:);
D = beta(1);
K = beta(2);
%-------------------------------------
% Constrain
%-------------------------------------
if K < minK
    K = minK;
end
if strcmp(maxconst,'yes') 
    C = 3;
    maxkval = C/(SCN.b(length(SCN.b))*D);
    if K > maxkval
        fitK = K
        constK = maxkval
        K = maxkval;
    end
end
%-------------------------------------
% Test
%-------------------------------------
testb = (0:2500);
Fit = S(1)*exp(-testb*D + (1/6)*(testb.^2)*(D^2)*K);

figure(100); 
plot(SCN.b,log(S),'k*');
hold on;
plot(testb,log(Fit),'b');
%hold off;
%axis([0 2500 -1 5.5]);
%figure(101);
%plot(SCN.b,resid,'*r');

Status('done','');
Status2('done','',2);
Status2('done','',3);
D
K

%=========================================================
% Kurtosis Function
%=========================================================
function S = Kurtosis(P,SCN) 

S = SCN.Sb0*exp(-SCN.b*P(1) + (1/6)*(SCN.b.^2)*(P(1)^2)*P(2));

%=========================================================
% ln-Kurtosis Function
%=========================================================
function S = lnKurtosis(P,SCN) 

S = SCN.Sb0 - SCN.b*P(1) + (1/6)*(SCN.b.^2)*(P(1)^2)*P(2);

%=========================================================
% Diffusion Function
%=========================================================
function S = Diffusion(P,SCN) 

S = SCN.Sb0*exp(-SCN.b*P(1));

%=========================================================
% ln-Diffusion Function
%=========================================================
function S = lnDiffusion(P,SCN) 

S = SCN.Sb0 - SCN.b*P(1);






