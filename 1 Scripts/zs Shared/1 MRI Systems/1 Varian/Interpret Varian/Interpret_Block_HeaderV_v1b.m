%===============================================
% Interpret Block Header
%       (7 int32 input)
%===============================================

function Interpret_Block_HeaderV_v1b(A)


test = typecast(int32(A(1)),'int16');


%scale   = fread(infid, 1, 'short');     %2     % finish...
%status  = fread(infid, 1, 'short');
%index   = fread(infid, 1, 'short');
%mode    = fread(infid, 1, 'short');
%ct      = fread(infid, 1, 'long');      %4
%lpval   = fread(infid, 1, 'float');
%rpval   = fread(infid, 1, 'float');     %4
%lvl     = fread(infid, 1, 'float');
%tlt     = fread(infid, 1, 'float');


