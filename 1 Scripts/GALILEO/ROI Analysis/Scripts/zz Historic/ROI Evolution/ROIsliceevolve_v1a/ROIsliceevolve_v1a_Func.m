%=========================================================
% 
%=========================================================

function [PLOT,err] = ROIsliceevolve_v1a_Func(PLOT,INPUT)

global ROISOFINTEREST
global CURFIG

Status('busy','Plot ROI Slice Evolution');
Status2('done','',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Get Input
%---------------------------------------------
clear INPUT

%---------------------------------------------
% Test
%---------------------------------------------
if sum(ROISOFINTEREST) > 1
    err.flag = 1;
    err.msg = 'Only 1 ROI of Interest Allowed';
    return
end

if sum(ROISOFINTEREST) == 0
    err.flag = 1;
    err.msg = 'One ROI Must Be Selected';
    return
end
roinum = find(ROISOFINTEREST == 1);

%---------------------------------------------
% Extract ROI as an Array
%---------------------------------------------
[ROI_Arr] = Extract_ROI_Array_Each_Slice_v1a(roinum,CURFIG);

%---------------------------------------------
% Plot
%---------------------------------------------
clr = ['b','g','m','y','k','c','r'];
meanvals = mean(ROI_Arr,2);
relmeanvals = 100*(meanvals/mean(meanvals) - 1);
figure(100); hold on;
plot(relmeanvals,clr(roinum));
ylim([-5 5]);



