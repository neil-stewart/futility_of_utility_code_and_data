function [preds, fit] = accept_reject_CE_diagnose(gain, loss, response, params, certainpay)
% params 1 = utility weighting
% params 2 = sensitivity
% params 3 = loss aversion 
if nargin < 5
    ucertain = 0;
%     disp('no certain input received. Assuming zero outcome.')
%     1
else
    ucertain = certainpay.^params(1);
%     2
end

ugamble = 0.5.*(gain.^params(1)) - 0.5.*params(3).*(abs(loss).^params(1));

% gamble_ce = (abs((ugamble-ucertain)).^(1./params(1))).*sign(ugamble - ucertain);
% gamble_ce = (abs((ucertain-ugamble)).^(1./params(1))).*sign(ucertain - ugamble);
% gamble_ce = (abs((ucertain-ugamble)./params(3)).^(1./params(1))).*sign(ucertain - ugamble);
gamble_ce((ugamble-ucertain)>=0) = (abs((ugamble((ugamble-ucertain)>=0)-ucertain((ugamble-ucertain)>=0))).^(1./params(1))).*sign(ugamble((ugamble-ucertain)>=0) - ucertain((ugamble-ucertain)>=0));
gamble_ce((ugamble-ucertain)<0) = (abs((ugamble((ugamble-ucertain)<0)-ucertain((ugamble-ucertain)<0))./params(3)).^(1./params(1))).*sign(ugamble((ugamble-ucertain)<0) - ucertain((ugamble-ucertain)<0));

preds = 1./(1+exp(-((gamble_ce).*params(2))));
% preds = 1./(1 + exp(-(xutil - yutil).*params(6)));
fit = nansum(log(preds(response == 1))) + nansum(log(1-preds(response == 0)));

fit = -fit;