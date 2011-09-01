 function [total_re_x0 total_im_x0] = calc_x0(fs, T, delta, omega, e_shifts, q_space, out_filestem, energy_ind_combs)

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
%   omega:          Plasma frequency (default: zero)
%   out_filestem:   Filestem for all the individual band combinations
%                          Default: 'x0'
%   e_shifts:       Energy shifts to apply to the energy voxels (n.b. 
%                          this is NOT applied to the chemical potential, but 
%                          rather the energies, this is in Rydbergs)
%                          Default: zero shifts
%   q_space:        Dimensions of the Q space to calculate in terms
%                          of the number of points in the energy voxels
%                          (i.e. if the energy voxels, such as found in
%                          cartE, are 50x50x50 pts, for a tetragonal symmetry
%                          25x25x50 can be supplied). Default is all but is
%                          highly recommended to adjust this
%

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

% Set the energy shifts
if isempty(e_shifts)
    e_shifts = zeros(size(fs.cartE));
end
disp('Energy shifts set to:');
disp(e_shifts);

% Set the output filestem
if isempty(out_filestem)
    out_filestem = 'x0';
end
disp(['Filestem set to: ' out_filestem]);

% Set the size of the Q region to be calculated
if isempty(q_space)
    [num_qx num_qy num_qz] = size(fs.cartE{1});
else
    num_qx = q_space(1);
    num_qy = q_space(2);
    num_qz = q_space(3);
end
disp(sprintf('Size of q space is: %dx%dx%d', num_qx, num_qy, num_qz));

% Set the combinations of bands to be calculated
% Replace if necessary
if isempty(energy_ind_combs)
    % Compile a list of combinations of the bands in terms of indices
    inds = 1:length(fs.cartE);
    energy_ind_combs = repmat(inds, [2 1])';
    if length(inds) > 1
        energy_ind_combs = [energy_ind_combs; nchoosek(inds, 2)];
    end
end
disp('Band combinations to be calculated and summed over:');
disp(energy_ind_combs);


%K_BOLTZ = 1.3806503e-23;
K_BOLTZ = 6.3336e-6; % In Rydbergs


total_im_x0 = zeros(num_qx, num_qy, num_qz);
total_re_x0 = zeros(num_qx, num_qy, num_qz);

for inds = energy_ind_combs'
    % Assign the two coupled bands to be calculated and apply the rigid energy shift
    energies = fs.cartE{inds(1)} + e_shifts(inds(1));
    q_energies = fs.cartE{inds(2)} + e_shifts(inds(2));
    % Initialise the results matrices
    im_x0 = zeros(num_qx, num_qy, num_qz);
    re_x0 = zeros(num_qx, num_qy, num_qz);
    % Iterate over all Q vectors
    for k = 1:num_qz
        for j = 1:num_qy
            disp(sprintf('Bands %d->%d: k=%d\tj=%d', inds', k, j));
            for i = 1:num_qx
                % Determine the energies at k+Q
                energies_prime = circshift(q_energies, [i, j, k]);

                % x0 (non-interacting susceptibility) is of form A / (B + iC)
                % Re(x0) is of form AB / (B^2 + C^2)
                % Im(x0) is of form -CA / (B^2 + C^2)

                % Quicker approximation to T=0 that also avoid divide by zero
                if T == 0
                    A = (energies <= fs.FermiLevel) - (energies_prime <= fs.FermiLevel);
                else
                    A = 1 ./ ( exp((energies - fs.FermiLevel)/(K_BOLTZ * T)) + 1 ) - 1 ./ ( exp((energies_prime - fs.FermiLevel)/(K_BOLTZ * T)) + 1 );
                end
                B = energies - energies_prime - omega;
                C = -delta;

                im_result = - C .* A ./ ( B.^2 + C.^2 );
                re_result = A .* B ./ ( B.^2 + C.^2 );
                % Remove NaNs (usu. from 0/0 operations)
                im_result(isnan(im_result)) = 0; 
                re_result(isnan(re_result)) = 0; 
                
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



