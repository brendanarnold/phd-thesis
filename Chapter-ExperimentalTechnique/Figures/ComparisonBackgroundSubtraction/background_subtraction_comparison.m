
%%

% Generate B^2 distriution with noise

B = linspace(6, 18, 1000);
V = -0.001 - (B.^2) .* 0.008 ./ 324 + rand(1, 1000) .* 0.0005;

plot(B, V)

data = [B' V'];
save('typical_B2_plus_noise.dat', 'data', '-ascii', '-tabs');

% Generate typical flat disibution with noise

% B = linspace(6, 18, 1000);
% V = -0.001 + rand(1, 1000) .* 0.001;
% 
% plot(B, V)
    
%%

data = load('typical_B2_plus_noise.dat');
B = data(:,1);
V = data(:,2) .* 1e3;

p = polyfit(1./B, V, 2);
% invB = linspace(max(1./B), min(1./B), 1000);
fitInvB = polyval(p, 1./B);

figure
hold on


FONT_SIZE = 18;
set( get( gca, 'XLabel' ), 'FontSize', FONT_SIZE );
set( get( gca, 'YLabel' ), 'FontSize', FONT_SIZE );
set( get( gca, 'ZLabel' ), 'FontSize', FONT_SIZE );
set( gca, 'FontSize', FONT_SIZE);
set( gca, 'FontName', 'Times New Roman');

set(gcf, 'Color', [1 1 1]);
set(gca, 'Color', 'none');

box on;

% set(gcf, 'Position', [163   500   568   259]);
set(gcf, 'Position', [147   678   446   159]);

p = polyfit(B, V, 2);
fitB = polyval(p, B);

plot(B, V, 'k');
plot(B, fitB, 'r', 'Linewidth', 2);

xlim([6 18]);

export_fig('fit_B.png', '-r150', '-transparent');

figure
hold on


FONT_SIZE = 18;
set( get( gca, 'XLabel' ), 'FontSize', FONT_SIZE );
set( get( gca, 'YLabel' ), 'FontSize', FONT_SIZE );
set( get( gca, 'ZLabel' ), 'FontSize', FONT_SIZE );
set( gca, 'FontSize', FONT_SIZE);
set( gca, 'FontName', 'Times New Roman');

set(gcf, 'Color', [1 1 1]);
set(gca, 'Color', 'none');

box on;

% set(gcf, 'Position', [163   500   568   259]);
set(gcf, 'Position', [147   678   446   159]);

plot(1./B, V, 'k');
plot(1./B, fitInvB, 'r', 'Linewidth', 2);

xlim([min(1./B) max(1./B)]);

export_fig('fit_invB.png', '-r150', '-transparent');


%%

% Now load the FFT

fh = fopen('typical_B2_plus_noise_B_fft.dat');
data = textscan(fh, '%f %f', 'Headerlines', 5);
fclose(fh);

x = data{1};
y = data{2};

figure
hold on


FONT_SIZE = 18;
set( get( gca, 'XLabel' ), 'FontSize', FONT_SIZE );
set( get( gca, 'YLabel' ), 'FontSize', FONT_SIZE );
set( get( gca, 'ZLabel' ), 'FontSize', FONT_SIZE );
set( gca, 'FontSize', FONT_SIZE);
set( gca, 'FontName', 'Times New Roman');

set(gcf, 'Color', [1 1 1]);
set(gca, 'Color', 'none');

box on;

set(gcf, 'Position', [589   476   416   370]);
% set(gcf, 'Position', [589   476   518   370]);


plot(x, y, 'k-');

xlim([0 100]);
ylim([0 0.08]);




fh = fopen('typical_B2_plus_noise_invB_fft.dat');
data = textscan(fh, '%f %f', 'Headerlines', 5);
fclose(fh);

x = data{1};
y = data{2};

% figure
% hold on
% 
% 
% FONT_SIZE = 18;
% set( get( gca, 'XLabel' ), 'FontSize', FONT_SIZE );
% set( get( gca, 'YLabel' ), 'FontSize', FONT_SIZE );
% set( get( gca, 'ZLabel' ), 'FontSize', FONT_SIZE );
% set( gca, 'FontSize', FONT_SIZE);
% set( gca, 'FontName', 'Times New Roman');
% 
% set(gcf, 'Color', [1 1 1]);
% set(gca, 'Color', 'none');
% 
% box on;
% 
% set(gcf, 'Position', [462   265   376   259]);

plot(x, y, 'k--');

xlim([0, 100]);
ylim([0 0.08]);

set(gca, 'YTickLabel', '');

% legend('Fitted to B', 'Fitted to 1/B');

export_fig('fft_inset.png', '-r150', '-transparent');
