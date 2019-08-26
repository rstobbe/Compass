%============================================================
%   Looping function to create header and write multiple dicom files
%   Required functions: Image proc. toolbox
%   NB: This function has not been tested extensively
%   
%   Original Author (dicomw): R. Marc Lebel
%   Date: 04/2008
%   Edited (v1a): RWS
%   Date: 12/2013
%   
%   Usage: dicomw(img,path,par,scale,opt)
%   
%   Input:
%   img: image stack of size M x N (x O)
%       M x N: inplane resolution
%       O    : number of slices
%   path: file path and name base. sliceXXX.arrayXXX.dcm will be appended
%   par: varian parameter structure with several amendments (see below)
%        Use readprocpar to import procpar into matlab
%   opt.operator:  
%
%   It is usefull to manually add the following fields to the par struct:
%       StudyInstanceUID (keep for all study) (string)
%       SeriesNumber (number)
%       name.FamilyName (string)
%       name.GivenName (string)
%       PatientID (string)
%       PatientsBirthDate (string)
%       PatientAge (string)
%       PatientsWeight (string)
%       comment (sting)
%       StudyDescription (string)
%   
%   For fMRI, it is also useful to define the following:
%       AcquisitionNumber (number)
%       TemporalPositionIdentifier
%       NumberOfTemporalPositions
%       TemporalResolution (usually TR)
%   
%   Image orientation notes:
%   Input images must conform to the following orientation:
%   Pure axial images (phi = theta = phi = 0) should have anterior at image
%   top, patient left at image right, and the first slice is most inferior.
%
%   (v1a)
%       - start from 'dicomw' file
%       - file naming change
%       - opt to struct for operator input
%       - remove scale
%===========================================================

function dicomw_v1a(img,path,par,opt)

% Get and check image size
N = size(img);
if length(N) < 2 || length(N) > 3
    error('image must be M x N (x O)');
end
[~,~,O] = size(img);

% Check if image is complex
if ~isreal(img)
    warning('complex image data converted to magnitude');
    img = abs(img);
end

% Flip and negate pss (to conform with coordinte system)
par.pss = -fliplr(par.pss);

%   Fix some numerical parameters
%   Often parameters have odd rounding for insignificant bits that can
%   disrupt dicom export
par.pss = round(1e5*par.pss)*1e-5;
par.lro = round(1e5*par.lro)*1e-5;
par.lpe = round(1e5*par.lpe)*1e-5;
par.lpe2= round(1e5*par.lpe2)*1e-5;
par.gap = round(1e5*par.gap)*1e-5;

%   Warn and fix irregular slice spacing
pssdiff = diff(par.pss);
if sum(pssdiff == pssdiff(1)) ~= length(pssdiff)
%     disp('irregular slice spacing converted to equal spacing');
    par.pss = par.pss(1):median(pssdiff):par.pss(1)+median(pssdiff)*O;
end

%   Scale image
img = uint16(32760*img/max(img(:)));

%   Create key parameters
info.Modality = 'MR';
info.Manufacturer = 'Varian';
info.InstitutionName = 'University of Alberta';

%   Create pixel intensity parameters
info.SmallestImagePixelValue = 0;
info.LargestImagePixelValue = max(img(:));
info.WindowCenter = max(img(:))/2;
info.WindowWidth = max(img(:));
info.PhotometricInterpretation = 'MONOCHROME2';
info.BitDepth = 16;
info.BitsAllocated = 16;
info.BitsStored = 16;
info.HighBit = 15;
info.ColorType = 'grayscale';

%   Create basic sequence parameters
info.SequenceName = par.seqfil;
if par.nD == 2
    info.MRAcquisitionType = '2D';
elseif par.nD == 3
    info.MRAcquisitionType = '3D';
end
info.ImageType = 'ORIGINAL\PRIMARY\OTHER\OTHER';
info.ImageLaterality = 'U';
info.ScanOptions = '';
if strcmp(par.seqfil,'fsemsuf') || strcmp(par.seqfil,'fse3dml')
    if strcmp(par.haste,'n')
        info.SequenceVariant = 'SK';
    else
        info.SequenceVariant = 'NONE';
        info.ScanOptions = 'PFP';
    end
    if strcmp(par.ir,'y')
        info.ScanningSequence = 'SE';
        info.InversionTime = par.ti;
    else
        info.ScanningSequence = 'SE';
    end
    info.EchoTrainLength = par.etl;
    fatemp = par.fliptrain;
    info.FlipAngle = fatemp(end);
    if isequal(fatemp(1),mean(fatemp))
        info.VariableFlipAngleFlag = 'N';
    else
        info.VariableFlipAngleFlag = 'Y';
    end
    info.EchoNumber = par.eff_echo;
elseif strcmp(par.seqfil,'gems') || strcmp(par.seqfil,'ge3d') || strcmp(par.seqfil,'mp_flash3d')
    info.SequenceVariant='SP';
    info.ScanningSequence='GR';
else
    info.SequenceVariant='NONE';
    info.ScanningSequence='RM';
end
info.EchoTrainLength = 1;
info.AngioFlag = 'N';

%   Create basic acquisition parameters
info.Width = par.nv;
info.Height = par.np/2;
if par.nD == 2
    info.SliceThickness = par.thk;
    info.SpacingBetweenSlices = round(1e4*par.thk+par.gap*10)*1e-4;
else
    info.SliceThickness = round(1e4*par.lpe2/par.nv2 * 10)*1e-4;
    info.SpacingBetweenSlices = info.SliceThickness;
end
info.RepetitionTime = par.tr * 1000;
info.EchoTime = par.te*1000;
info.NumberOfAverages = par.nt;
info.PixelBandwidth = 2*par.sw/par.np;
info.NumberOfPhaseEncodingSteps = par.nv;
info.PercentPhaseFieldOfView = par.lpe/par.lro * 100;
info.Rows = par.np/2;
info.Columns = par.nv;
info.InPlanePhaseEncodingDirection = 'ROW';
info.PixelSpacing = round(1e3 * [2*par.lro/par.np; par.lpe/par.nv]*10) * 1e-3;
if info.PixelSpacing(1) ~= info.PixelSpacing(2)
    info.PixelAspectRatio = round(50 * [info.PixelSpacing(1)/info.PixelSpacing(2); 1]);
end
% info.PresentationPixelAspectRatio = info.PixelAspectRatio;
% info.PresentationPixelSpacing = info.PixelSpacing;
% info.PresentationSizeMode = 'TRUE SIZE';
info.ImagingFrequency = par.sfrq;
info.ImagedNucleus = '1H';
info.MagneticFieldStrength = par.B0/10000;
if par.nrcvrs > 1
    info.ReceiveCoilName = 'Neuro Array';
end
info.TransmitCoilName = par.rfcoil;
info.PercentSampling = 100;
info.AcquisitionMatrix = [0; par.np/2; par.nv; 0];

%   Create patient parameters
if ~isfield(par,'PatientID') || isempty(par.PatientID)
    info.PatientID = '0';
else
    info.PatientID = par.PatientID;
end
if isempty(par.name)
    info.PatientName.FamilyName = 'Anonymous';
    info.PatientName.GivenName = 'Anonymous';
else
    info.PatientName = par.name;
end
if ~isfield(par,'PatientsBirthDate') || isempty(par.PatientsBirthDate)
    info.PatientsBirthDate = '';
else
    info.PatientsBirthDate = par.PatientsBirthDate;
end
if ~isfield(par,'PatientsSex') || isempty(par.PatientsSex)
    info.PatientsSex = '';
else
    info.PatientsSex = par.PatientsSex;
end
if ~isfield(par,'PatientsAge') || isempty(par.PatientsAge)
    info.PatientsAge = '';
else
    info.PatientsAge = par.PatientsAge;
end
if ~isfield(par,'PatientsWeight') || isempty(par.PatientsWeight)
    info.PatientsWeight = '';
else
    info.PatientsWeight = par.PatientsWeight;
end
info.PatientPosition = 'HFS';

%   Create time and study unique identifiers
ind = findstr(par.time_complete,'T');
info.StudyDate = par.time_complete(1:ind-1);
info.SeriesDate = par.time_complete(1:ind-1);
info.AcquisitionDate = par.time_complete(1:ind-1);
info.ContentDate = par.time_complete(1:ind-1);
info.StudyTime = par.time_complete(ind+1:end);
info.SeriesTime = par.time_complete(ind+1:end);
info.AcquisitionTime = par.time_complete(ind+1:end);
info.ContentTime = par.time_complete(ind+1:end);
if ~isfield(par,'StudyDescription') || isempty(par.StudyDescription)
    info.StudyDescription = 'Test Study';
else
    info.StudyDescription = par.StudyDescription;
end
if isempty(par.comment)
    info.SeriesDescription = 'Test Series';
else
    info.SeriesDescription = par.comment;
end
if ~isfield(par,'SeriesNumber') || isempty(par.SeriesNumber)
    info.SeriesNumber = 1;
else
    info.SeriesNumber = par.SeriesNumber;
end
if isfield(par,'AcquisitionNumber')
    info.AcquisitionNumber = par.AcquisitionNumber;
    info.TemporalPositionIdentifier = par.AcquisitionNumber;
else
    info.AcquisitionNumber = 1;
    info.TemporalPositionIdentifier = 1;
end
if isfield(par,'NumberOfTemporalPositions')
    info.NumberOfTemporalPositions = par.NumberOfTemporalPositions;
else
    info.NumberOfTemporalPositions = info.TemporalPositionIdentifier;
end
if isfield(par,'TemporalResolution')
    info.TemporalResolution = par.TemporalResolution;
else
    info.TemporalResolution = par.tr;
end
info.OperatorName = opt.operator;
info.ProtocolName = par.seqfil;
info.StudyID = '1';
if isfield(par,'SeriesInstanceUID');
    info.SeriesInstanceUID = par.SeriesInstanceUID;
else
    info.SeriesInstanceUID = dicomuid;
end
if isfield(par,'StudyInstanceUID')
    info.StudyInstanceUID = par.StudyInstanceUID;
else
    info.StudyInstanceUID = dicomuid;
end
info.SOPInstanceUID = dicomuid;
info.MediaStorageSOPInstanceUID = dicomuid;

%   Determine direction cosines
phi   = par.phi   * pi/180;
theta = par.theta * pi/180;
psi   = -par.psi   * pi/180;
Rtheta = [1 0 0;0 cos(theta) sin(theta);0 -sin(theta) cos(theta)];
Rpsi   = [cos(psi) sin(psi) 0;-sin(psi) cos(psi) 0;0 0 1];
Rphi   = [cos(phi) 0 sin(phi);0 1 0;-sin(phi) 0 cos(phi)];
R = round(1e6*Rphi * Rpsi * Rtheta)*1e-6;
R(:,1:2) = -R(:,1:2);
info.ImageOrientationPatient = -[R(1,1); R(2,1); R(3,1); R(1,2); R(2,2); R(3,2)];

%   Compute orientation parameters
%   http://mathworld.wolfram.com/EulerAngles.html
% phi   = par.phi   * pi/180;
% theta = par.theta * pi/180;
% psi   = par.psi   * pi/180;
% d11 = cos(psi)*cos(phi) - cos(theta)*sin(phi)*sin(psi);
% d12 = cos(psi)*sin(phi) + cos(theta)*cos(phi)*sin(psi);
% d13 = sin(psi)*sin(theta);
% d21 = -sin(psi)*cos(phi) - cos(theta)*sin(phi)*cos(psi);
% d22 = -sin(psi)*sin(phi) + cos(theta)*cos(phi)*cos(psi);
% d23 = cos(psi)*sin(theta);
% d31 = sin(theta)*sin(phi);
% d32 = -sin(theta)*cos(phi);
% d33 = cos(theta);
% info.ImageOrientationPatient = [d11; d12; d13; d21; d22; d23];


%   Loop through each slice
for i = 1:O
    
    %   Define slice centers
    Ox = round(1e6*(-R(1,1)*par.ppe*10 - R(1,2)*par.pro*10 + R(1,3)*par.pss(i)*10))*1e-6;
    Oy = round(1e6*(-R(2,1)*par.ppe*10 - R(2,2)*par.pro*10 + R(2,3)*par.pss(i)*10))*1e-6;
    Oz = round(1e6*(-R(3,1)*par.ppe*10 - R(3,2)*par.pro*10 + R(3,3)*par.pss(i)*10))*1e-6;
    
    %   Define span/2
    Px = round(1e6*(R(1,1)*par.lpe/2*10 + R(1,2)*par.lro/2*10))*1e-6;
    Py = round(1e6*(R(2,1)*par.lpe/2*10 + R(2,2)*par.lro/2*10))*1e-6;
    Pz = round(1e6*(R(3,1)*par.lpe/2*10 + R(3,2)*par.lro/2*10))*1e-6;
    
%     %   Define slice centers
%     Ox = round(1e6*(-d11*par.ppe*10 - d12*par.pro*10 + d13*par.pss(i)*10))*1e-6;
%     Oy = round(1e6*(-d21*par.ppe*10 - d22*par.pro*10 + d23*par.pss(i)*10))*1e-6;
%     Oz = round(1e6*(-d31*par.ppe*10 - d32*par.pro*10 + d33*par.pss(i)*10))*1e-6;
%     
%     %   Define span/2
%     Px = round(1e6*(d11*par.lpe/2*10 + d12*par.lro/2*10))*1e-6;
%     Py = round(1e6*(d21*par.lpe/2*10 + d22*par.lro/2*10))*1e-6;
%     Pz = round(1e6*(d31*par.lpe/2*10 + d32*par.lro/2*10))*1e-6;

    %   Create corner position vector
    info.ImagePositionPatient = [Ox+Px; Oy+Py; Oz+Pz];
    
    %   Update Slice location and number
    info.SliceLocation = round(1e6*(par.pss(i) * 10))*1e-6;
    info.InstanceNumber = i;
    
    %   Update filename
    istr = int2str(i);
    if i < 100
        istr = ['0' istr];
    end
    if i < 10
        istr = ['0' istr];
    end
    filename = [path 'image' istr '.dcm'];
    
    %   Call dicom writing engine
    dicomwrite(img(:,:,i),filename,info,'CompressionMode','none');
    
end
