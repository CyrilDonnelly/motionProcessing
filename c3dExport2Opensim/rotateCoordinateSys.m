function [oData] = rotateCoordinateSys(oData,rotation)
% rotateCoordinateSys()
% Rotates xyz data about an axis. Data is assumed to be an nx3 sized array.
% Examples would be the xyz coordinates of a marker or the xyz components
% of a ground reaction force. 
% This code was originally build to rotate lab coorindates that use an
% "Z is up" right handed coordinate system to a "Y is up" right handed 
% coordinate system. This was expanded to be able to rotate any global data
% frame. The rotation matrices represent a CLOCKWISE rotation relative
% to fixed coordinate axes, by an angle of Rot. 
% 
% Input - oData - either a nX3 matrix or a strucutre containing matrix variables 
%                 eg oData.LASI = [nx3]
%         rotation.axis - string denoting which axis the rotation  will be around 
%                   eg rotAxis = 'x'
%         Rot   - The rotation about rotAxis in degrees
%                 eg Rot = 90
%
% Output - nData - structure format containing rotated matrix data
%
% Author: Cyril J Donnelly, James Dunne, Thor Besier.  
    
%%  Determine the coordinate to rotate around   
if ~isstruct(rotation)
    error('variable "rotation" is not a structure. Please view function help to view variable format')
end
    
nRot = length(rotation.axis);


for i = 1 : nRot   
    
    rotAxis = char(rotation.axis(i));
    Rot     = rotation.value(i);
    
    % Create roation matrices according to Rot (degrees)   
    RotAboutX1 = [1,0,0;0,cos(Rot*pi/180),-(sin(Rot*pi/180));0,sin(Rot*pi/180),cos(Rot*pi/180)];
    RotAboutY1 = [cos(Rot*pi/180),0,sin(Rot*pi/180);0,1,0;-(sin(Rot*pi/180)),0,cos(Rot*pi/180)];
    RotAboutZ1 = [cos(Rot*pi/180),-(sin(Rot*pi/180)),0;sin(Rot*pi/180),cos(Rot*pi/180),0;0,0,1];
    % choose which rotation matrix to use based on user input 
    if     strcmpi(rotAxis,'x') 
        rotationMatrix = RotAboutX1;
    elseif strcmpi(rotAxis,'y') 
        rotationMatrix = RotAboutY1;
    elseif strcmpi(rotAxis,'z')
        rotationMatrix = RotAboutZ1;
    end
        
    
%% Rotate nx3 arrays by the rotation matrix  
    if isstruct(oData)
        fields  = fieldnames(oData);
        nFields = length(fields);
        nData = oData;

        for u = 1:nFields
                % assign the strucutre field to data 
                vectorData = oData.(fields{u});
                % Rotate the data
                rotatedData = [rotationMatrix'*vectorData']';
                % assign the rotated data back to field  
                oData.(fields{u}) = rotatedData;  
        end
    elseif ismatrix(oData)
        % Data is a n*3 matrix
        oData = [rotationMatrix'*oData']';

    end
end
