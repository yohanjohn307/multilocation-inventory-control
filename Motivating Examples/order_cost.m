function out = order_cost(u,l,h,K,K_h,order_flag,dim_flag)
    if strcmp(dim_flag,'1D')
        if strcmp(order_flag,'sector')
            % out = l*u;
            out = u;
            out(u > 0 & u <= 1) = l*out(u > 0 & u <= 1);
            out(u >= 2) = h*out(u >= 2);
        elseif strcmp(order_flag,'affine')
            % out = h*u;
            % out(out > 0) = out(out > 0) + K_h;
            out = u;
            out(u > 0 & u <= 1) = l*out(u > 0 & u <= 1);
            out(u >= 2) = h*out(u >= 2);
            out(out > 0) = out(out > 0) + K;
        else
            error('Invalid flag value.')
        end
    elseif strcmp(dim_flag,'2D')
        u = sum(u,3);
        if strcmp(order_flag,'sector')
            % out = l*u + ( ((h-l)*u) ./ (1+abs(u)) );
            out = u;
            out(u > 0 & u <= 1) = l*out(u > 0 & u <= 1);
            out(u >= 2) = h*out(u >= 2);
        elseif strcmp(order_flag,'affine')
            % out = l*u + ( ((h-l)*u) ./ (1+abs(u)) );
            out = u;
            out(u > 0 & u <= 1) = l*out(u > 0 & u <= 1);
            out(u >= 2) = h*out(u >= 2);
            out(out > 0) = out(out > 0) + K;
        else
            error('Invalid flag value.')
        end
    else
        error('Invalid flag value.')
    end
end