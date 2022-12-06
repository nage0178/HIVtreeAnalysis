CC = gcc
CFLAGS=`pkg-config --cflags glib-2.0` -g -Wall -O3
LDADD=`pkg-config --libs glib-2.0`

simulateParameters: simulateParameters.c
	$(CC) $(CFLAGS) simulateParameters.c -lgsl -lgslcblas -lm -g -o simulateParameters

clean:
	$(RM) simulateParameters
