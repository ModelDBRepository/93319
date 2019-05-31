// This script plots a spike train when 
// Kt current is blocked

// Fig. 7 contains a portion of this spike train
// as well as others where KNa_fast, or both
// KNa_fast and Kt were blocked 

// Uncomment the appropriate line below
// in order to block KNa_fast channels

float PI = 3.141592654

int	i
float dt = 1e-5
float sim_time = 1.02
setclock 0 {dt}
setclock 1 1e-4
setmethod 11
// setmethod 0

float NMDA=0
float AMPA=0.0

include library
include finish

make_cell cell.p neuron

include xout_fig7

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

str comp

foreach comp ({el /neuron/##[OBJECT=compartment]})
    setfield {comp}/Kt Gbar 0
    // setfield {comp}/KNa_fast Gbar 0
end

step 0.020 -t

setfield /neuron/soma inject 2e-9
step 1 -t









