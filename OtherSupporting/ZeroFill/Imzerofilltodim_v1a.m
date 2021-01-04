%=====================================================
%
%=====================================================

function [Imzf,err] = Imzerofilltodim_v1a(Im,zfdims)


%---------------------------------------------
% Test
%---------------------------------------------
sz = size(Im);
if zfdims(1) < sz(1) || zfdims(2) < sz(2) || zfdims(3) < sz(3)
    err.flag = 1;
    err.msg = 'zerofill too small';
    return
end
if zfdims(1) == sz(1) && zfdims(2) == sz(2) && zfdims(3) == sz(3)
    return
end
nrcvrs = sz(4);

%---------------------------------------------
% Zero-Fill
%---------------------------------------------
Imzf = zeros([zfdims,nrcvrs]);
for n = 1:nrcvrs
    kdat = fftshift(ifftn(ifftshift(Im(:,:,:,n))));
    zfkdat = zeros(zfdims);
    bot = floor((zfdims - sz(1:3))/2)+1;
    top = bot + sz(1:3) - 1;
    zfkdat(bot(1):top(1),bot(2):top(2),bot(3):top(3)) = kdat;
    Imzf(:,:,:,n) = fftshift(fftn(ifftshift(zfkdat)));
end
%test = size(Imzf)

