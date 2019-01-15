main:	strcpy.o main.o
	gcc -g -O2 strcpy.o main.o -o main

clean:
	rm -fr *.o
	rm -fr main
