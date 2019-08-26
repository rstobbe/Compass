
gamma = 2*pi*42.577e6 ;         % rad/(s*T)    
G = 0.095;                      % T/m  (big number assumes using gradient combinations @ 55...)
dur = (1:0.1:20)*1e-3;          % s
b = 250*1e6;                    % s/m2

del = (b/(gamma^2*G^2))./(dur.^2) + dur/3;

for n = 1:length(del)
    if del(n) < dur(n)
        del(n) = dur(n);
    end
end
L = dur + del;

figure(100); hold on;
plot(dur,L);
plot(dur,(del-dur));            % fastest encoding when no space between gradients.  