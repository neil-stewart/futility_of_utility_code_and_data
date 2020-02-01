function fit = accept_reject_la_order3(gain, loss, response, params, certainpay)
params = params([1 3 2]);
if nargin < 5
    ucertain = 0;
%     disp('no certain input received. Assuming zero outcome.')
%     1
else
    ucertain = certainpay.^params(1);
%     2
end

ugamble = 0.5.*(gain.^params(1)) - 0.5.*params(2).*(abs(loss).^params(1));


preds = 1./(1+exp(-((ugamble-ucertain).*params(3))));

fit = nansum(log(preds(response == 1))) + nansum(log(1-preds(response == 0)));

fit = -fit;