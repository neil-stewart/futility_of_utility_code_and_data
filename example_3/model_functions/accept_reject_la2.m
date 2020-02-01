function fit = accept_reject_la(gain, loss, response, params)

udiff = 0.5.*gain.^params(1) - 0.5.*params(2).*loss.^params(1);

preds = 1./(1+exp(-(udiff.*params(3))));

fit = sum(log(preds(response == 1))) + sum(log(1-preds(response == 0)));

fit = -fit;