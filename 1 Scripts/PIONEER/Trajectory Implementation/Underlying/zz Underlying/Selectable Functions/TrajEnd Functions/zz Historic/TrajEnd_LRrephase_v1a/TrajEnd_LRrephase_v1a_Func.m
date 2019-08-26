%====================================================
% 
%====================================================

function [TEND,err] = TrajEnd_LRrephase_v1a_Func(TEND,INPUT)

Status2('busy','End Trajectory',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Get Input
%---------------------------------------------
GQNT = INPUT.GQNT;
PROJimp = INPUT.PROJimp;
GQKSA = INPUT.GQKSA;
G0 = INPUT.G0;
clear INPUT;

%---------------------------------------------
% Common
%---------------------------------------------
gseg = GQNT.gseg;
gamma = PROJimp.gamma;
slope = TEND.slope;
slope = slope/(sqrt(3));
gstep = gseg*slope;

%---------------------------------------------
% Solve Rephase
%---------------------------------------------
nproj = length(GQKSA(:,1,1));
len = length(GQKSA(1,:,1));
GrphsVal = zeros(nproj,3);
Grphs = zeros(nproj,1000,3);
for n = 1:nproj;
    for i = 1:3
        kend = GQKSA(n,len,i);
        Gend = G0(n,len-1,i);
        kGendtrngle = sign(Gend)*Gend^2*gamma/(2*slope);
        krem = kend+kGendtrngle;
        if Gend < 0 && krem < 0
            dir = 1;                            % dir = 1 means toward 0 and dir = -1 means away from 0
            GrphsSgn = 1;
        elseif  Gend < 0 && krem > 0
            dir = -1;
            GrphsSgn = -1;
        elseif  Gend > 0 && krem < 0
            dir = -1;
            GrphsSgn = 1;            
        elseif  Gend > 0 && krem > 0
            dir = 1;
            GrphsSgn = -1;
        end
            
        GrphsMag = sqrt(-dir*sign(Gend)*GrphsSgn*Gend^2/2 - kend*GrphsSgn*slope/gamma);
          
        test = kend + dir*sign(Gend)*Gend^2*gamma/(2*slope) + GrphsSgn*GrphsMag^2*gamma/(slope);
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
            GrphsVal(n,i) = Gend;
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

