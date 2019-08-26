%=====================================================
% (v8a)
%       - Parallelize
%=====================================================

function [Kmat,Kend] = ReSampleKSpace_v8a(G,T,samp,gamma)

error;              % doesn't work yet

npro = length(samp);
[nproj,~,~] = size(G);

samp = [0 samp];
samp = round(samp*1e6);
T = round(T*1e6);

if T(1) ~= 0    
    error;              % can't handle negative
end

if nproj > 1
    Kmat = zeros(nproj,npro+1,3);
    K = zeros(nproj,3);
       
    divs = 100;
    for p = 1:ceil((npro+1)/divs)
        if p*divs < (npro+1)
            marray = (p-1)*divs+1:p*divs;
        else
            marray = (p-1)*divs+1:(npro+1);
        end
        Status2('busy',['Sample Number: ',num2str(marray(end))],3);     
        ind = 2;
        parfor m = marray
            d = 0;
            while d == 0
                if T(ind) < samp(m)                
                    if T(ind) > samp(m-1)
                        if T(ind-1) < samp(m-1)
                            K = K + (T(ind)-samp(m-1))*(squeeze(G(:,ind-1,:)))*gamma/1e6;
                            ind = ind+1;
                        elseif T(ind-1) >= samp(m-1)
                            K = K + (T(ind)-T(ind-1))*(squeeze(G(:,ind-1,:)))*gamma/1e6;
                            ind = ind+1;
                        end
                    elseif T(ind) <= samp(m-1)
                        if ind == length(T)
                            K = K + (samp(m)-T(ind))*(squeeze(G(:,ind,:)))*gamma/1e6;
                            d = 1; 
                            Kmat(:,m,:) = K;
                        else
                            if T(ind+1) >= samp(m)                
                                K = K + (samp(m)-samp(m-1))*(squeeze(G(:,ind,:)))*gamma/1e6;
                                d = 1; 
                                Kmat(:,m,:) = K;
                            elseif T(ind+1) < samp(m)
                                ind = ind+1;
                            end
                        end
                    end
                elseif T(ind) >= samp(m)   
                    if T(ind-1) <= samp(m-1)
                        K = K + (samp(m)-samp(m-1))*(squeeze(G(:,ind-1,:)))*gamma/1e6;
                        d = 1; 
                        Kmat(:,m,:) = K;
                    elseif T(ind-1) > samp(m-1)
                        K = K + (samp(m)-T(ind-1))*(squeeze(G(:,ind-1,:)))*gamma/1e6;
                        d = 1;
                        Kmat(:,m,:) = K;
                    end
                end
            end
        end
    end
elseif nproj == 1
    Kmat = zeros(nproj,npro+1,3);
    K = zeros(nproj,3);
    ind = 2;
    for m = 2:npro+1
        d = 0;
        while d == 0
            if T(ind) < samp(m)                
                if T(ind) > samp(m-1)
                    if T(ind-1) < samp(m-1)
                        K = K + (T(ind)-samp(m-1))*(squeeze(G(:,ind-1,:)))'*gamma/1e6;
                        ind = ind+1;
                    elseif T(ind-1) >= samp(m-1)
                        K = K + (T(ind)-T(ind-1))*(squeeze(G(:,ind-1,:)))'*gamma/1e6;
                        ind = ind+1;
                    end
                elseif T(ind) <= samp(m-1)
                    if ind == length(T)
                        K = K + (samp(m)-T(ind))*(squeeze(G(:,ind,:)))'*gamma/1e6;
                        d = 1; 
                        Kmat(:,m,:) = K;
                    else
                        if T(ind+1) >= samp(m)                
                            K = K + (samp(m)-samp(m-1))*(squeeze(G(:,ind,:)))'*gamma/1e6;
                            d = 1; 
                            Kmat(:,m,:) = K;
                        elseif T(ind+1) < samp(m)
                            ind = ind+1;
                        end
                    end
                end
            elseif T(ind) >= samp(m)   
                if T(ind-1) <= samp(m-1)
                    K = K + (samp(m)-samp(m-1))*(squeeze(G(:,ind-1,:)))'*gamma/1e6;
                    d = 1; 
                    Kmat(:,m,:) = K;
                elseif T(ind-1) > samp(m-1)
                    K = K + (samp(m)-T(ind-1))*(squeeze(G(:,ind-1,:)))'*gamma/1e6;
                    d = 1;
                    Kmat(:,m,:) = K;
                end
            end
        end
        Status2('busy',['Sample Number: ',num2str(m)],3);     
    end
end
    
Kend = Kmat(:,npro+1,:);
Kmat = Kmat(:,2:npro+1,:);

