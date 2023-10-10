# 2023_Computer_Architecture
Here will upload the projects related to the course Computer Architecture in 2023.
But now is only Homework 1. :(
------------------------------------------------------------------------------------
# HW1
The goal of Homework 1 is to modify the concepts that was illustrated in the [Quiz1_2023](https://hackmd.io/@sysprog/arch2023-quiz1-sol).
We should choose one concept from Problem A to C, transfer the C code to RISC-V assembly code, and use the concept to complete further function.
The concept I choose is "Count Leading Zero (CLZ)" and the extended function is "The Image Binarization".
To focus on the implement of binarization and CLZ, I assume the input has already been transfer into array type.
The main function is to let the pixels (elements) convert to 0 if they are smaller than the "Threshold". And convert to 255 if bigger.
* The CLZ concept is mainly used in comparing the scalar of the elements.
* The [note page](https://hackmd.io/@edenlin/BkuFYLOxa) is proposed.
