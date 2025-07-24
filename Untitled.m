% T?o k?ch b?n v? tinh
startTime = datetime(2024, 11, 14, 12, 0, 0);
stopTime = datetime(2024, 11, 15, 12, 0, 0);
sampleTime = 60; % C?p nh?t m?i phút
scenario = satelliteScenario(startTime, stopTime, sampleTime);

% Thêm v? tinh t? file TLE
sat = satellite(scenario, "satelliteData.tle");

% Thêm tr?m m?t ??t t?i m?t ??a ?i?m c? th?
groundStation = groundStation(scenario, 10.762622, 106.660172); % Ho Chi Minh City

% Hi?n th? và ch?y k?ch b?n
show(scenario);
play(scenario);
