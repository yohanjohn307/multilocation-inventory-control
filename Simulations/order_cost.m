function out = order_cost(u,l,h,K,K_h,x_switch,order_flag,dim_flag)
    if strcmp(dim_flag,'1D')
        if strcmp(order_flag,'sector')
            out = l*u;
        elseif strcmp(order_flag,'affine')
            out = h*u;
            out(out > 0) = out(out > 0) + K_h;
        else
            error('Invalid flag value.')
        end
    elseif strcmp(dim_flag,'2D')
        u = sum(u,3);
        % if size(u,3) > 1
        %     u = squeeze(tensorprod([1; 2],u,1,3));
        % end
        if strcmp(order_flag,'sector')
            % out = l*u + ( ((h-l)*u) ./ (1+abs(u)) );
            out = u;
            out(u > 0 & u <= x_switch) = h*out(u > 0 & u <= x_switch);
            out(u > x_switch) = l*out(u > x_switch) + x_switch*(h-l);
        elseif strcmp(order_flag,'affine')
            % out = l*u + ( ((h-l)*u) ./ (1+abs(u)) );
            out = u;
            out(u > 0 & u <= x_switch) = h*out(u > 0 & u <= x_switch);
            out(u > x_switch) = l*out(u > x_switch) + x_switch*(h-l);
            out(out > 0) = out(out > 0) + K;
        else
            error('Invalid flag value.')
        end
    else
        error('Invalid flag value.')
    end
end