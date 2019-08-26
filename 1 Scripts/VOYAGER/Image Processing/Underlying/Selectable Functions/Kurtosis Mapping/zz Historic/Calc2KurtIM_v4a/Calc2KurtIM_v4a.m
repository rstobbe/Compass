%=========================================================
% 
%=========================================================

function [SCRPTipt,SCRPTGBL,err] = Calc2KurtIM_v4a(SCRPTipt,SCRPTGBL)

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
minvalonb0 = str2double(SCRPTipt(strcmp('MinVal_b0',{SCRPTipt.labelstr})).entrystr); 
avenoiseflr = str2double(SCRPTipt(strcmp('AveNoiseFlr',{SCRPTipt.labelstr})).entrystr); 
sdvnoiseflr = str2double(SCRPTipt(strcmp('SdvNoiseFlr',{SCRPTipt.labelstr})).entrystr); 
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
IMave = squeeze(mean(kims,5));

sizeIm = size(IMave);

minK = 0;
maxconst = 'yes';
nfconst = 'yes';

pMD = zeros(sizeIm(1),sizeIm(2),sizeIm(5));
pMK = zeros(sizeIm(1),sizeIm(2),sizeIm(5));
IMdiraved = squeeze(mean(IMave,4));
ConstrVoxels = 0;
%-------------------------------------
% Fit Kurtosis
%-------------------------------------
for slice = 1:sizeIm(5)
    for m = 1:sizeIm(1)
        for n = 1:sizeIm(2)
            fittype = 'Kurt';
            S = squeeze(IMdiraved(m,n,:,slice))';
            if S(1) < minvalonb0;
                continue
            elseif isnan(S(1))
                continue
            end
            if strcmp(nfconst,'yes')
                ind = find(S < (avenoiseflr+sdvnoiseflr),1,'first');
                if isempty(ind)
                    SCN.b = bvalues;
                else
                    if ind < 3
                        S = S(1:ind);
                        SCN.b = bvalues(1:ind);
                        fittype = 'Diff';
                    else
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
                end
            else
                SCN.b = bvalues;
            end
            SCN.Sb0 = S(1);
            if strcmp(fittype,'Kurt')
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
                [beta,resid,jacob,sigma,mse] = nlinfit(SCN,S,@Kurtosis,Est,options);
                pMD(m,n,slice) = beta(1);
                pMK(m,n,slice) = beta(2);
            elseif strcmp(fittype,'Diff')
                Est = 0.001;
                [beta,resid,jacob,sigma,mse] = nlinfit(SCN,S,@Diffusion,Est,options);
                pMD(m,n,slice) = beta(1);
                pMK(m,n,slice) = 0;
            end
            %-------------------------------------
            % Constrain
            %-------------------------------------
            if pMK(m,n,slice) < minK
                pMK(m,n,slice) = minK;
            end
            if strcmp(maxconst,'yes') 
                C = 3;
                maxkval = C/(SCN.b(length(SCN.b))*pMD(m,n,slice));
                if pMK(m,n,slice) > maxkval
                    pMK(m,n,slice) = maxkval;
                    ConstrVoxels = ConstrVoxels + 1;
                end
            end
        end
        status('busy',['Slice: ',num2str(slice),'  Row: ',num2str(m)]);
    end
end
TotConstrVoxels = ConstrVoxels

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
% Diffusion Function
%=========================================================
function S = Diffusion(P,SCN) 

S = SCN.Sb0*exp(-SCN.b*P(1));
