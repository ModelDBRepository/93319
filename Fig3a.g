// This script plots a spike train like the
// simulated one in Fig. 3a

float PI = 3.141592654

int	i
float dt = 1e-5
float sim_time = 1
setclock 0 {dt}
setclock 1 1e-4
setmethod 11
// setmethod 0

float NMDA=0
float AMPA=0.0

include library
include finish

make_cell cell.p neuron

include xout_fig3a

create spikegen /neuron/soma/spike
setfield /neuron/soma/spike thresh -0.035 abs_refract 0.010 output_amp 1

create spikehistory spike.history
setfield spike.history ident_toggle 0 \ // index specification
                                  filename "spikes.dat" \
                                  initialize 1 leave_open 1 flush 1

addmsg /neuron/soma/spike spike.history SPIKESAVE

reset

// setfield neuron chanmode 0
// if hsolve is used
 call /neuron SETUP
 reset

setfield /neuron/soma inject 0.5e-9
step 1 -t












