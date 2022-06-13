CC = gcc
CFLAGS=-Wall -g -O3
LDADD=`pkg-config --libs glib-2.0`

latency_ODE: latency_ODE.c
	$(CC) $(CFLAGS) latency_ODE.c -lgsl -lgslcblas -lm -g -o latency_ODE


clean:
	$(RM) latency_ODE 
