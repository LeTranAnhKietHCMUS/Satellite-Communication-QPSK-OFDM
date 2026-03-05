# Satellite-Communication-QPSK-OFDM 🛰️

## 🇬🇧 English

A MATLAB simulation of a satellite communication system evaluating BER
(Bit Error Rate) performance using QPSK modulation over an OFDM framework
with a Rician fading channel and AWGN noise.

### Overview

The simulation models a realistic satellite link by combining QPSK modulation,
OFDM multi-carrier transmission, Rician fading (dominant LOS path), and AWGN.
It sweeps Eb/No from 0 to 20 dB and plots the resulting BER curve to evaluate
system performance.

### System Parameters
| Parameter | Value |
|---|---|
| Symbol Rate | 1 Mbps |
| OFDM Subcarriers | 64 |
| Cyclic Prefix Length | 16 |
| Pilot Subcarriers | 8 |
| Modulation | QPSK (2 bits/symbol) |
| Eb/No Range | 0 – 20 dB (step 2 dB) |
| Max Bit Errors | 100 |
| Max Bits Simulated | 1,000,000 |

### Channel Model
| Parameter | Value |
|---|---|
| Channel Type | Rician Fading + AWGN |
| Path Delays | [0, 1 µs] |
| Average Path Gains | [0, −10] dB |
| K-Factor | 10 (strong LOS) |
| Max Doppler Shift | 5 Hz |

### Signal Processing Chain
1. **Bit Generation** — Random binary data
2. **QPSK Modulation** — Phase offset π/4
3. **OFDM Framing** — Insert pilots, apply IFFT, add cyclic prefix
4. **Rician Channel** — Multipath fading with dominant LOS component
5. **AWGN** — Additive white Gaussian noise
6. **OFDM Receiver** — Remove CP, channel estimation via linear interpolation
7. **QPSK Demodulation** — Recover bits
8. **BER Calculation** — Compare transmitted vs received bits

### File Structure
| File | Description |
|---|---|
| `Doan.m` | Entry point — defines parameters and calls simulation |
| `SatelliteCommunication_QPSK_OFDM.m` | Loops over Eb/No, plots BER curve |
| `BERTool_QPSK_OFDM_RicianChannel.m` | Core simulation engine per Eb/No point |

### Requirements
- MATLAB R2020a or later
- Communications Toolbox

### How to Run
```matlab
run('Doan.m')
```

---

## 🇻🇳 Tiếng Việt

Mô phỏng MATLAB đánh giá hiệu năng BER (tỷ lệ lỗi bit) của hệ thống
thông tin vệ tinh sử dụng điều chế QPSK kết hợp OFDM trên kênh fading
Rician và nhiễu AWGN.

### Tổng quan

Mô phỏng xây dựng một liên kết vệ tinh thực tế bằng cách kết hợp điều chế
QPSK, truyền dẫn đa sóng mang OFDM, kênh fading Rician (thành phần LOS
mạnh) và nhiễu AWGN. Chương trình quét Eb/No từ 0 đến 20 dB và vẽ đường
cong BER để đánh giá hiệu suất hệ thống.

### Thông số hệ thống
| Thông số | Giá trị |
|---|---|
| Tốc độ ký hiệu | 1 Mbps |
| Số sóng mang OFDM | 64 |
| Độ dài cyclic prefix | 16 |
| Số pilot | 8 |
| Điều chế | QPSK (2 bit/ký hiệu) |
| Dải Eb/No | 0 – 20 dB (bước 2 dB) |
| Số lỗi bit tối đa | 100 |
| Số bit mô phỏng tối đa | 1.000.000 |

### Mô hình kênh truyền
| Thông số | Giá trị |
|---|---|
| Loại kênh | Rician Fading + AWGN |
| Độ trễ đường truyền | [0, 1 µs] |
| Suy hao trung bình | [0, −10] dB |
| Hệ số K | 10 (LOS mạnh) |
| Dịch Doppler tối đa | 5 Hz |

### Chuỗi xử lý tín hiệu
1. **Tạo bit** — Dữ liệu nhị phân ngẫu nhiên
2. **Điều chế QPSK** — Lệch pha π/4
3. **Đóng khung OFDM** — Chèn pilot, áp dụng IFFT, thêm cyclic prefix
4. **Kênh Rician** — Fading đa đường với thành phần LOS trội
5. **Nhiễu AWGN** — Nhiễu Gaussian trắng cộng
6. **Bộ thu OFDM** — Loại bỏ CP, ước lượng kênh qua nội suy tuyến tính
7. **Giải điều chế QPSK** — Khôi phục bit
8. **Tính BER** — So sánh bit phát và bit thu

### Cấu trúc file
| File | Mô tả |
|---|---|
| `Doan.m` | Điểm khởi chạy — khai báo tham số và gọi mô phỏng |
| `SatelliteCommunication_QPSK_OFDM.m` | Vòng lặp Eb/No, vẽ đường cong BER |
| `BERTool_QPSK_OFDM_RicianChannel.m` | Lõi mô phỏng cho từng điểm Eb/No |

### Yêu cầu
- MATLAB R2020a trở lên
- Communications Toolbox

### Cách chạy
```matlab
run('Doan.m')
```
