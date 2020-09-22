function BuildCompass

Version = cd;
ind = strfind(Version,'Code');
if isempty(ind)
    error('Must be in ''Code'' folder');
end
Version = Version(1:ind-1);

pcode('D:\0 Software\COMPASS\PathDist Info\');
pcode(Version);
pcode([Version 'Image Display\']);
pcode([Version 'Image Import\']);
pcode([Version 'Interactive Image Analysis\']);
pcode([Version 'Interactive Image Analysis\Functions\Contrast']);
pcode([Version 'Interactive Image Analysis\Functions\Current Point']);
pcode([Version 'Interactive Image Analysis\Functions\Dimension Change']);
pcode([Version 'Interactive Image Analysis\Functions\Line Tool']);
pcode([Version 'Interactive Image Analysis\Functions\Orientation']);
pcode([Version 'Interactive Image Analysis\Functions\Ortho']);
pcode([Version 'Interactive Image Analysis\Functions\Output Plot']);
pcode([Version 'Interactive Image Analysis\Functions\ROI']);
pcode([Version 'Interactive Image Analysis\Functions\Slice Change']);
pcode([Version 'Interactive Image Analysis\Functions\Tieing']);
pcode([Version 'Interactive Image Analysis\Functions\Zoom']);
pcode([Version 'Interactive Image Analysis\Classes\@FigObjsClass']);
pcode([Version 'Interactive Image Analysis\Classes\@ImageAnlzClass']);
pcode([Version 'Interactive Image Analysis\Classes\@ImageRoiClass']);
pcode([Version 'Interactive Image Analysis\Classes\@RoiCircleClass']);
pcode([Version 'Interactive Image Analysis\Classes\@RoiFreeHandClass']);
pcode([Version 'Interactive Image Analysis\Classes\@RoiSeedClass']);
pcode([Version 'Interactive Image Analysis\Classes\@RoiSphereClass']);
pcode([Version 'Interactive Image Analysis\Classes\@RoiTubeClass']);
pcode([Version 'Interactive Image Analysis\Classes\@StatusClass']);
pcode([Version 'RWSUI\0 Core']);
pcode([Version 'RWSUI\1 Panel']);
pcode([Version 'RWSUI\2 Various']);
pcode([Version 'RWSUI\3 Interaction']);
pcode([Version 'RWSUI\4 Globals']);
pcode([Version 'RWSUI\5 Defaults']);