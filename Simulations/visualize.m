function visualize(x_vec,U1,U2,U_coupled,U_decoupled,...
    J_coupled,J_decoupled,cost_coupled,cost_decoupled,cost_online,order_flag)

    N_states = length(x_vec);
    sz_X1 = [N_states N_states];

    % Coupled
    % -------
    cost_coupled = mean(cost_coupled,2);
    U1_vis = zeros(sz_X1);
    U2_vis = zeros(sz_X1);
    J_opt = reshape(J_coupled(:,1),sz_X1);
    for i = 1:N_states
        for j = 1:N_states
            ind = sub2ind(sz_X1, i, j);
            idx = U_coupled(ind,1);
            [ui,uj] = ind2sub(size(U1),idx);
            U1_vis(i,j) = U1(ui,uj);
            U2_vis(i,j) = U2(ui,uj);
        end
    end

    f = figure;
    f.Position = [600 300 900 400];
    subplot(1,2,1)
    heatmap(flipud(U1_vis),'Interpreter','latex','FontSize',20);
    xlabel('$x_0^1$'); ylabel('$x_0^2$');
    ax = gca;
    ax.XData = x_vec; ax.YData = fliplr(x_vec);
    title('$\mu_0^1$')
    colorbar('off')

    subplot(1,2,2)
    heatmap(flipud(U2_vis),'Interpreter','latex','FontSize',20);
    xlabel('$x_0^1$'); ylabel('$x_0^2$');
    ax = gca;
    ax.XData = x_vec; ax.YData = fliplr(x_vec);
    title('$\mu_0^2$')
    colorbar('off')

    figure
    heatmap(flipud(J_opt),'Interpreter','latex','FontSize',12)
    xlabel('$x_0^1$'); ylabel('$x_0^2$');
    ax = gca;
    ax.XData = x_vec; ax.YData = fliplr(x_vec);
    title('Optimal: $J_\pi$');
    colorbar('off')

    % Decoupled
    % ---------
    cost_decoupled = mean(cost_decoupled,2);
    decoupled_cost_ratios = cost_decoupled ./ cost_coupled;
    decoupled_cost_ratios = reshape(decoupled_cost_ratios,sz_X1);
    U1_vis = zeros(sz_X1);
    U2_vis = zeros(sz_X1);
    J_dec = reshape(J_decoupled(:,1),sz_X1);
    for i = 1:N_states
        for j = 1:N_states
            ind = sub2ind(sz_X1, i, j);
            idx = U_decoupled(ind,1);
            [ui,uj] = ind2sub(size(U1),idx);
            U1_vis(i,j) = U1(ui,uj);
            U2_vis(i,j) = U2(ui,uj);
        end
    end

    f = figure;
    f.Position = [600 300 900 400];
    subplot(1,2,1)
    heatmap(flipud(U1_vis),'Interpreter','latex','FontSize',20)
    xlabel('$x_0^1$'); ylabel('$x_0^2$');
    ax = gca;
    ax.XData = x_vec; ax.YData = fliplr(x_vec);
    title('$\mu_0^1$')
    colorbar('off')

    subplot(1,2,2)
    heatmap(flipud(U2_vis),'Interpreter','latex','FontSize',20)
    xlabel('$x_0^1$'); ylabel('$x_0^2$');
    ax = gca;
    ax.XData = x_vec; ax.YData = fliplr(x_vec);
    title('$\mu_0^2$')
    colorbar('off')

    figure
    heatmap(flipud(J_dec),'Interpreter','latex','FontSize',12)
    xlabel('$x_0^1$'); ylabel('$x_0^2$');
    ax = gca;
    ax.XData = x_vec; ax.YData = fliplr(x_vec);
    title('Decoupled: $J_\pi$');
    colorbar('off')

    f = figure;
    f.Position = [600 300 1200 400];
    subplot(1,2,1)
    h = heatmap(flipud(decoupled_cost_ratios),'Interpreter','latex','FontSize',14);
    xlabel('$x_0^1$'); ylabel('$x_0^2$');
    ax = gca;
    ax.XData = x_vec; ax.YData = fliplr(x_vec);
    title('Decoupled Policy');
    % clim([1.1 1.6])
    sh = struct(h);
    sh.Axes.XLabel.FontSize = 20;
    sh.Axes.YLabel.FontSize = 20;
    sh.Axes.Title.FontSize = 20;

    XLabels = x_vec;
    CustomXLabels = string(XLabels);
    CustomXLabels(mod(XLabels,1) ~= 0) = " ";
    h.XDisplayLabels = CustomXLabels;
    h.YDisplayLabels = CustomXLabels;
    
    % Online
    % ---------
    cost_online = mean(cost_online,2);
    online_cost_ratios = cost_online ./ cost_coupled;
    online_cost_ratios = reshape(online_cost_ratios,sz_X1);

    subplot(1,2,2)
    h = heatmap(flipud(online_cost_ratios),'Interpreter','latex','FontSize',14);
    xlabel('$x_0^1$'); ylabel('$x_0^2$');
    ax = gca;
    ax.XData = x_vec; ax.YData = fliplr(x_vec);
    title('Online Algorithm');
    % clim([1.1 1.6])
    sh = struct(h);
    sh.Axes.XLabel.FontSize = 20;
    sh.Axes.YLabel.FontSize = 20;
    sh.Axes.Title.FontSize = 20;

    XLabels = x_vec;
    CustomXLabels = string(XLabels);
    CustomXLabels(mod(XLabels,1) ~= 0) = " ";
    h.XDisplayLabels = CustomXLabels;
    h.YDisplayLabels = CustomXLabels;

    % figure
    % boxplot([decoupled_cost_ratios' online_cost_ratios'],["Decoupled", "Online"])
    % ylabel('Cost Ratio')
    % if strcmp(order_flag,'sector')
    %     title('Sector-Bounded')
    % elseif strcmp(order_flag,'affine')
    %     title('Affine-Bounded')
    % end
    % fontsize(gcf,scale=1.5)
    % 
    % figure
    % violinplot(categorical(["Decoupled", "Online"]),[decoupled_cost_ratios' online_cost_ratios'])
    % ylabel('Cost Ratio')
    % if strcmp(order_flag,'sector')
    %     title('Sector-Bounded')
    % elseif strcmp(order_flag,'affine')
    %     title('Affine-Bounded')
    % end
    % fontsize(gcf,scale=1.5)

    disp(['Decoupled ratio mean: ' num2str(mean(mean(decoupled_cost_ratios)))])
    disp(['Decoupled ratio max: ' num2str(max(max(decoupled_cost_ratios)))])
    disp(['Online ratio mean: ' num2str(mean(mean(online_cost_ratios)))])
    disp(['Online ratio max: ' num2str(max(max(online_cost_ratios)))])

end