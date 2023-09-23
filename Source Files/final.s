 //to compile: g++ final_cpp.cpp final.s -lwiringPi -g -o final

.equ INPUT, 0
.equ OUTPUT, 1
.equ LOW, 0
.equ HIGH, 1
.equ LEDR_PIN, 29	// wiringPi 29
.equ LEDG_PIN, 28	// wiringPi 28
.equ LEDB_PIN, 27	// wiringPi 27
.equ HIT_PIN,  26	// wiringPi 26
.equ STND_PIN, 6    // wiringPi 28
.equ A_PIN,    25	// wiringPi 25
.equ B_PIN,    24	// wiringPi 24
.equ C_PIN,    23	// wiringPi 23
.equ D_PIN,    22	// wiringPi 22
.equ E_PIN,    21	// wiringPi 21
.data
playerValue: .word 0
dealerValue: .word 0
intr_msg: .asciz "Welcome to my blackjack game!\n"
strt_msg: .asciz "Press the left button to start.\n"
info_msg: .asciz "The left button will be used to hit and the right button can be used to stand.\n"
deal_msg: .asciz "Hello World!\n"
test_msg: .asciz "New deck value of %d \n"
end_msg: .asciz "Thanks for playing my black jack game.\n"
dealer_win: .asciz "The dealer won the game\n"
player_win: .asciz "The player won the game\n"
push_win: .asciz "You and dealer had the same value and the game ended in a draw\n"
hit_msg: .asciz "Press the left button to hit and the right button to stand\n"
deal_initd: .asciz "The dealer has been dealt his initial cards\n"
deal_initp: .asciz "The player has been dealt his initials cards\n"
dealer_dealt: .asciz "The dealer has been dealt all their cards\n"
.text
.balign 4
.global start
.global deal_first2

start:
	push {lr}
	bl wiringPiSetup // wiringPiSetup(); // initialize the wiringPi library

	mov r0, #HIT_PIN //pinMode(29,INPUT); // set the wpi 29 pin for input
	mov r1, #INPUT 	 //Move input into r1
	bl pinMode	 //pinMode function call
	mov r0, #HIT_PIN
	mov r1, #LOW	 //move low into r1
	bl digitalWrite	 //digitalWrite function call

	mov r0, #STND_PIN //pinMode(28,INPUT); // set the wpi 28 pin for input
	mov r1, #INPUT	  //move input into r1
	bl pinMode	  //pinMode function call
	mov r0, #STND_PIN //pinMode(28,INPUT); // set the wpi 28 pin for input
	mov r1, #LOW	  //mov low into r1
	bl digitalWrite	  //digitalWrite(STND_PIN, LOW)

	mov r0, #LEDR_PIN //pinMode(23,OUTPUT); // set the wpi 23 pin for output
	mov r1, #OUTPUT   // mov output into r1
	bl pinMode        // pinMode function call
	mov r0, #LEDR_PIN
	mov r1, #LOW
	bl digitalWrite

	mov r0, #LEDG_PIN //pinMode(24,OUTPUT); // set the wpi 24 pin for output
	mov r1, #OUTPUT	  //move output into r1
	bl pinMode        //pinMode function call
	mov r0, #LEDG_PIN
	mov r1, #HIGH
	bl digitalWrite

	mov r0, #LEDB_PIN //pinMode(25,OUTPUT); // set the wpi 25 pin for output
	mov r1, #OUTPUT   //move output into r1
	bl pinMode	  //pinMode function call
	mov r0, #LEDB_PIN
	mov r1, #LOW
	bl digitalWrite

	mov r0, #A_PIN	//move a pin into r0
	mov r1, #OUTPUT	//move output into r1
	bl pinMode	//pinMode function call
	mov r0, #A_PIN
	mov r1, #LOW
	bl digitalWrite

	mov r0, #B_PIN	//move b pin into r0
	mov r1, #OUTPUT //move output into r1
	bl pinMode	//pinMode function call
	mov r0, #B_PIN	//move b pin into r0
	mov r1, #LOW
	bl digitalWrite


	mov r0, #C_PIN	//move c pin into r0
	mov r1, #OUTPUT	//move output into r1
	bl pinMode	//pinMode function call
	mov r0, #C_PIN	//move c pin into r0
	mov r1, #LOW
	bl digitalWrite


	mov r0, #D_PIN	//move d pin into r0
	mov r1, #OUTPUT	//move output into r1
	bl pinMode	//pinMode function call
	mov r0, #D_PIN	//move d pin into r0
	mov r1, #LOW
	bl digitalWrite


	mov r0, #E_PIN	//move e pin into r0
	mov r1, #OUTPUT //move output into r1
	bl pinMode	//pinMode function call
	mov r0, #E_PIN	//move e pin into r0
	mov r1, #LOW
	bl digitalWrite


	ldr r0, =intr_msg //load intro message into r0
	bl printf	  //Print intro message
	bl start_loop	  //branch to start loop

start_loop:

	ldr  r0, =strt_msg	//Load the start message into r0
	bl printf		//Press start message
	mov r0, #HIT_PIN	// Move hit pin into r0
	bl digitalRead          // digitalRead(HIT_PIN)
	cmp r0, #HIGH	 	// Check if button is pressed
	beq end_start_while 	// If pressed start game
	mov r0, #800		// Move 800 into r0
	bl delay	 	// Wait 8/10 seconds
	b start_loop		//Branch to the start loop to loop through the series again

end_start_while:
	ldr r0, =info_msg //Controls message is outputed to the screen
	bl printf //Printf function call
	b deal_first2 //deal first2 function call



deal_first2:

	bl getRandomKind//Get random number for the suit of the dealers first card
	mov r4, r0 //Save the random number in r4
	mov r1, #1 //Set r1 to 1 to make sure we are increasing the dealers hand
	cmp r4, #10//See if the card is a 10 or higher
	blge big_value //If the card is a 10 or higher than we want to add 10 to the dealers score
	bllt small_value//If the card is less than a ten then we assign the numeric value
	bl getRandomKind//Get random number for the suit of the dealers first card
	mov r4, r0 //Save the random number in r4
	mov r1, #1 //Set r1 to 1 to make sure we are increasing the dealers hand
	cmp r4, #10//See if the card is a 10 or higher
	blge big_value //If the card is a 10 or higher than we want to add 10 to the dealers score
	bllt small_value//If the card is less than a ten then we assign the numeric value
	ldr r0, =deal_initd
	bl printf

	bl getRandomKind//Give player first card
	mov r4, r0//////////////////////////////
	mov r1, #0//////////////////////////////
	cmp r4, #10/////////////////////////////
	blge big_value//////////////////////////
	bllt small_value////////////////////////

	bl getRandomKind//Give player second card
	mov r4, r0///////////////////////////////
	mov r1, #0///////////////////////////////
	cmp r4, #10//////////////////////////////
	blge big_value///////////////////////////
	bllt small_value/////////////////////////
	ldr r0, =deal_initp
	bl printf
	bl set_pins//////////////////////////////
	bl check4bj
	bl hit_loop
	b end_game

hit_loop:

	ldr r2, =playerValue//Load memory address of player value
	ldr r2, [r2]//Store value of player value
	cmp r2, #21 //Compare to see if the player has 21
	ldreq r0, =player_win //If he does have 21 then he wins the game 
	bleq printf ////////////////////////////////////////////////////
	beq end_game// Exit the game
	ldrgt r0, =dealer_win// Print dealer win message if greater than 21
	push {r2}
	blgt printf /////////////////////////////////////////////////////////
	pop {r2}
	cmp r2, #21
	movgt r0, #LEDR_PIN
	movgt r1, #HIGH
	blgt digitalWrite
	movgt r0, #LEDG_PIN
	movgt r1, #LOW
	blgt digitalWrite
	cmp r2, #21
	bgt end_game// Exit the game if dealer wins
	ldr r0, =hit_msg//Print out hit message
	bl printf//////////////////////////////
	mov r0, #500//Small delay to make sure you dont hit immediately when starting the game
	bl delay//////////////////////////////////////////////////////////////////////////////
	mov r0, #HIT_PIN//Check if hit pin is being pressed
	bl digitalRead/////////////////////////////////////
	cmp r0, #HIGH//////////////////////////////////////
	beq give_card//If pressed give card
	mov r0, #STND_PIN//Check if the stand pin is pressed if so call det_win function
	bl digitalRead////////////////////////////////////////////////////////////////
	cmp r0, #HIGH/////////////////////////////////////////////////////////////////
	bleq det_win//////////////////////////////////////////////////////////////////
	mov r0, #800//Delay 800ms so it doesn't spam the message
	bl delay///////////////////////////////////////////////
	bal hit_loop//Always start the loop again


det_win:

	ldr r1, =dealerValue
	ldr r1, [r1]
	cmp r1, #16
	bllt dealer_turn
	ldr r0, =dealer_dealt
	bl printf
	ldr r0, =playerValue
	ldr r0, [r0]
	ldr r1, =dealerValue
	ldr r1, [r1]
	cmp r0, r1
	movlt r0, #LEDR_PIN
	movlt r1, #HIGH
	bllt digitalWrite
	movlt r0, #LEDG_PIN
	movlt r1, #LOW
	bllt digitalWrite

	ldrgt r0, =player_win
	ldrlt r0, =dealer_win
	ldreq r0, =push_win
	bl printf
	b end_game


dealer_turn:
	push {lr}
	bl getRandomKind//get random number
	mov r4, r0//Save number in r4
	mov r1, #1//Set dealer param for big_value/small_value
	cmp r0, #10//Comapre the value
	blge big_value//Function call
	bllt small_value//Function call
	ldr r0, =dealerValue//Getting dealer value
	ldr r0, [r0]/////////////////////////////
	cmp r0, #16//If dealer value less than 16 force them to hit until they have larger value
	blt dealer_turn// Branch to top
	cmp r0, #21//Compare with 21
	movgt r1, #1//If it's greater than 21 then set the dealers value 1 to let the player win in det_win function
	ldrgt r0, =dealerValue//Getting memomory address
	strgt r1, [r0]//Storing value back into dealerValue
	pop {pc}

give_card:
	push {lr}
	bl getRandomKind
	mov r4, r0
	cmp r4, #10
	mov r1, #0
	blge big_value
	bllt small_value
	bl set_pins 
	pop {pc}

check4bj:
	push {lr}
	ldr r0, =dealerValue
	ldr r0, [r0]
	cmp r0, #21
	ldreq r0, =dealer_win
	bleq printf
	bleq end_game
	ldr r0, =playerValue
	ldr r0, [r0]
	cmp r0, #21
	ldreq r0, =player_win
	bleq printf
	beq end_game
 	pop {pc}

end_game:
	ldr r0, =end_msg //Load the end message into r0
	bl printf //printf function call
	mov r0, #0  //return 0;
	pop {pc}

big_value:
	push {lr} //Save program position onto stack
	cmp r1, #1 //See if the cards are for the dealer
	ldreq r2, =dealerValue //If it is then add to the dealerValue
	ldrne r2, =playerValue //If not then add to the playerValue
	ldr r0, =test_msg  //Format string to see what number we got
	ldr r1, [r2] //Saving the handValue to  r1
	add r1, #10 //Adding the card value to handValue
	push {r0,r1,r2} //Save values onto stack since we are using printf
	bl printf
	pop {r0,r1,r2} //Retrieve values off the stack after function call
	str r1, [r2] //Saving the new value into the handValue
	pop {pc} //Return back to program position

small_value:
	push {lr} //Save program position onto stack
	cmp r1, #1 //See if the cards are for the dealer
	ldreq r2, =dealerValue //If it is then add to the dealerValue
	ldrne r2, =playerValue //If not then add to the playerValue
	ldr r0, =test_msg //Format string to see what number we got
	ldr r1, [r2] //Saving the handValue to r1
	add r1, r1, r4 //Adding card value to handValue
	push {r0,r1,r2} //Saving values onto stack since we are using printf
	bl printf//Print out card value 
	pop {r0,r1,r2} //Retrieve values off the stack after function call
	str r1, [r2] //Saving the new value into the handValue
	pop {pc} //Return back to program position
	mov lr, pc

set_pins:
	push {lr}


	ldr r2, =playerValue
	ldr r2, [r2]
//	ldr r0, =test_msg
//	push {r2}
//	bl printf
//	pop {r2}

	cmp r2, #1
	moveq r4, #LOW
	moveq r5, #LOW
	moveq r6, #LOW
	moveq r7, #LOW
	moveq r8, #HIGH
	cmp r2, #2
	moveq r4, #LOW
	moveq r5, #LOW
	moveq r6, #LOW
	moveq r7, #HIGH
	moveq r8, #LOW
	cmp r2, #3
	moveq r4, #LOW
	moveq r5, #LOW
	moveq r6, #LOW
	moveq r7, #HIGH
	moveq r8, #HIGH
	cmp r2, #4
	moveq r4, #LOW
	moveq r5, #HIGH
	moveq r6, #LOW
	moveq r7, #LOW
	moveq r8, #LOW
	cmp r2, #5
	moveq r4, #LOW
	moveq r5, #LOW
	moveq r6, #HIGH
	moveq r7, #LOW
	moveq r8, #HIGH
	cmp r2, #6
	moveq r4, #LOW
	moveq r5, #LOW
	moveq r6, #HIGH
	moveq r7, #HIGH
	moveq r8, #LOW
	cmp r2, #7
	moveq r4, #LOW
	moveq r5, #LOW
	moveq r6, #HIGH
	moveq r7, #HIGH
	moveq r8, #HIGH
	cmp r2, #8
	moveq r4, #LOW
	moveq r5, #HIGH
	moveq r6, #LOW
	moveq r7, #LOW
	moveq r8, #LOW
	cmp r2, #9
	moveq r4, #LOW
	moveq r5, #HIGH
	moveq r6, #LOW
	moveq r7, #LOW
	moveq r8, #HIGH
	cmp r2, #10
	moveq r4, #LOW
	moveq r5, #HIGH
	moveq r6, #LOW
	moveq r7, #HIGH
	moveq r8, #LOW
	cmp r2, #11
	moveq r4, #LOW
	moveq r5, #HIGH
	moveq r6, #LOW
	moveq r7, #HIGH
	moveq r8, #HIGH
	cmp r2, #12
	moveq r4, #LOW
	moveq r5, #HIGH
	moveq r6, #HIGH
	moveq r7, #LOW
	moveq r8, #LOW
	cmp r2, #13
	moveq r4, #LOW
	moveq r5, #HIGH
	moveq r6, #HIGH
	moveq r7, #LOW
	moveq r8, #HIGH
	cmp r2, #14
	moveq r4, #LOW
	moveq r5, #HIGH
	moveq r6, #HIGH
	moveq r7, #HIGH
	moveq r8, #LOW
	cmp r2, #15
	moveq r4, #LOW
	moveq r5, #HIGH
	moveq r6, #HIGH
	moveq r7, #HIGH
	moveq r8, #HIGH
	cmp r2, #16
	moveq r4, #HIGH
	moveq r5, #LOW
	moveq r6, #LOW
	moveq r7, #LOW
	moveq r8, #LOW
	cmp r2, #17
	moveq r4, #HIGH
	moveq r5, #LOW
	moveq r6, #LOW
	moveq r7, #LOW
	moveq r8, #HIGH
	cmp r2, #18
	moveq r4, #HIGH
	moveq r5, #LOW
	moveq r6, #LOW
	moveq r7, #HIGH
	moveq r8, #LOW
	cmp r2, #19
	moveq r4, #HIGH
	moveq r5, #LOW
	moveq r6, #LOW
	moveq r7, #HIGH
	moveq r8, #HIGH
	cmp r2, #20
	moveq r4, #HIGH
	moveq r5, #LOW
	moveq r6, #HIGH
	moveq r7, #LOW
	moveq r8, #LOW
	cmp r2, #21
	moveq r4, #HIGH
	moveq r5, #LOW
	moveq r6, #HIGH
	moveq r7, #LOW
	moveq r8, #HIGH


	mov r0, #A_PIN 
	mov r1, r4
	bl digitalWrite

	mov r0, #B_PIN 
	mov r1, r5
	bl digitalWrite

	mov r0, #C_PIN 
	mov r1, r6
	bl digitalWrite

	mov r0, #D_PIN 
	mov r1, r7
	bl digitalWrite

	mov r0, #E_PIN 
	mov r1, r8
	bl digitalWrite

	pop {pc}
