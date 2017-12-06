function [idxs] = getIdx(data)

old_names = data.Mouse_Name;
names = unique(old_names, 'stable');
idxs = zeros(size(names, 1), 1);
trialTypes = data.Trial_Type;
idxT = 1;

for i=1:size(names, 1)
    while (~strcmp(trialTypes{idxT}, 'free whisking') || ~strcmp(old_names{idxT}, names{i}))
        idxT = idxT + 1;
    end
    idxs(i) = idxT;
end

% 38 needs to be add for cell 2 and trial 4 tk479
idxs = [idxs; 38];

end

