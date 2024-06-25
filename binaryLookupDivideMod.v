module binaryLookupDivideMod(
    input clk,
    input [15:0] val,
    output reg [3:0] bcd3,
    output reg [3:0] bcd2,
    output reg [3:0] bcd1,
    output reg [3:0] bcd0
    );
    
    reg [15:0] p1, p2;
    always@(posedge clk)
    begin
        bcd3 <= val/1000;
        p1 <= val%1000;
        bcd2 <= p1/100;
        p2 <= p1%100;
        bcd1 <= p2/10;
        bcd0 <= p2%10;
    end
endmodule
