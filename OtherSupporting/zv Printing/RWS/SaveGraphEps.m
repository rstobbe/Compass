%====================================================
%
%====================================================

function SaveGraphEps(Figure,pathfile)

if strcmp(Figure.hFig.Visible,'off')
    return
end
figure(Figure.hFig);
labels = Figure.hAx.XTickLabels;
for n = 1:length(labels)
    if rem(n,2)
        labels{n} = ['\rm',labels{n}];
    end
end
Figure.hAx.XTickLabels = labels;

export_fig([pathfile,'.eps'],'-nocrop','-transparent');

fid = fopen([pathfile,'.eps'],'r');
txt = fread(fid,'*char').';
fclose('all');
txt = strrep(txt,'Helvetica','Arial');
fid = fopen([pathfile,'.eps'],'w+');
fwrite(fid,txt,'*char');
fclose('all');





