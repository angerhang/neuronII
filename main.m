% load('data.mat');

indices = getIdx(data);
AP_rates = zeros(size(indices));
result = cell();
result{1} = cell();

for i = 1:length(indices)
    membrane_potential = data.Trial_MembranePotential{indices(i)};
    AP_rates(i) = AP_firing_rates(membrane_potential, -30);
    result{1}{i} = data.Mouse_Name{indices(i)};
end

result{2} = AP_rates';