%===============================================
% Interpret Block Header
% - never used - garbage
%===============================================

function Interpret_Block_Header(A)

scale1 = bitshift(A(1),8);                        % (1-2)
scale = scale1 + A(2);

status1 = bitshift(A(3),8);                        % (3-4)
status = status1 + A(4);

index1 = bitshift(A(5),8);                        % (5-6)
index = index1 + A(6);

mode1 = bitshift(A(7),8);                        % (7-8)
mode = mode1 + A(8);

ct1 = bitshift(A(11),8);                        % (9-12)
ct = ct1 + A(12);

%lpval1 = bitshift(A(15),8);                        % (13-16)
%lpval = lpval1 + A(16);

%rpval1 = bitshift(A(19),8);                        % (17-20)
%rpval = rpval1 + A(20);

lvl1 = A(21);                                   % (21-24)
sign = bitand(lvl1,128)/128;

lvl = lvl1 + A(24);

tlt1 = bitshift(A(27),8);                        % (21-24)
tlt = tlt1 + A(28);



