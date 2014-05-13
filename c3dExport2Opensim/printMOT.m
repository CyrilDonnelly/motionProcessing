function printMOT(structData)
% printMOT() Printes a structure of Mkr Data to TRC format
%   mkrData, 
%   sampleRate,
%   trialName,
%   dataPath

%   Export force data Into OpenSim ready format 
%   Author: J.J. Dunne, Thor Besier, C.J. Donnelly, S. Hamner. 

%% Pre- allocate some arrays and set some index values
nFrames      = length(structData.bodyForce_data(1).F);
nForces      = length(structData.bodyForce_data);
forceArray   = [];
torqueArray  = [];
[pathstr, name, ext] = fileparts(structData.marker_data.Filename);
analogRate   = structData.fp_data.Info(1).frequency;


%% Dump out all the force  Data
    for i = 1:nForces
          length( structData.bodyForce_data(i).F)
          forceArray = [forceArray structData.bodyForce_data(i).F];
          forceArray = [forceArray structData.bodyForce_data(i).P];
          
    end

    for i = 1:nForces
          torqueArray = [torqueArray structData.bodyForce_data(i).M];
    end
% Create Arrays for Frame and Time 
    frameArray  =   [0:nFrames-1]';                % Create frame Number array
    timeArray   =   (frameArray)/analogRate;       % Create time array

% Append to GRF Data
   forceData=[timeArray forceArray torqueArray];
    
%% create the headers for the file   
   Cord = {'x' 'y' 'z'};
   numPrefix = {'' '1_' '2_' '3_' '4_'};
   bodyForceHeader =[];
   bodyTorqueHeader=[];
   
    for i = 1:nForces
        ForceHeader = [];
        PointHeader = [];
        TorqueHeader= [];
        
        for u = 1:3
            forceHeader = [char(numPrefix(i)) 'ground_force_v' char(Cord(u))];
            ForceHeader = [ForceHeader {forceHeader}];
            pointHeader = [char(numPrefix(i)) 'ground_force_p' char(Cord(u))];
            PointHeader = [PointHeader {pointHeader}];
        end
            bodyForceHeader = [bodyForceHeader ForceHeader PointHeader];
        
        for u = 1:3
            torqueHeader= [char(numPrefix(i)) 'ground_torque_' char(Cord(u))];
            TorqueHeader= [TorqueHeader {torqueHeader}];
        end
            bodyTorqueHeader = [bodyTorqueHeader TorqueHeader];
        
    end
       headers = [{'time'} bodyForceHeader bodyTorqueHeader];
       nHeaders = length(headers);
%% Print Data 

% Find the size of the Matrix    
    [m n]            =   size(forceData);    
% Create a Print Path    
    motFileName      = fullfile(pathstr, [name '_grf.mot']);
    fid              = fopen(motFileName,'w');
    
    fprintf('\n      Printing .MOT File              ');
    
    % Print trial header
    fprintf(fid,'name %s\n',name);
    fprintf(fid,'datacolumns %d\n',n);
    fprintf(fid,'datarows %d\n',m);
    fprintf(fid,'range %f %f\n',timeArray(1),timeArray(end));
    fprintf(fid,'endheader\n');
    
        % Print array headers
    fmt1=['%s\t'];
    for i = 1:nHeaders
        fprintf(fid,fmt1,char(headers(i)));
    end
    fprintf(fid,'\n');
    
    % Print data
    fmt3=[repmat(' %2.6g\t',1,9*nForces+1) '\n']; 
    for i   = 1:nFrames
            fprintf(fid,fmt3,forceData(i,:));    % print a row's of Mkr Data
    end
    fclose(fid);
end

