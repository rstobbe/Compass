%===========================================
% 
%===========================================

function [AVE,err] = FmriAverageSubtract_v1a_Func(AVE,INPUT)

Status2('busy','AverageImagesAlongArray',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Get Input
%--------------------------------------------- 
IMG = INPUT.IMG;
clear INPUT;

%---------------------------------------------
% Test
%--------------------------------------------- 
if length(IMG) > 1
    err.flag = 1;
    err.msg = 'Use Multiple Image Averaging Script';
    return
end
IMG = IMG{1};

%---------------------------------------------
% Test
%--------------------------------------------- 
IMG.Im = abs(IMG.Im);
% ImAct = IMG.Im(:,:,:,[2,4,6,8,10,12,14,15,16]);
% ImRest = IMG.Im(:,:,:,[1,3,5,7,9,11,13,17,18,19]);
% ImAct = IMG.Im(:,:,:,[2,4,6,8,10]);
% ImRest = IMG.Im(:,:,:,[1,3,5,7,9,11]);
% ImAct = IMG.Im(:,:,:,[19,21,23,25,27,29]);
% ImRest = IMG.Im(:,:,:,[20,22,24,26,28,30]);
% ImAct = IMG.Im(:,:,:,[2,4,6,8,10,12]);
% ImRest = IMG.Im(:,:,:,[1,3,5,7,9,11,13]);
% ImAct = IMG.Im(:,:,:,[2,4,6,8,10,12,19,21,23,25,27,29,35,36,37,38,39]);
% ImRest = IMG.Im(:,:,:,[1,3,5,7,9,11,13,14,15,16,17,18,20,22,24,26,28,30,31,32,33,34]);
% Paradigm = [0 1 0 1 0 1 0 1 0 1 0 1 0 0 0 0 0 0 1 0 1 0 1 0 1 0 1 0 1 0 0 0 0 0 1 1 1 1 1];
% figure(12341234);
% plot(Paradigm);

% ImActAve = mean(ImAct,4);
% ImRestAve = mean(ImRest,4);
% ImSub = ImActAve - ImRestAve;

Slope = NaN*ones(size(IMG.Im(:,:,:,1)));
%Slope = zeros(size(IMG.Im(:,:,:,1)));
sz = size(IMG.Im);
for n = 1:sz(1)
    for m = 1:sz(2)
        for p = 1:sz(3)
            %Dat = squeeze(ImAct(n,m,p,:));
            Dat = squeeze(IMG.Im(n,m,p,1:39));
            if sum(Dat) == 0
                continue
            end
            tSlope = [ones(39,1) (0:38).']\Dat;
            if abs(tSlope(1)) > 1
                continue
            end
            Slope(n,m,p) = tSlope(2)/tSlope(1);
%             Paradigm = Paradigm(1:13);

%             [R,P] = corrcoef(Dat,Paradigm);
%             %test = ttest2(ImAct(n,m,p,:),ImRest(n,m,p,:));
%             if P(2,1) < 0.05
%                 ImTtest(n,m,p) = R(2,1);
%             end
        end
    end
    Status2('busy',num2str(n),3);
end
% ImSub = ImSub .* ImTtest;

%IMG.Im = cat(4,ImSub,ImActAve,ImRestAve);
%IMG.Im = ImSub;
%IMG.Im = ImTtest;
IMG.Im = Slope;

%---------------------------------------------
% Add to Panel Output
%---------------------------------------------
Panel(1,:) = {'','','Output'};
Panel(2,:) = {'',AVE.method,'Output'};
AVE.PanelOutput = cell2struct(Panel,{'label','value','type'},2);

%---------------------------------------------
% Return
%---------------------------------------------
AVE.FigureName = 'FMRI Subtraction';
AVE.IMG = IMG;

Status2('done','',2);
Status2('done','',3);

