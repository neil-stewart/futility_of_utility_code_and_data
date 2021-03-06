function fit = accept_reject_la_fixedutil(gain, loss, response, params, certainpay)

% params 1 = sensitivity
% params 2 = loss aversion 
params = [1, params];
if nargin < 5
    ucertain = 0;
%     disp('no certain input received. Assuming zero outcome.')
%     1
else
    ucertain = certainpay.^params(1);
%     2
end

ugamble = 0.5.*(gain.^params(1)) - 0.5.*params(3).*(abs(loss).^params(1));

preds = 1./(1+exp(-((ugamble-ucertain).*params(2))));

fit = nansum(log(preds(response == 1))) + nansum(log(1-preds(response == 0)));

fit = -fit;