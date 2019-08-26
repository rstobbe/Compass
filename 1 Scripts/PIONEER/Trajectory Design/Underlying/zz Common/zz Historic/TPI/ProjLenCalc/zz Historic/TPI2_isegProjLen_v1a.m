%====================================================
% 
%====================================================

function [projlen,p] = TPI2_isegProjLen_v1a(iseg,gamfunc,Tro,p,op)

if iseg == Tro
    projlen = 1;
    p = 1;
    return
end

set(0,'RecursionLimit',500);
options = odeset('RelTol',1e-4);

G = @(r) gamfunc(r,p);
%-------------------------------
% initial test
%-------------------------------
reliseg0 = iseg/Tro;
tau = (0:0.005:12);
[x,r] = ode45('Rad_Sol',tau,p,options,G);
tautest = [0 (x + p)'];
rtot = [0 abs(r)'];
ind = find(rtot == max(rtot));
rtot = rtot(1:ind);
tautest = tautest(1:ind);
projlen = interp1(rtot,tautest,1);
err = round(100000*(Tro/projlen)*p) - round(iseg*100000);
if strcmp(op,'design')
    if abs(err) < 10
        return
    end
end

%-------------------------------
% #1
%-------------------------------
projlen = 16;
it2 = 0;
stop = 0;
dir = '';
while stop == 0
    tau = (0:0.005:projlen*1.25);
    G = @(r) gamfunc(r,p);
    [x,r] = ode45('Rad_Sol',tau,p,options,G);                        
    tauMax = interp1(abs(r),tau,1);
    if isnan(tauMax)
        error('tau must be longer');
    end
    projlen = tauMax+p;
    reliseg = p/projlen;
    err = round(100000*(Tro/projlen)*p) - round(iseg*100000);
    Status2('busy',['p: ',num2str(p,'%8.6f')],2);
    Status2('busy',['err: ',num2str(err)],3);
    if reliseg < reliseg0
        if strcmp(dir,'down');
            dir = 'up';
            break
        else
            dir = 'up';
            p = p+0.01;
        end
    else
        if strcmp(dir,'up');
            dir = 'down';
            break
        else
            dir = 'down';
            p = p-0.01;
        end
    end
    it2 = it2 + 1;
    if it2 > 100
        break;
    end
end

%-------------------------------
% #2
%-------------------------------
it2 = 0;
stop = 0;
dir = '';
while stop == 0
    tau = (0:0.005:projlen*1.05);
    G = @(r) gamfunc(r,p);
    [x,r] = ode45('Rad_Sol',tau,p,options,G);                        
    tauMax = interp1(abs(r),tau,1);
    projlen = tauMax+p;
    reliseg = p/projlen;
    err = round(100000*(Tro/projlen)*p) - round(iseg*100000);
    Status2('busy',['p: ',num2str(p,'%8.6f')],2);
    Status2('busy',['err: ',num2str(err)],3);
    if reliseg < reliseg0
        if strcmp(dir,'down');
            dir = 'up';
            break
        else
            dir = 'up';
            p = p+0.001;
        end
    else
        if strcmp(dir,'up');
            dir = 'down';
            break
        else
            dir = 'down';
            p = p-0.001;
        end
    end
    it2 = it2 + 1;
    if it2 > 100
        break
    end
end

%-------------------------------
% #3
%-------------------------------
it2 = 0;
stop = 0;
dir = '';
while stop == 0
    tau = (0:0.01:projlen);
    G = @(r) gamfunc(r,p);
    [x,r] = ode45('Rad_Sol',tau,p,options,G);                        
    tauMax = interp1(abs(r),tau,1);
    projlen = tauMax+p;
    reliseg = p/projlen;
    err = round(100000*(Tro/projlen)*p) - round(iseg*100000);
    Status2('busy',['p: ',num2str(p,'%8.6f')],2);
    Status2('busy',['err: ',num2str(err)],3);
    if reliseg < reliseg0
        if strcmp(dir,'down');
            dir = 'up';
            break
        else
            dir = 'up';
            p = p+0.0001;
        end
    else
        if strcmp(dir,'up');
            dir = 'down';
            break
        else
            dir = 'down';
            p = p-0.0001;
        end
    end
    it2 = it2 + 1;
    if it2 > 100
        break
    end
end

%-------------------------------
% #4
%-------------------------------
it2 = 0;
stop = 0;
dir = '';
while stop == 0
    tau = (0:0.001:projlen);
    G = @(r) gamfunc(r,p);
    [x,r] = ode45('Rad_Sol',tau,p,options,G);                        
    tauMax = interp1(abs(r),tau,1);
    projlen = tauMax+p;
    reliseg = p/projlen;
    err = round(100000*(Tro/projlen)*p) - round(iseg*100000);
    Status2('busy',['p: ',num2str(p,'%8.6f')],2);
    Status2('busy',['err: ',num2str(err)],3);
    if err == 0
        Status2('done','',2);
        Status2('done','',3);
        return
    end
    if reliseg < reliseg0
        if strcmp(dir,'down');
            dir = 'up';
            break
        else
            dir = 'up';
            p = p+0.00001;
        end
    else
        if strcmp(dir,'up');
            dir = 'down';
            break
        else
            dir = 'down';
            p = p-0.00001;
        end
    end
    it2 = it2 + 1;
    if it2 > 100
        break
    end
end

%-------------------------------
% #5
%-------------------------------
it2 = 0;
stop = 0;
dir = '';
while stop == 0
    tau = (0:0.001:projlen);
    G = @(r) gamfunc(r,p);
    [x,r] = ode45('Rad_Sol',tau,p,options,G);                        
    tauMax = interp1(abs(r),tau,1);
    projlen = tauMax+p;
    reliseg = p/projlen;
    err = round(100000*(Tro/projlen)*p) - round(iseg*100000);
    Status2('busy',['p: ',num2str(p,'%8.6f')],2);
    Status2('busy',['err: ',num2str(err)],3);
    if err == 0
        Status2('done','',2);
        Status2('done','',3);
        return
    end
    if reliseg < reliseg0
        if strcmp(dir,'down');
            dir = 'up';
            break
        else
            dir = 'up';
            p = p+0.000001;
        end
    else
        if strcmp(dir,'up');
            dir = 'down';
            break
        else
            dir = 'down';
            p = p-0.000001;
        end
    end
    it2 = it2 + 1;
    if it2 > 100
        error('projlen did not converge');
    end
end
if abs(err) > 0
    error('projlen solution not fine enough');
end
Status2('done','',2);
Status2('done','',3);

