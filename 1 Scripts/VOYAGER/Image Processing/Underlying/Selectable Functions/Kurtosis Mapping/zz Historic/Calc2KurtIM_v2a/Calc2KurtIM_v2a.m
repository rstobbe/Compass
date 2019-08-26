%=========================================================
% 
%=========================================================

function [SCRPTipt,SCRPTGBL,err] = Calc2KurtIM_v2a(SCRPTipt,SCRPTGBL)

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
inputnum = str2double(SCRPTipt(strcmp('CalcImNum',{SCRPTipt.labelstr})).entrystr); 
MKmapImNum = str2double(SCRPTipt(strcmp('MKmapImNum',{SCRPTipt.labelstr})).entrystr); 
MDmapImNum = str2double(SCRPTipt(strcmp('MDmapImNum',{SCRPTipt.labelstr})).entrystr); 
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
IMave = mean(kims,5);

sizeIm = size(IMave);

minvalonb0 = 60;
minK = 0;
maxconst = 'yes';
fittype = 'exp';

pMD = zeros(sizeIm(1),sizeIm(2));
pMK = zeros(sizeIm(1),sizeIm(2));
IMdiraved = mean(IMave,4);

%-------------------------------------
% Fit Kurtosis
%-------------------------------------
for m = 1:sizeIm(1)
    for n = 1:sizeIm(2)
        S = squeeze(IMdiraved(m,n,:))';
        if S(1) < minvalonb0;
            continue
        elseif isnan(S(1))
            continue
        end
        SCN.b = bvalues;
        SCN.Sb0 = S(1);
        if (S(1)/S(2)) > 10
            Est = [0.004 0.5];
        elseif S(1)/S(2) > 5
            Est = [0.003 0.5];
        elseif S(1)/S(2) > 2.5
            Est = [0.002 0.5];
        elseif S(1)/S(2) > 1.5
            Est = [0.0015 0.5];
        else
            Est = [0.0005 0.5];
        end
        if strcmp(fittype,'exp')
            [beta,resid,jacob,sigma,mse] = nlinfit(SCN,S,@Kurtosis,Est,options);
        elseif strcmp(fittype,'ln')
            SCN.Sb0 = log(SCN.Sb0);
            lnS = log(S);
            [beta,resid,jacob,sigma,mse] = nlinfit(SCN,lnS,@lnKurtosis,Est,options);  
        end
        pMD(m,n) = beta(1);
        pMK(m,n) = beta(2);
        %-------------------------------------
        % Constrain
        %-------------------------------------
        if pMK(m,n) < minK
            pMK(m,n) = minK;
        end
        if strcmp(maxconst,'yes') 
            C = 3;
            maxkval = C/(SCN.b(length(SCN.b))*pMD(m,n));
            if pMK(m,n) > maxkval
                fitK = pMK(m,n)
                constK = maxkval
                pMK(m,n) = maxkval;
            end
        end
    end
    status('busy',['Row: ',num2str(m)]);
end

figno = 1;
LoadImageGalileo(pMK*1000,figno);
figno = 2;
LoadImageGalileo(pMD*1000000,figno);

IM{MKmapImNum} = pMK*1000;
set(findobj('tag',['I',num2str(MKmapImNum)]),'string','MKmap');
set(findobj('tag',['I',num2str(MKmapImNum)]),'visible','on');

IM{MDmapImNum} = pMD*1000000;
set(findobj('tag',['I',num2str(MDmapImNum)]),'string','MDmap');
set(findobj('tag',['I',num2str(MDmapImNum)]),'visible','on');

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


