%=========================================================
% 
%=========================================================

function [SCRPTipt,SCRPTGBL,err] = Calc2KurtROI_v4a(SCRPTipt,SCRPTGBL)

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
avenoiseflr = str2double(SCRPTipt(strcmp('AveNoiseFlr',{SCRPTipt.labelstr})).entrystr); 
sdvnoiseflr = str2double(SCRPTipt(strcmp('SdvNoiseFlr',{SCRPTipt.labelstr})).entrystr);
bvaluesstr = SCRPTipt(strcmp('b-values',{SCRPTipt.labelstr})).entrystr; 
inputnum = str2double(SCRPTipt(strcmp('CalcImNum',{SCRPTipt.labelstr})).entrystr); 
figno = str2double(SCRPTipt(strcmp('CalcFigNum',{SCRPTipt.labelstr})).entrystr); 
roinum = str2double(SCRPTipt(strcmp('CalcROINum',{SCRPTipt.labelstr})).entrystr); 
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
kims = IM{inputnum};
IMave = squeeze(mean(kims,5));
IMdirave = squeeze(mean(IMave,4));

fittype = 'Kurt';
%fittype = 'Diff';

for b = 1:length(bvalues)
    %-------------------------------------
    % Display Images
    %-------------------------------------
    LoadImageGalileo(squeeze(IMdirave(:,:,b,:)),figno);
    %-------------------------------------
    % Extract Signal
    %-------------------------------------
    [SROI] = Extract_ROI_Array_v2a(roinum,figno);
    S(b) = mean(SROI);
end

nfconst = 'yes';
if strcmp(nfconst,'yes')
    ind = find(S < (avenoiseflr+sdvnoiseflr),1,'first');
    if isempty(ind)
        SCN.b = bvalues;
    else
        figure(101)
        plot(bvalues,log(S));
        slope1 = log(S(ind-1))-log(S(ind));
        slope0 = log(S(ind-2))-log(S(ind-1));
        rslope = slope0/slope1;
        if rslope > 2
            ind = ind-1;
        end
        S = S(1:ind);
        SCN.b = bvalues(1:ind);
        if ind == 3
            fittype = 'Diff';
        end
    end
else
    SCN.b = bvalues;
end
SCN.Sb0 = S(1);

%-------------------------------------
% Fit Data
%-------------------------------------
if strcmp(fittype,'Kurt')
    Est = [0.001 0.5];
    [beta,resid,jacob,sigma,mse] = nlinfit(SCN,S,@Kurtosis,Est,options);
    ci = nlparci(beta,resid,'covar',sigma);
    Dci = ci(1,:)
    Kci = ci(2,:)
    D = beta(1)
    K = beta(2)
elseif strcmp(fittype,'Diff')
    Est = 0.001;
    [beta,resid,jacob,sigma,mse] = nlinfit(SCN,S,@Diffusion,Est,options);
    ci = nlparci(beta,resid,'covar',sigma);
    Dci = ci(1,:)
    D = beta(1)
    K = 0;
end

%-------------------------------------
% Test
%-------------------------------------
testb = (0:2500);
Fit = S(1)*exp(-testb*D + (1/6)*(testb.^2)*(D^2)*K);

figure(100); hold on;
%plot(SCN.b,S/S(1),'k*');
%hold on;
%plot(testb,Fit/Fit(1),'k');
plot(SCN.b,S,'k*');
hold on;
plot(testb,Fit,'k');
%hold off;
%axis([0 2500 -1 5.5]);
%figure(101);
%plot(SCN.b,resid,'*r');

set(gca,'YScale','log');
set(gca,'Ytick',[4 8 16 32 64 128 256]);
ylim([4 256]);
%set(gca,'Ytick',[0.25 0.35 0.5 0.71 1]);
%ylim([0.25 1]);
xlim([0 2500]);


xlabel('b-Value','fontsize',10,'fontweight','bold');
ylabel('Average Signal (log)','fontsize',10,'fontweight','bold');
%set(gcf,'units','inches');
%set(gca,'units','inches');
%set(gcf,'position',[4 4 3.2 2.8]);
%set(gca,'position',[0.75 0.5 2 2]);
%set(gcf,'paperpositionmode','auto');
%set(gca,'fontsize',10,'fontweight','bold');
%set(gca,'PlotBoxAspectRatio',[1.2 1 1]);     
%set(gca,'box','on');

Status('done','');
Status2('done','',2);
Status2('done','',3);

%=========================================================
% Kurtosis Function
%=========================================================
function S = Kurtosis(P,SCN) 

S = SCN.Sb0*exp(-SCN.b*P(1) + (1/6)*(SCN.b.^2)*(P(1)^2)*P(2));

%=========================================================
% Diffusion Function
%=========================================================
function S = Diffusion(P,SCN) 

S = SCN.Sb0*exp(-SCN.b*P(1));







