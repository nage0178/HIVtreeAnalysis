#include <stdio.h>
#include <stdlib.h>
#include <gsl/gsl_rng.h>
#include <gsl/gsl_randist.h>
#include <assert.h>
#include <stdbool.h>
#include <math.h>

bool FloatEquals(double a, double b, double threshold) {
  return fabs(a-b) < threshold;
}

gsl_rng * r;  /* global generator */

void freeMemory(int lastTimeIndex, long int **storeVirusCount, long int **storeUninfectedCount, long int **storeInfectedCount,
  long int **storeLatentCompCount, long int **storeLatentIncompCount) ;

int main(void) {

  /*Set up random number generator */
  const gsl_rng_type * T;
  gsl_rng_env_setup();
  T = gsl_rng_default;
  r = gsl_rng_alloc(T);

  int print = 1; /* If 1, prints population size every 10000 events*/

  /* Parameters */
  double mLBlood = 100; /* uL of blood in the body. Need to get an estimate.*/
  /* CHECK TO MAKE SURE YOU DON'T HAVE PRECISION ISSUES */

  //CHANGE THESE
  /* Counts of State Variables */
  /* Initial values */
  long int numVirusInit = 1000;  //10 * mLBlood; /* 10^-6 virions per uL used in paper */
  //assert(numVirusInit > 0);
  long int numCellUninfectInit = 1e4 * mLBlood; /* I was unsure if this saw the initial used in the paper
  This changes the birth rate. */
  long int numCellInfectInit = 100; //* mLBlood;
  long int numLatentCompInit = 0;
  long int numLatentIncompInit = 0;

  // This is only going to give the appropriate number is only 1 lineage to start with. 
  long long unsigned  numNodes = 1;

  /* Patient 8 parameters from Strafford paper */
  double uninfectedBirth = 170 * mLBlood; /* lambda */
  double uninfectDeath = 0.017;   /* d */
  double uninfectToInfect = 8 * 1e-7 / mLBlood; /* kappa */
  double virusBirth = 730;       /* p */
  double virusDeath = 3;         /* c */
  double infectedDeath = .31;       /* delta */

  double probLatent = 0.00116;       /* eta */
  double reactLatent = .000057;      /* alpha */
  double probDefect = 0.95;       /* gamma */
  double latIncompDeath = 0.00011;      /* tau */
  double latCompDeath = 0.00052;   /* sigma */

  uninfectToInfect = uninfectToInfect/ (1-probDefect) / (1- probLatent);

  /* Probabilities of each event */
  double probUninfectedBirth;
  double probUninfectToInfect;
  double probUninfectDeath;
  double probInfectedDeath;
  double probVirusBirth;
  double probVirusDeath;

  double probUninfectToLatIncomp;
  double probUninfectToLatComp;
  double probLatIncompDeath;
  double probLatCompDeath;
  double probLatReact;

  double totRate; /* Total rate of events */

  /* Updated throughout the program */
  long int numVirus;
  long int numCellInfect;
  long int numCellUninfect;
  long int numLatentComp;
  long int numLatentIncomp;

  /* Times */
  double totTime = 0;
  double timesCheckCount[7] = {1, 2, 3, 4, 5, 10, 365}; /* List of times to check population size */
  int timeCheckIndex = 0; /* Index of the next time to check population size */
  int lastTimeIndex =  sizeof(timesCheckCount) / sizeof(timesCheckCount[0]) - 1;
  double timeART = 300;
  double setART = 1;

  /* Random number */
  double waitTime; /* Exponential waiting time */
  double unif; /* Uniform random number */
  int numEvents = 0; /* Total number of events that have occured */

  int numRep = 1; /* Number of Simulations */
  /* Stores the number of cells/viruses at the specified times for all of the
  replicate simulations */
  long int **storeVirusCount, **storeUninfectedCount, **storeInfectedCount;
  long int **storeLatentCompCount, **storeLatentIncompCount;
  storeUninfectedCount   = malloc((lastTimeIndex + 1) * sizeof(long int *));
  storeInfectedCount     = malloc((lastTimeIndex + 1) * sizeof(long int *));
  storeVirusCount        = malloc((lastTimeIndex + 1) * sizeof(long int *));
  storeLatentCompCount   = malloc((lastTimeIndex + 1) * sizeof(long int *));
  storeLatentIncompCount = malloc((lastTimeIndex + 1) * sizeof(long int *));

  if (storeVirusCount == NULL || storeUninfectedCount == NULL || storeInfectedCount == NULL ||
    storeLatentCompCount == NULL || storeLatentIncompCount == NULL) {
    fprintf(stderr, "Insufficient Memory\n");
    exit(1);
  }

  for(int i = 0; i < lastTimeIndex + 1; i++) {
    storeUninfectedCount[i]   = malloc(numRep * sizeof(long int));
    storeInfectedCount[i]     = malloc(numRep * sizeof(long int));
    storeVirusCount[i]        = malloc(numRep * sizeof(long int));
    storeLatentCompCount[i]   = malloc(numRep * sizeof(long int));
    storeLatentIncompCount[i] = malloc(numRep * sizeof(long int));

    if (storeUninfectedCount[i] == NULL || storeInfectedCount[i] == NULL || storeVirusCount[i] == NULL ||
    storeLatentCompCount[i] == NULL || storeLatentIncompCount[i] == NULL) {
      fprintf(stderr, "Insufficient Memory\n");
      exit(1);
    }
  }

  /* Set the number of viruses/cells equal to -1 at all times.
  Used to ensure that the average number of viruses/cells is conditional on
  none of the populations going extinct */
  for (int i = 0; i < lastTimeIndex + 1; i++) {
    for (int j = 0; j < numRep; j++) {
      storeUninfectedCount[i][j]   = -1;
      storeInfectedCount[i][j]     = -1;
      storeVirusCount[i][j]        = -1;
      storeLatentCompCount[i][j]   = -1;
      storeLatentIncompCount[i][j] = -1;
    }
  }

  if (print == 1) {
    printf("totTime, numVirus, numCellInfect, numCellUninfect, numLatentComp, numLatentIncomp\n");
  }

  /* Repeat the simulation numRep times */
  //for (int j = 0; j < numRep; j ++) {
  int j = 0;
  while (j < numRep){
    /* Reset the initial conditions for every simulation */
    numVirus        = numVirusInit;
    numCellUninfect = numCellUninfectInit;
    numCellInfect   = numCellInfectInit;
    numLatentComp   = numLatentCompInit;
    numLatentIncomp = numLatentIncompInit;

    timeCheckIndex = 0;
    totTime = 0;

    /* Continue simulating until the last time is reached or there are no viruses or no cells */
    while (totTime < timesCheckCount[lastTimeIndex] && ((numVirus + numCellInfect > 0 && numCellUninfect >= 0 && numCellInfect >= 0 && numCellInfect + numCellUninfect > 0) || setART == 0)) {
      /* Caluate rates */
      totRate = uninfectedBirth + (uninfectDeath + ((1-probLatent) * (1-probDefect) + probLatent) * uninfectToInfect * numVirus) * numCellUninfect + (infectedDeath + virusBirth) * numCellInfect
      + virusDeath * numVirus + (reactLatent + latCompDeath) * numLatentComp + latIncompDeath * numLatentIncomp;

      probUninfectedBirth = uninfectedBirth / totRate;
      probUninfectToInfect = (1 - probLatent) * (1 - probDefect) * uninfectToInfect * numVirus * numCellUninfect / totRate;
      probUninfectDeath = uninfectDeath * numCellUninfect / totRate;
      probInfectedDeath = infectedDeath * numCellInfect / totRate;
      probVirusBirth = virusBirth * numCellInfect / totRate;
      probVirusDeath = virusDeath * numVirus / totRate;

      probUninfectToLatIncomp = probDefect * probLatent * uninfectToInfect * numCellUninfect * numVirus / totRate ;
      probUninfectToLatComp = (1 - probDefect) * probLatent * uninfectToInfect * numCellUninfect * numVirus / totRate;
      probLatIncompDeath =  latIncompDeath * numLatentIncomp / totRate;
      probLatCompDeath = latCompDeath * numLatentComp / totRate;
      probLatReact = reactLatent * numLatentComp / totRate;

      assert(FloatEquals(probUninfectedBirth + probUninfectToInfect + probUninfectDeath
        + probInfectedDeath + probVirusBirth + probVirusDeath + probUninfectToLatIncomp +
        probUninfectToLatComp + probLatIncompDeath + probLatCompDeath + probLatReact, 1, 1e-14));

      waitTime = gsl_ran_exponential (r, 1 / totRate);
      totTime = totTime + waitTime;

      /* Prints population sizes for the first simulation */
      if (print == 1 && (numEvents % 1000000 == 0 ||  (numEvents % 10000 == 0 && setART == 0) ) && j == 0) {
        printf("%f, %ld, %ld, %ld, %ld, %ld \n", totTime, numVirus, numCellInfect, numCellUninfect, numLatentComp, numLatentIncomp);
        //printf("%f, %ld, %ld, %ld, %ld, %ld, %llu \n", totTime, numVirus, numCellInfect, numCellUninfect, numLatentComp, numLatentIncomp, numNodes);
      }

      unif = gsl_rng_uniform (r);
      numEvents++;

      if (setART && totTime > timeART) {
	uninfectToInfect = 0;
	totTime = timeART;
	setART = 0;

      }

      /* If the time is passed the sample time, record the number of every class */
      if (totTime >= timesCheckCount[timeCheckIndex]) {
        /* Keep track of state variables at specific time */
        storeUninfectedCount[timeCheckIndex][j]   = numCellUninfect;
        storeInfectedCount[timeCheckIndex][j]     = numCellInfect;
        storeVirusCount[timeCheckIndex][j]        = numVirus;
        storeLatentCompCount[timeCheckIndex][j]   = numLatentComp;
        storeLatentIncompCount[timeCheckIndex][j] = numLatentIncomp;
        timeCheckIndex++;
      }

      /* Uninfected birth */
      if (unif < probUninfectedBirth) {
        numCellUninfect++;

        /* Uninfected cell becomes infected */
      } else if (unif < probUninfectedBirth + probUninfectToInfect) {
        numCellUninfect--;
        numCellInfect++;
	numNodes++; 

        /* Uninfected cell dies */
      } else if (unif < probUninfectedBirth + probUninfectToInfect + probUninfectDeath) {
        numCellUninfect--;

        /* Infected cell dies */
      } else if (unif < probUninfectedBirth + probUninfectToInfect + probUninfectDeath + probInfectedDeath) {
        numCellInfect--;

        /* Virus is born */
      } else if (unif < probUninfectedBirth + probUninfectToInfect + probUninfectDeath + probInfectedDeath + probVirusBirth) {
        numVirus++;
	numNodes++; 

        /* Virus dies */
      } else if (unif < probUninfectedBirth + probUninfectToInfect + probUninfectDeath
        + probInfectedDeath + probVirusBirth + probVirusDeath) {
        numVirus--;

        /* Uninfected cell becomes latent replication incompetent cell*/
      } else if (unif < probUninfectedBirth + probUninfectToInfect + probUninfectDeath
        + probInfectedDeath + probVirusBirth + probVirusDeath + probUninfectToLatIncomp) {
          numCellUninfect--;
          numLatentIncomp++;
	  numNodes++; 

        /* Uninfected cell becomes latent replication competent cell*/
      } else if (unif < probUninfectedBirth + probUninfectToInfect + probUninfectDeath
        + probInfectedDeath + probVirusBirth + probVirusDeath + probUninfectToLatIncomp +
        probUninfectToLatComp) {
          numCellUninfect--;
          numLatentComp++;
	  numNodes++; 

        /* Latent replication incompetent cell death */
      } else if (unif < probUninfectedBirth + probUninfectToInfect + probUninfectDeath
        + probInfectedDeath + probVirusBirth + probVirusDeath + probUninfectToLatIncomp +
        probUninfectToLatComp + probLatIncompDeath) {
          numLatentIncomp--;

        /* Latent replication competent cell death */
      } else if (unif < probUninfectedBirth + probUninfectToInfect + probUninfectDeath
        + probInfectedDeath + probVirusBirth + probVirusDeath + probUninfectToLatIncomp +
        probUninfectToLatComp + probLatIncompDeath + probLatCompDeath ) {
          numLatentComp--;

        /* Latent virus reactivates */
      } else {
        numLatentComp--;
        numCellInfect++;
      }

    }
    if (totTime < timesCheckCount[lastTimeIndex]) {
      printf("Did not finish %f %ld %ld %ld %ld %ld\n", totTime, numCellUninfect, numCellInfect, numVirus, numLatentComp, numLatentIncomp);
      printf("Starting again\n");
      j--;

    }
    j++;
  }

  freeMemory(lastTimeIndex, storeVirusCount, storeUninfectedCount, storeInfectedCount, storeLatentCompCount, storeLatentIncompCount);

  //printf("Number of nodes: %llu\n", numNodes); 
  gsl_rng_free (r);
  return(0);
}

void freeMemory(int lastTimeIndex, long int **storeVirusCount, long int **storeUninfectedCount, long int **storeInfectedCount,
  long int **storeLatentCompCount, long int **storeLatentIncompCount) {
    for(int i = 0; i < lastTimeIndex + 1; i++) {
      free(storeUninfectedCount[i]);
      free(storeInfectedCount[i]);
      free(storeVirusCount[i]);
      free(storeLatentCompCount[i]);
      free(storeLatentIncompCount[i]);

    }
    free(storeUninfectedCount);
    free(storeInfectedCount);
    free(storeVirusCount);
    free(storeLatentCompCount);
    free(storeLatentIncompCount);

}

void findAverage(int lastTimeIndex, int numRep, long int **storeVirusCount, long int **storeUninfectedCount, long int **storeInfectedCount,
  long int **storeLatentCompCount, long int **storeLatentIncompCount) {

    int numberFinish[lastTimeIndex + 1]; /* Number of replicates that finished */

    /* Stores the average number of cells/viruses at each specified time */
    double* averageUninfected = malloc(sizeof(double) * (lastTimeIndex + 1));
    double* averageInfected   = malloc(sizeof(double) * (lastTimeIndex + 1));
    double* averageVirus      = malloc(sizeof(double) * (lastTimeIndex + 1));
    double* averageLatComp    = malloc(sizeof(double) * (lastTimeIndex + 1));
    double* averageLatIncomp  = malloc(sizeof(double) * (lastTimeIndex + 1));

    for (int i = 0; i < lastTimeIndex + 1; i++) {
      averageUninfected[i]  = 0;
      averageInfected[i]    = 0;
      averageVirus[i]       = 0;
      averageLatComp[i]     = 0;
      averageLatIncomp[i]   = 0;
    }

    for (int timeCount = 0; timeCount < lastTimeIndex + 1; timeCount++) {
      numberFinish[timeCount] = numRep;

      for (int repCount = 0; repCount < numRep; repCount++) {
        /* If the simulation stopped before the given time, decrease the number of
        replicates that finished */
        if (storeVirusCount[timeCount][repCount] == -1) {
          numberFinish[timeCount]--;

        } else {
          averageUninfected[timeCount] = averageUninfected[timeCount] + storeUninfectedCount[timeCount][repCount];
          averageInfected[timeCount]   = averageInfected[timeCount]   + storeInfectedCount[timeCount][repCount];
          averageVirus[timeCount]      = averageVirus[timeCount]      + storeVirusCount[timeCount][repCount];
          averageLatComp[timeCount]    = averageLatComp[timeCount]    + storeLatentCompCount[timeCount][repCount];
          averageLatIncomp[timeCount]  = averageLatIncomp[timeCount]  + storeLatentIncompCount[timeCount][repCount];

        }

      }
      averageUninfected[timeCount] = averageUninfected[timeCount] / numberFinish[timeCount];
      averageInfected[timeCount]   = averageInfected[timeCount]   / numberFinish[timeCount];
      averageVirus[timeCount]      = averageVirus[timeCount]      / numberFinish[timeCount];
      averageLatComp[timeCount]    = averageLatComp[timeCount]    / numberFinish[timeCount];
      averageLatIncomp[timeCount]  = averageLatIncomp[timeCount]  / numberFinish[timeCount];

      //printf("%f %f %f %f %d\n", timesCheckCount[timeCount], averageUninfected[timeCount], averageInfected[timeCount], averageVirus[timeCount], numberFinish[timeCount]);

    }
    free(averageUninfected);
    free(averageInfected);
    free(averageVirus);
    free(averageLatComp);
    free(averageLatIncomp);

  }
