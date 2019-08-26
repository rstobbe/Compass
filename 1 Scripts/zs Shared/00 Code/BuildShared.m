function BuildShared

Version = cd;
ind = strfind(Version,'00 Code');
if isempty(ind)
    error('Must be in ''00 Code'' folder');
end
Version = Version(1:ind-1);

pcode([Version '0 General\File Related\']);
pcode([Version '0 General\File Related\Version Control\']);
pcode([Version '0 General\File Related\Underlying\']);
pcode([Version '0 General\Mat2Arr\']);
pcode([Version '0 General\Interpolation\']);
pcode([Version '1 MRI Systems\4 Siemens\Get Sequence Data\']);
pcode([Version '2 Convolution\Testing\']);
pcode([Version '2 Convolution\Normalize Projections to Grid\']);
pcode([Version '3 Image Related\Image Plotting\Compass Defaults\']);
pcode([Version '3 Image Related\Image Plotting\Overlay Defaults\']);
pcode([Version '3 Image Related\Image Plotting\Plot Montage\Top\']);
pcode([Version '3 Image Related\Image Plotting\Plot Montage\Underlying']);
pcode([Version '3 Image Related\Image Plotting\Setup Montage\']);
pcode([Version '3 Image Related\Filters\Cartesian Filters\']);
