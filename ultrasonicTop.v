module ultrasonicTop(
    input clk,
    input reset,
    input start,
    input pulse,
    output [15:0] led,
    output reg measureReq,
    output [7:0] seg,
    output [3:0] an
    );
    
    
    reg [3:0] state;
    wire startW1, startDB, startOS;
    wire done;
    wire [31:0] stateCountVal;

    assign stateCountVal = 1100;
    reg [31:0] cnt;
    reg [13:0] microsCount;
    reg [13:0] displayVal;
    assign led = state;    
    localparam IDLE = 0, INIT = 1, WAIT = 2, MEASURE = 3, MEASUREDONE = 4;
    
    deBounce #(.CLKSPDMHZ(100), .DELAYMS(5)) db1 (.clk(clk), .reset(reset), .in(startW1), .out(startDB));
    Synchronizer #(.NUMBITS(1)) synch1 (.clk(clk), .in(start), .out(startW1));
    oneShot os1(.clk(clk), .in(startDB), .out(startOS), .reset(reset));
    
    assign enable = (state == INIT);
    
    customTimer cTime(.enable(enable), .microsLen(1100), .clk(clk), .done(done), .reset(reset));
    dispdHex dd(.clk(clk), .reset(reset), .indata(displayVal), .sseg(seg), .latchAN(an));
    
    always@(posedge clk)
    begin
        if(reset)
        begin
            state <= IDLE;
            displayVal <= 0;
        end
        else
        begin
            case(state)
            IDLE:
            begin
                cnt <= 0;
                microsCount <= 0;
                measureReq <= 0;
                if(startOS)
                    state <= INIT;
            end
            INIT:
            begin
                measureReq <= 1;
                if(done)
                    state <= WAIT;
            end
            WAIT:
            begin
                measureReq <= 0;
                if(pulse)
                    state <= MEASURE;
            end
            MEASURE:
            begin
                cnt <= cnt + 1;
                if(cnt == 99)
                begin
                    cnt <= 0;
                    microsCount <= microsCount + 1;
                end
                if(pulse == 0)
                    state <= MEASUREDONE;
            end
            MEASUREDONE:
            begin
                displayVal <= microsCount/58;
                state <= IDLE;
            end
            default:
                state <= IDLE;
            endcase
        end
    end
endmodule
