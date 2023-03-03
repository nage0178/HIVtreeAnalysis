#include <stdio.h>
#include <stdlib.h>
#include <gsl/gsl_rng.h>
#include <gsl/gsl_randist.h>
#include <time.h>
#include <assert.h>

int main (int argc, char **argv) {
	/* Tree shape ((A,B),C), C is latent */

	  /* Set up random number generator */
	gsl_rng * r;
	const gsl_rng_type * T;
	gsl_rng_env_setup();
	T = gsl_rng_default;
	r = gsl_rng_alloc(T);
 
	gsl_rng_set(r, time(0));


	double alpha = 5, beta = 10; 
	double BCLower = .3 , ALower = .10, rootLower = 0, t_BC, t_lA, timeRoot; 
	double ** ages; 
	long int samples = 1000000;
	long int rejected = 0;
	int i = 0;

	ages = malloc(sizeof(double *) * 3);
	for (i = 0; i < 3; i++) {
		ages[i] = malloc(sizeof(double) * samples);
	}

	i = 0;
	rootLower = (BCLower > ALower ? BCLower : ALower);
	printf("rep\tt_ABC\t t_Al\tt_BC\n");
	while (i < samples) {
		timeRoot =  rootLower + gsl_ran_gamma(r, alpha, 1/beta);
		assert(timeRoot != 0);

		t_BC= gsl_ran_flat(r, 0, timeRoot);
		t_lA = gsl_ran_flat(r, 0, timeRoot);
		

		if (t_BC < BCLower) {
			rejected++;
			continue;
		}
		if (t_lA < ALower) {
			rejected++;
			continue;
		}
		
		ages[0][i] = timeRoot;
		ages[1][i] = t_lA; 
		ages[2][i] = t_BC; 

		printf("%d\t%f\t%f\t %f\n", i, ages[0][i], ages[1][i], ages[2][i]); 
		i++;
	}

}
