library verilog;
use verilog.vl_types.all;
entity LTC1744_T01 is
    generic(
        Samp_Time       : integer := 99;
        Samp_Up         : integer := 49
    );
    port(
        Clk             : in     vl_logic;
        Rst_n           : in     vl_logic;
        data_in         : in     vl_logic_vector(15 downto 0);
        FST3253         : out    vl_logic_vector(1 downto 0);
        OE_n            : out    vl_logic;
        ENC_P           : out    vl_logic;
        ENC_N           : out    vl_logic;
        data_out0       : out    vl_logic_vector(15 downto 0);
        data_out1       : out    vl_logic_vector(15 downto 0);
        data_out2       : out    vl_logic_vector(15 downto 0);
        data_out3       : out    vl_logic_vector(15 downto 0);
        one_turn        : out    vl_logic
    );
    attribute mti_svvh_generic_type : integer;
    attribute mti_svvh_generic_type of Samp_Time : constant is 1;
    attribute mti_svvh_generic_type of Samp_Up : constant is 1;
end LTC1744_T01;
