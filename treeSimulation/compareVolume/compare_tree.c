#include <stdio.h>
#include <stdlib.h>
#include "dna_sim.h"
#include "string_utilities.h"
void findLastSampleTime(struct NodeSampledTree* node, int* nodeName, double* maxSampleTime);
int findHeight(struct NodeSampledTree* node, int nodeName, double* height);
double findRootAge (struct NodeSampledTree* node) ;
void treeLength(struct NodeSampledTree* node, double* length);
double percentTimeLatent(struct NodeSampledTree* root);
void totLatentTimeTree(struct NodeSampledTree* node, double* timeLatent);

void findLastSampleTime(struct NodeSampledTree* node, int* nodeName, double* maxSampleTime) {
  if(node->left == NULL) {
    if(node->sample_time > *maxSampleTime) {
      *nodeName = node->name;
      *maxSampleTime = node->sample_time;
    }
  } else {
    findLastSampleTime(node->left, nodeName, maxSampleTime);
    findLastSampleTime(node->right, nodeName, maxSampleTime);
  }
  return;
}

int findHeight(struct NodeSampledTree* node, int nodeName, double* height) {
  int left, right;
  if(node->left == NULL) {
    if(node->name == nodeName) {
      *height = node->branchLength;
      return 1;
    } else {
      return 0;
    }
  } else {
    left = findHeight(node->left, nodeName, height);
    right = findHeight(node->right, nodeName, height);
  }
  if (left || right) {
    *height = *height + node->branchLength;
    return 1;
  } else {
    return 0;
  }
}

//NOT DONE
double findRootAge (struct NodeSampledTree* node) {
  int nodeName;
  double maxSampleTime, height;
  findLastSampleTime(node, &nodeName, &maxSampleTime);
  findHeight(node, nodeName, &height); //Need to check if this is adding the branchLength at the root
  return height - node->branchLength;

}

double percentTimeLatent(struct NodeSampledTree* root) {
  double length = 0;
  treeLength(root, &length);
  double timeLatent = 0;
  totLatentTimeTree(root, &timeLatent);
  return timeLatent / length;
}

void treeLength(struct NodeSampledTree* node, double* length) {
  if(node->left == NULL) {
    *length = *length + node->branchLength;
  } else {
    treeLength(node->left, length);
    treeLength(node->right, length );
    *length = *length + node->branchLength;

  }

}

void totLatentTimeTree(struct NodeSampledTree* node, double* timeLatent) {
  if(node->left == NULL) {
    *timeLatent = *timeLatent +  node->totTimeLatent;
  } else {
    totLatentTimeTree(node->left, timeLatent);
    totLatentTimeTree(node->right, timeLatent);
    *timeLatent = *timeLatent + node->totTimeLatent;
  }

}

int main (int argc, char **argv) {
  char* treeFile = argv[1];
  char* latentHistoryFile = argv[2];
  char *treeString = string_from_file(treeFile);

  /*Make a tree */
  /* Note that  birth times are actually branch lengths-figure out if they are where you want them to be */
  struct NodeSampledTree* root_ptr = newNodeSampledTree(0, 1);
  int endChar = makeTree(root_ptr, treeString, 0);
  if (treeString[endChar] != '\0') {
    fprintf(stderr, "Problem reading in tree. Did not reach the end of the file \n");
    exit(1);
  }

  FILE *latentFile;
  latentFile = fopen(latentHistoryFile, "r");
  readLatent(root_ptr, latentFile);
  fclose(latentFile);

  double length = 0 ;
  treeLength(root_ptr, &length);
  printf("Tree Length: %f\n", length);

  double timeLatent = 0 ;
  totLatentTimeTree(root_ptr ,&timeLatent);
  printf("Total time Latent: %f\n", timeLatent);

  printf("Percent time latent: %f\n", percentTimeLatent(root_ptr));

  double rootage = findRootAge(root_ptr);
  printf("Root age: %f\n", rootage);

}
