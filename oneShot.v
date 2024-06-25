module oneShot(
    input clk,
    input in,
    input reset,
    output reg out
    );
    
    reg [1:0] state;
    
    localparam idle = 0;
    localparam output1 = 1;
    localparam waitOnzero = 2;     
    
    always@(posedge clk)
    begin
        if(reset)
        begin
            state <= idle;
        end
        else
        begin
            case(state)
            idle:
                begin
                    if(in)
                    begin
                        state <= output1;
                    end
                end
            output1:
                begin
                    state <= waitOnzero;
                end
            waitOnzero:
                begin
                    if(~in)
                    begin
                        state <= idle;
                    end
                end
            default:
                begin
                    state <= idle;
                end
            endcase
        end
    end
    
    always@(state)
    begin
        case(state)
            idle:out = 0;
            output1:out = 1;
            waitOnzero:out = 0;
            default:out = 0;
        endcase
    end
endmodule
