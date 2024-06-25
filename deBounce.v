module deBounce #(parameter CLKSPDMHZ = 100, parameter DELAYMS = 5)(
    input clk,
    input in,
    input reset,
    output reg out
    );
   
    wire [20:0] dbCount = CLKSPDMHZ*DELAYMS*1000;
    reg cntDn;
    
    reg[2:0] state;
    
    localparam output0 = 0;
    localparam detect1 = 1;
    localparam output1 = 2;
    localparam detect0 = 3;
    
    always@(posedge clk)
    begin
        if(reset)
        begin
            state <= output0;
        end
        else
        begin
            case(state)
            output0:
                begin
                    if(in == 1)
                    begin
                        state <= detect1;
                    end
                end
            detect1:
                begin
                    if(cntDn == 1)
                    begin
                        state <= output1;
                    end
                end
            output1:
                begin
                    if(in == 0)
                    begin
                        state <= detect0;
                    end
                end
            detect0:
                begin
                    if(cntDn == 1)
                    begin
                        state <= output0;
                    end
                end
            default:
                begin
                    state <= output0;
                end
            endcase
        end
    end
    
    reg[21:0] cnt;
    always@(posedge clk)
    begin
        if(reset)
        begin
            cnt <= 0;
            cntDn <= 0;
        end
        else
        begin
            if(state == output0 || state == output1)
                cnt <= 0;
            else if (state == detect0 || state == detect1)
                cnt <= cnt + 1;
            
            if(cnt > dbCount)
            begin
                cntDn <= 1;
                cnt <= 0;
            end
            else
                cntDn <= 0;
        end      
    end
    
    always@(state)
    begin
        case(state)
            output0:out = 0;
            detect1:out = 0;
            output1:out = 1;
            detect0:out = 1;
            default:out = 0;
        endcase
    end
    
endmodule
