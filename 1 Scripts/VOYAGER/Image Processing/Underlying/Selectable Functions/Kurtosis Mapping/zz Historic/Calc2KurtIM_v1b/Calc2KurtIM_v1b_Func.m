%=========================================================
% 
%=========================================================

function [OUTPUT,err] = Calc2KurtIM_v1b_Func(INPUT)

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
minvalonb0 = KURT.minvalonb0;
constrain = KURT.constrain;
sz = size(dwims);
Nslices = sz(3);

%-------------------------------------
% Average
%-------------------------------------
MD = zeros(sz(1),sz(2),sz(3));
MK = zeros(sz(1),sz(2),sz(3));
avedwims = squeeze(mean(dwims,5));
%TestImSize = size(avedwims)

%-------------------------------------
% Fit Kurtosis
%-------------------------------------
NumCstrdVoxMax = 0;
NumCstrdVoxMin = 0;
options = statset('Robust','off');
%for slice = 1
for slice = 1:Nslices
    for m = 1:sz(1)
        for n = 1:sz(2)
            S = squeeze(avedwims(m,n,slice,:))';
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
            [beta,resid,jacob,sigma,mse] = nlinfit(SCN,S,@Kurtosis,Est,options);
            MD(m,n,slice) = beta(1);
            MK(m,n,slice) = beta(2);
            %-------------------------------------
            % Constrain
            %-------------------------------------
            if MK(m,n,slice) < 0 && strcmp(constrain,'Yes') 
                MK(m,n,slice) = 0;
                NumCstrdVoxMin = NumCstrdVoxMin+1;
            end
            if strcmp(constrain,'Yes') 
                C = 3;
                maxkval = C/(SCN.b(length(SCN.b))*MD(m,n,slice));
                if MK(m,n,slice) > maxkval
                    %fitK = MK(m,n,slice)
                    %constK = maxkval
                    MK(m,n,slice) = maxkval;
                    NumCstrdVoxMax = NumCstrdVoxMax+1;
                end
            end
        end
        Status2('busy',['Slice: ',num2str(slice),'  Row: ',num2str(m)],2);
    end
    figure;
    imshow(squeeze(MK(:,:,slice))*1000,[0 2500]);        
end

Status('done','');
Status2('done','',2);
Status2('done','',3);

%---------------------------------------------
% Return
%---------------------------------------------
OUTPUT.MK = MK;
OUTPUT.MD = MD;
OUTPUT.KURT.NumCstrdVoxMin = NumCstrdVoxMin;
OUTPUT.KURT.NumCstrdVoxMax = NumCstrdVoxMax;

%=========================================================
% Kurtosis Function
%=========================================================
function S = Kurtosis(P,SCN) 

S = SCN.Sb0*exp(-SCN.b*P(1) + (1/6)*(SCN.b.^2)*(P(1)^2)*P(2));

