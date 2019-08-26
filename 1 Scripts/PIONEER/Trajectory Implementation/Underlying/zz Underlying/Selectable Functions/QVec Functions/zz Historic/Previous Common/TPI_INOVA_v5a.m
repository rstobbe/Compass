%=========================================================
% 
%=========================================================

function [PROJimp,GQNT,IMPipt,err] = TPI_INOVA_v5a(PROJdgn,PROJimp,GQNT,IMPipt,err)


func = GQNT.return;
wantedtro = GQNT.wantedtro;
wantediseg = GQNT.wantediseg;
noisegs = GQNT.noisegs;
wantedtwseg = GQNT.wantedtwseg;

twwords = round((wantedtro - noisegs*wantediseg)/wantedtwseg);
iseg0 = floor(wantediseg*10000);
twseg0 = ceil(wantedtwseg*10000);

L = 40;
while true
    iseg = zeros(L,L);
    twseg = zeros(L,L);    
    idivno = zeros(L,L);
    twdivno = zeros(L,L);
    ind = zeros(L,L);
    trotest = zeros(L,L);
    isegtest = zeros(L,L);
    twsegtest = zeros(L,L);
    for n = 0:(L-1)
        for m = 0:(L-1)
            iseg(n+1,m+1) = iseg0-(L/2)+n;
            twseg(n+1,m+1) = twseg0+(L/2)-m;
            G = gcd(iseg(n+1,m+1),twseg(n+1,m+1));
            idivno(n+1,m+1) = iseg(n+1,m+1)/G;
            twdivno(n+1,m+1) = twseg(n+1,m+1)/G;
            if idivno(n+1,m+1) < 256 && twdivno(n+1,m+1) < 256 
                ind(n+1,m+1) = 1;
            end
        end
    end    
    trotest(logical(ind)) = (noisegs*iseg(logical(ind))+(twseg(logical(ind))*twwords))/10000;
    isegtest(logical(ind)) = iseg(logical(ind))/10000;
    twsegtest(logical(ind)) = twseg(logical(ind))/10000;
    [besttro,sortinds] = sort(trotest(:),'descend');
    bestiseg = isegtest(sortinds);
    besttwseg = twsegtest(sortinds);

    closest = find((besttro > wantedtro),1,'last');
    if isempty(closest)
        L = L+10;
    else
        if closest <= 2
            L = L+10;
        else
            if length(besttro(logical(besttro))) - closest < 3
                L = L+10;
            else
                break
            end
        end
    end
    if L >= 200
        error('Need Expanded Search for GCDs');
    end
end

besttro = besttro(logical(besttro));
bestiseg = bestiseg(logical(besttro));
besttwseg = besttwseg(logical(besttro));

GQNT.besttro = besttro(closest-2:closest+3);
GQNT.bestiseg = bestiseg(closest-2:closest+3);
GQNT.besttwseg = besttwseg(closest-2:closest+3);
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
GQNT.arr = [0 (GQNT.iseg:GQNT.iseg:noisegs*GQNT.iseg) (noisegs*GQNT.iseg+GQNT.twseg:GQNT.twseg:wantedtro)];

if GQNT.arr(length(GQNT.arr)) ~= wantedtro
    error();
end

PROJimp.iseg = GQNT.iseg;
PROJimp.twseg = GQNT.twseg;
PROJimp.tro = GQNT.reqtro;
PROJimp.mingseg = min([PROJimp.iseg PROJimp.twseg]);
PROJimp.GQNT = GQNT;

[IMPipt] = AddToPanelOutput(IMPipt,'iGseg_Imp (ms)','0output',GQNT.iseg,'0numout');
[IMPipt] = AddToPanelOutput(IMPipt,'twGseg_Imp (ms)','0output',GQNT.twseg,'0numout');



