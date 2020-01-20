%=========================================================
% 
%=========================================================

function [SCRPTipt,SCRPTGBL,err] = PixelCorrelationInROI_v1a(SCRPTipt,SCRPTGBL)

SCRPTGBL.TextBox = '';
SCRPTGBL.Figs = [];
SCRPTGBL.Data = [];
err.flag = 0;
err.msg = '';

%-------------------------------------
% Script Info
%-------------------------------------
XFigNum = str2double(SCRPTipt(strcmp('XFigNum',{SCRPTipt.labelstr})).entrystr); 
YFigNum = str2double(SCRPTipt(strcmp('YFigNum',{SCRPTipt.labelstr})).entrystr); 

%-------------------------------------
% Extract Signal
%-------------------------------------
roinum = 1;
[ROI_Arr1] = Extract_ROI_Array_v2a(roinum,XFigNum);
[ROI_Arr2] = Extract_ROI_Array_v2a(roinum,YFigNum);

figure(1);
plot(ROI_Arr1/1000,ROI_Arr2/1000,'*');
%set(gca,'xdir','reverse');
axis([0.2 1 0.5 3]);
xlabel('MD','fontsize',10,'fontweight','bold');
ylabel('MK','fontsize',10,'fontweight','bold');
set(gcf,'units','inches');
set(gca,'units','inches');
%set(gcf,'position',[4 4 3.2 2.8]);
set(gca,'position',[0.75 0.5 2 2]);
set(gcf,'paperpositionmode','auto');
set(gca,'fontsize',10,'fontweight','bold');
set(gca,'PlotBoxAspectRatio',[1.2 1 1]);     
set(gca,'box','on');

