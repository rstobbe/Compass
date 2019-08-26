%=========================================================
% 
%=========================================================

function [SCRPTipt,SCRPTGBL,err] = KurtROIDicom_v5a(SCRPTipt,SCRPTGBL)

SCRPTGBL.TextBox = '';
SCRPTGBL.Figs = [];
SCRPTGBL.Data = [];
err.flag = 0;
err.msg = '';

options = statset('Robust','off');

%-------------------------------------
% Load Script
%-------------------------------------
offset = str2double(SCRPTipt(strcmp('BGoffset',{SCRPTipt.labelstr})).entrystr);

%-------------------------------------
% Average
%-------------------------------------
aveb0im = mean(b0im,3);




minK = -2;
anferr = 'no';
maxconst = 'yes';
fittype = 'exp';
minkurtlen = find(bvalues == minbkurt,1);
D = zeros(totdirs,1);
K = zeros(totdirs,1);
for dir = 1:totdirs
    %-------------------------------------
    % Display Images
    %-------------------------------------
    figno = 1;
    LoadImageGalileo(squeeze(IMave(:,:,:,dir)),ImInfo,figno);
    %-------------------------------------
    % Extract Signal
    %-------------------------------------
    [SROI] = Extract_ROI_Array_Each_Slice_v1a(1,1);
    S0 = mean(SROI,2);
    %-------------------------------------
    % Avoid noise-floor error
    %-------------------------------------
    if strcmp(anferr,'yes')
        %ind = find(S0 < 2*std,1,'first');
        %ind = find(S0 < 1*std,1,'first');
        ind = find(S0 < 0,1,'first');
        if not(isempty(ind))
            S = S0(1:ind-1);
            SCN.b = bvalues(1:ind-1);
        else
            S = S0;
            SCN.b = bvalues;
        end
    else
        S = S0;
        SCN.b = bvalues;
    end
    %-------------------------------------
    % Fit Kurtosis
    %-------------------------------------
    SCN.Sb0 = S(1);
    if length(S) < minkurtlen
        Est = 0.003;
        if strcmp(fittype,'exp');
            [beta,resid,jacob,sigma,mse] = nlinfit(SCN,S',@Diffusion,Est,options);    
        elseif strcmp(fittype,'ln')
            SCN.Sb0 = log(SCN.Sb0);
            lnS = log(S);
            [beta,resid,jacob,sigma,mse] = nlinfit(SCN,lnS',@lnDiffusion,Est,options);  
        end
        ci = nlparci(beta,resid,'covar',sigma);
        Dci(dir,:) = ci(1,:);
        D(dir) = beta(1); 
        testb = (0:2500);
        Fit = S(1)*exp(-testb*beta(1));        
    else
        Est = [0.0005 1];
        if strcmp(fittype,'exp')
            [beta,resid,jacob,sigma,mse] = nlinfit(SCN,S',@Kurtosis,Est,options);
        elseif strcmp(fittype,'ln')
            SCN.Sb0 = log(SCN.Sb0);
            lnS = log(S);
            [beta,resid,jacob,sigma,mse] = nlinfit(SCN,lnS',@lnKurtosis,Est,options);  
        end
        ci = nlparci(beta,resid,'covar',sigma);
        Dci(dir,:) = ci(1,:);
        Kci(dir,:) = ci(2,:);
        D(dir) = beta(1);
        K(dir) = beta(2);
        if K(dir) < minK
            K(dir) = minK;
        end
        if strcmp(maxconst,'yes') 
            C = 3;
            maxkval = C/(SCN.b(length(SCN.b))*D(dir));
            if K(dir) > maxkval
                fitK = K(dir)
                constK = maxkval
                K(dir) = maxkval;
                constdir = dir
            end
        end
        testb = (0:2500);
        Fit = S(1)*exp(-testb*D(dir) + (1/6)*(testb.^2)*(D(dir)^2)*K(dir));
        if Fit(2500) > Fit(2000);
            errordir = dir
        end
    end
    figure(100); 
    plot(SCN.b,log(S),'k*');
    hold on;
    plot(testb,log(Fit),'b');
    hold off;
    axis([0 2500 -1 5.5]);
    figure(101);
    plot(SCN.b,resid,'*r');
end

MK = mean(K)
MD = mean(D)

figure(100);
testb = (0:2500);
Fit = S(1)*exp(-testb*MD + (1/6)*(testb.^2)*(MD^2)*MK);
plot(testb,log(Fit),'r');


Status('done','');
Status2('done','',2);
Status2('done','',3);

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






