%do an
function SatelliteCommunication_QPSK_OFDM(EbNoValues, Rs, numSubcarriers, ...
    cpLength, numSymbolsPerFrame, numPilots, maxNumErrs, maxNumBits)
    rng(12345);
    % Display Start Message
    disp('Running BER simulation for Satellite Communication System...');
    disp('===========================================================');
    
    % Result storage
    BER = zeros(size(EbNoValues));
    
    % Iterate over Eb/No values
    for idx = 1:length(EbNoValues)
        EbNo = EbNoValues(idx);
        disp(['Simulating for Eb/No = ', num2str(EbNo), ' dB...']);
        
        % Run BER simulation for the current Eb/No
        BER(idx) = BERTool_QPSK_OFDM_RicianChannel(EbNo, Rs, ...
            numSubcarriers, cpLength, numSymbolsPerFrame, numPilots, ...
            maxNumErrs, maxNumBits);
    end
    
    % Plot BER Results
    figure;
    semilogy(EbNoValues, BER, '-o', 'LineWidth', 2);
    grid on;
    xlabel('Eb/No (dB)');
    ylabel('Bit Error Rate (BER)');
    title('BER Performance of Satellite Communication System');
    legend('QPSK over OFDM with Rician Channel');
end
