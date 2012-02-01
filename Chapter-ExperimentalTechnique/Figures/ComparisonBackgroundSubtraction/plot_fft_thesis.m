cd 'C:/PhD/Results/2010/dHvA BaFe2P2 June/Data/Sample2/AngleSweep1-001To110/InvestigateLowFreqs/SubtractVariousBackgrounds'

% RUNS_TO_ANGLE_FILENAME = []
% FILESTEM = 'BareCantilever_B=6-18T_Fit=O2B/BareCant_00908a_%d_fft.dat'
% CACHE_FILE = 'BareCantilever_B=6-18T_Fit=O2B/Cache.mat'
% SKIP = [1 10]

% RUNS_TO_ANGLE_FILENAME = []
% FILESTEM = 'BareCantileverExtracted_03B_Raw/BareCant_00908a_%d_fft.dat'
% CACHE_FILE = 'BareCantileverExtracted_03B_Raw/Cache.mat'
% SKIP = [1 10]

RUNS_TO_ANGLE_FILENAME = '../../AngleCorrection/runs_to_angles.dat'
FILESTEM = 'AngleSweep110_B=6-18T_Fit=O2B/BaFe2P2_AngleSweep_%d_fft.dat'
CACHE_FILE = 'AngleSweep110_B=6-18T_Fit=O2B/Cache.mat'
SKIP = [3]

% RUNS_TO_ANGLE_FILENAME = '../AngleCorrection/runs_to_angles.dat'
% FILESTEM = 'AngleSweepExtracted_O3B_Fit=O2RecipB/BaFe2P2_AngleSweep_ExtractedO3B_%d_fft.dat'
% CACHE_FILE = 'AngleSweepExtracted_O3B_Fit=O2RecipB/Cache.mat'
% SKIP = [3]

BASE_ANGLES = [-20 0 20 40 60 80 100 120]


i = 1;
all_famps = [];
while exist(sprintf(FILESTEM, i), 'file')
    fn = sprintf(FILESTEM, i);
    if ismember(i, SKIP)
        disp(['Skipping: ' fn]);
        i = i + 1;
        continue
    end
    disp(fn);
    [headers, data] = hdrload(fn);
    freqs = data(:,1);
    famps = data(:,2);
    all_famps = [all_famps famps];
    i = i + 1;
end
if isempty(RUNS_TO_ANGLE_FILENAME)
    angles = BASE_ANGLES;
else
    data = load(RUNS_TO_ANGLE_FILENAME);
    angles = data(:,2);
    angles(SKIP) = [];
end

save(CACHE_FILE, 'all_famps', 'angles', 'freqs');

cutoff_ind= find(freqs > 100, 1);
freqs = freqs(1:cutoff_ind);
all_famps = all_famps(1:cutoff_ind,:);
[grid_angles, grid_freqs] = meshgrid(angles, freqs);

figure
surf(grid_angles, grid_freqs, all_famps);

ylim([0 100]);

FONT_SIZE = 18;
set( get( gca, 'XLabel' ), 'FontSize', FONT_SIZE );
set( get( gca, 'YLabel' ), 'FontSize', FONT_SIZE );
set( get( gca, 'ZLabel' ), 'FontSize', FONT_SIZE );
set( gca, 'FontSize', FONT_SIZE);
set( gca, 'FontName', 'Times New Roman');

set(gcf, 'Color', [1 1 1]);
set(gca, 'Color', 'none');

set(gca, 'ZTickLabel', '');

view(-152.5, 30)
set(gca, 'Position', [278   519   438   359]);

box on;

% export_fig('fft_O2invBbackground.png', '-r150', '-transparent');


