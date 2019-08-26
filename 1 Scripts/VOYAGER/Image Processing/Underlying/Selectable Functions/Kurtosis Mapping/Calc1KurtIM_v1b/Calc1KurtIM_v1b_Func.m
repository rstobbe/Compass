%=========================================================
% 
%=========================================================

function [OUTPUT,err] = Calc1KurtIM_v1b_Func(INPUT)

Status('busy','Calculate Mean Kurtosis');
Status2('done','',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';
OUTPUT = struct();

%---------------------------------------------
% Get Input
%---------------------------------------------
KURT = INPUT.KURT;
IMAT = INPUT.IMAT;

%---------------------------------------------
% Variables
%---------------------------------------------
dwims = IMAT.dwims;
bvalues = IMAT.bvalues;
minvalonb0 = 60;
minK = 0;
maxconst = 'yes';
fittype = 'exp';
sz = size(dwims);
Nslices = sz(3);
Ndirs = sz(5);

%---------------------------------------------
% Calculate
%---------------------------------------------
D = zeros(sz(1),sz(2),sz(3),Ndirs);
K = zeros(sz(1),sz(2),sz(3),Ndirs);
options = statset('Robust','off');
for slice = 1
%for slice = 1:Nslices
    for dir = 1:Ndirs
        %-------------------------------------
        % Fit Kurtosis
        %-------------------------------------
        for m = 1:sz(1)
            for n = 1:sz(2)
                S = squeeze(dwims(m,n,slice,:,dir))';
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
                D(m,n,slice,dir) = beta(1);
                K(m,n,slice,dir) = beta(2);
                %-------------------------------------
                % Constrain
                %-------------------------------------
                if K(m,n,slice,dir) < minK
                    K(m,n,slice,dir) = minK;
                end
                if strcmp(maxconst,'yes') 
                    C = 3;
                    maxkval = C/(SCN.b(length(SCN.b))*D(m,n,slice,dir));
                    if K(m,n,slice,dir) > maxkval
                        K(m,n,slice,dir) = maxkval;
                    end
                end
            end
            Status2('busy',['Slice: ',num2str(slice),'  Dir: ',num2str(dir),'  Row: ',num2str(m)],2);
        end
        %-------------------------------------
        % Display Associated Images
        %-------------------------------------
        %LoadImageGalileo(squeeze(dwims(:,:,slice,:,dir)),figno);    
        %-------------------------------------
        % Display kMap
        %-------------------------------------
        %LoadImageGalileo(squeeze(K(:,:,slice,dir))*1000,kmapfigno);
        figure(100);
        imshow(squeeze(K(:,:,slice,dir))*1000,[0 2000]); 
    end
end
    
MK = squeeze(mean(K,4));
MD = squeeze(mean(D,4));

figure(200);
imshow(squeeze(MK(:,:,slice))*1000,[0 2500]); 

%figno = 1;
%LoadImageGalileo(MK*1000,figno);
%figno = 2;
%LoadImageGalileo(MD*1000000,figno);

%IM{MKmapImNum} = MK*1000;
%set(findobj('tag',['I',num2str(MKmapImNum)]),'string','MKmap');
%set(findobj('tag',['I',num2str(MKmapImNum)]),'visible','on');

%IM{MDmapImNum} = MD*1000000;
%set(findobj('tag',['I',num2str(MDmapImNum)]),'string','MDmap');
%set(findobj('tag',['I',num2str(MDmapImNum)]),'visible','on');

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


