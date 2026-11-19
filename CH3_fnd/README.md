# [CH 3] 4-digit Seven-Segment Display Controller


## 1. EDA & Board

![Vivado 2020.2 및 Xilinx Basys-3](./verilog_readme_intro.png)

---

## 2. Design Overview

8비트 정수(0~255)를 10진수로 변환하고, 4자리 7세그먼트 디스플레이에 한 자리씩 표시하는 제어기를 Verilog로 구현했습니다. 각 자리를 순서대로 켜면서 세그먼트 신호를 공유하는 **시분할 구동** 방식입니다.

### 설계 포인트

- **주사 타이밍** · `clk_div`는 100 MHz 입력에서 1 kHz 클록을 만듭니다. `counter_4`는 이 클록의 상승 에지마다 1의 자리부터 1000의 자리까지 순환합니다. 한 자리의 활성 시간은 정상 순환에서 1 ms이고, 같은 자리는 4 ms마다 다시 켜집니다.
- **10진수 변환** · `digit_splitter`는 나눗셈과 나머지 연산으로 각 자릿수를 구합니다. 8비트 입력 범위에서는 1000의 자리가 항상 0이며, 앞자리 0도 표시합니다.
- **자리와 숫자 동기화** · 같은 2비트 선택 신호 `w_digit_sel`이 `mux_4x1`과 `decoder_2x4`에 연결됩니다. `decoder_2x4`는 선택된 자리의 `fnd_com` 비트만 0으로 내려 활성화하고, `bcd`는 해당 숫자의 세그먼트 패턴을 `fnd_data`로 출력합니다.

[RTL 코드](rtl/fnd_controller.v)

---

## 3. Block Diagram

![클록 분주와 자리 선택, 10진 자릿수 분리와 세그먼트 출력 경로](./fnd-controller.drawio.png)

---

## 4. Simulation Scenario

[CH3_fnd.xpr](CH3_fnd.xpr)를 열고 `tb_fnd`를 시뮬레이션 최상위 모듈로 선택해 **Run Behavioral Simulation → Run All**을 실행합니다. [테스트벤치](tb/tb_fnd.v)의 동작 순서는 다음과 같습니다.

| 구간 | 입력 자극 | 확인 목적 |
|---|---|---|
| 0~10 ns | `reset = 1`, `fnd_in = 123` | 분주기와 자리 선택 카운터 초기화 |
| 10 ns 이후 | `reset = 0`, `fnd_in = 123` 유지 | 네 자리의 표시 순환 확인 |
| 리셋 해제 후 5.5 ms | `$stop` | 파형 관찰 종료 |

클록은 10 ns 주기(100 MHz)입니다. 리셋 직후 자리 선택은 0이며, 해제 약 0.5 ms 뒤 첫 자리 전환이 발생합니다. 이후 약 1 ms마다 다음 자리가 선택됩니다.

| 활성 자리 | 표시 숫자 | 기대 `fnd_com[3:0]` | 기대 `fnd_data[7:0]` |
|---|---:|---|---|
| 1의 자리 | 3 | `1110` | `8'hB0` |
| 10의 자리 | 2 | `1101` | `8'hA4` |
| 100의 자리 | 1 | `1011` | `8'hF9` |
| 1000의 자리 | 0 | `0111` | `8'hC0` |

`fnd_com`이 바뀔 때 같은 자리의 숫자 패턴이 `fnd_data`에 나오는지 확인합니다. 네 자리는 정상 순환에서 4 ms마다 반복되며 표시 값은 앞자리 0을 포함한 `0123`입니다. 테스트벤치는 파형 관찰용이며 [파형 설정 파일](waveform/tb_fnd_behav.wcfg)을 포함합니다.

---

## 5. Simulation Results

---

## 6. Demo

---
