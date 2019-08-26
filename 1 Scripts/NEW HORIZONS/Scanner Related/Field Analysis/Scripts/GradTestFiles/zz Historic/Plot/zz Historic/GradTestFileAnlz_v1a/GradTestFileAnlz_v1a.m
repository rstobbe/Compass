%====================================================
%
%====================================================

function [SCRPTipt,SCRPTGBL,err] = GradTestFileAnlz_v1a(SCRPTipt,SCRPTGBL)

err.flag = 0;
SCRPTGBL.TextBox = '';
SCRPTGBL.Figs = [];
SCRPTGBL.Data = [];

if not(isfield(SCRPTGBL,'Gradient_File'))
    err.flag = 1;
    err.msg = 'Select Gradient_File First';
    return
end

%-------------------------------------
% Load GradTestFile
%-------------------------------------
load(SCRPTGBL.Gradient_File.MatLoc);        
whos

figure(20); hold on;
if pnum == 1
    plot(L,Gvis);      
    xlabel('ms'); ylabel('mT/m'); title('Gradient Field Design');
else   
    for n = 1:pnum                 
        plot([0 T],[0 G(n,:,1)],'r');      
        xlabel('ms'); ylabel('mT/m'); title('Gradient Field Design');
    end
end

