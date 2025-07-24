function BER = BERTool_QPSK_OFDM_RicianChannel(EbNo, Rs, numSubcarriers, ...
    cpLength, numSymbolsPerFrame, maxNumErrs, maxNumBits)

    % Create QPSK Modulator and Demodulator
    QPSKMod = comm.QPSKModulator('BitInput', true, 'PhaseOffset', pi/4);
    QPSKDemod = comm.QPSKDemodulator('BitOutput', true, 'PhaseOffset', pi/4);

    % Create Rician Channel
    PathDelays = [0 1e-6]; % Path delays (in seconds)
    PathAvGains = [0 -10]; % Path gains (in dB)
    KFactor = [3 3];       % K-factor for Rician fading
    fD = 25;               % Maximum Doppler shift (Hz)
    
    RicianChannel = comm.RicianChannel( ...
        'SampleRate', Rs, ...
        'PathDelays', PathDelays, ...
        'AveragePathGains', PathAvGains, ...
        'KFactor', KFactor, ...
        'MaximumDopplerShift', fD, ...
        'DirectPathDopplerShift', zeros(size(PathDelays)), ...
        'DirectPathInitialPhase', zeros(size(PathDelays)), ...
        'DopplerSpectrum', doppler('Jakes'), ...
        'NormalizePathGains', true ...
    );

    % Create AWGN Channel
    k = 2; % Bits per QPSK symbol
    SNR = EbNo + 10*log10(k);
    AWGNChannel = comm.AWGNChannel('NoiseMethod', 'Signal to noise ratio (SNR)', ...
        'SNR', SNR);
    
    % BER Calculator
    BERCalc = comm.ErrorRate;

    % Simulation Variables
    BERIm = zeros(3,1);
    
    % Loop until maxNumErrs or maxNumBits is reached
    while BERIm(2) < maxNumErrs && BERIm(3) < maxNumBits
        % Generate Random Bits
        txBits = randi([0 1], numSymbolsPerFrame * k, 1);

        % QPSK Modulation
        txSymbols = QPSKMod(txBits);

        % OFDM Modulation
        txOFDM = reshape(txSymbols, numSubcarriers, []);
        txOFDM_cp = [txOFDM(end-cpLength+1:end, :); txOFDM]; % Add cyclic prefix
        txOFDMFlattened = txOFDM_cp(:); % Serialize
        
        % Pass through Rician Channel
        rxOFDMChan = RicianChannel(txOFDMFlattened);

        % Add AWGN
        AWGNChannel.SignalPower = var(txOFDMFlattened);
        rxOFDM = AWGNChannel(rxOFDMChan);

        % OFDM Demodulation
        rxOFDMReshaped = reshape(rxOFDM, numSubcarriers + cpLength, []);
        rxOFDM_noCP = rxOFDMReshaped(cpLength+1:end, :); % Remove cyclic prefix
        
        % LS Channel Estimation (Simplified)
        hEst = mean(rxOFDM_noCP ./ txOFDM, 2);

        % Equalization
        rxOFDMEqualized = rxOFDM_noCP ./ hEst;

        % QPSK Demodulation
        rxBits = QPSKDemod(rxOFDMEqualized(:));

        % BER Calculation
        BERIm = BERCalc(txBits, rxBits);
    end
    
    % Output BER
    BER = BERIm(1);
    disp(['BER = ', num2str(BER), ' after ', num2str(BERIm(3)), ' bits.']);
end
