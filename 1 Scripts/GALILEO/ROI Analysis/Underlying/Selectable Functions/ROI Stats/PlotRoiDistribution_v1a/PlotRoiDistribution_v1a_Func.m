%=========================================================
% 
%=========================================================

function [PLTDIST,err] = PlotRoiDistribution_v1a_Func(PLTDIST,INPUT)

Status2('busy','Plot Distribution',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Get Input
%---------------------------------------------
ROI = INPUT.ROI;
IMAGEANLZ = INPUT.IMAGEANLZ;
clear INPUT

%---------------------------------------------
% Get Image
%---------------------------------------------
RoiArr = ROI.GetROIDataArray(IMAGEANLZ)/10;

test = max(RoiArr)

%---------------------------------------------
% Plot
%---------------------------------------------
hFig = figure(2893746);
%histogram(RoiArr,[(0:0.002:0.1) 0.3],'Normalization','probability','FaceColor',[0.5 0.5 0.5],'FaceAlpha',1);
%histogram(RoiArr,[(0:0.002:0.1) 0.3],'Normalization','probability','FaceColor',[0.5 0.5 0.5],'FaceAlpha',1);
histogram(RoiArr,[(0:0.01:0.3) 0.5],'Normalization','probability','FaceColor',[0.5 0.5 0.5],'FaceAlpha',1);
hAx = gca;
hAx.XLim = [0 0.2];
hAx.YLim = [0 1];

xlabel('PSF magnitude (% Peak)','fontsize',10,'fontweight','bold');
ylabel('Relative Bin Volume (% Total)','fontsize',10,'fontweight','bold');
hFig.Units = 'inches';
hFig.Position = [5 5 2.8 2.3];

PLTDIST.Name = 'RoiDistribution';
fig = 1;
PLTDIST.Figure(fig).Name = 'RoiDistribution';
PLTDIST.Figure(fig).Type = 'Graph';
PLTDIST.Figure(fig).hFig = hFig;
PLTDIST.Figure(fig).hAx = hAx;

PLTDIST.ExpDisp = '';
PLTDIST.saveable = 'yes';
PLTDIST.label = '';

Panel(1,:) = {'','','Output'};
Panel(2,:) = {'',PLTDIST.method,'Output'};
PLTDIST.Panel = Panel;

Status2('done','',2);
Status2('done','',3);
