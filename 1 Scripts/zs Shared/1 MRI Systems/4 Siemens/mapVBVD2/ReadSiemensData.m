function Hdr = ReadSiemensData(filename)

fid = fopen(filename,'r','l','US-ASCII');
fseek(fid,0,'bof');

firstInt  = fread(fid,1,'uint32');
secondInt = fread(fid,1,'uint32');

if not(and(firstInt < 10000, secondInt <= 64))
    error
end

%-----------------------------------------------------
% Header Stuff
%-----------------------------------------------------
NScans = secondInt;
MeasId = fread(fid,1,'uint32');
FileId = fread(fid,1,'uint32');
MeasOffset = fread(fid,1,'uint64');             % points to beginning of header, usually at 10240 bytes
fseek(fid,MeasOffset,'bof');
HdrLen = fread(fid, 1,'uint32');
%[Hdr,~] = read_twix_hdr(fid);

%-----------------------------------------------------
% Read (first) Mdh
%-----------------------------------------------------
DataStart = MeasOffset + HdrLen;
fseek(fid,DataStart,'bof');
byteMdh = 184;
MdhTemp = fread(fid,byteMdh,'uint8=>uint8');
MdhTemp = MdhTemp([1:20 41:end],:);     % remove 20 unnecessary bytes
Mdh = EvalMdh(MdhTemp);

sLC             = double(Mdh.sLC ) + 1;  % +1: convert to matlab index style
this.NCol       = double( Mdh.ushSamplesInScan ).';
this.NCha       = double( Mdh.ushUsedChannels ).';
this.Lin        = sLC(:,1).' ;
this.Ave        = sLC(:,2).' ;
this.Sli        = sLC(:,3).' ;
this.Par        = sLC(:,4).' ;
this.Eco        = sLC(:,5).' ;
this.Phs        = sLC(:,6).' ;
this.Rep        = sLC(:,7).' ;
this.Set        = sLC(:,8).' ;
this.Seg        = sLC(:,9).' ;
this.Ida        = sLC(:,10).';
this.Idb        = sLC(:,11).';
this.Idc        = sLC(:,12).';
this.Idd        = sLC(:,13).';
this.Ide        = sLC(:,14).';

end

function this = readMDH(this, mdh, filePos )
    % extract all values in all MDHs at once
    %
    % data types:
    % Use double for everything non-logical, both ints and floats. Seems the
    % most robust way to avoid unexpected cast-issues with very nasty side effects.
    % Examples: eps(single(16777216)) == 2
    %           uint32( 10 ) - uint32( 20 ) == 0
    %           uint16(100) + 1e5 == 65535
    %           size(1 : 10000 * uint16(1000)) ==  [1  65535]
    %
    % The 1st example always hits the timestamps.

    if ~isstruct( mdh ) || isempty( mdh )
        return
    end

    this.NAcq     = numel( filePos );
    sLC           = double( mdh.sLC ) + 1;  % +1: convert to matlab index style
    evalInfoMask1 = double( mdh.aulEvalInfoMask(:,1) ).';

    % save mdh information for each line
    this.NCol       = double( mdh.ushSamplesInScan ).';
    this.NCha       = double( mdh.ushUsedChannels ).';
    this.Lin        = sLC(:,1).' ;
    this.Ave        = sLC(:,2).' ;
    this.Sli        = sLC(:,3).' ;
    this.Par        = sLC(:,4).' ;
    this.Eco        = sLC(:,5).' ;
    this.Phs        = sLC(:,6).' ;
    this.Rep        = sLC(:,7).' ;
    this.Set        = sLC(:,8).' ;
    this.Seg        = sLC(:,9).' ;
    this.Ida        = sLC(:,10).';
    this.Idb        = sLC(:,11).';
    this.Idc        = sLC(:,12).';
    this.Idd        = sLC(:,13).';
    this.Ide        = sLC(:,14).';

    this.centerCol   = double( mdh.ushKSpaceCentreColumn ).' + 1;
    this.centerLin   = double( mdh.ushKSpaceCentreLineNo ).' + 1;
    this.centerPar   = double( mdh.ushKSpaceCentrePartitionNo ).' + 1;
    this.cutOff      = double( mdh.sCutOff ).';
    this.coilSelect  = double( mdh.ushCoilSelect ).';
    this.ROoffcenter = double( mdh.fReadOutOffcentre ).';
    this.timeSinceRF = double( mdh.ulTimeSinceLastRF ).';
    this.IsReflected = logical(min(bitand(evalInfoMask1,2^24),1));
    this.scancounter = double( mdh.ulScanCounter ).';
    this.timestamp   = double( mdh.ulTimeStamp ).';
    this.pmutime     = double( mdh.ulPMUTimeStamp ).';
    this.IsRawDataCorrect = logical(min(bitand(evalInfoMask1,2^10),1)); %SRY
    this.slicePos    = double( mdh.SlicePos ).';
    this.iceParam    = double( mdh.aushIceProgramPara ).';
    this.freeParam   = double( mdh.aushFreePara ).';

    this.memPos = filePos;

end % of readMDH








function [mdh,mask] = EvalMdh(MdhTemp)
% see pkg/MrServers/MrMeasSrv/SeqIF/MDH/mdh.h
% and pkg/MrServers/MrMeasSrv/SeqIF/MDH/MdhProxy.h

if ~isa( MdhTemp, 'uint8' )
    error( [mfilename() ':NoInt8'], 'Binary mdh data must be a uint8 array!' )
end


isVD = true;


Nmeas   = size( MdhTemp, 2 );

mdh.ulPackBit   = bitget( MdhTemp(4,:), 2).';
mdh.ulPCI_rx    = bitset(bitset(MdhTemp(4,:), 7, 0), 8, 0).'; % keep 6 relevant bits
MdhTemp(4,:)   = bitget( MdhTemp(4,:),1);  % ubit24: keep only 1 bit from the 4th byte

% unfortunately, typecast works on vectors, only
data_uint32     = typecast( reshape(MdhTemp(1:76,:),  [],1), 'uint32' );
data_uint16     = typecast( reshape(MdhTemp(29:end,:),[],1), 'uint16' );
data_single     = typecast( reshape(MdhTemp(69:end,:),[],1), 'single' );

data_uint32 = reshape( data_uint32, [], Nmeas ).';
data_uint16 = reshape( data_uint16, [], Nmeas ).';
data_single = reshape( data_single, [], Nmeas ).';

test = data_uint32(1,:)

%  byte pos.
%mdh.ulDMALength               = data_uint32(:,1);      %   1 :   4
mdh.lMeasUID                   = data_uint32(:,2);      %   5 :   8
mdh.ulScanCounter              = data_uint32(:,3);      %   9 :  12
mdh.ulTimeStamp                = data_uint32(:,4);      %  13 :  16
mdh.ulPMUTimeStamp             = data_uint32(:,5);      %  17 :  20
mdh.aulEvalInfoMask            = data_uint32(:,6:7);    %  21 :  28
mdh.ushSamplesInScan           = data_uint16(:,1);      %  29 :  30
mdh.ushUsedChannels            = data_uint16(:,2);      %  31 :  32
mdh.sLC                        = data_uint16(:,3:16);   %  33 :  60
mdh.sCutOff                    = data_uint16(:,17:18);  %  61 :  64
mdh.ushKSpaceCentreColumn      = data_uint16(:,19);     %  66 :  66
mdh.ushCoilSelect              = data_uint16(:,20);     %  67 :  68
mdh.fReadOutOffcentre          = data_single(:, 1);     %  69 :  72
mdh.ulTimeSinceLastRF          = data_uint32(:,19);     %  73 :  76
mdh.ushKSpaceCentreLineNo      = data_uint16(:,25);     %  77 :  78
mdh.ushKSpaceCentrePartitionNo = data_uint16(:,26);     %  79 :  80

if isVD
    mdh.SlicePos                    = data_single(:, 4:10); %  81 : 108
    mdh.aushIceProgramPara          = data_uint16(:,41:64); % 109 : 156
    mdh.aushFreePara                = data_uint16(:,65:68); % 157 : 164
else
    mdh.aushIceProgramPara          = data_uint16(:,27:30); %  81 :  88
    mdh.aushFreePara                = data_uint16(:,31:34); %  89 :  96
    mdh.SlicePos                    = data_single(:, 8:14); %  97 : 124
end

% inlining of evalInfoMask
evalInfoMask1 = mdh.aulEvalInfoMask(:,1);
mask.MDH_ACQEND             = min(bitand(evalInfoMask1, 2^0), 1);
mask.MDH_RTFEEDBACK         = min(bitand(evalInfoMask1, 2^1), 1);
mask.MDH_HPFEEDBACK         = min(bitand(evalInfoMask1, 2^2), 1);
mask.MDH_SYNCDATA           = min(bitand(evalInfoMask1, 2^5), 1);
mask.MDH_RAWDATACORRECTION  = min(bitand(evalInfoMask1, 2^10),1);
mask.MDH_REFPHASESTABSCAN   = min(bitand(evalInfoMask1, 2^14),1);
mask.MDH_PHASESTABSCAN      = min(bitand(evalInfoMask1, 2^15),1);
mask.MDH_SIGNREV            = min(bitand(evalInfoMask1, 2^17),1);
mask.MDH_PHASCOR            = min(bitand(evalInfoMask1, 2^21),1);
mask.MDH_PATREFSCAN         = min(bitand(evalInfoMask1, 2^22),1);
mask.MDH_PATREFANDIMASCAN   = min(bitand(evalInfoMask1, 2^23),1);
mask.MDH_REFLECT            = min(bitand(evalInfoMask1, 2^24),1);
mask.MDH_NOISEADJSCAN       = min(bitand(evalInfoMask1, 2^25),1);
mask.MDH_VOP                = min(bitand(mdh.aulEvalInfoMask(2), 2^(53-32)),1); % was 0 in VD

mask.MDH_IMASCAN            = ones( Nmeas, 1, 'uint32' );

noImaScan = (   mask.MDH_ACQEND             | mask.MDH_RTFEEDBACK   | mask.MDH_HPFEEDBACK       ...
              | mask.MDH_PHASCOR            | mask.MDH_NOISEADJSCAN | mask.MDH_PHASESTABSCAN    ...
              | mask.MDH_REFPHASESTABSCAN   | mask.MDH_SYNCDATA                                 ... 
              | (mask.MDH_PATREFSCAN & ~mask.MDH_PATREFANDIMASCAN) );

mask.MDH_IMASCAN( noImaScan ) = 0;

end % of evalMDH()
