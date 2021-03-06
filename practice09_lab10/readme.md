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
seq_rx: leadercode 이후 들어오는 신호의 값을 순차적으로 monitoring하는 역할을 한다. 
이때 high(1) -> low(0)가 1세트씩 반복되면 reset후 다시 count해야하므로
0에서 1로 변하는 순간 reset 후 다시 count하기 시작하고, data가 0으로 유지될 때 cnt_l(0)가 1씩 증가한다. data가 1으로 유지될 때 cnt_h(1)가 1씩 증가함.



*STATE MACHINE*
Idle state
항상 leadercode 대기. 
들어온 data의 bit수 저장하기 위해 cnt32사용, 대기하는동안 항상 0.
cnt_h(1)이 8500, cnt_l(0)이 4000번 들어온 후(1㎲단위의 clk)에, DATACODE 받는 state로 진행하게 되고, 그렇지 않을 경우 계속 Leadercode state에 머무르게 됨.(즉, IDLE에서 LEADERCODE의 여부 판단)

DATACODE state
seq_rx가 2'b01일때만 cnt32의 값이 1씩 증가하고, 그 이외의 경우에는 변동이 없음.
cnt32의 값이 32가 되는순간 32bit의 데이터가 모두 들어오고(마지막 rising edge), 이떄 cnt_l(0)이 1000번 이상 들어왔을때(0이 1ms이상 즉 bit1일때) 다시 IDLE state로 돌아오고 위의 과정을 계속 반복한다. 그렇지 않을 경우 계속 DATACODE state에 머무르게됨


#### **module	top**:
위의 모듈들을 불러와서 모두 연결.



 결과 
### **Top Module Waveform 및 FPGA 동작 사진 **
![](https://github.com/jlee0942/LogicDesign/blob/master/practice09_lab10/KakaoTalk_20191126_182425768.png)
![](https://github.com/jlee0942/LogicDesign/blob/master/practice09_lab10/KakaoTalk_20191126_195247943.jpg)


> Written with [StackEdit](https://stackedit.io/).
<!--stackedit_data:
eyJoaXN0b3J5IjpbLTk5NTYyODExNl19
-->
