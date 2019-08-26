
function findzf

p = 1;
for n = 1:500
    m = n*1.28;
    if not(rem(m,1))
        test(p) = m;
        p = p+1;
    end
end
test