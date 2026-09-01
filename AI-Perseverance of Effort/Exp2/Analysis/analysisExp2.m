clc; clear; close all;
rng('default')
T = readtable('C:\Users\86157\Desktop\AI-Perseverance of Effort\\Exp2\Data\Exp2.csv');
AI_age_m = mean(T.age(T.group == 1));
AI_age_sd = std(T.age(T.group == 1));
nonAI_age_m = mean(T.age(T.group == 2));
nonAI_age_sd = std(T.age(T.group == 2));

%% grouo_diff_grit
AI_grit = mean(T.grit(T.group == 1));
nonAI_grit = mean(T.grit(T.group == 2));
[p1, d1, CI1] = permutationTest(T.grit(T.group == 1),T.grit(T.group == 2), 'type', 'independent');
% p1=0.1423, d1=0.2575, CI1=[-0.044015151515152,0.300378787878788]

%% -----1.1----- task1time
rng('default')
AI_task1time_m = mean(T.task1_time(T.group  == 1));
AI_task1time_sd = std(T.task1_time(T.group  == 1));
nonai_task1time_m = mean(T.task1_time(T.group  == 2));
nonai_task1time_sd = std(T.task1_time(T.group  == 2));
[p2, d2, CI2] = permutationTest(T.task1_time(T.group  == 1),T.task1_time(T.group  == 2), 'type', 'independent');
% p2=0.0213, d2=0.4057, CI2=[0.593484848484849,7.660681818181825]

h = daviolinplot({T.task1_time(T.group == 1), T.task1_time(T.group == 2)}, ...
    'colors', [179,205,228; 203,233,195]/255, ...
    'boxcolors', 'w', ...
    'scattercolors', 'same', ...
    'boxspacing', 1, ...
    'boxwidth', 1, ...
    'violinalpha', 0.7, ...
    'violinwidth', 0.7, ...
    'box', 1, ...                  
    'whiskers', 1, ...
    'scatter', 1, ...
    'scattersize', 10, ...
    'scatteralpha', 0.6, ...
    'jitter', 1, ...
    'linkline', 1, ...
    'xtlabels', {'AI‑assisted group','non‑AI‑assisted group'});

bx = h.bx;  
wh = h.wh;
md = h.md;
xdata = get(bx(1,1), 'XData');
boxWidth = max(xdata) - min(xdata);

shift = 0.9 * boxWidth;  
for cond = 1:size(bx,1)
    for grp = 1:size(bx,2)
        if ishandle(bx(cond, grp))
            xdata = get(bx(cond, grp), 'XData');
            set(bx(cond, grp), 'XData', xdata + shift);
        end
    end
end

for cond = 1:size(wh,1)
    for grp = 1:size(wh,2)
        for w = 1:2
            if ishandle(wh(cond, grp, w))
                xdata = get(wh(cond, grp, w), 'XData');
                set(wh(cond, grp, w), 'XData', xdata + shift);
            end
        end
    end
end

for cond = 1:size(md,1)
    for grp = 1:size(md,2)
        if ishandle(md(cond, grp))
            xdata = get(md(cond, grp), 'XData');
            set(md(cond, grp), 'XData', xdata + shift);
        end
    end
end

bx = h.bx;   
sc = h.sc;  
num_conditions = size(bx, 1);
num_groups = size(bx, 2);

for cond = 1:num_conditions
    for grp = 1:num_groups
        if ishandle(bx(cond, grp)) && ishandle(sc(cond, grp))
            x_box = get(bx(cond, grp), 'XData');
            box_center = mean(x_box);
            x_scatter = get(sc(cond, grp), 'XData');
            scatter_center = mean(x_scatter);
            shift = box_center - scatter_center;
            set(sc(cond, grp), 'XData', x_scatter + shift);
        end
    end
end

if isfield(h, 'ot')
    ot = h.ot;
    for cond = 1:num_conditions
        for grp = 1:num_groups
            if ishandle(ot(cond, grp))
                x_ot = get(ot(cond, grp), 'XData');
                x_box = get(bx(cond, grp), 'XData');
                box_center = mean(x_box);
                ot_center = mean(x_ot);
                set(ot(cond, grp), 'XData', x_ot + (box_center - ot_center));
            end
        end
    end
end

ax = gca;
ax.FontName = 'Arial';
ax.FontSize = 11;
ax.Box = 'off';
ax.TickDir = 'out';
ax.YLabel.String = 'task1 time(min)';
ax.FontWeight = 'bold';
ax.LineWidth = 2;
set(h.ds, 'LineWidth', 1.8);

fig = gcf;
fig.Units = 'centimeters';
fig.Position = [5, 5, 12, 8];

x1 = mean(get(h.ds(1,1), 'XData')); 
x2 = mean(get(h.ds(1,2), 'XData'))-0.2;  

y1 = max(get(h.wh(1,1,2), 'YData'));  
y2 = max(get(h.wh(1,2,2), 'YData'));  
yMax = max([y1, y2]);

ylimits = ylim;
yPos = yMax + 0.05 * (ylimits(2) - ylimits(1));

line([x1, x2], [yPos, yPos], 'Color', 'k', 'LineWidth', 1.5);
line([x1, x1], [yPos - 0.02*(ylimits(2)-ylimits(1)), yPos], 'Color', 'k', 'LineWidth', 1);
line([x2, x2], [yPos - 0.02*(ylimits(2)-ylimits(1)), yPos], 'Color', 'k', 'LineWidth', 1);

text(mean([x1, x2]), yPos + 0.05*(ylimits(2)-ylimits(1)), ...
    'p < 0.05', ...
    'HorizontalAlignment', 'center', ...
    'FontSize', 12, ...
    'FontWeight', 'bold', ...
    'Color', 'k');

print(gcf, 'C:\Users\86157\Desktop\violin_task1time.tiff', '-dtiff', '-r300');

%% -----1.2----- task2time
rng('default')
AI_task2time_m = mean(T.task2_time(T.group  == 1));
AI_task2time_sd = std(T.task2_time(T.group  == 1));
nonai_task2time_m = mean(T.task2_time(T.group  == 2));
nonai_task2time_sd = std(T.task2_time(T.group  == 2));
[p3, d3, CI3] = permutationTest(T.task2_time(T.group  == 1),T.task2_time(T.group  == 2), 'type', 'independent');
% p3=0.0020, d3=-0.5440, CI3=[-7.710984848484848,-1.881287878787877]

h = daviolinplot({T.task2_time(T.group  == 1),T.task2_time(T.group  == 2)}, ...
    'colors', [255,217,168; 222,202,229]/255, ...
    'boxcolors', 'w', ...
    'scattercolors', 'same', ...
    'boxspacing', 1, ...
    'boxwidth', 1, ...
    'violinalpha', 0.7, ...
    'violinwidth', 0.7, ...
    'box', 1, ...                  
    'whiskers', 1, ...
    'scatter', 1, ...
    'scattersize', 10, ...
    'scatteralpha', 0.6, ...
    'jitter', 1, ...
    'linkline', 1, ...
    'xtlabels', {'AI‑assisted group','non‑AI‑assisted group'});

bx = h.bx;  
wh = h.wh;
md = h.md;
xdata = get(bx(1,1), 'XData');
boxWidth = max(xdata) - min(xdata);

shift = 0.9 * boxWidth;  
for cond = 1:size(bx,1)
    for grp = 1:size(bx,2)
        if ishandle(bx(cond, grp))
            xdata = get(bx(cond, grp), 'XData');
            set(bx(cond, grp), 'XData', xdata + shift);
        end
    end
end

for cond = 1:size(wh,1)
    for grp = 1:size(wh,2)
        for w = 1:2
            if ishandle(wh(cond, grp, w))
                xdata = get(wh(cond, grp, w), 'XData');
                set(wh(cond, grp, w), 'XData', xdata + shift);
            end
        end
    end
end

for cond = 1:size(md,1)
    for grp = 1:size(md,2)
        if ishandle(md(cond, grp))
            xdata = get(md(cond, grp), 'XData');
            set(md(cond, grp), 'XData', xdata + shift);
        end
    end
end

bx = h.bx;   
sc = h.sc;  
num_conditions = size(bx, 1);
num_groups = size(bx, 2);

for cond = 1:num_conditions
    for grp = 1:num_groups
        if ishandle(bx(cond, grp)) && ishandle(sc(cond, grp))
            x_box = get(bx(cond, grp), 'XData');
            box_center = mean(x_box);
            x_scatter = get(sc(cond, grp), 'XData');
            scatter_center = mean(x_scatter);
            shift = box_center - scatter_center;
            set(sc(cond, grp), 'XData', x_scatter + shift);
        end
    end
end

if isfield(h, 'ot')
    ot = h.ot;
    for cond = 1:num_conditions
        for grp = 1:num_groups
            if ishandle(ot(cond, grp))
                x_ot = get(ot(cond, grp), 'XData');
                x_box = get(bx(cond, grp), 'XData');
                box_center = mean(x_box);
                ot_center = mean(x_ot);
                set(ot(cond, grp), 'XData', x_ot + (box_center - ot_center));
            end
        end
    end
end

ax = gca;
ax.FontName = 'Arial';
ax.FontSize = 11;
ax.Box = 'off';
ax.TickDir = 'out';
ax.YLabel.String = 'task2 time(min)';
ax.FontWeight = 'bold';
ax.LineWidth = 2;
set(h.ds, 'LineWidth', 1.8);

fig = gcf;
fig.Units = 'centimeters';
fig.Position = [5, 5, 12, 8];

x1 = mean(get(h.ds(1,1), 'XData')); 
x2 = mean(get(h.ds(1,2), 'XData'))-0.2;  

y1 = max(get(h.wh(1,1,2), 'YData'));  
y2 = max(get(h.wh(1,2,2), 'YData'));  
yMax = max([y1, y2]);

ylimits = ylim;
yPos = yMax + 0.05 * (ylimits(2) - ylimits(1));

line([x1, x2], [yPos, yPos], 'Color', 'k', 'LineWidth', 1.5);
line([x1, x1], [yPos - 0.02*(ylimits(2)-ylimits(1)), yPos], 'Color', 'k', 'LineWidth', 1);
line([x2, x2], [yPos - 0.02*(ylimits(2)-ylimits(1)), yPos], 'Color', 'k', 'LineWidth', 1);

text(mean([x1, x2]), yPos + 0.05*(ylimits(2)-ylimits(1)), ...
    'p < 0.01', ...
    'HorizontalAlignment', 'center', ...
    'FontSize', 12, ...
    'FontWeight', 'bold', ...
    'Color', 'k');

print(gcf, 'C:\Users\86157\Desktop\violin_task2time.tiff', '-dtiff', '-r300');

%% -----1.3----- AI‑assisted group time
rng('default')
[p4, d4, CI4] = permutationTest(T.task1_time(T.group  == 1),T.task2_time(T.group  == 1));
% p4=9.999000099990002e-05, d4=0.9291, CI4=[7.378939393939394,12.591969696969699]

h = daviolinplot({T.task1_time(T.group == 1), T.task2_time(T.group == 1)}, ...
    'colors', [179,205,228; 255,217,168]/255, ...
    'boxcolors', 'w', ...
    'scattercolors', 'same', ...
    'withinlines', 0, ...    
    'boxspacing', 1, ...
    'boxwidth', 1, ...
    'violinalpha', 0.7, ...
    'violinwidth', 0.7, ...
    'box', 1, ...
    'whiskers', 1, ...
    'scatter', 1, ...
    'scattersize', 10, ...
    'scatteralpha', 0.6, ...
    'jitter', 1, ...
    'linkline', 1, ...
    'xtlabels', {'task1', 'task2'});

bx = h.bx; wh = h.wh; md = h.md;
xdata = get(bx(1,1), 'XData');
boxWidth = max(xdata) - min(xdata);
shift = 0.9 * boxWidth;

for cond = 1:size(bx,1)
    for grp = 1:size(bx,2)
        if ishandle(bx(cond, grp))
            set(bx(cond, grp), 'XData', get(bx(cond, grp), 'XData') + shift);
        end
    end
end

for cond = 1:size(wh,1)
    for grp = 1:size(wh,2)
        for w = 1:2
            if ishandle(wh(cond, grp, w))
                set(wh(cond, grp, w), 'XData', get(wh(cond, grp, w), 'XData') + shift);
            end
        end
    end
end

for cond = 1:size(md,1)
    for grp = 1:size(md,2)
        if ishandle(md(cond, grp))
            set(md(cond, grp), 'XData', get(md(cond, grp), 'XData') + shift);
        end
    end
end

sc = h.sc;
num_conditions = size(bx,1);  
num_groups = size(bx,2);      

for cond = 1:num_conditions
    for grp = 1:num_groups
        if ishandle(bx(cond, grp)) && ishandle(sc(cond, grp))
            x_box = get(bx(cond, grp), 'XData');
            box_center = mean(x_box);
            x_scatter = get(sc(cond, grp), 'XData');
            scatter_center = mean(x_scatter);
            shift_sc = box_center - scatter_center;
            set(sc(cond, grp), 'XData', x_scatter + shift_sc);
        end
    end
end

if isfield(h, 'ot')
    ot = h.ot;
    for cond = 1:num_conditions
        for grp = 1:num_groups
            if ishandle(ot(cond, grp))
                x_ot = get(ot(cond, grp), 'XData');
                x_box = get(bx(cond, grp), 'XData');
                box_center = mean(x_box);
                ot_center = mean(x_ot);
                set(ot(cond, grp), 'XData', x_ot + (box_center - ot_center));
            end
        end
    end
end

x1 = get(sc(1,1), 'XData');  
y1 = get(sc(1,1), 'YData');  
x2 = get(sc(1,2), 'XData');   
y2 = get(sc(1,2), 'YData');   

hold on;
for i = 1:length(x1)
    plot([x1(i), x2(i)], [y1(i), y2(i)], ...
        'Color', [0.5 0.5 0.5 0.4], 'LineWidth', 0.8);
end
hold off;

ax = gca;
ax.FontName = 'Arial';
ax.FontSize = 11;
ax.Box = 'off';
ax.TickDir = 'out';
ax.YLabel.String = 'AI‑assisted group time (min)';
ax.FontWeight = 'bold';
ax.LineWidth = 2;
set(h.ds, 'LineWidth', 1.8);

fig = gcf;
fig.Units = 'centimeters';
fig.Position = [5, 5, 12, 8];

hold off;
x1_pos = mean(get(h.ds(1,1), 'XData'));
x2_pos = mean(get(h.ds(1,2), 'XData'));
y1_vals = get(sc(1,1), 'YData');
y2_vals = get(sc(1,2), 'YData');
y_max = max([max(y1_vals), max(y2_vals)]);
ylimits = ylim;
yPos = y_max + 0.08 * (ylimits(2) - ylimits(1));

line([x1_pos, x2_pos], [yPos, yPos], 'Color', 'k', 'LineWidth', 1.5);
line([x1_pos, x1_pos], [yPos - 0.02*(ylimits(2)-ylimits(1)), yPos], 'Color', 'k', 'LineWidth', 1);
line([x2_pos, x2_pos], [yPos - 0.02*(ylimits(2)-ylimits(1)), yPos], 'Color', 'k', 'LineWidth', 1);
text(mean([x1_pos, x2_pos]), yPos + 0.05*(ylimits(2)-ylimits(1)), ...
    'p < 0.001', 'HorizontalAlignment', 'center', 'FontSize', 12, ...
    'FontWeight', 'bold', 'Color', 'k');
ylim([ylimits(1), yPos + 0.1*(ylimits(2)-ylimits(1))]);

ax = gca;

print(gcf, 'C:\Users\86157\Desktop\violin_AIassistedtime.tiff', '-dtiff', '-r300');

%% -----1.4----- non-AI‑assisted group time
rng('default')
[p5, d5, CI5] = permutationTest(T.task1_time(T.group  == 2),T.task2_time(T.group  == 2));
% p5=0.4607, d5=0.0901, CI5=[-1.525984848484849,3.619166666666667]

h = daviolinplot({T.task1_time(T.group == 2), T.task2_time(T.group == 2)}, ...
    'colors', [203,233,195; 222,202,229]/255, ...
    'boxcolors', 'w', ...
    'scattercolors', 'same', ...
    'withinlines', 0, ...    
    'boxspacing', 1, ...
    'boxwidth', 1, ...
    'violinalpha', 0.7, ...
    'violinwidth', 0.7, ...
    'box', 1, ...
    'whiskers', 1, ...
    'scatter', 1, ...
    'scattersize', 10, ...
    'scatteralpha', 0.6, ...
    'jitter', 1, ...
    'linkline', 1, ...
    'xtlabels', {'task1', 'task2'});

bx = h.bx; wh = h.wh; md = h.md;
xdata = get(bx(1,1), 'XData');
boxWidth = max(xdata) - min(xdata);
shift = 0.9 * boxWidth;

for cond = 1:size(bx,1)
    for grp = 1:size(bx,2)
        if ishandle(bx(cond, grp))
            set(bx(cond, grp), 'XData', get(bx(cond, grp), 'XData') + shift);
        end
    end
end

for cond = 1:size(wh,1)
    for grp = 1:size(wh,2)
        for w = 1:2
            if ishandle(wh(cond, grp, w))
                set(wh(cond, grp, w), 'XData', get(wh(cond, grp, w), 'XData') + shift);
            end
        end
    end
end

for cond = 1:size(md,1)
    for grp = 1:size(md,2)
        if ishandle(md(cond, grp))
            set(md(cond, grp), 'XData', get(md(cond, grp), 'XData') + shift);
        end
    end
end

sc = h.sc;
num_conditions = size(bx,1);  
num_groups = size(bx,2);      

for cond = 1:num_conditions
    for grp = 1:num_groups
        if ishandle(bx(cond, grp)) && ishandle(sc(cond, grp))
            x_box = get(bx(cond, grp), 'XData');
            box_center = mean(x_box);
            x_scatter = get(sc(cond, grp), 'XData');
            scatter_center = mean(x_scatter);
            shift_sc = box_center - scatter_center;
            set(sc(cond, grp), 'XData', x_scatter + shift_sc);
        end
    end
end

if isfield(h, 'ot')
    ot = h.ot;
    for cond = 1:num_conditions
        for grp = 1:num_groups
            if ishandle(ot(cond, grp))
                x_ot = get(ot(cond, grp), 'XData');
                x_box = get(bx(cond, grp), 'XData');
                box_center = mean(x_box);
                ot_center = mean(x_ot);
                set(ot(cond, grp), 'XData', x_ot + (box_center - ot_center));
            end
        end
    end
end

x1 = get(sc(1,1), 'XData');  
y1 = get(sc(1,1), 'YData');  
x2 = get(sc(1,2), 'XData');   
y2 = get(sc(1,2), 'YData');   

hold on;
for i = 1:length(x1)
    plot([x1(i), x2(i)], [y1(i), y2(i)], ...
        'Color', [0.5 0.5 0.5 0.4], 'LineWidth', 0.8);
end
hold off;

ax = gca;
ax.FontName = 'Arial';
ax.FontSize = 11;
ax.Box = 'off';
ax.TickDir = 'out';
ax.YLabel.String = 'non-AI‑assisted group time (min)';
ax.FontWeight = 'bold';
ax.LineWidth = 2;
set(h.ds, 'LineWidth', 1.8);

fig = gcf;
fig.Units = 'centimeters';
fig.Position = [5, 5, 12, 8];

print(gcf, 'C:\Users\86157\Desktop\violin_nonAIassistedtime.tiff', '-dtiff', '-r300');

%% -----1.5----- task_diff_time
rng('default')
AI_difftime_m = mean(T.dif_time(T.group  == 1));
AI_difftime_sd = std(T.dif_time(T.group  == 1));
nonai_difftime_m = mean(T.dif_time(T.group  == 2));
nonai_difftime_sd = std(T.dif_time(T.group  == 2));
[p6, d6, CI6] = permutationTest(T.dif_time(T.group  == 1),T.dif_time(T.group  == 2), 'type', 'independent');
% p6=9.999000099990002e-05, d6=0.8372, CI6=[5.378636363636364,12.553863636363637]

h = daviolinplot({T.dif_time(T.group  == 1),T.dif_time(T.group  == 2)}, ...
    'colors', [101,195,167; 252,142,98]/255, ...
    'boxcolors', 'w', ...
    'scattercolors', 'same', ...
    'boxspacing', 1, ...
    'boxwidth', 1, ...
    'violinalpha', 0.7, ...
    'violinwidth', 0.7, ...
    'box', 1, ...                  
    'whiskers', 1, ...
    'scatter', 1, ...
    'scattersize', 10, ...
    'scatteralpha', 0.6, ...
    'jitter', 1, ...
    'linkline', 1, ...
    'xtlabels', {'AI‑assisted group','non‑AI‑assisted group'});

bx = h.bx;  
wh = h.wh;
md = h.md;
xdata = get(bx(1,1), 'XData');
boxWidth = max(xdata) - min(xdata);

shift = 0.9 * boxWidth;  
for cond = 1:size(bx,1)
    for grp = 1:size(bx,2)
        if ishandle(bx(cond, grp))
            xdata = get(bx(cond, grp), 'XData');
            set(bx(cond, grp), 'XData', xdata + shift);
        end
    end
end

for cond = 1:size(wh,1)
    for grp = 1:size(wh,2)
        for w = 1:2
            if ishandle(wh(cond, grp, w))
                xdata = get(wh(cond, grp, w), 'XData');
                set(wh(cond, grp, w), 'XData', xdata + shift);
            end
        end
    end
end

for cond = 1:size(md,1)
    for grp = 1:size(md,2)
        if ishandle(md(cond, grp))
            xdata = get(md(cond, grp), 'XData');
            set(md(cond, grp), 'XData', xdata + shift);
        end
    end
end

bx = h.bx;   
sc = h.sc;  
num_conditions = size(bx, 1);
num_groups = size(bx, 2);

for cond = 1:num_conditions
    for grp = 1:num_groups
        if ishandle(bx(cond, grp)) && ishandle(sc(cond, grp))
            x_box = get(bx(cond, grp), 'XData');
            box_center = mean(x_box);
            x_scatter = get(sc(cond, grp), 'XData');
            scatter_center = mean(x_scatter);
            shift = box_center - scatter_center;
            set(sc(cond, grp), 'XData', x_scatter + shift);
        end
    end
end

if isfield(h, 'ot')
    ot = h.ot;
    for cond = 1:num_conditions
        for grp = 1:num_groups
            if ishandle(ot(cond, grp))
                x_ot = get(ot(cond, grp), 'XData');
                x_box = get(bx(cond, grp), 'XData');
                box_center = mean(x_box);
                ot_center = mean(x_ot);
                set(ot(cond, grp), 'XData', x_ot + (box_center - ot_center));
            end
        end
    end
end

ax = gca;
ax.FontName = 'Arial';
ax.FontSize = 11;
ax.Box = 'off';
ax.TickDir = 'out';
ax.YLabel.String = 'Task time difference(min)';
ax.FontWeight = 'bold';
ax.LineWidth = 2;
set(h.ds, 'LineWidth', 1.8);

fig = gcf;
fig.Units = 'centimeters';
fig.Position = [5, 5, 12, 8];

x1 = mean(get(h.ds(1,1), 'XData')); 
x2 = mean(get(h.ds(1,2), 'XData'))-0.2;  

y1 = max(get(h.wh(1,1,2), 'YData'));  
y2 = max(get(h.wh(1,2,2), 'YData'));  
yMax = max([y1, y2]);

ylimits = ylim;
yPos = yMax + 0.05 * (ylimits(2) - ylimits(1));

line([x1, x2], [yPos, yPos], 'Color', 'k', 'LineWidth', 1.5);
line([x1, x1], [yPos - 0.02*(ylimits(2)-ylimits(1)), yPos], 'Color', 'k', 'LineWidth', 1);
line([x2, x2], [yPos - 0.02*(ylimits(2)-ylimits(1)), yPos], 'Color', 'k', 'LineWidth', 1);

text(mean([x1, x2]), yPos + 0.05*(ylimits(2)-ylimits(1)), ...
    'p < 0.001', ...
    'HorizontalAlignment', 'center', ...
    'FontSize', 12, ...
    'FontWeight', 'bold', ...
    'Color', 'k');

print(gcf, 'C:\Users\86157\Desktop\violin_task_difftime.tiff', '-dtiff', '-r300');

%% -----2.1----- task1wordcount
rng('default')
[p7, d7, CI7] = permutationTest(T.task1_num(T.group  == 1),T.task1_num(T.group  == 2), 'type', 'independent');
% p7=0.6248, d7=-0.0845, CI7=[-61.560606060606062,35.886363636363683]

h = daviolinplot({T.task1_num(T.group  == 1),T.task1_num(T.group  == 2)}, ...
    'colors', [179,205,228; 203,233,195]/255, ...
    'boxcolors', 'w', ...
    'scattercolors', 'same', ...
    'boxspacing', 1, ...
    'boxwidth', 1, ...
    'violinalpha', 0.7, ...
    'violinwidth', 0.7, ...
    'box', 1, ...                  
    'whiskers', 1, ...
    'scatter', 1, ...
    'scattersize', 10, ...
    'scatteralpha', 0.6, ...
    'jitter', 1, ...
    'linkline', 1, ...
    'xtlabels', {'AI‑assisted group','non‑AI‑assisted group'});

bx = h.bx;  
wh = h.wh;
md = h.md;
xdata = get(bx(1,1), 'XData');
boxWidth = max(xdata) - min(xdata);

shift = 0.9 * boxWidth;  
for cond = 1:size(bx,1)
    for grp = 1:size(bx,2)
        if ishandle(bx(cond, grp))
            xdata = get(bx(cond, grp), 'XData');
            set(bx(cond, grp), 'XData', xdata + shift);
        end
    end
end

for cond = 1:size(wh,1)
    for grp = 1:size(wh,2)
        for w = 1:2
            if ishandle(wh(cond, grp, w))
                xdata = get(wh(cond, grp, w), 'XData');
                set(wh(cond, grp, w), 'XData', xdata + shift);
            end
        end
    end
end

for cond = 1:size(md,1)
    for grp = 1:size(md,2)
        if ishandle(md(cond, grp))
            xdata = get(md(cond, grp), 'XData');
            set(md(cond, grp), 'XData', xdata + shift);
        end
    end
end

bx = h.bx;   
sc = h.sc;  
num_conditions = size(bx, 1);
num_groups = size(bx, 2);

for cond = 1:num_conditions
    for grp = 1:num_groups
        if ishandle(bx(cond, grp)) && ishandle(sc(cond, grp))
            x_box = get(bx(cond, grp), 'XData');
            box_center = mean(x_box);
            x_scatter = get(sc(cond, grp), 'XData');
            scatter_center = mean(x_scatter);
            shift = box_center - scatter_center;
            set(sc(cond, grp), 'XData', x_scatter + shift);
        end
    end
end

if isfield(h, 'ot')
    ot = h.ot;
    for cond = 1:num_conditions
        for grp = 1:num_groups
            if ishandle(ot(cond, grp))
                x_ot = get(ot(cond, grp), 'XData');
                x_box = get(bx(cond, grp), 'XData');
                box_center = mean(x_box);
                ot_center = mean(x_ot);
                set(ot(cond, grp), 'XData', x_ot + (box_center - ot_center));
            end
        end
    end
end

ax = gca;
ax.FontName = 'Arial';
ax.FontSize = 11;
ax.Box = 'off';
ax.TickDir = 'out';
ax.YLabel.String = 'task1 word count';
ax.FontWeight = 'bold';
ax.LineWidth = 2;
set(h.ds, 'LineWidth', 1.8);

fig = gcf;
fig.Units = 'centimeters';
fig.Position = [5, 5, 12, 8];

print(gcf, 'C:\Users\86157\Desktop\violin_task1_wordcount.tiff', '-dtiff', '-r300');

%% -----2.2----- task2wordcount
rng('default')
AI_task2word_m = mean(T.task2_num(T.group  == 1));
AI_task2word_sd = std(T.task2_num(T.group  == 1));
nonai_task2word_m = mean(T.task2_num(T.group  == 2));
nonai_task2word_sd = std(T.task2_num(T.group  == 2));
[p8, d8, CI8] = permutationTest(T.task2_num(T.group  == 1),T.task2_num(T.group  == 2), 'type', 'independent');
% p8=0.0219, d8=-0.3954, CI8=[-1.757727272727273e+02,-15.575757575757564]

h = daviolinplot({T.task2_num(T.group  == 1),T.task2_num(T.group  == 2)}, ...
    'colors', [255,217,168; 222,202,229]/255, ...
    'boxcolors', 'w', ...
    'scattercolors', 'same', ...
    'boxspacing', 1, ...
    'boxwidth', 1, ...
    'violinalpha', 0.7, ...
    'violinwidth', 0.7, ...
    'box', 1, ...                  
    'whiskers', 1, ...
    'scatter', 1, ...
    'scattersize', 10, ...
    'scatteralpha', 0.6, ...
    'jitter', 1, ...
    'linkline', 1, ...
    'xtlabels', {'AI‑assisted group','non‑AI‑assisted group'});

bx = h.bx;  
wh = h.wh;
md = h.md;
xdata = get(bx(1,1), 'XData');
boxWidth = max(xdata) - min(xdata);

shift = 0.9 * boxWidth;  
for cond = 1:size(bx,1)
    for grp = 1:size(bx,2)
        if ishandle(bx(cond, grp))
            xdata = get(bx(cond, grp), 'XData');
            set(bx(cond, grp), 'XData', xdata + shift);
        end
    end
end

for cond = 1:size(wh,1)
    for grp = 1:size(wh,2)
        for w = 1:2
            if ishandle(wh(cond, grp, w))
                xdata = get(wh(cond, grp, w), 'XData');
                set(wh(cond, grp, w), 'XData', xdata + shift);
            end
        end
    end
end

for cond = 1:size(md,1)
    for grp = 1:size(md,2)
        if ishandle(md(cond, grp))
            xdata = get(md(cond, grp), 'XData');
            set(md(cond, grp), 'XData', xdata + shift);
        end
    end
end

bx = h.bx;   
sc = h.sc;  
num_conditions = size(bx, 1);
num_groups = size(bx, 2);

for cond = 1:num_conditions
    for grp = 1:num_groups
        if ishandle(bx(cond, grp)) && ishandle(sc(cond, grp))
            x_box = get(bx(cond, grp), 'XData');
            box_center = mean(x_box);
            x_scatter = get(sc(cond, grp), 'XData');
            scatter_center = mean(x_scatter);
            shift = box_center - scatter_center;
            set(sc(cond, grp), 'XData', x_scatter + shift);
        end
    end
end

if isfield(h, 'ot')
    ot = h.ot;
    for cond = 1:num_conditions
        for grp = 1:num_groups
            if ishandle(ot(cond, grp))
                x_ot = get(ot(cond, grp), 'XData');
                x_box = get(bx(cond, grp), 'XData');
                box_center = mean(x_box);
                ot_center = mean(x_ot);
                set(ot(cond, grp), 'XData', x_ot + (box_center - ot_center));
            end
        end
    end
end

ax = gca;
ax.FontName = 'Arial';
ax.FontSize = 11;
ax.Box = 'off';
ax.TickDir = 'out';
ax.YLabel.String = 'task2 word count';
ax.FontWeight = 'bold';
ax.LineWidth = 2;
set(h.ds, 'LineWidth', 1.8);

fig = gcf;
fig.Units = 'centimeters';
fig.Position = [5, 5, 12, 8];

x1 = mean(get(h.ds(1,1), 'XData')); 
x2 = mean(get(h.ds(1,2), 'XData'))-0.2;  

y1 = max(get(h.wh(1,1,2), 'YData'));  
y2 = max(get(h.wh(1,2,2), 'YData'));  
yMax = max([y1, y2]);

ylimits = ylim;
yPos = yMax + 0.05 * (ylimits(2) - ylimits(1));

line([x1, x2], [yPos, yPos], 'Color', 'k', 'LineWidth', 1.5);
line([x1, x1], [yPos - 0.02*(ylimits(2)-ylimits(1)), yPos], 'Color', 'k', 'LineWidth', 1);
line([x2, x2], [yPos - 0.02*(ylimits(2)-ylimits(1)), yPos], 'Color', 'k', 'LineWidth', 1);

text(mean([x1, x2]), yPos + 0.05*(ylimits(2)-ylimits(1)), ...
    'p < 0.05', ...
    'HorizontalAlignment', 'center', ...
    'FontSize', 12, ...
    'FontWeight', 'bold', ...
    'Color', 'k');

print(gcf, 'C:\Users\86157\Desktop\violin_task2wordcount.tiff', '-dtiff', '-r300');

%% -----2.3----- AI‑assisted group wordcount
rng('default')
AI_task1word_m = mean(T.task1_num(T.group  == 1));
AI_task1word_sd = std(T.task1_num(T.group  == 1));
[p9, d9, CI9] = permutationTest(T.task1_num(T.group  == 1),T.task2_num(T.group  == 1));
% p9=3.999600039996001e-04, d9=0.4655, CI9=[44.560606060606062,1.374924242424242e+02]

h = daviolinplot({T.task1_num(T.group  == 1),T.task2_num(T.group  == 1)}, ...
    'colors', [179,205,228; 255,217,168]/255, ...
    'boxcolors', 'w', ...
    'scattercolors', 'same', ...
    'withinlines', 0, ...    
    'boxspacing', 1, ...
    'boxwidth', 1, ...
    'violinalpha', 0.7, ...
    'violinwidth', 0.7, ...
    'box', 1, ...
    'whiskers', 1, ...
    'scatter', 1, ...
    'scattersize', 10, ...
    'scatteralpha', 0.6, ...
    'jitter', 1, ...
    'linkline', 1, ...
    'xtlabels', {'task1', 'task2'});

bx = h.bx; wh = h.wh; md = h.md;
xdata = get(bx(1,1), 'XData');
boxWidth = max(xdata) - min(xdata);
shift = 0.9 * boxWidth;

for cond = 1:size(bx,1)
    for grp = 1:size(bx,2)
        if ishandle(bx(cond, grp))
            set(bx(cond, grp), 'XData', get(bx(cond, grp), 'XData') + shift);
        end
    end
end

for cond = 1:size(wh,1)
    for grp = 1:size(wh,2)
        for w = 1:2
            if ishandle(wh(cond, grp, w))
                set(wh(cond, grp, w), 'XData', get(wh(cond, grp, w), 'XData') + shift);
            end
        end
    end
end

for cond = 1:size(md,1)
    for grp = 1:size(md,2)
        if ishandle(md(cond, grp))
            set(md(cond, grp), 'XData', get(md(cond, grp), 'XData') + shift);
        end
    end
end

sc = h.sc;
num_conditions = size(bx,1);  
num_groups = size(bx,2);      

for cond = 1:num_conditions
    for grp = 1:num_groups
        if ishandle(bx(cond, grp)) && ishandle(sc(cond, grp))
            x_box = get(bx(cond, grp), 'XData');
            box_center = mean(x_box);
            x_scatter = get(sc(cond, grp), 'XData');
            scatter_center = mean(x_scatter);
            shift_sc = box_center - scatter_center;
            set(sc(cond, grp), 'XData', x_scatter + shift_sc);
        end
    end
end

if isfield(h, 'ot')
    ot = h.ot;
    for cond = 1:num_conditions
        for grp = 1:num_groups
            if ishandle(ot(cond, grp))
                x_ot = get(ot(cond, grp), 'XData');
                x_box = get(bx(cond, grp), 'XData');
                box_center = mean(x_box);
                ot_center = mean(x_ot);
                set(ot(cond, grp), 'XData', x_ot + (box_center - ot_center));
            end
        end
    end
end

x1 = get(sc(1,1), 'XData');  
y1 = get(sc(1,1), 'YData');  
x2 = get(sc(1,2), 'XData');   
y2 = get(sc(1,2), 'YData');   

hold on;
for i = 1:length(x1)
    plot([x1(i), x2(i)], [y1(i), y2(i)], ...
        'Color', [0.5 0.5 0.5 0.4], 'LineWidth', 0.8);
end
hold off;

ax = gca;
ax.FontName = 'Arial';
ax.FontSize = 11;
ax.Box = 'off';
ax.TickDir = 'out';
ax.YLabel.String = 'AI‑assisted group word count';
ax.FontWeight = 'bold';
ax.LineWidth = 2;
set(h.ds, 'LineWidth', 1.8);

fig = gcf;
fig.Units = 'centimeters';
fig.Position = [5, 5, 12, 8];

hold off;
x1_pos = mean(get(h.ds(1,1), 'XData'));
x2_pos = mean(get(h.ds(1,2), 'XData'))-0.2;
y1_vals = get(sc(1,1), 'YData');
y2_vals = get(sc(1,2), 'YData');
y_max = max([max(y1_vals), max(y2_vals)]);
ylimits = ylim;
yPos = y_max + 0.08 * (ylimits(2) - ylimits(1));

line([x1_pos, x2_pos], [yPos, yPos], 'Color', 'k', 'LineWidth', 1.5);
line([x1_pos, x1_pos], [yPos - 0.02*(ylimits(2)-ylimits(1)), yPos], 'Color', 'k', 'LineWidth', 1);
line([x2_pos, x2_pos], [yPos - 0.02*(ylimits(2)-ylimits(1)), yPos], 'Color', 'k', 'LineWidth', 1);
text(mean([x1_pos, x2_pos]), yPos + 0.05*(ylimits(2)-ylimits(1)), ...
    'p < 0.001', 'HorizontalAlignment', 'center', 'FontSize', 12, ...
    'FontWeight', 'bold', 'Color', 'k');
ylim([ylimits(1), yPos + 0.1*(ylimits(2)-ylimits(1))]);

ax = gca;

print(gcf, 'C:\Users\86157\Desktop\violin_AIassistedwordcount.tiff', '-dtiff', '-r300');

%% -----2.4----- non-AI‑assisted group wordcount
rng('default')
[p10, d10, CI10] = permutationTest(T.task1_num(T.group  == 2),T.task2_num(T.group  == 2));
% p10=0.7449, d10=0.0407, CI10=[-47.878787878787875,65.356060606060595]

h = daviolinplot({T.task1_num(T.group  == 2),T.task2_num(T.group  == 2)}, ...
    'colors', [203,233,195; 222,202,229]/255, ...
    'boxcolors', 'w', ...
    'scattercolors', 'same', ...
    'withinlines', 0, ...    
    'boxspacing', 1, ...
    'boxwidth', 1, ...
    'violinalpha', 0.7, ...
    'violinwidth', 0.7, ...
    'box', 1, ...
    'whiskers', 1, ...
    'scatter', 1, ...
    'scattersize', 10, ...
    'scatteralpha', 0.6, ...
    'jitter', 1, ...
    'linkline', 1, ...
    'xtlabels', {'task1', 'task2'});

bx = h.bx; wh = h.wh; md = h.md;
xdata = get(bx(1,1), 'XData');
boxWidth = max(xdata) - min(xdata);
shift = 0.9 * boxWidth;

for cond = 1:size(bx,1)
    for grp = 1:size(bx,2)
        if ishandle(bx(cond, grp))
            set(bx(cond, grp), 'XData', get(bx(cond, grp), 'XData') + shift);
        end
    end
end

for cond = 1:size(wh,1)
    for grp = 1:size(wh,2)
        for w = 1:2
            if ishandle(wh(cond, grp, w))
                set(wh(cond, grp, w), 'XData', get(wh(cond, grp, w), 'XData') + shift);
            end
        end
    end
end

for cond = 1:size(md,1)
    for grp = 1:size(md,2)
        if ishandle(md(cond, grp))
            set(md(cond, grp), 'XData', get(md(cond, grp), 'XData') + shift);
        end
    end
end

sc = h.sc;
num_conditions = size(bx,1);  
num_groups = size(bx,2);      

for cond = 1:num_conditions
    for grp = 1:num_groups
        if ishandle(bx(cond, grp)) && ishandle(sc(cond, grp))
            x_box = get(bx(cond, grp), 'XData');
            box_center = mean(x_box);
            x_scatter = get(sc(cond, grp), 'XData');
            scatter_center = mean(x_scatter);
            shift_sc = box_center - scatter_center;
            set(sc(cond, grp), 'XData', x_scatter + shift_sc);
        end
    end
end

if isfield(h, 'ot')
    ot = h.ot;
    for cond = 1:num_conditions
        for grp = 1:num_groups
            if ishandle(ot(cond, grp))
                x_ot = get(ot(cond, grp), 'XData');
                x_box = get(bx(cond, grp), 'XData');
                box_center = mean(x_box);
                ot_center = mean(x_ot);
                set(ot(cond, grp), 'XData', x_ot + (box_center - ot_center));
            end
        end
    end
end

x1 = get(sc(1,1), 'XData');  
y1 = get(sc(1,1), 'YData');  
x2 = get(sc(1,2), 'XData');   
y2 = get(sc(1,2), 'YData');   

hold on;
for i = 1:length(x1)
    plot([x1(i), x2(i)], [y1(i), y2(i)], ...
        'Color', [0.5 0.5 0.5 0.4], 'LineWidth', 0.8);
end
hold off;

ax = gca;
ax.FontName = 'Arial';
ax.FontSize = 11;
ax.Box = 'off';
ax.TickDir = 'out';
ax.YLabel.String = 'non-AI‑assisted group word count';
ax.FontWeight = 'bold';
ax.LineWidth = 2;
set(h.ds, 'LineWidth', 1.8);

fig = gcf;
fig.Units = 'centimeters';
fig.Position = [5, 5, 12, 8];

print(gcf, 'C:\Users\86157\Desktop\violin_nonAIassistedwordcount.tiff', '-dtiff', '-r300');

%% -----2.5----- task_diff_wordcount
rng('default')
AI_difword_m = mean(T.dif_num(T.group  == 1));
AI_difword_sd = std(T.dif_num(T.group  == 1));
nonai_difword_m = mean(T.dif_num(T.group  == 2));
nonai_difword_sd = std(T.dif_num(T.group  == 2));
[p11, d11, CI11] = permutationTest(T.dif_num(T.group  == 1),T.dif_num(T.group  == 2), 'type', 'independent');
% p11=0.0279, d11=0.3803, CI11=[8.348484848484848,1.559924242424242e+02]

h = daviolinplot({T.dif_num(T.group  == 1),T.dif_num(T.group  == 2)}, ...
    'colors', [101,195,167; 252,142,98]/255, ...
    'boxcolors', 'w', ...
    'scattercolors', 'same', ...
    'boxspacing', 1, ...
    'boxwidth', 1, ...
    'violinalpha', 0.7, ...
    'violinwidth', 0.7, ...
    'box', 1, ...                  
    'whiskers', 1, ...
    'scatter', 1, ...
    'scattersize', 10, ...
    'scatteralpha', 0.6, ...
    'jitter', 1, ...
    'linkline', 1, ...
    'xtlabels', {'AI‑assisted group','non‑AI‑assisted group'});

bx = h.bx;  
wh = h.wh;
md = h.md;
xdata = get(bx(1,1), 'XData');
boxWidth = max(xdata) - min(xdata);

shift = 0.9 * boxWidth;  
for cond = 1:size(bx,1)
    for grp = 1:size(bx,2)
        if ishandle(bx(cond, grp))
            xdata = get(bx(cond, grp), 'XData');
            set(bx(cond, grp), 'XData', xdata + shift);
        end
    end
end

for cond = 1:size(wh,1)
    for grp = 1:size(wh,2)
        for w = 1:2
            if ishandle(wh(cond, grp, w))
                xdata = get(wh(cond, grp, w), 'XData');
                set(wh(cond, grp, w), 'XData', xdata + shift);
            end
        end
    end
end

for cond = 1:size(md,1)
    for grp = 1:size(md,2)
        if ishandle(md(cond, grp))
            xdata = get(md(cond, grp), 'XData');
            set(md(cond, grp), 'XData', xdata + shift);
        end
    end
end

bx = h.bx;   
sc = h.sc;  
num_conditions = size(bx, 1);
num_groups = size(bx, 2);

for cond = 1:num_conditions
    for grp = 1:num_groups
        if ishandle(bx(cond, grp)) && ishandle(sc(cond, grp))
            x_box = get(bx(cond, grp), 'XData');
            box_center = mean(x_box);
            x_scatter = get(sc(cond, grp), 'XData');
            scatter_center = mean(x_scatter);
            shift = box_center - scatter_center;
            set(sc(cond, grp), 'XData', x_scatter + shift);
        end
    end
end

if isfield(h, 'ot')
    ot = h.ot;
    for cond = 1:num_conditions
        for grp = 1:num_groups
            if ishandle(ot(cond, grp))
                x_ot = get(ot(cond, grp), 'XData');
                x_box = get(bx(cond, grp), 'XData');
                box_center = mean(x_box);
                ot_center = mean(x_ot);
                set(ot(cond, grp), 'XData', x_ot + (box_center - ot_center));
            end
        end
    end
end

ax = gca;
ax.FontName = 'Arial';
ax.FontSize = 11;
ax.Box = 'off';
ax.TickDir = 'out';
ax.YLabel.String = 'Task word count difference';
ax.FontWeight = 'bold';
ax.LineWidth = 2;
set(h.ds, 'LineWidth', 1.8);

fig = gcf;
fig.Units = 'centimeters';
fig.Position = [5, 5, 12, 8];

x1 = mean(get(h.ds(1,1), 'XData')); 
x2 = mean(get(h.ds(1,2), 'XData'))-0.2;  

y1 = max(get(h.wh(1,1,2), 'YData'));  
y2 = max(get(h.wh(1,2,2), 'YData'));  
yMax = max([y1, y2]);

ylimits = ylim;
yPos = yMax + 0.05 * (ylimits(2) - ylimits(1));

line([x1, x2], [yPos, yPos], 'Color', 'k', 'LineWidth', 1.5);
line([x1, x1], [yPos - 0.02*(ylimits(2)-ylimits(1)), yPos], 'Color', 'k', 'LineWidth', 1);
line([x2, x2], [yPos - 0.02*(ylimits(2)-ylimits(1)), yPos], 'Color', 'k', 'LineWidth', 1);

text(mean([x1, x2]), yPos + 0.05*(ylimits(2)-ylimits(1)), ...
    'p < 0.05', ...
    'HorizontalAlignment', 'center', ...
    'FontSize', 12, ...
    'FontWeight', 'bold', ...
    'Color', 'k');

print(gcf, 'C:\Users\86157\Desktop\violin_task_diffwordcount.tiff', '-dtiff', '-r300');

