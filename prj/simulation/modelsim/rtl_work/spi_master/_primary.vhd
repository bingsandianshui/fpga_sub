library verilog;
use verilog.vl_types.all;
entity spi_master is
    generic(
        cnt_Cs_n_35us_max: integer := 7000;
        cnt_send_words_max: integer := 2165
    );
    port(
        Clk200M         : in     vl_logic;
        Rst_n           : in     vl_logic;
        start_send      : in     vl_logic;
        set_speed       : in     vl_logic_vector(2 downto 0);
        data0           : in     vl_logic_vector(15 downto 0);
        data1           : in     vl_logic_vector(15 downto 0);
        data2           : in     vl_logic_vector(15 downto 0);
        Cs_n            : out    vl_logic;
        Clk_out         : out    vl_logic;
        MOSI            : out    vl_logic;
        finish_n        : out    vl_logic;
        rdreq0          : out    vl_logic;
        rdreq1          : out    vl_logic;
        rdreq2          : out    vl_logic
    );
    attribute mti_svvh_generic_type : integer;
    attribute mti_svvh_generic_type of cnt_Cs_n_35us_max : constant is 1;
    attribute mti_svvh_generic_type of cnt_send_words_max : constant is 1;
end spi_master;
