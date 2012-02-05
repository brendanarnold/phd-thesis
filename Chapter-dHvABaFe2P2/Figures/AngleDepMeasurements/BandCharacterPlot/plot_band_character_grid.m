% To generate the character data necessary for the 110 cuts, run
% C:\PhD\Results\2010\dHvA BaFe2P2 June\Data\WIEN2k-BaFe2P2\BandCharacter1e5\apply_orbit_character_shift_110cut_fs.m
% and type save('Band2_110Slice_BandCharacter', 'character', 'interp_grid_x', 'interp_grid_y', 'energies');

BAND_NUM = 2;
EF = 0.61358;
COLORS = {[1 0.5 0] [1 0 0] [0 0.6 0] [0 0 0.6]};
color = COLORS{BAND_NUM};
%CHAR_NAMES = {'$\Sigma d$', '$d_{z^2}$', '$d_{xy}$', '$d_{x^2y^2}$', '$d_{xz}+d_{yz}$'};
FNTSZ = 18;
SAVE_FILESTEM = ['Band' num2str(BAND_NUM) '_BandCharPlot_%d.png'];


load(['Band' num2str(BAND_NUM) '_110Slice_BandCharacter']);

for splt = 1:5
    figure;
    hold on;
    ch = character{splt + 5};
    disp(sprintf('Char %d max is %.4f and min is %.4f', splt, max(ch(:)), min(ch(:))));
    pcolor(interp_grid_x, interp_grid_y, ch);
    shading interp;
    colormap('jet');
    contour(interp_grid_x, interp_grid_y, energies, [EF EF], 'Color', [1 1 1], 'LineWidth', 3);
    contour(interp_grid_x, interp_grid_y, energies, [EF EF], 'Color', color, 'LineWidth', 2);
    %myaa;
    FONT_SIZE = 18;
    set( get( gca, 'XLabel' ), 'FontSize', FONT_SIZE );
    set( get( gca, 'YLabel' ), 'FontSize', FONT_SIZE );
    set( get( gca, 'ZLabel' ), 'FontSize', FONT_SIZE );
    set( gca, 'FontSize', FONT_SIZE);
    set( gca, 'FontName', 'Times New Roman');
    set(gcf, 'Color', [1 1 1])
    set(gca, 'Color', 'none')
    box on;
    colorbar;
    xlim([min(interp_grid_x(:)) max(interp_grid_x(:))]);
    ylim([min(interp_grid_y(:)) max(interp_grid_y(:))]);
    print(sprintf(SAVE_FILESTEM, splt), '-dpng', '-r300');
    hold off;
end

% for splt = 1:5
%     subplot(3, 2, splt);
%     hold on;
%     pcolor(interp_grid_x, interp_grid_y, circshift(character{splt}, [0 0]));
%     xlim([-sqrt(2)/2, sqrt(2)/2]);
%     ylim([0, 1]);
%     shading interp;
%     colormap('jet');
%     contour(interp_grid_x, interp_grid_y, energies, [EF EF], 'Color', color, 'LineWidth', 2);
%     title(CHAR_NAMES{splt}, 'Interpreter', 'latex', 'FontSize', FNTSZ);
%     if ismember(splt, [4 5])
%         xlabel('$\sqrt{k_x^2 + k_y^2}$', 'Interpreter', 'latex', 'FontSize', FNTSZ);
%     end
%     if ismember(splt, [3])
%         ylabel('$k_z$', 'Interpreter', 'latex', 'FontSize', FNTSZ);
%     end
%     hold off;
% end