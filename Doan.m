%do an
EbNoValues = 0:2:20;         % Eb/No range (dB)
Rs = 1e6;                   % Symbol rate (1 Mbps)
numSubcarriers = 64;        % Number of OFDM subcarriers
cpLength = 16;              % Cyclic prefix length
numSymbolsPerFrame = 1000;  % Symbols per frame
numPilots = 8;              % Number of pilot subcarriers
maxNumErrs = 100;           % Maximum bit errors to simulate
maxNumBits = 1e6;           % Maximum number of bits to simulate

SatelliteCommunication_QPSK_OFDM(EbNoValues, Rs, numSubcarriers, ...
    cpLength, numSymbolsPerFrame, numPilots, maxNumErrs, maxNumBits);
