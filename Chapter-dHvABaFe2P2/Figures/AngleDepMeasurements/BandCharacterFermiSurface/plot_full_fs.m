%clear all;

fs_noso = load('BaFe2P2_1e5_cartC.mat');
fs_so = load('BaFe2P2_1e5.bands.mat');

e_shifts = 0.00519 * (1 - ((circshift(fs_noso.cartC{2}{2}, [2 2 2]) - 0.033) / (0.2205 - 0.033))) - 0.0020;
fs_so.cartE{2} = fs_so.cartE{2} - e_shifts;

figure('Position',[50 50 800 600])
ACPlotFS_BaFeAsP(fs_so, [0.0083 0.004 -0.0043 -0.005], [1]);
ACPlotFS_BaFeAsP(fs_so, [0.0083 0.004 -0.0043 -0.005], [2]);
ACPlotFS_BaFeAsP(fs_so, [0.0083 0.004 -0.0043 -0.005], [3]);
ACPlotFS_BaFeAsP(fs_so, [0.0083 0.004 -0.0043 -0.005], [4]);
%ACPlotFS_BaFeAsP(fs_so, [0.0 0.0 0.0 0.0], [4]);
set( get( gca, 'XLabel' ), 'FontSize', 18 )
set( get( gca, 'YLabel' ), 'FontSize', 18 )
set( get( gca, 'ZLabel' ), 'FontSize', 18 )
set( gca, 'FontSize', 18);
axis on;
camva(6);
%zlim([-0.5 0.5]);
%xlim([0.2 1.4]);
%ylim([0.2 1.4]);
%grid on;
%campos([12 6 7])
%campos([3.2 14.8 6.6])
campos([21.5766    6.4178   11.9692]);
set(gcf, 'color', [1 1 1])

export_fig 'Band4_Shifted.png' '-r150'


%set(0, 'ScreenPixelsPerInch', 120)

%myaa
%I = getframe(gcf);
%imwrite(I.cdata, 'Band4_UnShifted.png', 'Transparency', [1 1 1]);
