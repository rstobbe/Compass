%=========================================================
% 
%=========================================================

function [warning,warnflag,AIDgqnt,GQNT,IMPipt] = Even_Division_v1c(AIDdgn,IMPipt)

warning = '';
warnflag = 0;

sym = IMPipt(strcmp('Sym',{IMPipt.labelstr})).entrystr;
if iscell(sym)
    sym = IMPipt(strcmp('Sym',{IMPipt.labelstr})).entrystr{IMPipt(strcmp('Sym',{IMPipt.labelstr})).entryvalue};
end
gres = str2double(IMPipt(strcmp('Gres',{IMPipt.labelstr})).entrystr);

if rem(AIDdgn.tro,gres)
    warnflag = 2;
    warning = 'Tro must be a multiple of Gres';
    return
end

GQNT.gres = gres;   
GQNT.arr = (0:gres:AIDdgn.tro);
GQNT.sym = sym;

AIDgqnt.meth = 'Even_Division_v1c';
AIDgqnt.mingres = gres;
AIDgqnt.wpproj = length(GQNT.arr-1);
AIDgqnt.tw = length(GQNT.arr-1)*AIDdgn.nproj;
AIDgqnt.sym = sym;
if strcmp(sym,'PosNeg');
    AIDgqnt.tw = AIDgqnt.tw/2;
end


