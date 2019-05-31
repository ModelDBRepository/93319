/******************************************************************************
**
**		Creating the library
**
**  We don't want the library to try to calculate anything, so we disable it
**
******************************************************************************/

if (!{exists /library})
	create neutral /library
	disable /library
end


/******************************************************************************
**
**	1	Including script files for prototype functions
**
******************************************************************************/


/* file for standard compartments */
include compartments 

/* file for tabulated Na, K, K_Ca, Ca etc ...  channels */
include tchan

/******************************************************************************
**
**  2	Invoking functions to make prototypes in the /library element
**
******************************************************************************/

/*	To ensure that all subsequent elements are made in the library    */
pushe /library

/*	Make the standard types of compartments  */

	make_cylind_compartment		/* makes "compartment"		*/
	make_cylind_symcompartment	/* makes "symcompartment"	*/

/*	Make the spike element */

	create spikegen	spike
		setfield spike	thresh 		-0.025	\
						abs_refract	0.005	\
						output_amp	1.0

/*	These are some standard channels used in .p files */
make_fast_Na_h_shifted_orig	0.007	0.010 3.0 15.0 1 fshNa		// makes "fshNa", fast
make_fast_Na_h_shifted_orig -0.001 0.000 10.0 10.0 1 fshNa-is
make_fast_Na_h_shifted_orig 0.007 0.010 3.0 15.0 1 fshNa-dend

	make_Ks 1								
	make_Kt	1 1 Kt						
	// make_Kt 1 1 Kt-is
    make_NMDA	
    make_bath_AMPA
	make_KNa_fast
	make_KNa_slow

	/* The Ca currents */
	make_Ca_L
    make_Ca_N
    make_Ca_LVA      
	make_Ca_NMDA		

	/* The K(Ca) channels (depending upon fast and slow Ca pools) */
	make_KCa_NMDA		
	make_KCa_N		

	make_Ca_pools

pope


    
