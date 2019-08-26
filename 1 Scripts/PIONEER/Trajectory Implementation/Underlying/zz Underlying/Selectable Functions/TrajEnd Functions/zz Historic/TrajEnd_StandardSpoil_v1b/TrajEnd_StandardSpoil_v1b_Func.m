%=============================================================
% 
%=============================================================

function [TEND,err] = TrajEnd_StandardSpoil_v1b_Func(TEND,INPUT)

Status2('busy','End Trajectory',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Get Input
%---------------------------------------------
PROJdgn = INPUT.PROJdgn;
PROJimp = INPUT.PROJimp;
SYS = INPUT.SYS;
gseg = SYS.GradSampBase/1000;
gmax = SYS.GradMaxWorking;
slope = sqrt((TEND.slope^2)/3);
Gmom = INPUT.Gmom;
Gend0 = INPUT.Gend;
clear INPUT;

%---------------------------------------------
% Extra Gradient Moment
%---------------------------------------------
Gmomadd = TEND.spoilfactor*PROJdgn.kmax/PROJimp.gamma;

%---------------------------------------------
% Solve Rephase
%---------------------------------------------
sz = size(Gmom);
nproj = sz(1);
gstep = gseg*slope;
Grphs = zeros(nproj,1000,3);
for n = 1:nproj
    for i = 1:3 
        Gend = Gend0(n,1,i);                            % make sure input in this format                       
        Gmomtraj = Gmom(n,1,i);
        Gmomendtrngle = sign(Gend)*Gend^2/(2*slope);
        Gmomrem = Gmomtraj+Gmomendtrngle+Gmomadd;
        if Gend < 0 && Gmomrem < 0
            dir = 1;                                    % dir = 1 means toward 0 and dir = -1 means away from 0
            GrphsSgn = 1;
            sol = 1;
        elseif  Gend < 0 && Gmomrem > 0
            dir = -1;
            GrphsSgn = -1;
            sol = 1;
            if Gmomrem < abs(Gend)*gseg
                sol = 2;
            end
        elseif  Gend > 0 && Gmomrem < 0
            dir = -1;
            GrphsSgn = 1;
            sol = 1;
            if abs(Gmomrem) < Gend*gseg
                sol = 2;
            end
        elseif  Gend > 0 && Gmomrem > 0
            dir = 1;
            GrphsSgn = -1;
            sol = 1;
        end
        if sol == 1
            [Grphs,err] = Solution1(Grphs,Gmomtraj,Gmomadd,Gend,dir,GrphsSgn,slope,gstep,gmax,n,i);
        else
            [Grphs,err] = Solution2(Grphs,Gmomtraj,Gmomadd,Gend,dir,GrphsSgn,slope,gstep,gmax,n,i);
        end
        if err.flag
            return
        end
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
end

%=============================================================
% Solution1
%=============================================================
function [Grphs,err] = Solution1(Grphs,Gmomtraj,Gmomadd,Gend,dir,GrphsSgn,slope,gstep,gmax,n,i)
    err.flag = 0;
    GrphsMag = sqrt(-dir*sign(Gend)*GrphsSgn*Gend^2/2 - (Gmomtraj+Gmomadd)*GrphsSgn*slope);
    test = Gmomtraj + dir*sign(Gend)*Gend^2/(2*slope) + GrphsSgn*GrphsMag^2/(slope);
    if round(test*1e6) ~= -round(Gmomadd*1e6)
        error();
    end    
    GrphsVal = GrphsSgn*GrphsMag;
    if abs(GrphsVal) > gmax
        err.flag = 1;
        err.msg = 'Reduce Spoil Slope (or Factor)';
        return
    end
    if dir == 1
        Grphs1 = (Gend-sign(Gend)*gstep/2:-sign(Gend)*gstep:GrphsVal);
    else
        Grphs1 = (Gend+sign(Gend)*gstep/2:sign(Gend)*gstep:GrphsVal);
    end
    if isempty(Grphs1)
        Grphs1 = GrphsVal;
    end
    lft = GrphsVal - Grphs1(length(Grphs1));
    Grphs2 = (GrphsVal-GrphsSgn*gstep+lft:-GrphsSgn*gstep:0);
    Grphs0 = [Grphs1 Grphs2 0];
    Grphs(n,1:length(Grphs0),i) = Grphs0;
end


%=============================================================
% Solution2
%=============================================================
function [Grphs,err] = Solution2(Grphs,Gmomtraj,Gmomadd,Gend,dir,GrphsSgn,slope,gstep,gmax,n,i)
    err.flag = 0;
    GrphsMag = sqrt(abs(Gmomtraj+Gmomadd)*2*slope);
    test = Gmomtraj - dir*sign(Gend)*GrphsMag^2/(2*slope);
    if round(test*1e6) ~= -round(Gmomadd*1e6)
        error();
    end    
    GrphsVal = GrphsSgn*GrphsMag;
    if abs(GrphsVal) > gmax
        err.flag = 1;
        err.msg = 'Reduce Spoil Slope (or Factor)';
        return
    end
    Grphs2 = (GrphsVal-GrphsSgn*gstep/2:-GrphsSgn*gstep:0);
    Grphs0 = [Grphs2 0];
    Grphs(n,1:length(Grphs0),i) = Grphs0;
end
