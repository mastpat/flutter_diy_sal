class AccountOpeningRequest {
  String mobileNumber;
  String email;
  String aadhaarNumber;
  String panNumber;
  bool agreedToTerms;

  AccountOpeningRequest({
    required this.mobileNumber,
    required this.email,
    required this.aadhaarNumber,
    required this.panNumber,
    required this.agreedToTerms,
  });

  Map<String, dynamic> toJson() => {
    "mobileNumber": mobileNumber,
    "email": email,
    "aadhaarNumber": aadhaarNumber,
    "panNumber": panNumber,
    "agreedToTerms": agreedToTerms,
  };
}
