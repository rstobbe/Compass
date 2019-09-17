h = figure; hold on
for n = 1:4000
    plot3(Tracts{n}(:,1),Tracts{n}(:,2),Tracts{n}(:,3));
end