                                 %PART I 	    
                    
                    %QUESTION 1:


fs = 1000;                 
t = linspace(0, 10, 10*fs + 1);

x1 = exp(-2.*t) .* (t >= 0 & t < 2);
x2 = cos(4*pi.*t) .* exp(-0.5.*t) .* (t >= 2);
x = x1 + x2;

w = linspace(-40, 40, 2000); 
X = zeros(size(w));

for i = 1:length(w)
   
    X(i) = sum( x .* exp(-1j .* w(i) .* t) ) /fs; 
end

figure;
plot(w, abs(X), 'LineWidth', 1.5);
title('Magnitude Spectrum |X(\omega)|');
xlabel('Frequency \omega (rad/s)');
ylabel('|X(\omega)|');
grid on;

E_tot = sum(abs(x).^2) /fs;
E_density = abs(X).^2;
dw = w(2) - w(1);
cumulative_E = cumsum(E_density) * dw / (2*pi);
tot_freq_E = cumulative_E(end);
up_bound = 0.95 * tot_freq_E; 
idx_up = find(cumulative_E >= up_bound, 1);
W_95 = w(idx_up);

fprintf('\nTotal Energy (Time): %f Joules\n', E_tot);
fprintf('Total Energy (Freq): %f Joules\n', tot_freq_E);
fprintf('95%% Energy upper frequency bound: %f rad/s\n', W_95);
fprintf('Total 95%% Bandwidth (from -W to W): %f rad/s\n\n', 2*W_95);




									%QUESTION 2:


fs= 1000;
 t= linspace(-100,100,200*fs);

 s = sin (2*t) ./ (2* t);
 s( t == 0) = 1;

 x1 = s .* cos( 3* pi *t);
 
 figure
 plot(t,x1);
 xlabel(" Time (s) ");
 title('x1(t) in time domain ');
 xlim([-6,6]);
 
 r =( t>=-2 & t<=2);

 x2= r .* cos( 3* pi *t);
 
 figure
 plot(t,x2);
 xlabel(" Time (s) ");
 title('x2(t) in time domain ');
 xlim([-2,2]);
  
 % fourier transfrom for both two functions
 
 xf1=fftshift(fft(x1)) / fs;
 f1=linspace( -fs/2, fs/2 ,length(xf1));
 figure
 plot(f1,abs(xf1));
 xlim([-5 5]);
 xlabel(" frequency (w) ");
 title('x1(w) in frequency domain ');
 
 xf2=fftshift(fft(x2)) / fs;
 f2=linspace( -fs/2, fs/2 ,length(xf2));
 figure
 plot(f2,abs(xf2));
 xlim([-5 5]);
 xlabel(" frequency (w) ");
 title('x2(w) in frequency domain ');



									%QUESTION 3:


fs=1000;
T = 4;
w =2*pi /4;

t= linspace(-2,2,4*fs);
x=[linspace(-2 ,0, 2*fs)+2 2*ones(1,2*fs)];

n=-15:15;

Dn=zeros(size(n));

for i= 1:length(n)
    Dn(i) = (1/T) .* sum(x .* exp( -1i .* w .* n(i) .*t))./fs;
end

phase_degrees = rad2deg(angle(Dn)); 

figure
stem(n,abs(Dn));
title('Magnitude Spectrum');
figure
stem(n,phase_degrees);
title('Phase Spectrum (Degrees)');
xlabel('n');
ylabel('\theta (degrees)');

x_fourier = zeros(size(t));

for i=1: length(n)
    x_fourier = x_fourier + Dn(i) .*exp( 1i *w *n(i) *t);
end

figure
plot(t,x);
hold on
plot(t, real(x_fourier));
title('Signal Reconstruction');

