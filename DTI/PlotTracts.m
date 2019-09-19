h = figure; hold on
% for n = 1:4000
%     plot3(Tracts{n}(:,1),Tracts{n}(:,2),Tracts{n}(:,3));
% end
% for n = 1:500
%     plot3(Tracts{n}(:,1),Tracts{n}(:,2),Tracts{n}(:,3));
% end
% for n = 501:1000
%     plot3(Tracts{n}(:,1),Tracts{n}(:,2),Tracts{n}(:,3));
% end
Len = 1000;
N = length(Tracts);
inds = randi(N,1,Len);
for n = 1:Len
    plot3(Tracts{inds(n)}(:,1),Tracts{inds(n)}(:,2),Tracts{inds(n)}(:,3));
end
