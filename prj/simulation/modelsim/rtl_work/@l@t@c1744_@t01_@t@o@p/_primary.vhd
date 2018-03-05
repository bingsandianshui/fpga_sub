library verilog;
use verilog.vl_types.all;
entity LTC1744_T01_TOP is
    port(
        Clk             : in     vl_logic;
        Rst_n           : in     vl_logic;
        data0           : in     vl_logic_vector(15 downto 0);
        FST3253_0       : out    vl_logic_vector(1 downto 0);
        FST3253_OEN_0   : out    vl_logic;
        ENC_P_0         : out    vl_logic;
        ENC_N_0         : out    vl_logic;
        OF_0            : in     vl_logic;
        led             : out    vl_logic;
        Cs_n            : out    vl_logic;
        Clk_out         : out    vl_logic;
        MOSI            : out    vl_logic
    );
end LTC1744_T01_TOP;
