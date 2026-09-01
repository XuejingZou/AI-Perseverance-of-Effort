clc; clear; close all;
rng('default')
T = readtable('C:\Users\86157\Desktop\AI-Perseverance of Effort\\Exp1\Data\Exp1.csv');
%% Non-response Bias test
subnum = round(height(T)*0.25);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
[p1, obs1] = perm_chi_multi({T.subj_AI(1:subnum),T.subj_AI(height(T)-subnum+1:end)});
% p1=0.3880, obs1=5.4578
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
[p2,obs2] = perm_chi_multi({T.subj_AI,T.subj_AI(~isnan(T.AI_meantime))});
% p2=0.5531, obs2=4.0157
%% Correlation Heatmap 1
var_name = {'Ln7', 'Ln30','Ln90','Lngm','persistence', 'interest', 'grit'}; 
data_sub = T{:,var_name};

[r_pearson, p_pearson] = corr(data_sub, 'Rows', 'pairwise');
n = size(r_pearson,1);

cmap = redblue(256);
% Adam Auton (2026). Red Blue Colormap (https://ww2.mathworks.cn/matlabcentral/fileexchange/25536-red-blue-colormap), MATLAB Central File Exchange.
RGB = ones(n, n, 3);
for i = 1:n
    for j = 1:n
        if i <= j
            continue;
        else
            if p_pearson(i,j) < 0.05
                idx = round((r_pearson(i,j) + 1) / 2 * (size(cmap,1) - 1)) + 1;
                RGB(i,j,:) = cmap(idx, :);
            else
                RGB(i,j,:) = [0.8, 0.8, 0.8];
            end
        end
    end
end

figure('Units', 'centimeters', 'Position', [5, 5, 14, 14]);  

imagesc(1:n, 1:n, RGB);
axis square; 

ax = gca;
ax.FontSize = 9;
ax.FontWeight = 'bold';
ax.XTick = 1:n;
ax.XTickLabel = var_name;
ax.YTick = 1:n;
ax.YTickLabel = var_name;
ax.TickLabelInterpreter = 'none';  
ax.XTickLabelRotation = 45;       
ax.YDir = 'reverse';              
ax.Box = 'off';                   

ax.Position = [0.18, 0.2, 0.65, 0.65]; 

hold on;
for i = 1:n
    for j = 1:n
        if i > j
            bg = squeeze(RGB(i,j,:))';  
            brightness = 0.299*bg(1) + 0.587*bg(2) + 0.114*bg(3); 
            if brightness < 0.5
                text_color = 'w';
            else
                text_color = 'k';
            end
            text(j, i, sprintf('%.2f', r_pearson(i,j)), ...
                'HorizontalAlignment', 'center', ...
                'VerticalAlignment', 'middle', ...
                'FontSize', 9, ...
                'FontWeight', 'bold', ...        
                'Color', text_color, ...
                'FontWeight', 'bold');     
        end
    end
end
hold off;

colormap(ax, redblue(256));
cb = colorbar;
cb.FontSize = 9;            
cb.Label.String = '';          
caxis([-1, 1]);

print(gcf, 'C:\Users\86157\Desktop\Correlation_heatmap.tiff', '-dtiff', '-r300');

%% Frequency bar chart (subjective)
software_subj = {'Kimi', 'Doubao', 'Deepseek', 'ChatGPT', 'Ernie', 'Qwen', 'Skywork', 'Spark', 'Yuanbao', 'Miyu','Other'};
fre_subj = [sum(T.kimi), sum(T.doubao),sum(T.deepSeek),sum(T.chatgpt),sum(T.ernie),...
    sum(T.qwen),sum(T.skywork),sum(T.spark),sum(T.yuanbao),sum(T.miyu),sum(T.other)];
[users_subj, idx] = sort(fre_subj, 'ascend');
sorted_subj = software_subj(idx);
color_subj = [231 47 51]/255;  

figure('Units', 'centimeters', 'Position', [5, 5, 14, 14]); 
hold on;
barh(1:length(users_subj), users_subj, ...
    'FaceColor', color_subj, ...
    'EdgeColor', 'none', ...
    'BarWidth', 0.7);   
for i = 1:length(users_subj)
    text(users_subj(i) + 1, i, num2str(users_subj(i)), ...
        'VerticalAlignment', 'middle', ...
        'HorizontalAlignment', 'left', ...
        'FontName', 'Arial', ...
        'FontSize', 9, ...
        'FontWeight', 'bold', ...     
        'Color', [0.2, 0.2, 0.2]);
end

ax = gca;
axis square; 
set(ax, ...
    'Box', 'off', ...
    'TickDir', 'out', ...
    'TickLength', [0.015, 0.015], ...
    'XMinorTick', 'off', ...
    'YMinorTick', 'off', ...
    'XColor', [0.1, 0.1, 0.1], ...
    'YColor', [0.1, 0.1, 0.1], ...
    'FontName', 'Arial', ...
    'FontSize', 9, ...
    'FontWeight', 'bold', ...            
    'LineWidth', 1.2);

yticks(1:length(sorted_subj));
yticklabels(sorted_subj);
ylim([0.5, length(sorted_subj)+0.5]); 

ax.Position(1) = ax.Position(1) + 0.05;
ax.Position(3) = ax.Position(3) - 0.05;
ax.Position(2) = ax.Position(2) + 0.05;  
ax.Position(4) = ax.Position(4) - 0.05;

xlabel('Frequency(subjective)', 'FontName', 'Arial', 'FontSize', 9); 
ylabel('AI APP', 'FontName', 'Arial', 'FontSize', 9);  
xlim([0, max(users_subj)*1.12]);

print(gcf, 'C:\Users\86157\Desktop\fre_zhuguan.tiff', '-dtiff', '-r300');

%% Frequency bar chart (objective)
software_obj = {'Deepseek', 'Doubao', 'Quark', 'Ernie', 'Kimi','Yuanbao','Wenxiaoyuan',...
    'Qwen', 'Souti','Zuoyebang','Keling','Breeno','Smartscreen','ChatGPT','Yoyo','Uai',...
    'Kuaidui','Bulelm','Xiaoyuan','Spark', 'Chatglm','Nano','Jovi','Xiaoai','Jimeng',...
    'Huoying','Wenxiaobai'};
fre_obj = [sum(~isnan(T.t_deepseek)),sum(~isnan(T.t_doubao)),sum(~isnan(T.t_quark)),...
    sum(~isnan(T.t_ernie)),sum(~isnan(T.t_kimi)),sum(~isnan(T.t_yuanbao)),...
    sum(~isnan(T.t_wenxiaoyan)),sum(~isnan(T.t_qwen)),sum(~isnan(T.t_souti)),...
    sum(~isnan(T.t_zuoyebang)),sum(~isnan(T.t_keling)),sum(~isnan(T.t_breeno)),...
    sum(~isnan(T.t_smartscreen)),sum(~isnan(T.t_chatgpt)),sum(~isnan(T.t_yoyo)),...
    sum(~isnan(T.t_uai)),sum(~isnan(T.t_kuaidui)),sum(~isnan(T.t_bulelm)),...
    sum(~isnan(T.t_xiaoyuan)),sum(~isnan(T.t_spark)),sum(~isnan(T.t_chatglm)),...
    sum(~isnan(T.t_nano)),sum(~isnan(T.t_jovi)),sum(~isnan(T.t_xiaoai)),...
    sum(~isnan(T.t_jimeng)),sum(~isnan(T.t_huoxing)),sum(~isnan(T.t_wenxiaobai))];

[users_obj, idx] = sort(fre_obj, 'ascend');  
users_obj = users_obj(end-10:end);
sorted_obj = software_obj(idx(end-10:end));

color_obj = [50 180 213]/255;  

figure('Units', 'centimeters', 'Position', [5, 5, 14, 14]); 
hold on;
barh(1:length(users_obj), users_obj, ...
    'FaceColor', color_obj, ...
    'EdgeColor', 'none', ...
    'BarWidth', 0.7);   
for i = 1:length(users_obj)
    text(users_obj(i) + 1, i, num2str(users_obj(i)), ...
        'VerticalAlignment', 'middle', ...
        'HorizontalAlignment', 'left', ...
        'FontName', 'Arial', ...
        'FontSize', 9, ...
        'FontWeight', 'bold', ...     
        'Color', [0.2, 0.2, 0.2]);
end

ax = gca;
axis square; 
set(ax, ...
    'Box', 'off', ...
    'TickDir', 'out', ...
    'TickLength', [0.015, 0.015], ...
    'XMinorTick', 'off', ...
    'YMinorTick', 'off', ...
    'XColor', [0.1, 0.1, 0.1], ...
    'YColor', [0.1, 0.1, 0.1], ...
    'FontName', 'Arial', ...
    'FontSize', 9, ...
    'FontWeight', 'bold', ...            
    'LineWidth', 1.2);

yticks(1:length(sorted_obj));
yticklabels(sorted_obj);
ylim([0.5, length(sorted_obj)+0.5]); 

ax.Position(1) = ax.Position(1) + 0.05;
ax.Position(3) = ax.Position(3) - 0.05;
ax.Position(2) = ax.Position(2) + 0.05;  
ax.Position(4) = ax.Position(4) - 0.05;

xlabel('Frequency(objective)', 'FontName', 'Arial', 'FontSize', 9); 
ylabel('AI APP', 'FontName', 'Arial', 'FontSize', 9);  
xlim([0, max(users_obj)*1.12]);

print(gcf, 'C:\Users\86157\Desktop\fre_keguan.tiff', '-dtiff', '-r300');
%% Correlation Heatmap 2
var_name_2 = {'Lndeepseek', 'LnAI','Ln7','Ln30','Ln90','Lngm'}; 
data_2 = T{:,var_name_2};

[r2, p_2] = corr(data_2, 'Rows', 'pairwise');
n = size(r2,1);

cmap = redblue(256);
RGB = ones(n, n, 3);
for i = 1:n
    for j = 1:n
        if i <= j
            continue;
        else
            if p_2(i,j) < 0.05
                idx = round((r2(i,j) + 1) / 2 * (size(cmap,1) - 1)) + 1;
                RGB(i,j,:) = cmap(idx, :);
            else
                RGB(i,j,:) = [0.8, 0.8, 0.8];
            end
        end
    end
end

figure('Units', 'centimeters', 'Position', [5, 5, 14, 14]);  

imagesc(1:n, 1:n, RGB);
axis square; 

ax = gca;
ax.FontSize = 9;
ax.FontWeight = 'bold';
ax.XTick = 1:n;
ax.XTickLabel = var_name_2;
ax.YTick = 1:n;
ax.YTickLabel = var_name_2;
ax.TickLabelInterpreter = 'none';  
ax.XTickLabelRotation = 45;       
ax.YDir = 'reverse';              
ax.Box = 'off';                   

ax.Position = [0.18, 0.2, 0.65, 0.65]; 

hold on;
for i = 1:n
    for j = 1:n
        if i > j
            bg = squeeze(RGB(i,j,:))';  
            brightness = 0.299*bg(1) + 0.587*bg(2) + 0.114*bg(3); 
            if brightness < 0.5
                text_color = 'w';
            else
                text_color = 'k';
            end
            text(j, i, sprintf('%.2f', r2(i,j)), ...
                'HorizontalAlignment', 'center', ...
                'VerticalAlignment', 'middle', ...
                'FontSize', 9, ...
                'FontWeight', 'bold', ...        
                'Color', text_color, ...
                'FontWeight', 'bold');     
        end
    end
end
hold off;
colormap(ax, redblue(256));
cb = colorbar;
cb.FontSize = 9;            
cb.Label.String = '';          
caxis([-1, 1]);

print(gcf, 'C:\Users\86157\Desktop\Correlation_heatmap2.tiff', '-dtiff', '-r300');

%% Hierarchical Regression 1
block1 = {'gender'};
block2 = {'edulevel'};
block3 = {'hometown'};
block4 = {'income'};
block5 = {'subj_AI'};
block6 = {'LnAI'};
allBlocks = {block1, block2, block3, block4, block5, block6};

responseVars = {'Ln7','Ln30','Ln90' 'Lngm'};
results = struct();  

for rv = 1:length(responseVars)
    responseVar = responseVars{rv};
    fprintf('\n========== %s ==========\n', responseVar);
    
    fittedModels = {};
    layerLabels = [];
    cumVars = {};
    
    for layer = 1:length(allBlocks)
        currentBlock = allBlocks{layer};
        if isempty(currentBlock)
            continue;
        end

        cumVars = [cumVars, currentBlock];
        formulaStr = [responseVar ' ~ ' strjoin(cumVars, ' + ')];
        mdl = fitlm(T, formulaStr);
        fittedModels{end+1} = mdl;
        layerLabels(end+1) = layer;
    end
    
    numModels = length(fittedModels);
 
    R2 = cellfun(@(m) m.Rsquared.Ordinary, fittedModels);
    adjR2 = cellfun(@(m) m.Rsquared.Adjusted, fittedModels);

    deltaR2 = NaN(numModels,1);
    F_change = NaN(numModels,1);
    p_change = NaN(numModels,1);
    if numModels >= 2
        for i = 2:numModels
            deltaR2(i) = R2(i) - R2(i-1);
            df_num = fittedModels{i}.NumCoefficients - fittedModels{i-1}.NumCoefficients;
            df_den = fittedModels{i}.DFE;
            if df_num > 0 && df_den > 0 && deltaR2(i) > 0
                F_change(i) = (deltaR2(i) / df_num) / ((1 - R2(i)) / df_den);
                p_change(i) = 1 - fcdf(F_change(i), df_num, df_den);
            else
                F_change(i) = NaN;
                p_change(i) = NaN;
            end
        end
    end
    
    fprintf('layer\tR²\t\tmoR²\tΔR²\t\tF_change\tp\n');
    for i = 1:numModels
        if i == 1
            fprintf('%d\t%.4f\t\t%.4f\t--\t\t--\t\t--\n', layerLabels(i), R2(i), adjR2(i));
        else
            fprintf('%d\t%.4f\t\t%.4f\t%.4f\t%.4f\t\t%.4f\n', ...
                layerLabels(i), R2(i), adjR2(i), deltaR2(i), F_change(i), p_change(i));
        end
    end
    
    disp('Final regression model coefficients:');
    disp(fittedModels{end}.Coefficients);
    
    results.(responseVar).R2 = R2;
    results.(responseVar).adjR2 = adjR2;
    results.(responseVar).deltaR2 = deltaR2;
    results.(responseVar).F_change = F_change;
    results.(responseVar).p_change = p_change;
    results.(responseVar).layerLabels = layerLabels;
    results.(responseVar).finalModel = fittedModels{end};
    
end

%% Hierarchical Regression 2
block2_1 = {'gender'};
block2_2 = {'edulevel'};
block2_3 = {'hometown'};
block2_4 = {'income'};
block2_5 = {'subj_AI'};
block2_6 = {'Lndeepseek'};
allBlocks2 = {block2_1, block2_2, block2_3, block2_4, block2_5, block2_6};

responseVars2 = {'Ln7','Ln30','Ln90' 'Lngm'};
results2 = struct();  

for rv2 = 1:length(responseVars2)
    responseVar2 = responseVars2{rv2};
    fprintf('\n========== %s ==========\n', responseVar2);
    
    fittedModels2 = {};
    layerLabels2 = [];
    cumVars2 = {};
    
    for layer2 = 1:length(allBlocks2)
        currentBlock2 = allBlocks2{layer2};
        if isempty(currentBlock2)
            continue;
        end

        cumVars2 = [cumVars2, currentBlock2];
        formulaStr2 = [responseVar2 ' ~ ' strjoin(cumVars2, ' + ')];
        mdl2 = fitlm(T, formulaStr2);
        fittedModels2{end+1} = mdl2;
        layerLabels2(end+1) = layer2;
    end
    
    numModels2 = length(fittedModels2);
 
    R2_2 = cellfun(@(m) m.Rsquared.Ordinary, fittedModels2);
    adjR2_2 = cellfun(@(m) m.Rsquared.Adjusted, fittedModels2);

    deltaR2_2 = NaN(numModels2,1);
    F_change2 = NaN(numModels2,1);
    p_change2 = NaN(numModels2,1);
    if numModels2 >= 2
        for i = 2:numModels2
            deltaR2_2(i) = R2_2(i) - R2_2(i-1);
            df_num2 = fittedModels2{i}.NumCoefficients - fittedModels2{i-1}.NumCoefficients;
            df_den2 = fittedModels2{i}.DFE;
            if df_num2 > 0 && df_den2 > 0 && deltaR2_2(i) > 0
                F_change2(i) = (deltaR2_2(i) / df_num2) / ((1 - R2_2(i)) / df_den2);
                p_change2(i) = 1 - fcdf(F_change2(i), df_num2, df_den2);
            else
                F_change2(i) = NaN;
                p_change2(i) = NaN;
            end
        end
    end
    
    fprintf('layer\tR²\t\tmoR²\tΔR²\t\tF_change\tp\n');
    for i = 1:numModels2
        if i == 1
            fprintf('%d\t%.4f\t\t%.4f\t--\t\t--\t\t--\n', layerLabels2(i), R2_2(i), adjR2_2(i));
        else
            fprintf('%d\t%.4f\t\t%.4f\t%.4f\t%.4f\t\t%.4f\n', ...
                layerLabels2(i), R2_2(i), adjR2_2(i), deltaR2_2(i), F_change2(i), p_change2(i));
        end
    end
    
    disp('Final regression model coefficients:');
    disp(fittedModels2{end}.Coefficients);
    
    results2.(responseVar2).R2 = R2_2;
    results2.(responseVar2).adjR2 = adjR2_2;
    results2.(responseVar2).deltaR2 = deltaR2_2;
    results2.(responseVar2).F_change = F_change2;
    results2.(responseVar2).p_change = p_change2;
    results2.(responseVar2).layerLabels = layerLabels2;
    results2.(responseVar2).finalModel = fittedModels2{end};
    
end