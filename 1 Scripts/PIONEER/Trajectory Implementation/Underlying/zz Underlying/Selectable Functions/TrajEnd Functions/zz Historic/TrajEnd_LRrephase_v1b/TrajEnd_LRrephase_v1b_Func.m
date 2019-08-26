%====================================================
% 
%====================================================

function [TEND,err] = TrajEnd_LRrephase_v1b_Func(TEND,INPUT)

Status2('busy','End Trajectory',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Get Input
%---------------------------------------------
gseg = INPUT.SYS.GradSampBase/1000;
slope = INPUT.gslew;
Gmom = INPUT.Gmom;
Gend0 = INPUT.Gend;
clear INPUT;

%---------------------------------------------
% Solve Rephase
%---------------------------------------------
sz = size(Gmom);
nproj = sz(1);
gstep = gseg*slope;
GrphsVal = zeros(nproj,3);
Grphs = zeros(nproj,1000,3);
for n = 1:nproj;
    for i = 1:3
        Gend = Gend0(n,i);
        Gendtrngle = sign(Gend)*Gend^2/(2*slope);
        Grem = Gmom(n,i)+Gendtrngle;
        if Gend < 0 && Grem < 0
            dir = 1;                            % dir = 1 means toward 0 and dir = -1 means away from 0
            GrphsSgn = 1;
        elseif  Gend < 0 && Grem > 0
            dir = -1;
            GrphsSgn = -1;
        elseif  Gend > 0 && Grem < 0
            dir = -1;
            GrphsSgn = 1;            
        elseif  Gend > 0 && Grem > 0
            dir = 1;
            GrphsSgn = -1;
        end
            
        GrphsMag = sqrt(-dir*sign(Gend)*GrphsSgn*Gend^2/2 - Gmom(n,i)*GrphsSgn*slope);
          
        test = Gmom(n,i) + dir*sign(Gend)*Gend^2/(2*slope) + GrphsSgn*GrphsMag^2/(slope);
        if round(test*1e6) ~= 0
            error();
        end    
        GrphsVal(n,i) = GrphsSgn*GrphsMag;

        if dir == 1
            Grphs1 = (Gend-sign(Gend)*gstep/2:-sign(Gend)*gstep:GrphsVal(n,i));
        else
            Grphs1 = (Gend+sign(Gend)*gstep/2:sign(Gend)*gstep:GrphsVal(n,i));
        end
        if isempty(Grphs1)
            Grphs1 = GrphsVal(n,i);
        end
       
        lft = GrphsVal(n,i) - Grphs1(length(Grphs1));
        Grphs2 = (GrphsVal(n,i)-GrphsSgn*gstep+lft:-GrphsSgn*gstep:0);
        Grphs0 = [Grphs1 Grphs2 0];
        Grphs(n,1:length(Grphs0),i) = Grphs0;
    end
end

test = sum(abs(Grphs),1);
test = sum(test,3);
test = squeeze(test);
ind = find(test == 0,1,'first');
Grphs = Grphs(:,1:ind,:);

%---------------------------------------------
% Return
%---------------------------------------------
TEND.Gend = Grphs;
TEND.rphsslope = slope;

Status2('done','',3);

