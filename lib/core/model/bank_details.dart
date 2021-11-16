class BankDetailsModel {
  String id, userID, accountHolderName, accountNumber, ifscCode;

  BankDetailsModel(
      {this.id,
      this.userID,
      this.accountHolderName,
      this.accountNumber,
      this.ifscCode});

  factory BankDetailsModel.fromJson(Map<String, dynamic> json) =>
      BankDetailsModel(
        id: json['id'].toString(),
        userID: json['userID'].toString(),
        accountHolderName: json['account_holder_name'].toString(),
        accountNumber: json['account_no'].toString(),
        ifscCode: json['ifsc_code'].toString(),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        'userID': userID,
        'account_holder_name': accountHolderName,
        'account_no': accountNumber,
        "ifsc_code": ifscCode
      };
}
