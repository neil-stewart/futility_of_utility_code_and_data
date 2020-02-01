function fit = accept_reject_CE(gain, loss, response, params, certainpay)
% params 1 = utility weighting
% params 2 = sensitivity
% params 3 = loss aversion 
if nargin < 5
    ucertain = 0;
    certainpay = 0;
%     disp('no certain input received. Assuming zero outcome.')
%     1
else
    ucertain = certainpay.^params(1);
%     2
end
ugamble = 0.5.*(gain.^params(1)) - 0.5.*params(3).*(abs(loss).^params(1));


gamble_ce = NaN(size(ugamble));
gamble_ce(ugamble>=0) = (abs((ugamble(ugamble>=0))).^(1./params(1))).*sign(ugamble(ugamble>=0));
gamble_ce(ugamble<0) = (abs((ugamble(ugamble<0))./params(3)).^(1./params(1))).*sign(ugamble(ugamble<0));

preds = 1./(1+exp(-((gamble_ce - certainpay).*params(2))));

fit = nansum(log(preds(response == 1))) + nansum(log(1-preds(response == 0)));

fit = -fit;


% cptvals = (ugamble-ucertain);
% gamble_ce = NaN(size(ugamble));
% gamble_ce(cptvals>=0) = (abs((cptvals(cptvals>=0))).^(1./params(1))).*sign(cptvals(cptvals>=0));
% gamble_ce(cptvals<0) = (abs((cptvals(cptvals<0))./params(3)).^(1./params(1))).*sign(cptvals(cptvals<0));
