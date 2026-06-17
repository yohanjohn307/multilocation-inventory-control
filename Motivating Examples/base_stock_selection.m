function [J_basestock,U_basestock] = base_stock_selection(X1,J_basestock,U_basestock)

    mask = true(numel(X1),1);
    % mask = T_vec >= -3 & T_vec <= 0;
    % mask = T_vec == 0;
    avg_score = Inf(size(J_basestock));
    for i = 1:length(J_basestock)
        J = J_basestock{i};
        if ~isempty(J)
            avg_score(i) = mean(J(mask,1));
        end
    end
    [~,idx] = min(avg_score);
    J_basestock = J_basestock{idx};
    U_basestock = U_basestock{idx};

end