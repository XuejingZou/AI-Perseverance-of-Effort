function [p, d, CI] = permutationTest(x, y, varargin)
% permutationTest - Permutation test for one-sample, paired, independent, or multiple independent groups
%   Usage:
%       [p, d, CI] = permutationTest(x, y)
%       [p, d, CI] = permutationTest(x, y, 'nPerm', 10000)
%       [p, d, CI] = permutationTest(x, y, 'type', 'independent')
%
%   Inputs:
%       x  - vector of observations (numeric)
%       y  - scalar (one-sample) or vector (paired/independent/multiple groups)
%   Optional parameters:
%       'nPerm' - number of permutations (default 10000), also used for bootstrap iterations
%       'type'  - test type, options: 'single', 'paired', 'independent', 'multiple', 'auto'.
%                 If not specified, auto-detection:
%                   - y scalar -> 'single'
%                   - y is an integer vector with at least 3 unique groups -> 'multiple'
%                   - y length differs from x -> 'independent' (two-group independent)
%                   - y length same as x -> 'paired'
%   Outputs:
%       p  - two-tailed permutation p-value (one-tailed for multiple groups, as F-test is naturally one-tailed)
%       d  - effect size: Cohen's d for one-sample/paired/two-independent, eta² for multiple groups
%       CI - 95% confidence interval (bootstrap percentile method)
%            * one-sample: CI of the original mean
%            * paired/independent: CI of the mean difference
%            * multiple: bootstrap CI of eta²

    pInput = inputParser;
    addRequired(pInput, 'x', @(v) isnumeric(v) && isvector(v));
    addRequired(pInput, 'y', @(v) isnumeric(v) && isvector(v));
    addParameter(pInput, 'nPerm', 10000, @(v) isscalar(v) && v>0 && round(v)==v);
    addParameter(pInput, 'type', 'auto', @(v) ismember(v, {'single','paired','independent','multiple','auto'}));
    parse(pInput, x, y, varargin{:});
    
    x = pInput.Results.x(:);
    y = pInput.Results.y(:);
    nPerm = pInput.Results.nPerm;
    type = pInput.Results.type;
    
    n = length(x);
    ny = length(y);
    
    if strcmp(type, 'auto')
        if isscalar(y)
            testType = 'single';
        elseif ny ~= n
            if all(floor(y) == y) && length(unique(y)) >= 3
                testType = 'multiple';
            else
                testType = 'independent';
            end
        else
            testType = 'paired';
        end
    else
        testType = type;
    end
    
    switch testType
        case 'single'
            % One-sample test against a constant
            diffVec = x - y;          
            obsDiff = mean(diffVec);
            N = length(diffVec);
            if N < 2
                error('Effective sample size is insufficient (at least 2 required)');
            end

            signs = 2 * (rand(nPerm, N) > 0.5) - 1;
            permDiffs = (signs * diffVec) / N;

            d = obsDiff / std(diffVec, 0);

            bootMeans = zeros(nPerm, 1);
            for i = 1:nPerm
                idx = randi(N, N, 1);
                bootMeans(i) = mean(x(idx));
            end
            CI = quantile(bootMeans, [0.025, 0.975]);

            p = (sum(abs(permDiffs) >= abs(obsDiff)) + 1) / (nPerm + 1);
            
        case 'paired'
            % Paired two-sample test
            if ny ~= n
                error('Paired test requires x and y to have the same length');
            end
            diffVec = x - y;
            obsDiff = mean(diffVec);
            N = length(diffVec);
            if N < 2
                error('Effective sample size is insufficient (at least 2 required)');
            end
            signs = 2 * (rand(nPerm, N) > 0.5) - 1;
            permDiffs = (signs * diffVec) / N;
            d = obsDiff / std(diffVec, 0);
            bootMeans = zeros(nPerm, 1);
            for i = 1:nPerm
                idx = randi(N, N, 1);
                bootMeans(i) = mean(diffVec(idx));
            end
            CI = quantile(bootMeans, [0.025, 0.975]);
            p = (sum(abs(permDiffs) >= abs(obsDiff)) + 1) / (nPerm + 1);
            
        case 'independent'
            % Two-group independent test
            n1 = n;
            n2 = ny;
            pool = [x; y];
            obsDiff = mean(x) - mean(y);
            
            permDiffs = zeros(nPerm, 1);
            for i = 1:nPerm
                idx = randperm(n1 + n2);
                permX = pool(idx(1:n1));
                permY = pool(idx(n1+1:end));
                permDiffs(i) = mean(permX) - mean(permY);
            end
            
            var1 = var(x, 0);
            var2 = var(y, 0);
            pooledVar = ((n1-1)*var1 + (n2-1)*var2) / (n1+n2-2);
            pooledStd = sqrt(pooledVar);
            d = obsDiff / pooledStd;
            
            bootMeans = zeros(nPerm, 1);
            for i = 1:nPerm
                idx1 = randi(n1, n1, 1);
                idx2 = randi(n2, n2, 1);
                bootMeans(i) = mean(x(idx1)) - mean(y(idx2));
            end
            CI = quantile(bootMeans, [0.025, 0.975]);
            p = (sum(abs(permDiffs) >= abs(obsDiff)) + 1) / (nPerm + 1);
            
        case 'multiple'
            % Multiple independent groups (one-way ANOVA)
            if ny ~= n
                error('Multiple-group test requires x and y to have the same length');
            end

            group = categorical(y);
            g = length(unique(group));   
            if g < 3
                error('Multiple-group test requires at least 3 groups, currently %d groups', g);
            end
            
            % Observed F-statistic and eta²
            [~, ~, stats] = anova1(x, group, 'off');
            F_obs = stats{2,5};
            
            grandMean = mean(x);
            SS_total = sum((x - grandMean).^2);
            groupMeans = splitapply(@mean, x, group);
            groupSizes = splitapply(@length, x, group);
            SS_between = sum(groupSizes .* (groupMeans - grandMean).^2);
            eta2_obs = SS_between / SS_total;
            
            % Permutation distributions
            F_perm = zeros(nPerm, 1);
            eta2_perm = zeros(nPerm, 1);
            for i = 1:nPerm
                shuffledGroup = group(randperm(n));
                [~, ~, statsShuff] = anova1(x, shuffledGroup, 'off');
                F_perm(i) = statsShuff{2,5};

                gMeans = splitapply(@mean, x, shuffledGroup);
                gSizes = splitapply(@length, x, shuffledGroup);
                SS_between_perm = sum(gSizes .* (gMeans - grandMean).^2);
                eta2_perm(i) = SS_between_perm / SS_total;
            end
            
            % p-value (one-tailed for F)
            p = (sum(F_perm >= F_obs) + 1) / (nPerm + 1);
            d = eta2_obs;  
            
            % Bootstrap CI for eta²
            bootEta2 = zeros(nPerm, 1);
            for i = 1:nPerm
                % Resample within each group
                bootX = [];
                bootGroup = [];
                for gi = 1:g
                    idx = randi(groupSizes(gi), groupSizes(gi), 1);
                    bootX = [bootX; x(group == gi)];
                    bootGroup = [bootGroup; repmat(gi, groupSizes(gi), 1)];
                end
                gMeans_boot = splitapply(@mean, bootX, categorical(bootGroup));
                gSizes_boot = splitapply(@length, bootX, categorical(bootGroup));
                grandMean_boot = mean(bootX);
                SS_total_boot = sum((bootX - grandMean_boot).^2);
                SS_between_boot = sum(gSizes_boot .* (gMeans_boot - grandMean_boot).^2);
                bootEta2(i) = SS_between_boot / SS_total_boot;
            end
            CI = quantile(bootEta2, [0.025, 0.975]);
    end
end