%=========================================================
% 
%=========================================================

function [SCRPTipt,SCRPTGBL,err] = Calc2KurtIM_v1a(SCRPTipt,SCRPTGBL)

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
IMave = mean(kims,5);               % average along 'Averages' dimension
IMave = mean(IMave,4);              % average along 'directions' dimension
[M,N,b] = size(IMave);

%-------------------------------------
% regression
%-------------------------------------
minvalonb0 = 60;
minK = 0;
%minK = -2;
maxconst = 'yes';
fittype = 'exp';
D = zeros(M,N);
K = zeros(M,N);
    
for m = 1:M
    for n = 1:N
        S0 = squeeze(IMave(m,n,:))';
        if S0(1) < minvalonb0;
            continue
        end
        S = S0;
        SCN.b = bvalues;
        %-------------------------------------
        % Fit Kurtosis
        %-------------------------------------
        SCN.Sb0 = S(1); 
        if S(2) < 0
            D(m,n) = 1;
            continue
        elseif (S(1)/S(2)) > 20
            D(m,n) = 1;
            continue
        elseif (S(1)/S(2)) > 10
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
        D(m,n) = beta(1);
        K(m,n) = beta(2);
        if K(m,n) < minK
            %K(m,n) = minK;
            %testb = (0:2500);
            %Fit = S(1)*exp(-testb*D(m,n) + (1/6)*(testb.^2)*(D(m,n)^2)*K(m,n));
            %figure(100); 
            %plot(SCN.b,log(S),'k*');
            %hold on;
            %plot(testb,log(Fit),'b');
            %fitK = K(m,n)
            %fitD = D(m,n)
            D(m,n) = 0;
            %K(m,n) = 1000;
        end
        if strcmp(maxconst,'yes') 
            C = 3;
            maxkval = C/(bvalues(length(bvalues))*D(m,n));
            %maxkval = 1/(750*D(m,n));                                 % calc from b2000 & b2500  (equivalent to C = 3.3333)
            if K(m,n) > maxkval
                %testb = (0:2500);
                %Fit = S(1)*exp(-testb*D(m,n) + (1/6)*(testb.^2)*(D(m,n)^2)*K(m,n));
                %figure(100); 
                %plot(SCN.b,log(S),'k*');
                %hold on;
                %plot(testb,log(Fit),'b');
                %fitK = K(m,n)
                %constK = maxkval
                %fitD = D(m,n)
                %K(m,n) = maxkval;
                %D(m,n) = 1;
                %K(m,n) = 1000;
            end
        end
    end
    Status('busy',['Row: ',num2str(m)]);
end
figno = 1;
LoadImageGalileo(K*1000,figno);
figno = 2;
LoadImageGalileo(D*1000000,figno);    

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






