module counterCeas #(
    parameter COUNT_TO = 12000000,       
    parameter PAUSE_TIME = 5           
) (
    input clk,
    input reset,
    input buton,
    output reg [31:0] count,
    output reg red,
    output reg yellow,
    output reg green,
    output reg red_p,
    output reg green_p,
    output reg [31:0] pause_timer,
    output reg pause_active

);

reg b;


always @(posedge clk or negedge reset) begin
    if (~reset) begin
        count <= 0;
        red <= 1;
        yellow <= 1;
        green <= 0;
        red_p <= 0;
        green_p <= 1;
        b <= 1;
        pause_timer <= 0;
        pause_active <= 0;
    end
    else begin
        if (buton == 0 && !pause_active) begin
            b <= 0;
        end

        if (count == COUNT_TO*5 && ~red) begin
            red <= 1;
            green <= 0;
            red_p <= 0;
            green_p <= 1;
            count <= 0;
        end
        else if (count == COUNT_TO*2 && ~yellow) begin
            yellow <= 1;
            red <= 0;
            red_p <= 1;
            green_p <= 0;
            b <= 1;
            count <= 0;
        end
        else if (count >= COUNT_TO*5 && ~b && ~green) begin
            yellow <= 0;
            green <= 1;
            count <= 0;
        end
        else begin
            count <= count + 1;
        end

        // Gestionarea pauzei
        if (pause_active) begin
            if (pause_timer >= PAUSE_TIME * COUNT_TO) begin
                pause_active <= 0;  // Dezactivăm pauza
            end else begin
                pause_timer <= pause_timer + 1;
            end
        end else if (b == 0 && buton == 0) begin
            pause_active <= 1;  // Activăm pauza
            pause_timer <= 0;
        end
    end
end

endmodule
