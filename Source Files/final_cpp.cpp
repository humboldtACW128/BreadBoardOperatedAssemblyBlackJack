 //to compile: g++ final_cpp.cpp final.s -lwiringPi -g -o final
 
#include <stdio.h>      /* printf, scanf, puts, NULL */
#include <stdlib.h>     /* srand, rand */
#include <time.h>       /* time */
#include <string>

extern "C" int getRandomKind();
extern "C" int getRandomSuit();
extern "C" void start();
int getRandomKind();

int main() {
	//Random function seed instantiation which is kinda trash honestly
	srand(static_cast<unsigned int>(time(NULL)));

	start();//Start the game
	return 0;
}


int  getRandomKind() {
	int random = rand() % 13 + 1; //Get random number from 0-12
	return random; //return random number
}
	
int getRandomSuit() {
	int random = rand() % 4 + 1;  //Get random number from 0-3
	return random;//return random number
}
