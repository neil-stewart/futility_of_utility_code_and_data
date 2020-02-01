function [logl, preds] = cpt_ce_logl_est(x,p,y,q, choice, params)
% x = [-10, -20, 30; 12 15 40];
% p = [0.1, 0.2, 0.7; 0.8, 0.1, 0.1];
% y = [0, 30, 20; 15, 12, 30];
% q = [0.1, 0.2, 0.7; 0.8, 0.1, 0.1];
% choice = [0 1];
% params = [1, 1, 1, 1, 1];

% params 1 = gain value weight
% params 2 = loss value weight
% params 3 = gain probability weight
% params 4 = loss probability weight
% params 5 = loss aversion
% params 6 = sensitivity
if length(params) == 3
%     params = [params(1), params(1), params(2), params(2), 1, params(3)];
    params = [params(1), params(1), 1, 1, params(2), params(3)];
elseif length(params) == 4
    params = [params(1), params(1), params(2), params(2), params(3) ,params(4)];
elseif length(params) == 5
    params = [params(1), params(2), params(3), params(3), params(4) ,params(5)];
end

for i = 1:size(x,1)
    clear xutils
    if sum(x(i,:)<0)==0
        xgains = x(i,:);
        pgains = p(i,:);
        if length(xgains) == 1
            xutils(1) = (xgains(1).^params(1)).*pwt(pgains(1), params(3));
        else
            [xgains, xord] = sort(xgains, 'descend');
            pgains  = pgains(xord);
            xutils(1) = (xgains(1).^params(1)).*pwt(pgains(1), params(3));
            for k = 2:length(xgains)
                xutils(k) = (xgains(k).^params(1)).*(pwt(sum(pgains(1:k)), params(3)) - pwt(sum(pgains(1:k-1)), params(3)));
            end
        end
        xutil(i) = sum(xutils);
    elseif sum(x(i,:)>0) == 0
        xlosses = x(i,:);
        plosses = p(i,:);
        if length(xlosses) == 1
            xutils(1) = (xlosses(1).^params(2)).*pwt(plosses(1), params(4));
        else
            [xlosses, xord] = sort(xlosses);
            plosses  = plosses(xord);
            xutils(1) = -(abs(xlosses(1)).^params(2)).*pwt(plosses(1), params(4));
            for k = 1:length(xlosses)
                xutils(k) = -(abs(xlosses(k)).^params(2)).*(pwt(sum(plosses(1:k)), params(4)) - pwt(sum(plosses(1:k-1)), params(4)));
            end
        end
        xutil(i) = sum(xutils).*params(5);
    else
        xgains = x(i,x(i,:)>=0);
        pgains = p(i,x(i,:)>=0);
        if length(xgains) == 1
            xutils(1) = (xgains(1).^params(1)).*pwt(pgains(1), params(3));
        else
            [xgains, xord] = sort(xgains, 'descend');
            pgains  = pgains(xord);
            xutils(1) = (xgains(1).^params(1)).*pwt(pgains(1), params(3));
            for k = 2:length(xgains)
                xutils(k) = (xgains(k).^params(1)).*(pwt(sum(pgains(1:k)), params(3)) - pwt(sum(pgains(1:k-1)), params(3)));
            end
        end
        xutil(i) = sum(xutils);
        
        clear xutils;
        xlosses = x(i,x(i,:)<0);
        plosses = p(i,x(i,:)<0);
        if length(xlosses) == 1
            xutils(1) = -(abs(xlosses(1)).^params(2)).*pwt(plosses(1), params(4));
        else
            [xlosses, xord] = sort(xlosses);
            plosses  = plosses(xord);
            xutils(1) = -(abs(xlosses(1)).^params(2)).*pwt(plosses(1), params(4));
            for k = 1:length(xlosses)
                xutils(k) = -(abs(xlosses(k)).^params(2)).*(pwt(sum(plosses(1:k)), params(4)) - pwt(sum(plosses(1:k-1)), params(4)));
            end
        end
        xutil(i) = xutil(i) + sum(xutils).*params(5);
    end
    clear yutils
    if sum(y(i,:)<0)==0
        ygains = y(i,:);
        qgains = q(i,:);
        if length(ygains) == 1
            yutils(1) = (ygains(1).^params(1)).*pwt(qgains(1), params(3));
        else
            [ygains, yord] = sort(ygains, 'descend');
            qgains  = qgains(yord);
            yutils(1) = (ygains(1).^params(1)).*pwt(qgains(1), params(3));
            for k = 2:length(ygains)
                yutils(k) = (ygains(k).^params(1)).*(pwt(sum(qgains(1:k)), params(3)) - pwt(sum(qgains(1:k-1)), params(3)));
            end
        end
        yutil(i) = sum(yutils);
    elseif sum(y(i,:)>0) == 0
        ylosses = y(i,:);
        qlosses = q(i,:);
        if length(ylosses) == 1
            yutils(1) = -(abs(ylosses(1)).^params(2)).*pwt(qlosses(1), params(4));
        else
            [ylosses, yord] = sort(ylosses);
            qlosses  = qlosses(yord);
            yutils(1) = -(abs(ylosses(1)).^params(2)).*pwt(qlosses(1), params(4));
            for k = 1:length(ylosses)
                yutils(k) = -(abs(ylosses(k)).^params(2)).*(pwt(sum(qlosses(1:k)), params(4)) - pwt(sum(qlosses(1:k-1)), params(4)));
            end
        end
        yutil(i) = sum(yutils).*params(5);
    else
        ygains = y(i,y(i,:)>=0);
        qgains = q(i,y(i,:)>=0);
        if length(ygains) == 1
            yutils(1) = (ygains(1).^params(1)).*pwt(qgains(1), params(3));
        else
            [ygains, yord] = sort(ygains, 'descend');
            qgains  = qgains(yord);
            yutils(1) = (ygains(1).^params(1)).*pwt(qgains(1), params(3));
            for k = 2:length(ygains)
                yutils(k) = (ygains(k).^params(1)).*(pwt(sum(qgains(1:k)), params(3)) - pwt(sum(qgains(1:k-1)), params(3)));
            end
        end
        yutil(i) = sum(yutils);
        
        clear yutils;
        ylosses = y(i,y(i,:)<0);
        qlosses = q(i,y(i,:)<0);
        if length(ylosses) == 1
            yutils(1) = -(abs(ylosses(1)).^params(2)).*pwt(qlosses(1), params(4));
        else
            [ylosses, yord] = sort(ylosses);
            qlosses  = qlosses(yord);
            yutils(1) = -(abs(ylosses(1)).^params(2)).*pwt(qlosses(1), params(4));
            for k = 1:length(ylosses)
                yutils(k) = -(abs(ylosses(k)).^params(2)).*(pwt(sum(qlosses(1:k)), params(4)) - pwt(sum(qlosses(1:k-1)), params(4)));
            end
        end
        yutil(i) = yutil(i) + sum(yutils).*params(5);
    end
end

xutil(xutil>=0) = xutil(xutil>=0).^(1./params(1));
xutil(xutil<0) = -(abs(xutil(xutil<0)./params(5)).^(1./params(2)));
yutil(yutil>=0) = yutil(yutil>=0).^(1./params(1));
yutil(yutil<0) = -(abs(yutil(yutil<0)./params(5)).^(1./params(2)));

preds = 1./(1 + exp(-(xutil - yutil).*params(6)));
logl = -(sum(log(preds(choice == 1))) + sum(log(1-preds(choice == 0))));
% xutil
end

% function putil = pwt(prob, weight)
% putil = exp(-(-log(prob).^weight));
% end


