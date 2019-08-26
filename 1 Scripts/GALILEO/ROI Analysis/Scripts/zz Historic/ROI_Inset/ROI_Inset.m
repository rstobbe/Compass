%============================================
% 
%============================================

function [ROI_Arr] = ROI_Inset

roinum = 1;
imnum = 1;
L = 1;

global IMT
global SAVEDXLOC
global SAVEDYLOC
global SAVEDZLOC
global SAVEDROISFLAG

ROI_Arr = 0;
if SAVEDROISFLAG == 0
    return;
end

xlocarr = cell(1,100);                              
ylocarr = cell(1,100);                              
zlocarr = zeros(1,100);

if isempty(cell2mat(SAVEDXLOC(roinum,1)))
    return;
else
    if isempty(cell2mat(IMT(imnum)));
        return;
    else
        IM = cell2mat(IMT(imnum));
        outroi = zeros(size(IM)); 
        for m = 1:length(SAVEDXLOC)
            xloc = cell2mat(SAVEDXLOC(roinum,m));
            yloc = cell2mat(SAVEDYLOC(roinum,m));
            zloc = SAVEDZLOC(roinum,m);
            if zloc == 0
            else
                p = 1;
                xlocn(p) = xloc(1);
                ylocn(p) = yloc(1);
                for n = 1:length(xloc)
                    if sqrt((xloc(n)-xlocn(p))^2 + (yloc(n)-ylocn(p))^2) > 0.5
                        p = p+1;
                        xlocn(p) = xloc(n);
                        ylocn(p) = yloc(n);
                    end
                end
                xloc = xlocn;
                yloc = ylocn;
                n = 1;
                dir = -1;
                xloc2(n) = dir*L*sin(atan((yloc(n+1)-yloc(n))/(xloc(n+1)-xloc(n))))+(xloc(n+1)+xloc(n))/2;
                yloc2(n) = -dir*L*cos(atan((yloc(n+1)-yloc(n))/(xloc(n+1)-xloc(n))))+(yloc(n+1)+yloc(n))/2;
                for n = 2:length(xloc)-1
                    angle = atan((yloc(n+1)-yloc(n))/(xloc(n+1)-xloc(n)));
                    xlocq(1) = L*sin(angle)+(xloc(n+1)+xloc(n))/2;
                    ylocq(1) = -L*cos(angle)+(yloc(n+1)+yloc(n))/2;
                    xlocq(2) = -L*sin(angle)+(xloc(n+1)+xloc(n))/2;
                    ylocq(2) = L*cos(angle)+(yloc(n+1)+yloc(n))/2;
                    D = ((xlocq - xloc2(n-1)).^2 + (ylocq - yloc2(n-1)).^2).^(1/2);
                    xloc2(n) = xlocq(find(D == min(D),1,'first'));
                    yloc2(n) = ylocq(find(D == min(D),1,'first'));
                end
                angle = atan((yloc(1)-yloc(n+1))/(xloc(1)-xloc(n+1)));
                xlocq(1) = L*sin(angle)+(xloc(1)+xloc(n+1))/2;
                ylocq(1) = -L*cos(angle)+(yloc(1)+yloc(n+1))/2;
                xlocq(2) = -L*sin(angle)+(xloc(1)+xloc(n+1))/2;
                ylocq(2) = L*cos(angle)+(yloc(1)+yloc(n+1))/2;
                D = ((xlocq - xloc2(n)).^2 + (ylocq - yloc2(n)).^2).^(1/2);
                xloc2(n+1) = xlocq(find(D == min(D),1,'first'));
                yloc2(n+1) = ylocq(find(D == min(D),1,'first'));           
                xlocarr(m) = {xloc2};
                ylocarr(m) = {yloc2};            
                %xlocarr(m) = {xlocn};
                %ylocarr(m) = {ylocn};  
                zlocarr(m) = zloc; 
            end
        end
    end
end

SAVEDXLOC(roinum,:) = xlocarr;
SAVEDYLOC(roinum,:) = ylocarr;
SAVEDZLOC(roinum,:) = zlocarr;

