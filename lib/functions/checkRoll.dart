bool checkRoll(String rollNumber) {
  // TODO: Confirm this ***
  // TODO: Make a roll number regex
  bool correct = true;
  if (rollNumber.length != 9 || rollNumber[0] != '1') correct = false;
  return correct;
}
