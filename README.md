# Triple DES (Data Encryption Standard)

## File Structure

- `rtl/`
  - `des_core.sv`: 
  - `func_f.sv`: 
  - `func_ks.sv`: 
  - `tdes_core.sv`: 
  - `tdes_top.sv`: 
- `obj_dir/`: Directory containing object files and executables generated during Verilator simulation
- `tb.cpp`: Testbench top-level file
- `Makefile`: Makefile script to run the testbench
- `README.md`: Project documentation
- `LICENSE`: License information

## Running the Testbench

The provided testbench is designed for simulation using Verilator. Ensure Verilator is installed before running the testbench. Refer to the [Verilator GitHub page](https://github.com/verilator/verilator) for installation instructions.

1. Clone this repository:

   ```bash
   git clone https://github.com/shsjung/tdes-systemverilog.git
   ```

2. Navigate to the `tdes-systemverilog` directory and run the following command:

   ```bash
   make
   ```

## License

This project is distributed under the MIT License. See the [LICENSE](./LICENSE) file for details.

## Contributions

Contributions are welcome! Please open an issue or submit a Pull Request if you'd like to contribute to this project.

## Reference

1. [Recommendation for the Triple Data Encryption Algorithm (TDEA) Block Cipher: NIST SP 800-67 Rev. 2](https://csrc.nist.gov/pubs/sp/800/67/r2/final)
2. [NIST to Withdraw Special Publication 800-67 Revision 2]((https://csrc.nist.gov/news/2023/nist-to-withdraw-sp-800-67-rev-2)
