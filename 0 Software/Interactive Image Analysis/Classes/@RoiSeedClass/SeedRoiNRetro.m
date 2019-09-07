%============================================
% Seeded ROI Positive
%============================================
function [xlocout,ylocout,zlocout,err] = SeedRoiN(DAT,datapoint,ImageSlice)

err = 0;
xlocout = [];
ylocout = [];
zlocout = [];

x0 = round(datapoint(1));
y0 = round(datapoint(2));
ImageSlice(isnan(ImageSlice)) = 0;

x = x0;
y = y0;
if ImageSlice(y,x) <= DAT.seed
    while ImageSlice(y,x) <= DAT.seed
        x = x+1;
        y = y0;
    end
else
    err = 1;
    %Status2('error','Current pixel value greater than seed value',3);
    return
end
x1 = x;
y1 = y;
d = 's';

xloc = [];
yloc = [];
n = 0;
x = 0;
y = 0;
while x ~= x1 || y ~= y1
    if n == 0
        x = x1;
        y = y1;
    end
    if strcmp(d,'e')
        if ImageSlice(y,x+1) <= DAT.seed
            if ImageSlice(y-1,x) <= DAT.seed %deadend
                x = x-1;
                d = 'n';
            elseif ImageSlice(y-1,x+1) > DAT.seed
                y = y-1;
                x = x+1; 
                d = 'e';
                xloc = [xloc x];
                yloc = [yloc y+0.25];
            else
                y = y-1;
                d = 'n';
                xloc = [xloc x+0.25];
                yloc = [yloc y];
            end
        else
            if ImageSlice(y+1,x+1) > DAT.seed
                x = x+1;
                y = y+1;
                d = 's';
                xloc = [xloc x-0.25];
                yloc = [yloc y];
            else
                x = x+1;
                d = 'e';
                xloc = [xloc x];
                yloc = [yloc y+0.25];
            end
        end
    elseif strcmp(d,'s')
        if ImageSlice(y+1,x) <= DAT.seed
            if ImageSlice(y,x+1) <= DAT.seed %deadend
                y = y-1;
                d = 'e';
            elseif ImageSlice(y+1,x+1) > DAT.seed
                y = y+1;
                x = x+1;
                d = 's';
                xloc = [xloc x-0.25];
                yloc = [yloc y];
            else
                x = x+1;
                d = 'e';
                xloc = [xloc x];
                yloc = [yloc y+0.25];
            end
        else
            if ImageSlice(y+1,x-1) > DAT.seed
                x = x-1;
                y = y+1;
                d = 'w';
                xloc = [xloc x];
                yloc = [yloc y-0.25];
            else
                y = y+1;
                d = 's';
                xloc = [xloc x-0.25];
                yloc = [yloc y];
            end
        end
    elseif strcmp(d,'w')
        if ImageSlice(y,x-1) <= DAT.seed
            if ImageSlice(y+1,x) <= DAT.seed %deadend
                x = x+1;
                d = 's';
            elseif ImageSlice(y+1,x-1) > DAT.seed
                y = y+1;
                x = x-1;
                d = 'w';
                xloc = [xloc x];
                yloc = [yloc y-0.25];
            else
                y = y+1;
                d = 's';
                xloc = [xloc x-0.25];
                yloc = [yloc y];
            end
        else
            if ImageSlice(y-1,x-1) > DAT.seed
                x = x-1;
                y = y-1;
                d = 'n';
                xloc = [xloc x+0.25];
                yloc = [yloc y];
            else
                x = x-1;
                d = 'w';
                xloc = [xloc x];
                yloc = [yloc y-0.25];
            end
        end
    elseif strcmp(d,'n')
        if ImageSlice(y-1,x) <= DAT.seed
            if ImageSlice(y,x-1) <= DAT.seed %deadend
                y = y+1;
                d = 'w';
            elseif ImageSlice(y-1,x-1) > DAT.seed
                y = y-1;
                x = x-1;
                d = 'n';
                xloc = [xloc x+0.25];
                yloc = [yloc y];
            else
                x = x-1;
                d = 'w';
                xloc = [xloc x];
                yloc = [yloc y-0.25];
            end
        else
            if ImageSlice(y-1,x+1) > DAT.seed
                x = x+1;
                y = y-1;
                d = 'e';
                xloc = [xloc x];
                yloc = [yloc y+0.25];
            else
                y = y-1;
                d = 'n';
                xloc = [xloc x+0.25];
                yloc = [yloc y];
            end
        end
    end
    if isempty(xloc)
        err = 1;
        Status2('error','Cant do single hole',3);
        return;
    end
    n = n+1;
    if n > 10000
        error;
    end
end

xlocout = xloc;
ylocout = yloc;
zlocout = datapoint(3);


