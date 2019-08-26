p = 1;
Nums = [];
for n = 20:1000
    for m = n:3000
%         n = 25;
%         m = 32;
        if not(rem(1e12*m/n,1)) && not(rem(1e12*n/m,1))
            if m/n < 1.6 && m/n > 1.26
                Nums(p,:) = [n m m/n];
                p = p+1;
            end
        end
    end
end
Nums