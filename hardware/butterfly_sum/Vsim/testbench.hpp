#include "Vbutterfly_sum.h"
#include <verilated_vcd_c.h>

template<class MODULE> class TESTBENCH {

    public:
        unsigned long   m_tickcount;
        MODULE          *m_core;
        VerilatedVcdC   *m_trace;

        // Constructor
        TESTBENCH(void) {
            m_core = new MODULE;
            Verilated::traceEverOn(true);
            m_tickcount = 0l;
        }

        virtual void opentrace(const char *vcdname) {
            if (!m_trace) {
                m_trace = new VerilatedVcdC;
                m_core->trace(m_trace, 99);
                m_trace->open(vcdname);
            }
        }

        virtual void closetrace(void) {
            if (m_trace) {
                m_trace->close();
                m_trace = NULL;
            }
        }

        // Reset the module core
        virtual void reset(void) {
            m_core->i_RST = 1;
            // Ensure any inheritance gets applied
            this->tick();
            m_core->i_RST = 0;
        }

        // Increment clock signal to module core
        virtual void tick(void) {
            // Increment our own internal time reference
            m_tickcount++;

            /* Make sure any combinational logic depending upon
            * inputs that may have changed before we called tick()
            * has settled before the rising edge of the clock
            */
            m_core->i_CLK = 0;
            m_core->eval();

            // Dump to m_trace file
            if (m_trace) 
                m_trace->dump(10 * m_tickcount - 2);

            // Rising edge
            m_core->i_CLK = 1;
            m_core->eval();
            // Dump to m_trace file
            if (m_trace) 
                m_trace->dump(10 * m_tickcount);

            // Falling edge
            m_core->i_CLK = 0;
            m_core->eval();
            // Dump to m_trace file
            if (m_trace) {
                m_trace->dump(10 * m_tickcount + 5);

                /* Need to flush any I/O to the m_trace file so that
                 * we may use the assert() function between now and
                 * the next tick
                 */
                m_trace->flush();
            // Dump to trace file
            if (m_trace) 
                m_trace->dump(10 * m_tickcount);
            }
        }

        // 
        virtual bool done(void) { 
            return (Verilated::gotFinish()); 
        }

    
    // Destructor
    virtual ~TESTBENCH(void) {
        delete m_core;
        m_core = NULL;
    }
};
