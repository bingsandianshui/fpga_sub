library verilog;
use verilog.vl_types.all;
entity find_start is
    generic(
        threshold       : integer := 5000;
        counts          : integer := 65200
    );
    port(
        Clk             : in     vl_logic;
        Rst_n           : in     vl_logic;
        data_in0        : in     vl_logic_vector(15 downto 0);
        Samp_en         : out    vl_logic
    );
    attribute mti_svvh_generic_type : integer;
    attribute mti_svvh_generic_type of threshold : constant is 1;
    attribute mti_svvh_generic_type of counts : constant is 1;
end find_start;
