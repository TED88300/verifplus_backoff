class Article_Fam_Ebp {
  int Article_FamId = 0;
  String Article_Fam_Code = "";
  String Article_Fam_Code_Parent = "";
  String Article_Fam_Description = "";
  String Article_Fam_Libelle = "";
  String Article_Fam_UUID = "";

  static Article_Fam_EbpInit() {
    return Article_Fam_Ebp(
      0,
      "",
      "",
      "",
      "",
      "",
    );
  }

  Article_Fam_Ebp(int Article_FamId, String Article_Fam_Code, String Article_Fam_Code_Parent, String Article_Fam_Description, String Article_Fam_Libelle, String Article_Fam_UUID) {
    this.Article_FamId = Article_FamId;
    this.Article_Fam_Code = Article_Fam_Code;
    this.Article_Fam_Code_Parent = Article_Fam_Code_Parent;
    this.Article_Fam_Description = Article_Fam_Description;
    this.Article_Fam_Libelle = Article_Fam_Libelle;
    this.Article_Fam_UUID = Article_Fam_UUID;
  }

  factory Article_Fam_Ebp.fromJson(Map<String, dynamic> json) {
//    print("json $json");
    Article_Fam_Ebp warticleFamEbp = Article_Fam_Ebp(
      int.parse(json['Article_FamId']),
      json['Article_Fam_Code'],
      json['Article_Fam_Code_Parent'],
      json['Article_Fam_Description'],
      json['Article_Fam_Libelle'],
      json['Article_Fam_UUID'],
    );
    return warticleFamEbp;
  }

  String Desc() {
    return '  $Article_FamId,$Article_Fam_Code,$Article_Fam_Code_Parent,$Article_Fam_Description,$Article_Fam_Libelle, $Article_Fam_UUID ';
  }
}
