Fs = 128;
t  = 0:1/Fs:1-(1/Fs);
A  = 4;   % Vpeak
F1 = 8; % Hz
x  = A*cos(2*pi*t*F1);
idx = 1:128;
figure;
plot(t(idx),x(idx)); grid; ylabel('Amplitude'); xlabel('Time (sec)');
axis tight;

