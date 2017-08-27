[fname, dirpath] = uigetfile('*.wav', 'selectwav');
[y fs] = audioread(fullfile(dirpath, fname));

lookwin = 2;
returnwin = 1/2;
[runningct, runningst, runningen, displayst, displayen, buttons] = autoselectcalls(y, fs, lookwin, returnwin);











nfft = fs;
win = hann(nfft);
adv = nfft / 2;

spectrogram_truthful_labels(y, win, adv, nfft, fs, 'yaxis');
colorbar off;
set(gca, 'YScale', 'log');
caxis([-120 -60]);




nyq = fs / 2;
[S, F, T, P] = spectrogram_truthful_labels(y, win, adv, nfft, fs, 'yaxis');
ff = [15 35];
[b a] = butter(3, ff/nyq);
yf = filtfilt(b, a, y);
[Sf Ff Tf Pf] = spectrogram_truthful_labels(yf, win, adv, nfft, fs, 'yaxis');

p19 = P(find(F == 19), :);
p19norm = p19 ./ max(p19);

% 
% threshold = 0.15;
% 
% detections = nan(1, length(p19));
% detections(find(p19norm > threshold)) = 1;

chaudet = chau(p19norm, 400);

hitdif = chaudet(2:end) - chaudet(1:(end-1));
dese = 1 + [0 find(hitdif > 2)];

subplot 311;
spectrogram_truthful_labels(y, win, adv, nfft, fs, 'yaxis');
colorbar off;
set(gca, 'YScale', 'lo g');
caxis([-120 -60]);
hold on;
plot(T(chaudet(dese)), 171, '*');
hold off;
subplot 312;
plot(yf ./ max(abs(yf)))
hold on;
plot(T*fs, p19norm)
plot(T(chaudet(dese))*fs, 0.8, '*');
hold off;
subplot 313;
plot(p19norm);
hold on;
plot(chaudet, .5, '*');
hold off;
