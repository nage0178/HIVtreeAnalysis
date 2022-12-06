#include <stdio.h>
#include <stdlib.h>
#include <gsl/gsl_rng.h>
#include <gsl/gsl_randist.h>
#include <time.h>
#include <assert.h>

#define SWAP(x,y) do { __typeof__ (x) _t = x; x = y; y = _t; } while(0)

int main (int argc, char **argv) {
	/*  */

	  /* Set up random number generator */
	gsl_rng * r;
	const gsl_rng_type * T;
	gsl_rng_env_setup();
	T = gsl_rng_default;
	r = gsl_rng_alloc(T);
 
	gsl_rng_set(r, 1);

	double mu_alpha = 2, mu_beta = 200; 
	int samples = 4000;
	int i = 0;
	double mean[4] = {0, 0, 0, 0};
	double timeRoot = 3650;
	double time1, time2, time3;
	double tipDate = 1000;

	double * mu = malloc(sizeof(double) * samples);
	double ** ages = malloc(sizeof(double *) * 3);
	for (i = 0; i < 3; i++) {
		ages[i] = malloc(sizeof(double) * samples);
	}

	for (i = 0; i < samples; i++) {
		mu[i] = gsl_ran_gamma(r, mu_alpha, 1/mu_beta);

		time1 = gsl_ran_flat(r, 0, timeRoot);
		time2 = gsl_ran_flat(r, 0, timeRoot);
		time3 = gsl_ran_flat(r, 0, timeRoot);
		
		if (time1 > time2) 
			SWAP(time1, time2);
		if (time2 > time3)
			SWAP(time2, time3);
		if (time1 > time2) 
			SWAP(time1, time2);
		

		assert(time1 < time2);
		assert(time2 < time3);

		ages[0][i] = time1;
		ages[1][i] = time2; 
		ages[2][i] = time3; 

	}
	for (i = 0; i <samples; i ++) {
		printf("%.12f\t%f\t%f\t%f\t%f\t%f\n", mu[i]/tipDate, ages[0][i], ages[1][i], ages[2][i], timeRoot - ages[2][i], ages[2][i]-ages[1][i]);
	}

	for (i = 0; i < samples; i++) {
		mean[3] += mu[i]/samples/tipDate;
		for (int j = 0; j < 3; j++) 
			mean[j] += ages[j][i]/samples;

	}
	/*printf("Means: %f %f %f %f\n", mean[0], mean[1], mean[2], mean[3]); */

}
