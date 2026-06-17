function visualize(x_vec,U1,U2,U_coupled,U_decoupled,J_coupled,J_decoupled,cost_coupled,cost_decoupled)

    % U_vec = U1(1,:);
    N_states = length(x_vec);
    sz_X1 = [N_states N_states];
    N = size(J_coupled,2);

    % Coupled
    % -------
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
    % f = figure;
    % f.Position = [600 300 900 400];
    % subplot(1,2,1)
    % heatmap(flipud(U1_vis),'Interpreter','latex','FontSize',20);
    % xlabel('$x_0^1$'); ylabel('$x_0^2$');
    % ax = gca;
    % ax.XData = x_vec; ax.YData = fliplr(x_vec);
    % title('$\mu_0^1$')
    % colorbar('off')
    % 
    % % subplot_tight(1,2,2,[0.15 0.15])
    % subplot(1,2,2)
    % heatmap(flipud(U2_vis),'Interpreter','latex','FontSize',20);
    % xlabel('$x_0^1$'); ylabel('$x_0^2$');
    % ax = gca;
    % ax.XData = x_vec; ax.YData = fliplr(x_vec);
    % title('$\mu_0^2$')
    % colorbar('off')

    % figure
    % heatmap(flipud(J_vis),'Interpreter','latex','FontSize',12)
    % xlabel('$x_0^1$'); ylabel('$x_0^2$');
    % ax = gca;
    % ax.XData = x_vec; ax.YData = fliplr(x_vec);
    % title('Optimal: $J_\pi$');
    % colorbar('off')

    % figure
    % hold on
    % histogram(cost_coupled)
    % xline(mean(cost_coupled),'Color','r','LineWidth',2)
    % xline(median(cost_coupled),'Color','k','LineWidth',2)
    % title(['Coupled Cost: N = ' num2str(length(cost_coupled))])
    % hold off

    figure
    subplot(1,6,3)
    h = heatmap(flipud(U1_vis),'Interpreter','latex','FontSize',14);
    xlabel('$x_0^1$'); ylabel(''); % ylabel('$x_0^2$');
    ax = gca;
    ax.XData = x_vec; ax.YData = fliplr(x_vec);
    title('$\mu_0^1$')
    colorbar('off')
    sh = struct(h);
    sh.Axes.XLabel.FontSize = 18;
    sh.Axes.YLabel.FontSize = 18;
    sh.Axes.Title.FontSize = 18;

    subplot(1,6,4)
    h = heatmap(flipud(U2_vis),'Interpreter','latex','FontSize',14);
    xlabel('$x_0^1$'); ylabel(''); % ylabel('$x_0^2$');
    ax = gca;
    ax.XData = x_vec; ax.YData = fliplr(x_vec);
    title('$\mu_0^2$')
    colorbar('off')
    sh = struct(h);
    sh.Axes.XLabel.FontSize = 18;
    sh.Axes.YLabel.FontSize = 18;
    sh.Axes.Title.FontSize = 18;

    % Decoupled
    % ---------
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
    % f = figure;
    % f.Position = [600 300 900 400];
    % subplot(1,2,1)
    % heatmap(flipud(U1_vis),'Interpreter','latex','FontSize',20)
    % xlabel('$x_0^1$'); ylabel('$x_0^2$');
    % ax = gca;
    % ax.XData = x_vec; ax.YData = fliplr(x_vec);
    % title('$\mu_0^1$')
    % colorbar('off')
    % 
    % subplot(1,2,2)
    % heatmap(flipud(U2_vis),'Interpreter','latex','FontSize',20)
    % xlabel('$x_0^1$'); ylabel('$x_0^2$');
    % ax = gca;
    % ax.XData = x_vec; ax.YData = fliplr(x_vec);
    % title('$\mu_0^2$')
    % colorbar('off')
    % 
    % f = figure;
    % f.Position = [600 300 900 400];
    % subplot(1,2,1)
    % heatmap(flipud(J_opt/N),'Interpreter','latex','FontSize',20)
    % xlabel('$x_0^1$'); ylabel('$x_0^2$');
    % ax = gca;
    % ax.XData = x_vec; ax.YData = fliplr(x_vec);
    % title('$J_{\pi^*}$');
    % colorbar('off')
    % 
    % subplot(1,2,2)
    % heatmap(flipud(J_dec/N),'Interpreter','latex','FontSize',20)
    % xlabel('$x_0^1$'); ylabel('$x_0^2$');
    % ax = gca;
    % ax.XData = x_vec; ax.YData = fliplr(x_vec);
    % title('$J_{\pi_d}$');
    % colorbar('off')

    % figure
    % hold on
    % histogram(cost_decoupled)
    % xline(mean(cost_decoupled),'Color','r','LineWidth',2)
    % xline(median(cost_decoupled),'Color','k','LineWidth',2)
    % title(['Decoupled Cost: N = ' num2str(length(cost_decoupled))])
    % hold off

    subplot(1,6,1)
    h = heatmap(flipud(U1_vis),'Interpreter','latex','FontSize',14);
    xlabel('$x_0^1$'); ylabel('$x_0^2$');
    ax = gca;
    ax.XData = x_vec; ax.YData = fliplr(x_vec);
    title('$\mu_0^1$')
    colorbar('off')
    sh = struct(h);
    sh.Axes.XLabel.FontSize = 18;
    sh.Axes.YLabel.FontSize = 18;
    sh.Axes.Title.FontSize = 18;
    
    subplot(1,6,2)
    h = heatmap(flipud(U2_vis),'Interpreter','latex','FontSize',14);
    xlabel('$x_0^1$'); ylabel(''); % ylabel('$x_0^2$');
    ax = gca;
    ax.XData = x_vec; ax.YData = fliplr(x_vec);
    title('$\mu_0^2$')
    colorbar('off')
    sh = struct(h);
    sh.Axes.XLabel.FontSize = 18;
    sh.Axes.YLabel.FontSize = 18;
    sh.Axes.Title.FontSize = 18;

    subplot(1,6,5)
    h = heatmap(flipud(J_dec/N),'Interpreter','latex','FontSize',14);
    xlabel('$x_0^1$'); ylabel(''); % ylabel('$x_0^2$');
    ax = gca;
    ax.XData = x_vec; ax.YData = fliplr(x_vec);
    title('$J_{\pi_b}$');
    colorbar('off')
    sh = struct(h);
    sh.Axes.XLabel.FontSize = 18;
    sh.Axes.YLabel.FontSize = 18;
    sh.Axes.Title.FontSize = 18;

    subplot(1,6,6)
    h = heatmap(flipud(J_opt/N),'Interpreter','latex','FontSize',14);
    xlabel('$x_0^1$'); ylabel(''); % ylabel('$x_0^2$');
    ax = gca;
    ax.XData = x_vec; ax.YData = fliplr(x_vec);
    title('$J_{\pi_*}$');
    colorbar('off')
    sh = struct(h);
    sh.Axes.XLabel.FontSize = 18;
    sh.Axes.YLabel.FontSize = 18;
    sh.Axes.Title.FontSize = 18;

end