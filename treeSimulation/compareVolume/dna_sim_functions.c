#include "dna_sim.h"
#include <ctype.h>
#include <math.h>


/* Create a new new node. Allocates memory for the node and the latency states
structure. Assignment values to the variables in the node structure */
struct NodeSampledTree* newNodeSampledTree(double branchLength, int num) {
  /* Allocates memory for a new node */
  struct NodeSampledTree* node_ptr;
  node_ptr  = (struct NodeSampledTree*)malloc(sizeof(struct NodeSampledTree));

  if (node_ptr == NULL) {
    fprintf(stderr, "Insufficient Memory\n");
    exit(1);
  }

  node_ptr->branchLength = branchLength;
  node_ptr->sample_time = 0;
  node_ptr->name = num;

  node_ptr->isLatent = 0;
  node_ptr->totTimeLatent = -1;

  /* Sets pointers to daughter nodes */
  node_ptr->left = NULL;
  node_ptr->right = NULL;
  return(node_ptr);
}

// Read in files

/* The function parses a string into a tree structure. Every time there's an open
parenthesis, two new nodes are created and the function is called twice. The
function keeps track of which character in the treeString (currChar) it is looking
at. */
int makeTree(struct NodeSampledTree* node_ptr, char* treeString, int currChar) {

  /* Note: You should never actually reach the end of string character. The last
  time you return is after the last closed parenthesis */
  while( treeString[currChar] != '\0') {

    /* If the current character is an open parenthesis, make new node, call
    makeTree recursively. currChar is updated along the way */
    if (treeString[currChar] == '(') {
      node_ptr->left = newNodeSampledTree(-1, -1);
      currChar = makeTree(node_ptr->left, treeString, currChar + 1);
      node_ptr->right = newNodeSampledTree(-1, -1);
      currChar = makeTree(node_ptr->right, treeString, currChar);


    } else {
      /* First, find the node name. Then, find the branch length. Return the
      current character */
      char* ptr; /* Needed for the strtod function */
      char* residualTreeString = malloc(strlen(treeString) + 1); /* Used so the original string isn't modified */
      strcpy(residualTreeString, treeString + currChar);

      regex_t regDecimal, regInt;
      int regCompiled, regMatch;
      /* Regex of decimal number */
      regCompiled = regcomp(&regDecimal, "^([0-9]+)((\\.)([0-9]+))$" , REG_EXTENDED);
      if (regCompiled == 1) {
        fprintf(stderr, "Regular expression did not compile.\n");
        exit(1);
      }
      /* Regex of integer number */
      regCompiled = regcomp(&regInt, "^([0-9]+)$" , REG_EXTENDED);
      if (regCompiled == 1) {
        fprintf(stderr, "Regular expression did not compile.\n");
        exit(1);
      }

      /* Finds the nodeName by looking for the next ":". Convert it into an
      integer, save it in the node structure. Update currChar. */
      char* nodeName = strtok(residualTreeString, ":"); /*Note this function modified residualTreeString */

      regMatch = regexec(&regInt, nodeName, 0, NULL, 0);
      if (regMatch != 0) {
        fprintf(stderr, "Problem reading in tree file. Regular expression does not match a integers.\n");
        exit(1);
      }

      node_ptr->name = atoi(nodeName);
      currChar = currChar + strlen(nodeName) + 1;

      residualTreeString = strcpy(residualTreeString, treeString + currChar);

      /* Finds the branch length, converts it to a double, saves it in the node
      structure */
      char* branchLength = strtok(residualTreeString, ",)");

      regMatch = regexec(&regDecimal, branchLength, 0, NULL, 0);
      if (regMatch != 0) {
        fprintf(stderr, "Problem reading in tree file. Regular expression does not match a decimal number.\n");
        exit(1);
      }
      node_ptr->branchLength = strtod(branchLength, &ptr);
      currChar = currChar + strlen(branchLength) + 1 ;

      free(residualTreeString);
      regfree(&regDecimal);
      regfree(&regInt);

      /* Returns the updated current character */
      return(currChar);
    }
  }
  return(currChar);
}

/* Reads in a file with the amount of time spent in a latent state */
/* Each row in the file is in the format:
nodeName(integer):totalTimeLatent,sampleTime,isLatent
isLatent is 1 if the tip is latent when sampled and 0 otherwise*/
void readLatent (struct NodeSampledTree* node, FILE* latentFile) {
  char buff[200];
  char* nodeName;
  char* ptr;
  double latentTime, sampleTime;
  int checkScan;

  checkScan = fscanf(latentFile, "%s", buff);
  if (checkScan == EOF) {
    fprintf(stderr, "Problem reading in latent states. fscanf returns EOF. Not enough lines in the file. \n");
    exit(1);
  }
  nodeName = strtok(buff, ":");

  /* Checks the node in the input file matches the current node */
  if (node->name != atoi(nodeName)) {
    fprintf(stderr, "Problem reading in latent states. States are not in the correct order or does not contain the correct nodes. \n");
    exit(1);
  }

  latentTime = strtod(buff + strlen(buff) + 1, &ptr);
  node->totTimeLatent = latentTime;

  sampleTime = strtod(ptr+1, &ptr);
  node->sample_time = sampleTime;

  node->isLatent = atoi(ptr + 1);
  if (node->isLatent != 0 && node->isLatent != 1) {
    fprintf(stderr, "Problem reading in latent states. The latent state is not a 0 or a 1. \n");
    exit(1);
  }

  if (node->left == NULL && node->right == NULL) {
    return ;

  } else {
    readLatent(node->left, latentFile);
    readLatent(node->right, latentFile);

  }
  return;
}


