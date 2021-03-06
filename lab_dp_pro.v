module lab_dp_pro(
input clock,
input reset,
input [7:0]Input,
input IRload,JMPmux,PCload,Meminst,MemWr,
input [1:0]Asel,
input Aload,Sub,
output  Aeq0,Apos,
output [2:0]IR75,
output [7:0]OUT,
output [4:0]meminst,
output [7:0]da70,q70,ir70,
output [4:0]pc40,a70
);

wire [4:0]PC40;
wire [7:0]A70,IR70,Q70;
wire [7:0]addSubOUT,XOROUT;



reg [7:0]DA70;
reg [4:0]address;
reg [4:0]JMPm,Memm;
reg [7:0]Aselm,DIR,SubData;


ModuleReg #(8)IRregister(clock,IRload,reset,DIR,IR70);
ModuleReg #(5)PCregister(clock,PCload,reset,JMPm,PC40);
ModuleReg #(8)Aregister(clock,Aload,reset,DA70,A70);
RamReg RAM(clock,address,MemWr,A70,Q70);

always@* begin
	if(Meminst)
		address=IR70[4:0];
	else
		address=PC40;
		
		
	if(JMPmux)
		JMPm=IR70[4:0];
	else
		JMPm=PC40+1;
	if(Sub)
		SubData=A70-Q70;
	else
		SubData=A70+Q70;
	
	DIR=Q70;
	end
	
always@(Asel,SubData,Input,Q70)begin
	case(Asel)
	0:DA70=SubData;
	1:DA70=Input;
	2:DA70=Q70;
	default:DA70=0;
	endcase
	end
	
	assign Aeq0=~(|A70);
	assign Apos=~(A70>>7);  
	assign OUT=A70;
	assign IR75=IR70[7:5];
	assign meminst=address;
	assign da70=DA70;
	assign q70=Q70;
	assign ir70=IR70;
  assign pc40=PC40;
  assign a70=A70;
	endmodule

