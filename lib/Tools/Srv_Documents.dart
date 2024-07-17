class Document {
  int? DocID = 0;
  String? DocNom= "";
  String? DocDate= "";
  int? DocLength= 0;
  String? DocCRC= "";
  String? DocUserMat= "";

  Document(
      {this.DocID,
        this.DocNom,
        this.DocDate,
        this.DocLength,
        this.DocCRC,
        this.DocUserMat});

  Document.fromJson(Map<String, dynamic> json) {
    DocID =int.parse(json['DocID']);
    DocNom = json['DocNom'];
    DocDate = json['DocDate'];
    DocLength =  int.parse(json['DocLength']);
    DocCRC = json['DocCRC'];
    DocUserMat = json['DocUserMat'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['DocID'] = this.DocID;
    data['DocNom'] = this.DocNom;
    data['DocDate'] = this.DocDate;
    data['DocLength'] = this.DocLength;
    data['DocCRC'] = this.DocCRC;
    data['DocUserMat'] = this.DocUserMat;
    return data;
  }
}