#ifndef HIV_HEADER
#define HIV_HEADER
#define _GNU_SOURCE

#include <stdbool.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
//#include <glib.h>
#include <gsl/gsl_rng.h>
#include <gsl/gsl_randist.h>
#include <assert.h>
#include <time.h>
#include <getopt.h>
#include <unistd.h>
#include <regex.h>
#include <getopt.h>


/* Bifurcating tree */
struct NodeSampledTree {
  int name;
  double branchLength;
  double sample_time; /* 0 if not yet sampled otherwise time of sampling */
  struct NodeSampledTree* left;  /* NULL if no children*/
  struct NodeSampledTree* right; /* only viruses with no children are replicating */

  int isLatent;         /* 0 if active, 1 if latent */
  double totTimeLatent; /* Total time in a latent state on a branch*/

} ;

bool FloatEquals(double a, double b, double threshold);
struct NodeSampledTree* newNodeSampledTree(double branchLength, int num);
int makeTree(struct NodeSampledTree* node_ptr, char* treeString, int currChar);
void readLatent (struct NodeSampledTree* node, FILE* latentFile);
int simulateDnaTree(struct NodeSampledTree* node, int base, double instRate[4][4], const gsl_rng * r,
  char** alignment, int baseIndex, int nodeIndex, int* nodeNames, int* nodeLatentstate, double* nodeSampleTime, double gammaDraw);
int simulateDNABranch(int base, double instRate[4][4], double branchLength, const gsl_rng * r);
int countTips(struct NodeSampledTree* node, int count);
void printAlignment(char** alignment, int numSeq, int* nodeName, int* nodeLatentstate, double* sampleTime);
void printTree(struct NodeSampledTree* root_ptr, char* fileName);
char* NewickStringBranchLength(struct NodeSampledTree* node, char* treeString, double previousTime);
void clearTree(struct NodeSampledTree* node_ptr);
void writeSeed(unsigned int RGSeed);
int* readFasta(char* fastaSeq, int* numBases);
int* setStartSeq (int* numBases, int randomStart, double statFreq[], char* fastaSeq, gsl_rng *r);
void setSeed(int RGSeed, gsl_rng *r);

void makeAlignment(struct NodeSampledTree* root_ptr, int startSeq[], double instRate[4][4], char** alignment, int nodeNames[], int nodeLatentstate[], double nodeSampleTime[], int numBases, int numTips, gsl_rng *r, double alpha, int gammaRateVariation);
void clearMemory(struct NodeSampledTree* root_ptr, int numTips, int* nodeLatentstate, int* nodeNames, double* nodeSampleTime, char** alignment, char* treeString, gsl_rng *r);
char** allocateAlignmentMem(int numTips, int numBases);
void makeInstantaneousRate(double instRate[4][4], double statFreq[], double mu);
void checkInput(double statFreq[], double rateParams[], double mu);
void checkModelInput(int regMatch);

#endif
