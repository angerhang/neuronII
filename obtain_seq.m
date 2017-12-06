function [selectedTrial] = obtain_seq(data, mouse, n_trial, n_cell)
% data: is the name of data variable
% mouse, n_trial and n_cell are the parameters for a sequence
% return with the trial sequence
    trial = strcmp(data.Mouse_Name, mouse) & data.Cell_Counter == n_cell & data.Trial_Counter == n_trial;
    extractSelectedTrial = data.Trial_MembranePotential(trial);
    selectedTrial = extractSelectedTrial{1,1};
end

