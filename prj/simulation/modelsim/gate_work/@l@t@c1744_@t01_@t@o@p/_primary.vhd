library verilog;
use verilog.vl_types.all;
entity LTC1744_T01_TOP is
    port(
        altera_reserved_tms: in     vl_logic;
        altera_reserved_tck: in     vl_logic;
        altera_reserved_tdi: in     vl_logic;
        altera_reserved_tdo: out    vl_logic;
        Clk             : in     vl_logic;
        Rst_n           : in     vl_logic;
        data0           : in     vl_logic_vector(13 downto 0);
        FST3253_0       : out    vl_logic_vector(1 downto 0);
        FST3253_OEN_0   : out    vl_logic;
        ENC_P_0         : out    vl_logic;
        ENC_N_0         : out    vl_logic;
        OF_0            : in     vl_logic;
        data1           : in     vl_logic_vector(13 downto 0);
        FST3253_1       : out    vl_logic_vector(1 downto 0);
        FST3253_OEN_1   : out    vl_logic;
        ENC_P_1         : out    vl_logic;
        ENC_N_1         : out    vl_logic;
        OF_1            : in     vl_logic;
        data2           : in     vl_logic_vector(13 downto 0);
        FST3253_2       : out    vl_logic_vector(1 downto 0);
        FST3253_OEN_2   : out    vl_logic;
        ENC_P_2         : out    vl_logic;
        ENC_N_2         : out    vl_logic;
        OF_2            : in     vl_logic;
        data_temp       : out    vl_logic_vector(13 downto 0);
        led             : out    vl_logic
    );
end LTC1744_T01_TOP;
