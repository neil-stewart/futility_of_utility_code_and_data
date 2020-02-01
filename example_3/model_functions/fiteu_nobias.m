function logl = fiteu_nobias(payoutleft, probleft, payoutright, probright, choice, params)

% bias = params(1);
alpha = params(1);
gamma =params(2);

leftutility = sum((payoutleft.^alpha).*probleft, 2);
rightutility = sum((payoutright.^alpha).*probright, 2);

leftutility = leftutility.^(1./alpha);
rightutility = rightutility.^(1./alpha);

preds = 1./(1 + exp(-(leftutility - rightutility).*gamma));
logl = -(sum(log(preds(choice == 1))) + sum(log(1-preds(choice == 0))));
% logl = -(sum(log(preds(choice == 0))) + sum(log(1-preds(choice == 1))));

% choiceutil = (bias + leftutility.^gamma)./(leftutility.^gamma + rightutility.^gamma);

% logl = -sum(log(abs(choice - choiceutil)));

% logl = -(sum(log(choiceutil(choice == 1))) + sum(log(1-choiceutil(choice == 0))));




