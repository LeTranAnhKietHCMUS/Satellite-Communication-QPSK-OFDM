%do an
function BER = BERTool_QPSK_OFDM_RicianChannel(EbNo, Rs, numSubcarriers, ...
    cpLength, numSymbolsPerFrame, numPilots, maxNumErrs, maxNumBits)
    rng(12345);
    % Create QPSK Modulator and Demodulator
    QPSKMod = comm.QPSKModulator('BitInput', true, 'PhaseOffset', pi/4);
    QPSKDemod = comm.QPSKDemodulator('BitOutput', true, 'PhaseOffset', pi/4);

    % Rician Channel Parameters
    PathDelays = [0 1e-6];       % Path delays (in seconds) Mô t? ?? tr? c?a các ???ng truy?n tín hi?u (tính b?ng giây).
    PathAvGains = [0 -10];       % Path gains (in dB)
    KFactor = [10 10];           % Increase K-factor to reduce fading
    %H? s? K = 10 => cao, cho th?y tín hi?u ???ng LOS m?nh h?n nhi?u so v?i tín hi?u ph?n x?, làm gi?m fading.
    fD = 5;                      % t?n s? d?ch Doppler t?i ?a (Hz), mô ph?ng m?t kênh v?i t?c ?? d?ch chuy?n gi?a tr?m phát và tr?m thu th?p.
    DirectPathDopplerShift = [0 0];
    DirectPathInitialPhase = [0 0];

    RicianChannel = comm.RicianChannel( ...
        'SampleRate', Rs, ...
        'PathDelays', PathDelays, ...
        'AveragePathGains', PathAvGains, ...
        'KFactor', KFactor, ...
        'MaximumDopplerShift', fD, ...
        'DirectPathDopplerShift', DirectPathDopplerShift, ...
        'DirectPathInitialPhase', DirectPathInitialPhase, ...
        'NormalizePathGains', true ...
    );

    % AWGN Channel Parameters
    k = 2; % Bits per QPSK symbol
    SNR = EbNo + 10*log10(k);   % Calculate SNR based on Eb/No
    AWGNChannel = comm.AWGNChannel('NoiseMethod', 'Signal to noise ratio (SNR)', ...
        'SNR', SNR);

    % BER Calculator
    BERCalc = comm.ErrorRate;

    % Pilot Allocation
    pilotSpacing = floor(numSubcarriers / numPilots);
    pilotIndices = 1:pilotSpacing:numSubcarriers;

    if length(pilotIndices) ~= numPilots
        error('Number of pilots (numPilots) does not match length of pilotIndices.');
    end

    % Adjust numSymbolsPerFrame to include complete frames
    numOFDMFrames = ceil(numSymbolsPerFrame / (numSubcarriers - numPilots));
    adjustedNumSymbols = numOFDMFrames * (numSubcarriers - numPilots);

    BERIm = zeros(3, 1); % Initialize BER storage

    % Perform Simulation
    while BERIm(2) < maxNumErrs && BERIm(3) < maxNumBits
        % Generate Random Bits
        txBits = randi([0 1], adjustedNumSymbols * k, 1); 
        %T?o d? li?u bit ng?u nhiên ?? truy?n.

        % QPSK Modulation
        txSymbols = QPSKMod(txBits); 
        %?i?u ch? bit thành ký hi?u QPSK

        % Reshape to match OFDM structure
        txOFDM = reshape(txSymbols, numSubcarriers - numPilots, numOFDMFrames);
        %??a d? li?u vào khung OFDM.

        % Insert Pilots
        txOFDMWithPilots = zeros(numSubcarriers, numOFDMFrames);
        dataIndices = setdiff(1:numSubcarriers, pilotIndices);
        txOFDMWithPilots(dataIndices, :) = txOFDM;
        txOFDMWithPilots(pilotIndices, :) = 1;

        % Add Cyclic Prefix
        txOFDM_cp = [txOFDMWithPilots(end-cpLength+1:end, :); txOFDMWithPilots];
        txOFDMFlattened = txOFDM_cp(:);

        % Pass through Rician Channel
        rxOFDMChan = RicianChannel(txOFDMFlattened);
        %Truy?n tín hi?u qua kênh Rician.

        % Add AWGN
        AWGNChannel.SignalPower = var(txOFDMFlattened);
        rxOFDM = AWGNChannel(rxOFDMChan);
        %Thêm nhi?u AWGN:

        % Remove Cyclic Prefix
        rxOFDMReshaped = reshape(rxOFDM, numSubcarriers + cpLength, []);
        rxOFDM_noCP = rxOFDMReshaped(cpLength+1:end, :);

        % Channel Estimation with Linear Interpolation
        hEst = mean(rxOFDM_noCP(pilotIndices, :) ./ txOFDMWithPilots(pilotIndices, :), 2);
        hEstFull = interp1(pilotIndices, hEst, 1:numSubcarriers, 'linear', 'extrap');
        rxOFDMEqualized = rxOFDM_noCP ./ hEstFull.';
        %??c l??ng kênh và cân b?ng tín hi?u

        % Extract Data Symbols
        rxDataSymbols = rxOFDMEqualized(dataIndices, :);
        rxDataSymbolsFlattened = rxDataSymbols(:);

        % QPSK Demodulation
        rxBits = QPSKDemod(rxDataSymbolsFlattened);
        %Gi?i ?i?u bi?n QPSK

        % BER Calculation
        BERIm = BERCalc(txBits, rxBits);
        %Tính bit l?i
    end

    % Output BER
    BER = BERIm(1);
    disp(['BER = ', num2str(BER), ' after ', num2str(BERIm(3)), ' bits.']);
end
