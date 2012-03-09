%%
load('BaFe2P2_Mewis_1e5NoSO_DELTA=1,0E-003_OMEGA=1,0E-003_T=158K_TotalBands.mat');

%%

[kx, ky] = meshgrid(linspace(0, 2, 47), linspace(0, 2, 47));
contour(kx ,ky, flipud(im_x0(1:47,1:47,47)), 'k');
box on;

FONT_SIZE = 18;
set( get( gca, 'XLabel' ), 'FontSize', FONT_SIZE );
set( get( gca, 'YLabel' ), 'FontSize', FONT_SIZE );
set( get( gca, 'ZLabel' ), 'FontSize', FONT_SIZE );
set( gca, 'FontSize', FONT_SIZE);
set( gca, 'FontName', 'Times New Roman');

set(gcf, 'Color', [1 1 1])
set(gca, 'Color', 'none');

set(gcf, 'Position', [120   619   278   227]);
set(gca, 'Position', [0.1300    0.1100    0.7750    0.8150]);

set(gca, 'XTickLabel', []);
set(gca, 'YTickLabel', []);

xlim([0 2]);
ylim([0 2]);


export_fig 'ImContour.png' '-r150' '-transparent'

%%

figure
[kx, ky] = meshgrid(linspace(0, 2, 47), linspace(0, 2, 47));
contour(kx ,ky, flipud(re_x0(1:47,1:47,47)), 'k');
box on;

FONT_SIZE = 18;
set( get( gca, 'XLabel' ), 'FontSize', FONT_SIZE );
set( get( gca, 'YLabel' ), 'FontSize', FONT_SIZE );
set( get( gca, 'ZLabel' ), 'FontSize', FONT_SIZE );
set( gca, 'FontSize', FONT_SIZE);
set( gca, 'FontName', 'Times New Roman');

set(gcf, 'Color', [1 1 1])
set(gca, 'Color', 'none');

set(gcf, 'Position', [120   619   278   227]);
set(gca, 'Position', [0.1300    0.1100    0.7750    0.8150]);

set(gca, 'XTickLabel', []);
set(gca, 'YTickLabel', []);

xlim([0 2]);
ylim([0 2]);

export_fig 'ReContour.png' '-r150' '-transparent'