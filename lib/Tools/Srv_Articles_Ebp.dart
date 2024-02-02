class Article_Ebp {
  int ArticleID = 0;
  String Article_codeArticle = "";
  String Article_descriptionCommerciale = "";
  String Article_descriptionCommercialeEnClair = "";
  String Article_codeFamilleArticles = "";
  String Article_LibelleFamilleArticle = "";
  String Article_CodeSousFamilleArticle = "";
  String Article_LibelleSousFamilleArticle = "";
  double Article_PVHT = 0;
  double Article_tauxTVA = 0;
  String Article_codeTVA = "";
  double Article_PVTTC = 0;
  double Article_stockReel = 0;
  double Article_stockVirtuel = 0;
  String Article_Notes = "";
  bool     Article_Pousse     = false;
  double  Article_Promo_PVHT = 0;
  String  Article_Libelle     = "";
  String  Article_Groupe      = "";
  String  Article_Fam         = "";
  String  Article_Sous_Fam    = "";
  String  Article_codeArticle_Parent = "";

  static Article_EbpInit() {
    return Article_Ebp(0, "", "", "", "", "", "", "", 0, 0, "", 0, 0, 0, "", false, 0, "","","","", "");
  }

  Article_Ebp(int ArticleID, String Article_codeArticle, String Article_descriptionCommerciale, String Article_descriptionCommercialeEnClair, String Article_codeFamilleArticles, String Article_LibelleFamilleArticle, String Article_CodeSousFamilleArticle, String Article_LibelleSousFamilleArticle, double Article_PVHT, double Article_tauxTVA, String Article_codeTVA, double Article_PVTTC, double Article_stockReel, double Article_stockVirtuel, String Article_Notes,bool     Article_Pousse, double  Article_Promo_PVHT,String  Article_Libelle, String  Article_Groupe,String  Article_Fam, String  Article_Sous_Fam,String  Article_codeArticle_Parent) {
    this.ArticleID = ArticleID;
    this.Article_codeArticle = Article_codeArticle;
    this.Article_descriptionCommerciale = Article_descriptionCommerciale;
    this.Article_descriptionCommercialeEnClair = Article_descriptionCommercialeEnClair;
    this.Article_codeFamilleArticles = Article_codeFamilleArticles;
    this.Article_LibelleFamilleArticle = Article_LibelleFamilleArticle;
    this.Article_CodeSousFamilleArticle = Article_CodeSousFamilleArticle;
    this.Article_LibelleSousFamilleArticle = Article_LibelleSousFamilleArticle;
    this.Article_PVHT = Article_PVHT;
    this.Article_tauxTVA = Article_tauxTVA;
    this.Article_codeTVA = Article_codeTVA;
    this.Article_PVTTC = Article_PVTTC;
    this.Article_stockReel = Article_stockReel;
    this.Article_stockVirtuel = Article_stockVirtuel;
    this.Article_Notes = Article_Notes;
    this.Article_Pousse     = Article_Pousse;
    this.Article_Promo_PVHT = Article_Promo_PVHT;
    this.Article_Libelle = Article_Libelle;
    this.Article_Groupe = Article_Groupe;
    this.Article_Fam = Article_Fam;
    this.Article_Sous_Fam = Article_Sous_Fam;
    this.Article_codeArticle_Parent = Article_codeArticle_Parent;
  }


  factory Article_Ebp.fromJson(Map<String, dynamic> json) {
//    print("json $json");
    Article_Ebp warticleEbp = Article_Ebp(
      int.parse(json['ArticleID']),
      json['Article_codeArticle'],
      json['Article_descriptionCommerciale'],
      json['Article_descriptionCommercialeEnClair'],
      json['Article_codeFamilleArticles'],
      json['Article_LibelleFamilleArticle'],
      json['Article_CodeSousFamilleArticle'],
      json['Article_LibelleSousFamilleArticle'],
      double.parse(json['Article_PVHT']),
      double.parse(json['Article_tauxTVA']),
      json['Article_codeTVA'],
      double.parse(json['Article_PVTTC']),
      double.parse(json['Article_stockReel']),
      double.parse(json['Article_stockVirtuel']),
      json['Article_Notes'],
      int.parse(json['Article_Pousse']) == 1,
      double.parse(json['Article_Promo_PVHT']),
      json['Article_Libelle'],
      json['Article_Groupe'],
      json['Article_Fam'],
      json['Article_Sous_Fam'],
      json['Article_codeArticle_Parent'],
    );

    return warticleEbp;
  }

  String Desc() {
    return '$ArticleID,$Article_codeArticle,$Article_descriptionCommerciale,$Article_descriptionCommercialeEnClair,$Article_codeFamilleArticles,$Article_LibelleFamilleArticle,$Article_CodeSousFamilleArticle,$Article_LibelleSousFamilleArticle,$Article_PVHT,$Article_tauxTVA,$Article_codeTVA,$Article_PVTTC, $Article_stockReel, $Article_stockVirtuel, $Article_Notes $Article_Pousse    ,$Article_Promo_PVHT, $Article_Libelle   ,$Article_Groupe    ,$Article_Fam       ,$Article_Sous_Fam  ,$Article_codeArticle_Parent, ';
  }
}
