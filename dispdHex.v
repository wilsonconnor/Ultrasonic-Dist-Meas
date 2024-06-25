module dispdHex #(parameter CLK_FREQ = 100, parameter DISP_FREQ = 75)(
    input [15:0] indata,
    input clk,
    output reg[7:0] sseg,
    output reg[3:0] latchAN,
    input reset
    );
    
    reg[1:0] segselect;
    reg[15:0] data;
    wire[3:0] hex0, hex1, hex2, hex3;
    reg[31:0] count;
    
    
    localparam hex0stop = $rtoi(0.25 * CLK_FREQ * 1000000 / (DISP_FREQ*4));
    localparam hex1stop = $rtoi(0.5 * CLK_FREQ * 1000000 / (DISP_FREQ*4));
    localparam hex2stop = $rtoi(0.75 * CLK_FREQ * 1000000 / (DISP_FREQ*4));
    localparam hex3stop = $rtoi(1.0 * CLK_FREQ * 1000000 / (DISP_FREQ*4));
    
//    assign hex3 = indata[15:12];
//    assign hex2 = indata[11:8];
//    assign hex1 = indata[7:4];
//    assign hex0 = indata[3:0];

    binaryLookupDivideMod pipe(.clk(clk), .val(indata), .bcd3(hex3), .bcd2(hex2), .bcd1(hex1), .bcd0(hex0));
    
    always@(posedge clk)
    begin
        count <= count + 1;
        if(count < hex0stop)
            segselect <= 3;
        else if(count < hex1stop)
            segselect <= 2;
        else if(count < hex2stop)
            segselect <= 1;
        else if (count < hex3stop)
            segselect <= 0;
        else
            count <= 0;
    end
    
    reg [3:0] hexVal;
    reg [3:0] AN;
    
    always@(segselect, hex0, hex1, hex2, hex3)
    begin
        case(segselect)
            0:begin
                hexVal = hex0;
                AN = 4'b1110;
            end
            1:begin
                hexVal = hex1;
                AN = 4'b1101;
            end
            2:begin
                hexVal = hex2;
                AN = 4'b1011;
            end
            3:begin
                hexVal = hex3;
                AN = 4'b0111;
            end
        endcase
    end 
    
    always@(posedge clk)
    begin
        latchAN <= AN;
        case(hexVal)
            4'b0000: sseg <= 8'b11000000;
            4'b0001: sseg <= 8'b11111001;
            4'b0010: sseg <= 8'b10100100;
            4'b0011: sseg <= 8'b10110000;
            4'b0100: sseg <= 8'b10011001;
            4'b0101: sseg <= 8'b10010010;
            4'b0110: sseg <= 8'b10000010;
            4'b0111: sseg <= 8'b11111000;
            4'b1000: sseg <= 8'b10000000;
            4'b1001: sseg <= 8'b10011000;
            4'b1010: sseg <= 8'b10001000;
            4'b1011: sseg <= 8'b10000011;
            4'b1100: sseg <= 8'b10000111;
            4'b1101: sseg <= 8'b10100001;
            4'b1110: sseg <= 8'b10000110;
            4'b1111: sseg <= 8'b10001110;
            
            default: sseg <= 8'b11111111;
        endcase
    end
endmodule
