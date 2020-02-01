close all
clear all

load glockner_data_2012_new


% exclude = (sum([leftpay, rightpay] <0, 2)>0);

dominated = false(size(repetition));
dominated(min(leftpay, [], 2)>=max(rightpay, [], 2) | min(rightpay, [], 2)>=max(leftpay, [], 2)) = 1;
dominated(sum(leftpay.*(leftprob == 1), 2) > max(rightpay, [], 2) | sum(rightpay.*(rightprob == 1), 2) > max(leftpay, [], 2)) = 1;

for p = 1:length(unique(subject))
    numgambles(p) = length(unique(rightpay(subject == p)));
end
excludesubs = find(numgambles<134);

exclude = dominated|ismember(subject, excludesubs);

leftpay(exclude, :) = [];
rightpay(exclude, :) = [];
choices(exclude, :) = [];
leftprob(exclude, :) = [];
rightprob(exclude, :) = [];
gamble_no(exclude, :) = [];
condition(exclude, :) = [];
order(exclude, :) = [];
subject(exclude, :) = [];
time(exclude, :) = [];
repetition(exclude, :) = [];

% options = optimset('MaxIter', 50000, 'MaxFunEvals', 50000, 'TolX', 0.0000001, 'TolFun', 0.0000001, 'Display', 'off');
warning('off', 'optim:fminunc:SwitchingMethod')

gamble_no = gamble_no + 141.*condition;
count  = 0;
allgambles = unique(gamble_no);
for i = 1:length(allgambles)
    count = count+1;
    gamble_no(gamble_no == allgambles(i)) = i;
end

allgambles = [leftpay, leftprob, rightpay, rightprob];
[unique_gambles, ~, unique_gamble_no]=unique(allgambles,'rows','stable');
gamble_no = unique_gamble_no;

windowsize = floor(max(unique_gamble_no)/2);

allsubs = unique(subject);
% for i = 1:max(gamble_no)
%     for p = 1:length(allsubs)
%         gambleno_idx(i,p) = find(gamble_no == i & subject == allsubs(p));
% %         test(i,p) = sort(subject(find(gamble_no == i)));
%     end
% end

itrs = 10000;
nsubs = length(unique(subject));
gambleuse_sample1 = NaN(itrs, windowsize);
gambleuse_sample2 = NaN(itrs, windowsize);
paramests_ce_sample1 = NaN(4, itrs, nsubs);
fits_ce_sample1 = NaN(itrs, nsubs);
exit_ce_sample1 = NaN(itrs, nsubs);
pred_paramests_ce_sample1 = NaN(4, itrs, nsubs);
pred_fits_ce_sample1 = NaN(itrs, nsubs);
pred_exit_ce_sample1 = NaN(itrs, nsubs);
% predchoices = NaN(windowsize, itrs, nsubs);
% output_ce_sample1 = NaN(1, itrs, nsubs);
paramests_ce_sample2 = NaN(4, itrs, nsubs);
fits_ce_sample2 = NaN(itrs, nsubs);
exit_ce_sample2 = NaN(itrs, nsubs);
% output_ce_sample2 = NaN(1, itrs, nsubs);
% output_ce = NaN(itrs);

rng('shuffle')
for sample = 1:itrs
% for sample = 1:3
    disp(['ce_diffs ', num2str(sample)])
    tic
    %     use = maxminpay <= prctile(maxminpay, bins(b)) & maxminpay >= prctile(maxminpay, bins(b)-windowsize);
    %     use = filtervar <= prctile(filtervar, bins(b)) & filtervar >= prctile(filtervar, bins(b)-windowsize);
    sampleord = randperm(max(gamble_no));
    gambleuse_sample1(sample,:) = sampleord(1:windowsize);
    %     sampleususe = reshape(gambleno_idx(gambleuse_sample1(sample,:), :), 1, []);
    
    parfor p = 1:nsubs
        use = find(ismember(gamble_no, gambleuse_sample1(sample,:)) & subject == allsubs(p));
%         use = gambleno_idx(gambleuse_sample1(sample,:), p);
        [paramests_ce1, fits_ce1, exit_ce1, output_ce1]  = fminsearchbnd(@(params) cpt_logl_est(leftpay(use,:), leftprob(use,:), rightpay(use,:), rightprob(use,:), choices(use,:), params), [0.8, 1, 1, 0.01], [-inf -inf -inf 0], [inf inf inf inf]);
        [paramests_ce2, fits_ce2, exit_ce2, output_ce2]  = fminsearchbnd(@(params) cpt_logl_est(leftpay(use,:), leftprob(use,:), rightpay(use,:), rightprob(use,:), choices(use,:), params), paramests_ce1, [-inf -inf -inf 0], [inf inf inf inf]);
        [paramests_ce_sample1(:, sample, p), fits_ce_sample1(sample, p), exit_ce_sample1(sample, p), output_ce_sample1(sample, p)]  = fminsearchbnd(@(params) cpt_logl_est(leftpay(use,:), leftprob(use,:), rightpay(use,:), rightprob(use,:), choices(use,:), params), paramests_ce2, [-inf -inf -inf 0], [inf inf inf inf]);
    end
    
    parfor p = 1:nsubs
        use = find(ismember(gamble_no, gambleuse_sample1(sample,:)) & subject == allsubs(p));
%         use = gambleno_idx(gambleuse_sample1(sample,:), p);
        tempchoices = cpt_stochastic_choices(leftpay(use,:), leftprob(use,:), rightpay(use,:), rightprob(use,:), choices(use,:), paramests_ce_sample1(:, sample, p));
%         predchoices(:, sample, p) = tempchoices;
        [paramests_ce1, fits_ce1, exit_ce1, output_ce1]  = fminsearchbnd(@(params) cpt_logl_est(leftpay(use,:), leftprob(use,:), rightpay(use,:), rightprob(use,:), tempchoices, params), [0.8, 1, 1, 0.01], [-inf -inf -inf 0], [inf inf inf inf]);
        [paramests_ce2, fits_ce2, exit_ce2, output_ce2]  = fminsearchbnd(@(params) cpt_logl_est(leftpay(use,:), leftprob(use,:), rightpay(use,:), rightprob(use,:), tempchoices, params), paramests_ce1, [-inf -inf -inf 0], [inf inf inf inf]);
        [pred_paramests_ce_sample1(:, sample, p), pred_fits_ce_sample1(sample, p), pred_exit_ce_sample1(sample, p), pred_output_ce_sample1(sample, p)]  = fminsearchbnd(@(params) cpt_logl_est(leftpay(use,:), leftprob(use,:), rightpay(use,:), rightprob(use,:), tempchoices, params), paramests_ce2, [-inf -inf -inf 0], [inf inf inf inf]);
    end
    
        gambleuse_sample2(sample,:) = sampleord(end-windowsize+1:end);
    %     use = reshape(gambleno_idx(gambleuse_sample2(sample,:), :), 1, []);
    parfor p = 1:nsubs
        use = find(ismember(gamble_no, gambleuse_sample2(sample,:)) & subject == allsubs(p));
%         use = gambleno_idx(gambleuse_sample2(sample,:), p);
        [paramests_ce1, fits_ce1, exit_ce1, output_ce1]  = fminsearchbnd(@(params) cpt_logl_est(leftpay(use,:), leftprob(use,:), rightpay(use,:), rightprob(use,:), choices(use,:), params), [0.8, 1, 1, 0.01], [-inf -inf -inf 0], [inf inf inf inf]);
        [paramests_ce2, fits_ce2, exit_ce2, output_ce2]  = fminsearchbnd(@(params) cpt_logl_est(leftpay(use,:), leftprob(use,:), rightpay(use,:), rightprob(use,:), choices(use,:), params), paramests_ce1, [-inf -inf -inf 0], [inf inf inf inf]);
        [paramests_ce_sample2(:, sample, p), fits_ce_sample2(sample, p), exit_ce_sample2(sample, p), output_ce_sample2(sample, p)]  = fminsearchbnd(@(params) cpt_logl_est(leftpay(use,:), leftprob(use,:), rightpay(use,:), rightprob(use,:), choices(use,:), params), paramests_ce2, [-inf -inf -inf 0], [inf inf inf inf]);
    end
    toc
end

medparams = nanmedian(paramests_ce_sample1, 3);

try
    save('C:\Users\Tim\Documents\MATLAB\glockner_cpt_mixed_randhalves_fits1a.mat', '-v7.3')
catch
    save('glockner_cpt_mixed_randhalves_fits1a.mat', '-v7.3')
end

% plot(mean_maxmin_pay(exit_ce == 1), paramests_ce(2,exit_ce == 1))
% plot(meanminpay(exit_ce == 1), paramests_ce(2,exit_ce == 1))
% plot(meanriskdiff(exit_ce == 1), paramests_ce(2,exit_ce == 1), '.-')
% plot(meansafediff(exit_ce == 1), paramests_ce(2,exit_ce == 1), '.-')
% title(['Sample selected using ', num2str(windowsize), '% of trials'])
% xlabel('Mean lowest value of safe option')
% ylabel('Alpha')
