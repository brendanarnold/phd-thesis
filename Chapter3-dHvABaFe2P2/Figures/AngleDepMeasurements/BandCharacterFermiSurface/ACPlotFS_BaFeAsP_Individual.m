function ACPlotFS_BaFeAsP(fs,Shift,orbit_nums);

pvol = fs.BZfacenormals*fs.rlvs;

ka = 1.2;
% kz = 2 * pi / fs.latt_params(3);
kz = 2 * pi / fs.latt_params(3);
k1 = fs.rlvs(1,2) ./ 2;
k2 = k1 / 2;

disp(['Fermi Level Shift ' num2str(Shift) ' Ry'])
pvol2=[1.2 0 0; 0 1.2 0; 0 0 kz; -0.1 0 0; 0 -0.1 0; 0 0 -kz];
%pvol2=[ka 0 0; 0 ka 0; 0 0 kz/2; -ka 0 0; 0 -ka 0; 0 0 -kz/2; k1 k1 0];
pvol3=[-k1 0 0; 0 -k1 0; 0 0 kz; k1 0 0; 0 k1 0; 0 0 -kz];

colors=[237 255 0; 247 148 29; 236 0 0; 0 0 255; 140 198 63]./255;

if ismember(1, orbit_nums)
    plot_FS(fs,[1],fs.FermiLevel+Shift(1),colors(2,:),[],pvol3,[],[],[], ...
        'linear',gca,true);   
end
if ismember(2, orbit_nums)
    plot_FS(fs,[2],fs.FermiLevel+Shift(2),colors(3,:),[],pvol3,[],[],[], ...
        'linear',gca,true);
end
if ismember(3, orbit_nums)
    plot_FS(fs,[3],fs.FermiLevel+Shift(3),colors(4,:),[],pvol2,[],[],[], ...
        'linear',gca,true);
end
if ismember(4, orbit_nums)
    plot_FS(fs,[4],fs.FermiLevel+Shift(4),colors(5,:),[],pvol2,[],[],[], ...
        'linear',gca,true);
end
if ismember(5, orbit_nums)
    % Not tested
    plot_FS(fs,[5],fs.FermiLevel+Shift(5),colors(1,:),[],pvol3,[],[],[], ...
        'linear',gca,true);
end

%plotvol(gca,[],pvol,[0 0 0]);
%plotvol(gca,[],pvol3,[0 0 0]);

%view (26,18);
view (117,26);

axis off


