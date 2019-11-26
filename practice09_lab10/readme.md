# Lab 10
## 실습 내용
### **Practice09**
#### **module nco** :
FPGA의 50MHz clock을 o_gen_clk을 통해 1Hz clk으로 변경
	

#### **module fnd_dec** : 
카운터의 값에 따라 seven_segment display에 나타나는 값을 0~9로 표기할 수 있도록함. 

#### **module	double_fig_sep** :
0~59의 값을 갖는 6bit의 입력 신호를 받아 10의자리수, 1의 자리수를 각각 4bit로 출력함.
(10의 자리수 -> 10으로 나눈 몫 )
(1의 자리수 -> 10으로 나눈 나머지 )


#### **module	led_disp**:
FPGA의 6개의 seven segment와 dp가 뜨도록 함
카운터의 값에 따라 seven_segment display에 나타나는 값을 0~9로 표기. 
dp부분도 언제 출력될 지 결정

#### **module	ir_rx**:
LEADERCODE받은 후에 32bit의 data 받은 후 reset되도록 state machine 작성.
parameter 1㎲로 하여 ms단위 측정.

STATE MACHINE
Idle 에서 항상 leadercode 기다림, 
들어온 data의 bit수 저장하기 위해 cnt32사용, 대기하는동안 항상 0.

1이


#### **module	top**:
위의 모듈들 모두 연결



 결과 ### **Top Module Waveform 검증**
![](https://github.com/jlee0942/LogicDesign/blob/master/practice09_lab10/KakaoTalk_20191126_182425768.png)

### **FPGA 동작 사진 (3개- 일반, Q1, Q2)**
`Please fill up your source`


> Written with [StackEdit](https://stackedit.io/).
<!--stackedit_data:
eyJoaXN0b3J5IjpbLTk5NTYyODExNl19
-->
