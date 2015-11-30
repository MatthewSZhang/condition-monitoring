function [fnames, outmat] = select_features(M1_FZmat, SN41_FZmat)

frequencies = 0:2:1666*2;

tempvelZm1 = [M1_FZmat' ones(size(M1_FZmat,2),1)];
tempvelZsn41 = [SN41_FZmat' zeros(size(SN41_FZmat,2),1)]; 
tempvelZ = [tempvelZm1; tempvelZsn41];

Rvz = corr(tempvelZ);
Rvz = Rvz(1:1667,1668);

figure;
hold on;
% plot(frequencies, Raz, 'b')
plot(frequencies, Rvz, 'r')
xlabel('Frequency (Hz)')
ylabel('Correlation')
% legend({'Acceleration'; 'Velocity'});
% title('Velocity and Acceleration in the Z Direction')
title('Velocity in the Z Direction')

fnames = {};
outmat = [];
corr_threshold = 0.7;
% grab features with abs(correlation) > corr_threshold
indices_velZ = find(abs(Rvz) > corr_threshold);
freqs = frequencies(indices_velZ);
for i=1:length(freqs)
  fnames = [fnames; ['velZ' num2str(freqs(i)) '_Hz']];
end
outmat = [outmat tempvelZ(:,indices_velZ)];

fnames = [fnames; 'm1?'];
outmat = [outmat tempvelZ(:,1668)];
