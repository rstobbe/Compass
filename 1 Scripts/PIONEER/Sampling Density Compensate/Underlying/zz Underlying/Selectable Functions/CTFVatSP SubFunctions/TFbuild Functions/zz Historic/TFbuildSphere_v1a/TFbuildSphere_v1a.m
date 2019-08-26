%================================================================================
% (v1a)
%   - 
%================================================================================

function [CTF,SCRPTipt,err] = TFbuildSphere_v1a(PROJimp,TF,KRNprms,CTF,SDCS,SCRPTipt,err)

CTF.MinRadDim = str2double(SCRPTipt(strcmp('MinRadDim',{SCRPTipt.labelstr})).entrystr);
CTF.MaxSubSamp = str2double(SCRPTipt(strcmp('MaxSubSamp',{SCRPTipt.labelstr})).entrystr);

DblKern = KRNprms.DblKern;
FwdKern = KRNprms.FwdKern;
RvsKern = KRNprms.RvsKern;

%----------------------------------------
% Error Tests
%----------------------------------------
if isfield(PROJimp,'elip')
    if PROJimp.elip ~= 1;                   
        if length(err) ~= 1
            errn = length(err)+1;
        else
            errn = 1;
        end
        err(errn).flag = 1;
        err(errn).msg = 'Elip Not Supported with TFbuildSphere_v1a';
        return
    end
end

%----------------------------------------
% 'Sphere-Array' Size Test
%----------------------------------------
m = 1;
for n = 1:0.0005:CTF.MaxSubSamp
    test = round(1e9/(n*DblKern.res))/1e9;
    if not(rem(test,1))
        psubsamp(m) = n;
        m = m+1;
    end    
end
kmax = SDCS.compkmax;
SubSamp = SDCS.SubSamp;
CTF.RadDim = round((kmax/PROJimp.kstep)*SubSamp);
while CTF.RadDim < CTF.MinRadDim
    ind = find(psubsamp == SubSamp,1);
    if ind == length(psubsamp)
        err.flag = 1;
        err.msg = 'increase (MaxSubSamp) or decrease (MinRadDim)';
        return
    end
    SubSamp = psubsamp(ind+1);
    CTF.RadDim = round((kmax/PROJimp.kstep)*SubSamp);
end
CTF.SubSamp = SubSamp;

%----------------------------------------
% Build 'Sphere-Array'
%----------------------------------------
Status2('busy','Build Transfer Function Shape',2);
top = CTF.RadDim + 1;
bot = ceil((FwdKern.W+RvsKern.W)*SubSamp/2) + 1;
Loc = zeros((2*bot+1)^2*(top+bot+1),3);
Val = zeros((2*bot+1)^2*(top+bot+1),3);
n = 1;
m = 1;
L = length(TF.r)-1;
for x = -bot:top
    for y = -bot:bot
        for z = -bot:bot
            r = sqrt(x^2 + y^2 + z^2)/CTF.RadDim;
            if r <= 1 
                 Loc(n,:) = [x y z];  
                 Val(n) = lin_interp4(TF.tf,r,L);
                 n = n+1;
            elseif r > 1 && r <= 1.0001                             % accomodate quantization (for CTF.MinRadDim > 80, below does nothing)
                 Loc(n,:) = [x y z];  
                 r = 1;
                 Val(n) = lin_interp4(TF.tf,r,L);
                 n = n+1;                
            end
        end
    end
    Status2('busy',num2str(top+bot-m+1),3);
    m = m+1;    
end
Status2('done','',3);
CTF.Loc = Loc(1:n-1,:)*(PROJimp.kstep/SubSamp);
CTF.Val = Val(1:n-1);

Status2('done','',2);
Status2('done','',3);


