	                            %PART II
	


fprintf(' WELCOME TO PART II (Breakpoint Edition) \n');
fs = input('Enter frequency [default 100]: ');
if isempty(fs), fs = 100; end
ts = input('Enter time start [default 0]: ');
if isempty(ts), ts = 0; end
te = input('Enter time end [default 10]: ');
if isempty(te), te = 10; end
n = input('Enter Number of breakpoints [default 0]: ');
if isempty(n), n = 0; end

breakpoints = zeros(1, n);
for i = 1:n
    msg = sprintf('Enter breakpoint %d: ', i);
    breakpoints(i) = input(msg);
end

all_points = sort([ts, breakpoints, te]);


total_samples = round(fs * (te - ts));
t = linspace(ts, te, total_samples);
x = zeros(size(t));


for i = 1:(length(all_points)-1)
    t_start = all_points(i);
    t_end = all_points(i+1);
    
    idx = (t >= t_start) & (t <= t_end);
    t_seg = t(idx);
    y_seg = zeros(size(t_seg));
    
    fprintf('\nSegment %d (%.2f to %.2f) ---\n', i, t_start, t_end);
    fprintf(['choose a function:\n' ...
        '1. DC\n2. Ramp\n3. Polynomial\n4. Exponential\n' ...
        '5. Sinusoidal\n6. Gaussian pulse\n7. Sawtooth wave\n']);
    
    choice = input('choice = ');

    switch(choice)
        case 1 % DC
            amp = input('Enter DC amplitude [1]: '); if isempty(amp), amp = 1; end
            y_seg = amp * ones(size(t_seg));

        case 2 % Ramp
            slope = input('Enter slope [1]: '); if isempty(slope), slope = 1; end
            intercept = input('Enter intercept [0]: '); if isempty(intercept), intercept = 0; end
            y_seg = slope * (t_seg - t_start) + intercept;

        case 3 % Polynomial
            order = input('Enter order [2]: '); if isempty(order), order = 2; end
            amp = input('Enter amplitude [1]: '); if isempty(amp), amp = 1; end
            y_seg = amp * (t_seg - t_start).^order;

        case 4 % Exponential
            amp = input('Enter amplitude [1]: '); if isempty(amp), amp = 1; end
            exponent = input('Enter exponent [1]: '); if isempty(exponent), exponent = 1; end
            y_seg = amp * exp(exponent * (t_seg - t_start));

        case 5 % Sinusoidal
            amp = input('Enter amplitude [1]: '); if isempty(amp), amp = 1; end
            freq = input('Enter frequency [1]: '); if isempty(freq), freq = 1; end
            y_seg = amp * sin(2 * pi * freq * t_seg);

         case 6 % Gaussian pulse
            amp = input('Enter Gaussian amplitude [default 1]: ');
            if isempty(amp), amp = 1; end
            default_mean = (t_start + t_end) / 2;
            meanVal = input(['Enter Gaussian mean [default ' num2str(default_mean) ']: ']); 
            if isempty(meanVal), meanVal = default_mean; end
            width = input('Enter Gaussian width [default 1]: ');   
            if isempty(width), width = 1; end
            y_seg = amp * exp(-((t_seg - meanVal).^2) / (2 * width^2));

        case 7 % Sawtooth wave
            amp = input('Enter amplitude [1]: '); if isempty(amp), amp = 1; end
            freq = input('Enter frequency [1]: '); if isempty(freq), freq = 1; end
            y_seg = amp * sawtooth(2 * pi * freq * t_seg);

        otherwise
            fprintf('Invalid choice. Defaulting to 0 for this segment.\n');
    end
    
    x(idx) = y_seg;
end
    figure(100); 
    plot(t, x);
    title('Signal Window ');
    xlabel('Time (s)');
    ylabel('Amplitude');
      grid on;
while true
fprintf("choose a function:\n\n"+...
"1. Amplitude scaling\n" +...
"2. Time reversal \n"+...
"3. Time shift \n"+...
"4. Expansion \n"+...
"5. Compression \n"+...
"6. Addition  of random noise \n"+...
"7. Smoothing \n" +...
"8. None\n");

choice = input('choice = ');

switch(choice)
    case 1
        amplitude = input("Enter DC amplitude [1]: ");
        if isempty(amplitude), amplitude = 1; end
        x = x * amplitude;
        figure(101); plot(t, x);
        title('Signal Window [UPDATED]'); xlabel('Time (s)'); ylabel('Amplitude'); grid on;

    case 2
        t = -t;
        figure(101); plot(t, x);
        title('Signal Window [UPDATED]'); xlabel('Time (s)'); ylabel('Amplitude'); grid on;

    case 3
        shift = input("Enter shift [0]: ");
        if isempty(shift), shift = 0; end
        t = t - shift;
        figure(101); plot(t, x);
        title('Signal Window [UPDATED]'); xlabel('Time (s)'); ylabel('Amplitude'); grid on;

    case 4
        Expansion = input("Enter Expansion [1]: ");
        if isempty(Expansion), Expansion = 1; end
        t = Expansion .* t;
        figure(101); plot(t, x);
        title('Signal Window [UPDATED]'); xlabel('Time (s)'); ylabel('Amplitude'); grid on;

    case 5
        Compression = input("Enter Compression [1]: ");
        if isempty(Compression), Compression = 1; end
        t = t / Compression;
        figure(101); plot(t, x);
        title('Signal Window [UPDATED]'); xlabel('Time (s)'); ylabel('Amplitude'); grid on;

    case 6
        SNR = input("Enter SNR [dB] [100]: ");
        if isempty(SNR), SNR = 100; end
        n = length(x);
        power = sum(x.^2) / n;
        noise_p = power * 10^(-SNR/10);
        noise = randn(1, n);
        scale = sqrt(noise_p / (sum(noise.^2) / n));
        noise = noise * scale;
        x = x + noise;
        figure(101); plot(t, x);
        title('Signal Window [UPDATED]'); xlabel('Time (s)'); ylabel('Amplitude'); grid on;

    case 7
        window_time = input("Enter window [5]: ");
        if isempty(window_time), window_time = 5; end
        num_samples = round(window_time * fs);
        if mod(num_samples, 2) == 0, num_samples = num_samples + 1; end
        if num_samples < 3, num_samples = 3; end
        k = (num_samples - 1) / 2;
        n = length(x);
        xn = zeros(1, n);
        for i = 1:n
            STRAT = max(1, i - k);
            FINISH = min(n, i + k);
            xn(i) = sum(x(STRAT:FINISH)) / (FINISH - STRAT + 1);
        end
        x = xn;
        figure(101); plot(t, x);
        title('Signal Window [UPDATED]'); xlabel('Time (s)'); ylabel('Amplitude'); grid on;

    case 8
        fprintf(" DONE\n");
        break;
end
end
 
fprintf(" generating 10 different signals automatically ");
fs = 100;
ts = 0;
te = 10;
num_signals = 10;

for s = 1:num_signals
    
    figure(s); 

    n_breaks = randi([0, 3]); 
    breakpoints = sort(ts + (te - ts) * rand(1, n_breaks));
    all_points = [ts, breakpoints, te];

    t = linspace(ts, te, round(fs * (te - ts)));
    x = zeros(size(t)); 

    for i = 1:(length(all_points)-1)
        t_start = all_points(i);
        t_end = all_points(i+1);
        idx = (t >= t_start) & (t <= t_end);
        t_seg = t(idx);

        choice = randi([1, 7]);

        switch(choice)
            case 1 % DC
                  amp = rand()*20-10;
                  x(idx) = amp * ones(size(t_seg));

            case 2 % Ramp
                  slope = rand()*20-10;
                  intercept = rand()*20-10;
                  x(idx) = slope * (t_seg - t_start) + intercept;

            case 3 % Poly
                  order = randi([1, 5]);         
                  amp = rand()*10 - 5;
                  seg_len = t_end - t_start;
                  x(idx) = amp * ((t_seg - t_start) / seg_len).^order;

            case 4 % Exp
                  amp = rand()*10 - 5;           
                  exponent = rand()*6 - 3;     
                  seg_len = t_end - t_start;
                  x(idx) = amp * exp((exponent / seg_len) * (t_seg - t_start));

            case 5 % Sine
                amp = rand()*20-10;
                freq = randi([1,5]);
                x(idx)= amp * sin(2 * pi * freq * t_seg);

            case 6 % Gaussian 
                meanVal = t_start + (t_end - t_start) * rand();
                width = 0.5 + rand();       
                x(idx) = exp(-((t_seg - meanVal).^2) / (2 * width^2));

            case 7 % Sawtooth
                  amp = rand()*20-10;
                  freq = randi([1,5]);
                  x(idx) = amp * sawtooth(2 * pi * freq * t_seg);
        end
    end  
    
    plot(t, x);
    title(['Signal Window ', num2str(s)]);
    xlabel('Time (s)');
    ylabel('Amplitude');
    grid on;
    
    drawnow; 
end

fprintf(" The program is FINISHED \n");
fprintf("         THANK YOU         \n");
