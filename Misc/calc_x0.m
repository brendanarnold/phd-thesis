 function [total_re_x0 total_im_x0] = calc_x0(fs, T, delta, omega, q_space, energy_ind_combs, out_filestem)

% A function to calculate the non-interacting susceptibility according to
% the Lindhard function. Matrix elements are assumed to be unity.
%
%   energy_ind_combs: Optional Nx2 matrix of band pairs (default: empty, 
%                          All band pairs are calculated)
%   temperature:    Temperature (default: Absolute zero - slightly
%                          quicker to calculate)
%   delta:          Quasiparticle lifetime, if zero this will give
%                          zero for the imaginary portion of the
%                          susceptibility (default: zero)
%   omega:          Pertubation frequency (default: zero)
%   out_filestem:   Filestem for all the individual band combinations
%                          Default: 'x0'
%   q_space:        Indices of Q space to calculate passed as a cell array
%                          of 3 vectors, first for the Qx indices, second
%                          for the Qy indices, third for the Qz indices. An
%                          empty cell array or an empty vector in the cell
%                          array defaults to the full extent of grid of energy
%                          points. N.B. Since we are dealing with indices,
%                          not k-space values, 1 corresponds to a zero
%                          in q-space (i.e. qx = (n-1)*dk_x where n is the 
%                          number passed) 
%
% RETURNS:
%    re_x0:         Real values of x0
%    im_x0:         Im values of x0
%


% Use to test the code. Generates free electron energy dispersion and
% calcualtes a susceptibility. Actually not straightforward since free
% electron dispersion is not periodic.
TEST_FREE_ELECTRON = false;
DIMENSIONS = 3;


if TEST_FREE_ELECTRON
    clear fs;
    free_electron_dispersion = @(kx, ky, kz) (kx.^2 + ky.^2 + kz.^2);
    delta = 1e-9;
    omega = 1e-9;
    MAX_L = 1;
    MIN_L = -1;
    NUM_PTS = 100;
    fs.dL = (MAX_L - MIN_L) / (NUM_PTS - 1);
    fs.FermiLevel = 0.09;
    L = linspace(MIN_L, MAX_L, NUM_PTS);
    if DIMENSIONS == 3
        [fs.cartX, fs.cartY, fs.cartZ] = meshgrid(L, L, L);        
        q_space = {[], [], []};
        % Calulate distance each grid point is from centre in order to
        % build the symmetry mask
        [x y z] = meshgrid(1:NUM_PTS, 1:NUM_PTS, 1:NUM_PTS);
        r = hypot(hypot(x - NUM_PTS ./ 2, y - NUM_PTS ./ 2), z - NUM_PTS ./ 2);
    elseif DIMENSIONS == 2
        [fs.cartX, fs.cartY, fs.cartZ] = meshgrid(L, L, 0);
        q_space = {[], [], 1};
        [x y] = meshgrid(1:NUM_PTS, 1:NUM_PTS);
        r = hypot(x - NUM_PTS ./ 2, y - NUM_PTS ./ 2);
    else
        error('Number of dimensions not supported');
    end
    % Symmetry mask based on Fermi function, ensures that the symmetry is
    % spherical for the non-repeating free-electron case
    MASK_TRIM = 1.5;
    MASK_DECAY = 10;
    sym_mask = 1 ./ (exp((r - (NUM_PTS ./ 2 - MASK_TRIM)) * MASK_DECAY) + 1);
    fs.cartE = {};
    fs.cartE{1} = free_electron_dispersion(fs.cartX, fs.cartY, fs.cartZ);
end


% Set the temperature
if isempty(T)
    T = 0;
end
disp(sprintf('Temperature set to: %.3f', T));

% Set the lifetime
if isempty(delta)
    delta = 0;
end
disp(sprintf('Quasiparticle lifetime set to: %.3f', delta));

% Set omega
if isempty(omega)
    omega = 0;
end
disp(sprintf('Plasma frequency set to: %.3f', omega));

% Set the output filestem
if isempty(out_filestem)
    out_filestem = 'x0';
end
disp(['Filestem set to: ' out_filestem]);

% Set the size of the Q region to be calculated
[num_qx num_qy num_qz] = size(fs.cartE{1});
if isempty(q_space)
    q_space = {[] [] []};
end
if isempty(q_space{1})
    qx_range = 1:num_qx;
else
    qx_range = q_space{1};
end
if isempty(q_space{2})
    qy_range = 1:num_qy;
else
    qy_range = q_space{2};
end
if isempty(q_space{3})
    qz_range = 1:num_qz;
else
    qz_range = q_space{3};
end
disp(sprintf('Size of q space is: %dx%dx%d', num_qx, num_qy, num_qz));

% Set the combinations of bands to be calculated
% Replace if necessary
if isempty(energy_ind_combs)
    % Compile a list of combinations of the bands in terms of indices
    n = length(fs.cartE);
    energy_ind_combs = zeros([n 2]);
    i = 0;
    for ind1 = 1:n
        for ind2 = 1:n
            i = i + 1;
            energy_ind_combs(i,1) = ind1;
            energy_ind_combs(i,2) = ind2;
        end
    end
end
disp('Band combinations to be calculated and summed over:');
disp(energy_ind_combs);


%K_BOLTZ = 1.3806503e-23;
K_BOLTZ = 6.3336e-6; % In Rydbergs

total_im_x0 = zeros(num_qx, num_qy, num_qz);
total_re_x0 = zeros(num_qx, num_qy, num_qz);

% This will be 'Inf' if T=0 but will not be used later if thisis the case
beta = 1 ./ (K_BOLTZ .* T);

for inds = energy_ind_combs'
    % Assign the two coupled bands to be calculated
    energies = fs.cartE{inds(1)};
    q_energies = fs.cartE{inds(2)};
    % Initialise the results matrices
    im_x0 = zeros(num_qx, num_qy, num_qz);
    re_x0 = zeros(num_qx, num_qy, num_qz);
    % Iterate over all Q vectors
    for k = qz_range
        for j = qy_range
            disp(sprintf('Bands %d->%d: k=%d\tj=%d', inds', k, j));
            for i = qx_range
                % Determine the energies at k+Q
                if TEST_FREE_ELECTRON
                    qx = (i - 1) .* fs.dL;
                    qy = (j - 1) .* fs.dL;
                    qz = (k - 1) .* fs.dL;
                    energies_prime = free_electron_dispersion(fs.cartX + qx, fs.cartY + qy, fs.cartZ + qz);
                else
                    energies_prime = circshift(q_energies, [i - 1, j - 1, k - 1]);
                end
                % x0 (non-interacting susceptibility) is of form A / (B + iC)
                % Re(x0) is of form AB / (B^2 + C^2)
                % Im(x0) is of form -CA / (B^2 + C^2)

                % Quicker approximation for T=0 that also avoids Inf in
                % calculation
                if T == 0
                    A = (energies <= fs.FermiLevel) - (energies_prime <= fs.FermiLevel);
                else
                    A = 1 ./ ( exp(beta .* (energies - fs.FermiLevel)) + 1 ) - 1 ./ ( exp(beta .* (energies_prime - fs.FermiLevel)) + 1 );
                end
               
                B = energies_prime - energies - omega;
                C = delta; % Is -delta in formula, but this is cancelled by 
                           % a negative when finally calculating Im(x0)
                
                D = A ./ (B.^2 + C.^2);
   
                im_result = C .* D;
                re_result = B .* D;

                % Remove NaNs (usu. from 0/0 operations)
                im_result(isnan(im_result)) = 0; 
                re_result(isnan(re_result)) = 0; 
                
                if TEST_FREE_ELECTRON
                    im_result = im_result .* sym_mask;
                    re_result = re_result .* sym_mask;
                end

                im_x0(i, j, k) =  sum(im_result(:));
                re_x0(i, j, k) =  sum(re_result(:));
            end
        end
    end
    % Save this band pair data individually before combining with overall
    % x0
    save(sprintf([out_filestem '_Bands=%d-%d'], inds), 're_x0', 'im_x0');
    total_im_x0 = total_im_x0 + im_x0;
    total_re_x0 = total_re_x0 + re_x0;
end

end



