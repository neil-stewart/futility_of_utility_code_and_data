function putil = pwt(prob, weight)
if max(prob)>1
    prob = prob./max(prob(:));
end
% putil = exp(-((-log(prob)).^weight));
% putil = prob.^weight./((prob.^weight + (1-prob).^weight).^(1./weight));
putil = (prob.^weight)./(((prob.^weight) + (1-prob).^weight).^(1./weight));
end
