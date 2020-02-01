close all
clear

cd('E:\')

files = ls('*cpt_mixed*');

load(files(1,:), 'paramests_ce_sample1', 'paramests_ce_sample2', 'pred_paramests_ce_sample1')

paramests_sample1 = paramests_ce_sample1;
paramests_sample2 = paramests_ce_sample2;
paramests_sample1_pred = pred_paramests_ce_sample1;

for i = 2:size(files, 1)
load(files(i,:), 'paramests_ce_sample1', 'paramests_ce_sample2', 'pred_paramests_ce_sample1')

paramests_sample1(:, end+1:end+size(paramests_ce_sample1, 2), :) = paramests_ce_sample1;
paramests_sample2(:, end+1:end+size(paramests_ce_sample2, 2), :) = paramests_ce_sample2;
paramests_sample1_pred(:, end+1:end+size(pred_paramests_ce_sample1, 2), :) = pred_paramests_ce_sample1;
end




cell2csv('cpt_mixed_alphas_halves_1.csv', num2cell([(1:size(paramests_ce_sample1,3)); squeeze(paramests_ce_sample1(1,:,:)); squeeze(paramests_ce_sample2(1,:,:)); squeeze(pred_paramests_ce_sample1(1,:,:)); ]), ',')
cell2csv('cpt_mixed_lambda_halves_1.csv', num2cell([(1:size(paramests_ce_sample1,3)); squeeze(paramests_ce_sample1(3,:,:)); squeeze(paramests_ce_sample2(3,:,:)); squeeze(pred_paramests_ce_sample1(3,:,:)); ]), ',')



