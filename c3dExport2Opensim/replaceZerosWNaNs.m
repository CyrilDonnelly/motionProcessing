function structData = replaceZerosWNaNs(structData)
%% replaceZerosWNaNs()
%    Replaces zero values of marker data with NaN's

mkrNames = fieldnames(structData.marker_data.Markers);
nMkrs    = length(mkrNames);

for i = 1 : nMkrs
    % Find when the rows are zero
    zeroFrames = find(round(structData.marker_data.Markers.(mkrNames{i})(:,1)) == NaN);
    % For those rows, replace with nan's
    structData.marker_data.Markers.(mkrNames{i})(zeroFrames,:) = 0;
end






end