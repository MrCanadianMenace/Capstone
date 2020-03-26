#include "command_opts.h"

void scan_commands(int argc, char** argv, int &twiddle_size, std::string &output_file, bool &dryrun) {

    try {
        // Define the program options and attempt to parse the command line flags
        po::options_description desc("Options");
        desc.add_options()
            ("help,h", "Print this help message")
            ("dry-run,d", "Print out the generated values to stdout rather than write to file")
            ("size,n", po::value<int>()->required(), "Size of FFT")
            ("ofile,o", po::value<std::string>()->required(), "output file");

        po::variables_map vm;
        try {
            po::store(po::parse_command_line(argc, argv, desc), vm);    // Will throw an error if something is 
                                                                        // with input flags
            /** --help option **/
            if (vm.count("help")) {
                std::cout << "Capstone 2020 Simple FFT Calculation Application" << std::endl
                          << desc << std::endl;
                exit(0);
            }

            /** --dry-run option **/
            if (vm.count("dry-run")) 
                dryrun = true;
            else
                dryrun = false;

            po::notify(vm); // Throws on error, needs to be done after
                            // help case
        }
        catch(po::error& e) {
            std::cerr << "ERROR: " << e.what() << std::endl << std::endl;
            std::cerr << desc << std::endl;
            exit(1);
        }

        // Finally, retrieve the command line options
        output_file = vm["ofile"].as<std::string>();
        twiddle_size = vm["size"].as<int>() / 2;
    }
    catch(std::exception& e) {
        std::cerr << "Unhandled Exception: "
                  << e.what() << ", application now exiting" << std::endl;
        exit(2);
    }
}
