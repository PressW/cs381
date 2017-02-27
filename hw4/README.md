# Karel Semantic Implementation

## Description
The Karel language is a simple imperative programming language for directing an on-screen robot. The robot can move around a grid, pick up and place “beepers”, and test aspects of its environment to determine what to do next. The syntax of the language is based on Pascal. You can read the documentation for an open source implementation of Karel, if you’re interested.

In this assignment, you’ll be implementing an interpreter for a slightly modified version of Karel. This version is feature-complete with the real Karel, but the syntax has been updated to be a bit more concise and orthogonal.

## File Overview
+ KarelSyntax.hs: Defines the abstract syntax of Karel.

+ KarelState.hs: Karel’s program state is rather complicated compared to the other languages we’ve defined. This file defines types for representing this state and also several helper functions that perform all of the basic operations you will need to write the semantics.

+ KarelExamples.hs: Provides some simple worlds and Karel programs to use in testing.

+ KarelTests.hs: A test suite for evaluating your semantics, and for helping you understand exactly how it should behave.

+ KarelSemantics.hs: The template you will be completing. The types of the required functions are provided, along with a couple example cases to get you started.

## Tasks
1. Define the evaluation functions for Test. A test is essentially a query over the state of the world and the state of the robot, which can either be true or false. Therefore, the semantic domain is: World -> Robot -> Bool.

2. Define the evaluation function for the first five constructs of Stmt (two of these are provided already). These statements manipulate the state of the world and/or robot. The ultimate result of evaluating a statement is a value of type Result. This is one of (1) an OK value that contains the updated state of the world and robot, (2) a Done value that should only be produced by the Shutdown statement, or (3) an Error value that contains an error message. Note that to get the tests to pass, you’ll have to reverse engineer the error messages by reading the doctests.

3. Extend the stmt evaluation function to handle blocks. Once you get to this point, you should be able to pass the first section of tests.

4. Extend the stmt function to handle conditional statements (If). Now you can hopefully pass the conditional tests.

5. Extend the stmt function to handle macro calls. The lookup function in the Haskell Prelude is very handy for this! Now you can hopefully pass the macro tests.

6. Finally, extend the stmt function to handle the looping constructs. Now you should be able to pass all of the tests!
