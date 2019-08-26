%=========================================================
% 
%=========================================================

function [warning,warnflag,PROJimp,GQNT,IMPipt] = TPI_INOVA_v4d(PROJdgn,PROJimp,GQNT,IMPipt)

warning = '';
warnflag = 0;

func = GQNT.return;
wantedtro = GQNT.wantedtro;
wantediseg = GQNT.wantediseg;
wantedtwgseg = GQNT.wantedtwgseg;

twwords = round((PROJdgn.tro - wantediseg)/wantedtwgseg);
iseg0 = round(wantediseg*10000);
twseg0 = round(wantedtwgseg*10000);
iseg = zeros(10,10);
twseg = zeros(10,10);    
idivno = zeros(10,10);
twdivno = zeros(10,10);
ind = zeros(10,10);
trotest = zeros(10,10);
isegtest = zeros(10,10);
for n = 0:9
    for m = 0:9
        iseg(n+1,m+1) = iseg0+n;
        twseg(n+1,m+1) = twseg0-m;
        G = gcd(iseg(n+1,m+1),twseg(n+1,m+1));
        idivno(n+1,m+1) = iseg(n+1,m+1)/G;
        twdivno(n+1,m+1) = twseg(n+1,m+1)/G;
        if idivno(n+1,m+1) < 256 && twdivno(n+1,m+1) < 256 
            ind(n+1,m+1) = 1;
        end
    end
end    
trotest(logical(ind)) = (iseg(logical(ind))+(twseg(logical(ind))*twwords))/10000;
isegtest(logical(ind)) = iseg(logical(ind))/10000;
[besttro,sortinds] = sort(trotest(:),'descend');
bestiseg = isegtest(sortinds);
GQNT.besttro = besttro(logical(besttro));
GQNT.bestiseg = bestiseg(logical(besttro));
GQNT.twwords = twwords;

if strcmp(func,'FindPossible');
    return
end

[N,M] = find(trotest == wantedtro);
GQNT = struct();
GQNT.iseg = iseg(N,M)/10000;
GQNT.twseg = twseg(N,M)/10000;
GQNT.idivno = idivno(N,M);
GQNT.twdivno = twdivno(N,M);
GQNT.reqtro = trotest(N,M);
GQNT.twwords = twwords;
GQNT.wpproj = twwords + 2;
GQNT.sym = 2;
GQNT.arr = [0 GQNT.iseg (GQNT.iseg+GQNT.twseg:GQNT.twseg:PROJdgn.tro)];

PROJimp.wpproj = GQNT.wpproj;
PROJimp.tw = (PROJimp.wpproj+8)*PROJdgn.nproj/2;          % (Seems like 8 words per proj for system overhead)
PROJimp.iseg = GQNT.iseg;
PROJimp.twseg = GQNT.twseg;
PROJimp.mingseg = min([PROJimp.iseg PROJimp.twseg]);
PROJimp.GQNT = GQNT;

[IMPipt] = AddToPanelOutput(IMPipt,'iGseg_Imp (ms)','0output',GQNT.iseg,'0numout');
[IMPipt] = AddToPanelOutput(IMPipt,'twGseg_Imp (ms)','0output',GQNT.twseg,'0numout');



