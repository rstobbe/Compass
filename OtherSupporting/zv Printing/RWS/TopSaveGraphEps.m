%====================================================
%
%====================================================

function TopSaveGraphEps

Figure.hFig = gcf;
Figure.hAx = gca;

[file,path] = uiputfile('*.eps');

SaveGraphEps(Figure,[path,file])





