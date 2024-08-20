//utility class to store reusable Luhn functions

function leftToRightLuhnChecksum(inputNumber) {
    let sum = 0;

    for (let i = 0; i < inputNumber.length; i++) {
        let currentNumber = parseInt(inputNumber[i]);

        if ((i + 1) % 2 === 0) {
            currentNumber *= 2;
            if (currentNumber > 9) {
                currentNumber -= 9;
            }
        }
        sum += currentNumber;
    }
    return sum % 10 === 0;
}

export {leftToRightLuhnChecksum}