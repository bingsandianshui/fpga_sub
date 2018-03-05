library verilog;
use verilog.vl_types.all;
entity led_control is
    port(
        Clk             : in     vl_logic;
        Rst_n           : in     vl_logic;
        led             : out    vl_logic
    );
end led_control;
