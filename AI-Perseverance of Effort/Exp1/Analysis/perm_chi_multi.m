function [p_value, obs_chi2, perm_chi2_dist] = perm_chi_multi(groups, n_perm)
% PERM_CHI_MULTI Permutation chi‑square test for comparing two or more groups of categorical variables.
%   Input arguments:
%       groups    : Cell array, each cell contains one group of categorical data
%                   (numeric vector or cell array of strings).
%                   Example: {exp_gender, ctrl_gender} or {grp1, grp2, grp3}
%       n_perm    : (Optional) Number of permutations, default = 10000.
%   Output arguments:
%       p_value       : p‑value of the permutation test (Monte Carlo simulation).
%       obs_chi2      : Pearson chi‑square statistic from the original contingency table.
%       perm_chi2_dist: Vector of chi‑square statistics obtained from all permutations.
%
%   Examples:
%       % Two‑group gender comparison
%       exp_gender = [ones(1,20), zeros(1,10)];
%       ctrl_gender = [ones(1,10), zeros(1,20)];
%       [p, chi2, dist] = perm_chi_multi({exp_gender, ctrl_gender});
%
%       % Three‑group grade comparison (each group as a numeric vector)
%       grade1 = randi(4, 30, 1);   % freshman
%       grade2 = randi(4, 25, 1);   % sophomore
%       grade3 = randi(4, 28, 1);   % junior
%       [p, ~, ~] = perm_chi_multi({grade1, grade2, grade3});
%
%       % Origin place comparison (cell arrays of strings)
%       origin1 = {'浙江','江苏','河南'};
%       origin2 = {'江苏','安徽','浙江'};
%       origin3 = {'河南','浙江','江苏'};
%       [p, ~, ~] = perm_chi_multi({origin1, origin2, origin3}, 5000);

    if nargin < 2
        n_perm = 10000;
    end
    num_groups = length(groups);
    category_all = [];
    group_labels = [];
    for i = 1:num_groups
        data_i = groups{i};
        if iscell(data_i)
            [~, ~, data_i] = unique(data_i);
        end
        data_i = data_i(:);
        category_all = [category_all; data_i];
        group_labels = [group_labels; i * ones(length(data_i), 1)];
    end

    N = length(category_all);
    group = group_labels;
    [~, obs_chi2, ~] = crosstab(group, category_all);
    perm_chi2_dist = zeros(n_perm, 1);
    for i = 1:n_perm
        shuffled_cat = category_all(randperm(N));
        [~, perm_chi2_dist(i), ~] = crosstab(group, shuffled_cat);
    end
    p_value = (sum(perm_chi2_dist >= obs_chi2) + 1) / (n_perm + 1);
end