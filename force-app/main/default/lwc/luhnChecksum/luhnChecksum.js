/**
 * @description       : Utility class to store Luhn checksum functions
 * @author            : Cornelia Smit
 * @group             :
 * @last modified on  : 19-08-2024
 * @last modified by  : Cornelia Smit
 * Modifications Log
 * Ver   Date         Author                    Modification
 * 1.0   19-08-2024   Cornelia Smit             Initial Version
 **/
function leftToRightLuhnChecksum(inputNumber) {
  let sum = 0;

  for (let i = 0; i < inputNumber.length; i++) {
    // eslint-disable-next-line radix
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

export { leftToRightLuhnChecksum };
