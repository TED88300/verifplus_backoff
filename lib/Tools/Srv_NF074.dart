class NF074_Avertissements {
  int NF074_AvertissementsId = 0;
  String NF074_Avertissements_No = "";
  String NF074_Avertissements_Details = "";
  String NF074_Avertissements_Date_Fab = "";
  String NF074_Avertissements_Date_Fact = "";
  String NF074_Avertissements_Procedure = "";
  String NF074_Avertissements_Liens = "";

  NF074_Avertissements(
    int NF074_AvertissementsId,
    String NF074_Avertissements_No,
    String NF074_Avertissements_Details,
    String NF074_Avertissements_Date_Fab,
    String NF074_Avertissements_Date_Fact,
    String NF074_Avertissements_Procedure,
    String NF074_Avertissements_Liens,
  ) {
    this.NF074_AvertissementsId = NF074_AvertissementsId;
    this.NF074_Avertissements_No = NF074_Avertissements_No;
    this.NF074_Avertissements_Details = NF074_Avertissements_Details;
    this.NF074_Avertissements_Date_Fab = NF074_Avertissements_Date_Fab;
    this.NF074_Avertissements_Date_Fact = NF074_Avertissements_Date_Fact;
    this.NF074_Avertissements_Procedure = NF074_Avertissements_Procedure;
    this.NF074_Avertissements_Liens = NF074_Avertissements_Liens;
  }

  factory NF074_Avertissements.fromJson(Map<String, dynamic> json) {
    NF074_Avertissements wNF074_Avertissements = NF074_Avertissements(
      int.parse(json['NF074_AvertissementsId']),
      json['NF074_AvertissementsId'],
      json['NF074_Avertissements_No'],
      json['NF074_Avertissements_Details'],
      json['NF074_Avertissements_Date_Fab'],
      json['NF074_Avertissements_Date_Fact'],
      json['NF074_Avertissements_Procedure'],
    );
    return wNF074_Avertissements;
  }
}

class NF074_Gammes {
  int NF074_GammesId = 0;
  String NF074_Gammes_DESC = "";
  String NF074_Gammes_FAB = "";
  String NF074_Gammes_PRS = "";
  String NF074_Gammes_CLF = "";
  String NF074_Gammes_MOB = "";
  String NF074_Gammes_PDT = "";
  String NF074_Gammes_POIDS = "";
  String NF074_Gammes_GAM = "";
  String NF074_Gammes_CODF = "";
  String NF074_Gammes_REF = "";
  String NF074_Gammes_SERG = "";
  String NF074_Gammes_APD4 = "";
  String NF074_Gammes_AVT = "";
  String NF074_Gammes_NCERT = "";

  static NF074_GammesInit() {
    return NF074_Gammes(
      0,
      "",
      "",
      "",
      "",
      "",
      "",
      "",
      "",
      "",
      "",
      "",
      "",
      "",
      "",
    );
  }

  NF074_Gammes(
    int NF074_GammesId,
    String NF074_Gammes_DESC,
    String NF074_Gammes_FAB,
    String NF074_Gammes_PRS,
    String NF074_Gammes_CLF,
    String NF074_Gammes_MOB,
    String NF074_Gammes_PDT,
    String NF074_Gammes_POIDS,
    String NF074_Gammes_GAM,
    String NF074_Gammes_CODF,
    String NF074_Gammes_REF,
    String NF074_Gammes_SERG,
    String NF074_Gammes_APD4,
    String NF074_Gammes_AVT,
    String NF074_Gammes_NCERT,
  ) {
    this.NF074_GammesId = NF074_GammesId;
    this.NF074_Gammes_DESC = NF074_Gammes_DESC;
    this.NF074_Gammes_FAB = NF074_Gammes_FAB;
    this.NF074_Gammes_PRS = NF074_Gammes_PRS;
    this.NF074_Gammes_CLF = NF074_Gammes_CLF;
    this.NF074_Gammes_MOB = NF074_Gammes_MOB;
    this.NF074_Gammes_PDT = NF074_Gammes_PDT;
    this.NF074_Gammes_POIDS = NF074_Gammes_POIDS;
    this.NF074_Gammes_GAM = NF074_Gammes_GAM;
    this.NF074_Gammes_CODF = NF074_Gammes_CODF;
    this.NF074_Gammes_REF = NF074_Gammes_REF;
    this.NF074_Gammes_SERG = NF074_Gammes_SERG;
    this.NF074_Gammes_APD4 = NF074_Gammes_APD4;
    this.NF074_Gammes_AVT = NF074_Gammes_AVT;
    this.NF074_Gammes_NCERT = NF074_Gammes_NCERT;
  }

  factory NF074_Gammes.fromJson(Map<String, dynamic> json) {
    NF074_Gammes wNF074_Gammes = NF074_Gammes(
      int.parse(json['NF074_GammesId']),
      json['NF074_Gammes_DESC'],
      json['NF074_Gammes_FAB'],
      json['NF074_Gammes_PRS'],
      json['NF074_Gammes_CLF'],
      json['NF074_Gammes_MOB'],
      json['NF074_Gammes_PDT'],
      json['NF074_Gammes_POIDS'],
      json['NF074_Gammes_GAM'],
      json['NF074_Gammes_CODF'],
      json['NF074_Gammes_REF'],
      json['NF074_Gammes_SERG'],
      json['NF074_Gammes_APD4'],
      json['NF074_Gammes_AVT'],
      json['NF074_Gammes_NCERT'],
    );
    return wNF074_Gammes;
  }
}

class NF074_Histo_Normes {
  int NF074_Histo_NormesId = 0;
  String NF074_Histo_Normes_FAB = "";
  String NF074_Histo_Normes_NCERT = "";
  String NF074_Histo_Normes_ENTRMM = "";
  String NF074_Histo_Normes_ENTRAAAA = "";
  String NF074_Histo_Normes_SORTMM = "";
  String NF074_Histo_Normes_SORTAAAA = "";
  String NF074_Histo_Normes_SODT = "";
  String NF074_Histo_Normes_RTCH = "";
  String NF074_Histo_Normes_RTYP = "";
  String NF074_Histo_Normes_MVOL = "";
  String NF074_Histo_Normes_ADDF = "";
  String NF074_Histo_Normes_QTAD = "";
  String NF074_Histo_Normes_MEL = "";
  String NF074_Histo_Normes_AGEX = "";
  String NF074_Histo_Normes_FOY = "";
  String NF074_Histo_Normes_TEMP = "";
  String NF074_Histo_Normes_DURE = "";
  String NF074_Histo_Normes_TRSP = "";
  String NF074_Histo_Normes_MPRS = "";
  String NF074_Histo_Normes_GAZ = "";
  String NF074_Histo_Normes_USIN = "";

  static NF074_Histo_NormesInit() {
    return NF074_Histo_Normes(
      0,
      "",
      "",
      "",
      "",
      "",
      "",
      "",
      "",
      "",
      "",
      "",
      "",
      "",
      "",
      "",
      "",
      "",
      "",
      "",
      "",
      "",
    );
  }

  NF074_Histo_Normes(
    int NF074_Histo_NormesId,
    String NF074_Histo_Normes_FAB,
    String NF074_Histo_Normes_NCERT,
    String NF074_Histo_Normes_ENTRMM,
    String NF074_Histo_Normes_ENTRAAAA,
    String NF074_Histo_Normes_SORTMM,
    String NF074_Histo_Normes_SORTAAAA,
    String NF074_Histo_Normes_SODT,
    String NF074_Histo_Normes_RTCH,
    String NF074_Histo_Normes_RTYP,
    String NF074_Histo_Normes_MVOL,
    String NF074_Histo_Normes_ADDF,
    String NF074_Histo_Normes_QTAD,
    String NF074_Histo_Normes_MEL,
    String NF074_Histo_Normes_AGEX,
    String NF074_Histo_Normes_FOY,
    String NF074_Histo_Normes_TEMP,
    String NF074_Histo_Normes_DURE,
    String NF074_Histo_Normes_TRSP,
    String NF074_Histo_Normes_MPRS,
    String NF074_Histo_Normes_GAZ,
    String NF074_Histo_Normes_USIN,
  ) {
    this.NF074_Histo_NormesId = NF074_Histo_NormesId;
    this.NF074_Histo_Normes_FAB = NF074_Histo_Normes_FAB;
    this.NF074_Histo_Normes_NCERT = NF074_Histo_Normes_NCERT;
    this.NF074_Histo_Normes_ENTRMM = NF074_Histo_Normes_ENTRMM;
    this.NF074_Histo_Normes_ENTRAAAA = NF074_Histo_Normes_ENTRAAAA;
    this.NF074_Histo_Normes_SORTMM = NF074_Histo_Normes_SORTMM;
    this.NF074_Histo_Normes_SORTAAAA = NF074_Histo_Normes_SORTAAAA;
    this.NF074_Histo_Normes_SODT = NF074_Histo_Normes_SODT;
    this.NF074_Histo_Normes_RTCH = NF074_Histo_Normes_RTCH;
    this.NF074_Histo_Normes_RTYP = NF074_Histo_Normes_RTYP;
    this.NF074_Histo_Normes_MVOL = NF074_Histo_Normes_MVOL;
    this.NF074_Histo_Normes_ADDF = NF074_Histo_Normes_ADDF;
    this.NF074_Histo_Normes_QTAD = NF074_Histo_Normes_QTAD;
    this.NF074_Histo_Normes_MEL = NF074_Histo_Normes_MEL;
    this.NF074_Histo_Normes_AGEX = NF074_Histo_Normes_AGEX;
    this.NF074_Histo_Normes_FOY = NF074_Histo_Normes_FOY;
    this.NF074_Histo_Normes_TEMP = NF074_Histo_Normes_TEMP;
    this.NF074_Histo_Normes_DURE = NF074_Histo_Normes_DURE;
    this.NF074_Histo_Normes_TRSP = NF074_Histo_Normes_TRSP;
    this.NF074_Histo_Normes_MPRS = NF074_Histo_Normes_MPRS;
    this.NF074_Histo_Normes_GAZ = NF074_Histo_Normes_GAZ;
    this.NF074_Histo_Normes_USIN = NF074_Histo_Normes_USIN;
  }

  factory NF074_Histo_Normes.fromJson(Map<String, dynamic> json) {
    NF074_Histo_Normes wNF074_Histo_Normes = NF074_Histo_Normes(
      int.parse(json['NF074_Histo_NormesId']),
      json['NF074_Histo_Normes_FAB'],
      json['NF074_Histo_Normes_NCERT'],
      json['NF074_Histo_Normes_ENTR_MM'],
      json['NF074_Histo_Normes_ENTR_AAAA'],
      json['NF074_Histo_Normes_SORT_MM'],
      json['NF074_Histo_Normes_SORT_AAAA'],
      json['NF074_Histo_Normes_SODT'],
      json['NF074_Histo_Normes_RTCH'],
      json['NF074_Histo_Normes_RTYP'],
      json['NF074_Histo_Normes_MVOL'],
      json['NF074_Histo_Normes_ADDF'],
      json['NF074_Histo_Normes_QTAD'],
      json['NF074_Histo_Normes_MEL'],
      json['NF074_Histo_Normes_AGEX'],
      json['NF074_Histo_Normes_FOY'],
      json['NF074_Histo_Normes_TEMP'],
      json['NF074_Histo_Normes_DURE'],
      json['NF074_Histo_Normes_TRSP'],
      json['NF074_Histo_Normes_MPRS'],
      json['NF074_Histo_Normes_GAZ'],
      json['NF074_Histo_Normes_USIN'],
    );
    return wNF074_Histo_Normes;
  }
}

class NF074_Pieces_Det {
  int NF074_Pieces_DetId = 0;
  String NF074_Pieces_Det_NCERT = "";
  String NF074_Pieces_Det_RTYP = "";
  String NF074_Pieces_Det_DESC = "";
  String NF074_Pieces_Det_FAB = "";
  String NF074_Pieces_Det_PRS = "";
  String NF074_Pieces_Det_CLF = "";
  String NF074_Pieces_Det_MOB = "";
  String NF074_Pieces_Det_PDT = "";
  String NF074_Pieces_Det_POIDS = "";
  String NF074_Pieces_Det_GAM = "";
  String NF074_Pieces_Det_CODF = "";
  String NF074_Pieces_Det_SERG = "";
  String NF074_Pieces_Det_CdeArtFab = "";
  String NF074_Pieces_Det_DescriptionFAB = "";
  String NF074_Pieces_Det_Source = "";
  String NF074_Pieces_Det_Editon = "";
  String NF074_Pieces_Det_Revision = "";
  String NF074_Pieces_Det_Prescriptions = "";
  String NF074_Pieces_Det_Commentaires = "";
  String NF074_Pieces_Det_CodeArticle = "";
  String NF074_Pieces_Det_CodeArticlePD1 = "";
  String NF074_Pieces_Det_DescriptionPD1 = "";
  int NF074_Pieces_Det_Inst = 0;
  int NF074_Pieces_Det_VerifAnn = 0;
  int NF074_Pieces_Det_Rech = 0;
  int NF074_Pieces_Det_MAA = 0;
  int NF074_Pieces_Det_Charge = 0;
  int NF074_Pieces_Det_RA = 0;
  int NF074_Pieces_Det_RES = 0;
  String NF074_Pieces_Det_CodeArticlePD2 = "";
  String NF074_Pieces_Det_DescriptionPD2 = "";
  int NF074_Pieces_Det_QtePD2 = 0;
  String NF074_Pieces_Det_CodeArticlePD3 = "";
  String NF074_Pieces_Det_DescriptionPD3 = "";
  int NF074_Pieces_Det_QtePD3 = 0;



  static NF074_Pieces_DetInit() {
    return NF074_Pieces_Det(
      0,
      "",
      "",
      "",
      "",
      "",
      "",
      "",
      "",
      "",
      "",
      "",
      "",
      "",
      "",
      "",
      "",
      "",
      "",
      "",
      "",
      "",
      "",
      0,
      0,
      0,
      0,
      0,
      0,
      0,
      "",
      "",
      0,
      "",
      "",
      0,

    );
  }

  NF074_Pieces_Det(
    int NF074_Pieces_DetId,
    String NF074_Pieces_Det_NCERT,
    String NF074_Pieces_Det_RTYP,
    String NF074_Pieces_Det_DESC,
    String NF074_Pieces_Det_FAB,
    String NF074_Pieces_Det_PRS,
    String NF074_Pieces_Det_CLF,
    String NF074_Pieces_Det_MOB,
    String NF074_Pieces_Det_PDT,
    String NF074_Pieces_Det_POIDS,
    String NF074_Pieces_Det_GAM,
    String NF074_Pieces_Det_CODF,
    String NF074_Pieces_Det_SERG,
    String NF074_Pieces_Det_CdeArtFab,
    String NF074_Pieces_Det_DescriptionFAB,
    String NF074_Pieces_Det_Source,
    String NF074_Pieces_Det_Editon,
    String NF074_Pieces_Det_Revision,
    String NF074_Pieces_Det_Prescriptions,
    String NF074_Pieces_Det_Commentaires,
    String NF074_Pieces_Det_CodeArticle,
    String NF074_Pieces_Det_CodeArticlePD1,
    String NF074_Pieces_Det_DescriptionPD1,
    int NF074_Pieces_Det_Inst,
    int NF074_Pieces_Det_VerifAnn,
    int NF074_Pieces_Det_Rech,
    int NF074_Pieces_Det_MAA,
    int NF074_Pieces_Det_Charge,
    int NF074_Pieces_Det_RA,
    int NF074_Pieces_Det_RES,
    String NF074_Pieces_Det_CodeArticlePD2,
    String NF074_Pieces_Det_DescriptionPD2,
      int NF074_Pieces_Det_QtePD2,
    String NF074_Pieces_Det_CodeArticlePD3,
    String NF074_Pieces_Det_DescriptionPD3,
      int NF074_Pieces_Det_QtePD3,
  ) {
    this.NF074_Pieces_DetId = NF074_Pieces_DetId;
    this.NF074_Pieces_Det_NCERT = NF074_Pieces_Det_NCERT;
    this.NF074_Pieces_Det_RTYP = NF074_Pieces_Det_RTYP;
    this.NF074_Pieces_Det_DESC = NF074_Pieces_Det_DESC;
    this.NF074_Pieces_Det_FAB = NF074_Pieces_Det_FAB;
    this.NF074_Pieces_Det_PRS = NF074_Pieces_Det_PRS;
    this.NF074_Pieces_Det_CLF = NF074_Pieces_Det_CLF;
    this.NF074_Pieces_Det_MOB = NF074_Pieces_Det_MOB;
    this.NF074_Pieces_Det_PDT = NF074_Pieces_Det_PDT;
    this.NF074_Pieces_Det_POIDS = NF074_Pieces_Det_POIDS;
    this.NF074_Pieces_Det_GAM = NF074_Pieces_Det_GAM;
    this.NF074_Pieces_Det_CODF = NF074_Pieces_Det_CODF;
    this.NF074_Pieces_Det_SERG = NF074_Pieces_Det_SERG;
    this.NF074_Pieces_Det_CdeArtFab = NF074_Pieces_Det_CdeArtFab;
    this.NF074_Pieces_Det_DescriptionFAB = NF074_Pieces_Det_DescriptionFAB;
    this.NF074_Pieces_Det_Source = NF074_Pieces_Det_Source;
    this.NF074_Pieces_Det_Editon = NF074_Pieces_Det_Editon;
    this.NF074_Pieces_Det_Revision = NF074_Pieces_Det_Revision;
    this.NF074_Pieces_Det_Prescriptions = NF074_Pieces_Det_Prescriptions;
    this.NF074_Pieces_Det_Commentaires = NF074_Pieces_Det_Commentaires;
    this.NF074_Pieces_Det_CodeArticle = NF074_Pieces_Det_CodeArticle;
    this.NF074_Pieces_Det_CodeArticlePD1 = NF074_Pieces_Det_CodeArticlePD1;
    this.NF074_Pieces_Det_DescriptionPD1 = NF074_Pieces_Det_DescriptionPD1;
    this.NF074_Pieces_Det_Inst = NF074_Pieces_Det_Inst;
    this.NF074_Pieces_Det_VerifAnn = NF074_Pieces_Det_VerifAnn;
    this.NF074_Pieces_Det_Rech = NF074_Pieces_Det_Rech;
    this.NF074_Pieces_Det_MAA = NF074_Pieces_Det_MAA;
    this.NF074_Pieces_Det_Charge = NF074_Pieces_Det_Charge;
    this.NF074_Pieces_Det_RA = NF074_Pieces_Det_RA;
    this.NF074_Pieces_Det_RES = NF074_Pieces_Det_RES;
    this.NF074_Pieces_Det_CodeArticlePD2 = NF074_Pieces_Det_CodeArticlePD2;
    this.NF074_Pieces_Det_DescriptionPD2 = NF074_Pieces_Det_DescriptionPD2;
    this.NF074_Pieces_Det_QtePD2 = NF074_Pieces_Det_QtePD2;
    this.NF074_Pieces_Det_CodeArticlePD3 = NF074_Pieces_Det_CodeArticlePD3;
    this.NF074_Pieces_Det_DescriptionPD3 = NF074_Pieces_Det_DescriptionPD3;
    this.NF074_Pieces_Det_QtePD3 = NF074_Pieces_Det_QtePD3;
  }

  factory NF074_Pieces_Det.fromJson(Map<String, dynamic> json) {
    NF074_Pieces_Det wNF074_Pieces_Det = NF074_Pieces_Det(
      int.parse(json['NF074_Pieces_DetId']),
      json['NF074_Pieces_Det_NCERT'],
      json['NF074_Pieces_Det_RTYP'],
      json['NF074_Pieces_Det_DESC'],
      json['NF074_Pieces_Det_FAB'],
      json['NF074_Pieces_Det_PRS'],
      json['NF074_Pieces_Det_CLF'],
      json['NF074_Pieces_Det_MOB'],
      json['NF074_Pieces_Det_PDT'],
      json['NF074_Pieces_Det_POIDS'],
      json['NF074_Pieces_Det_GAM'],
      json['NF074_Pieces_Det_CODF'],
      json['NF074_Pieces_Det_SERG'],
      json['NF074_Pieces_Det_Cde_Art_Fab'],
      json['NF074_Pieces_Det_Description_FAB'],
      json['NF074_Pieces_Det_Source'],
      json['NF074_Pieces_Det_Editon'],
      json['NF074_Pieces_Det_Revision'],
      json['NF074_Pieces_Det_Prescriptions'],
      json['NF074_Pieces_Det_Commentaires'],
      json['NF074_Pieces_Det_Code_article'],
      json['NF074_Pieces_Det_Code_article_PD1'],
      json['NF074_Pieces_Det_Description_PD1'],
      int.parse(json['NF074_Pieces_Det_Inst']),
      int.parse(json['NF074_Pieces_Det_VerifAnn']),
      int.parse(json['NF074_Pieces_Det_Rech']),
      int.parse(json['NF074_Pieces_Det_MAA']),
      int.parse(json['NF074_Pieces_Det_Charge']),
      int.parse(json['NF074_Pieces_Det_RA']),
      int.parse(json['NF074_Pieces_Det_RES']),
      json['NF074_Pieces_Det_Code_article_PD2'],
      json['NF074_Pieces_Det_Description_PD2'],
      int.parse(json['NF074_Pieces_Det_Qte_PD2']),
      json['NF074_Pieces_Det_Code_article_PD3'],
      json['NF074_Pieces_Det_Description_PD3'],
      int.parse(json['NF074_Pieces_Det_Qte_PD3']),
    );
    return wNF074_Pieces_Det;
  }
}

class NF074_Pieces_Det_Inc {
  int NF074_Pieces_Det_IncId = 0;
  String NF074_Pieces_Det_Inc_DESC = "";
  String NF074_Pieces_Det_Inc_FAB = "";
  String NF074_Pieces_Det_Inc_PRS = "";
  String NF074_Pieces_Det_Inc_CLF = "";
  String NF074_Pieces_Det_Inc_MOB = "";
  String NF074_Pieces_Det_Inc_PDT = "";
  String NF074_Pieces_Det_Inc_POIDS = "";
  String NF074_Pieces_Det_Inc_GAM = "";
  int NF074_Pieces_Det_Inc_Inst = 0;
  int NF074_Pieces_Det_Inc_VerifAnn = 0;
  int NF074_Pieces_Det_Inc_Rech = 0;
  int NF074_Pieces_Det_Inc_MAA = 0;
  int NF074_Pieces_Det_Inc_Charge = 0;
  int NF074_Pieces_Det_Inc_RA = 0;
  int NF074_Pieces_Det_Inc_RES = 0;
  String NF074_Pieces_Det_Inc_CodeArticlePD1 = "";
  String NF074_Pieces_Det_Inc_DescriptionPD1 = "";
  int NF074_Pieces_Det_Inc_QtePD1 = 0;
  String NF074_Pieces_Det_Inc_CodeArticlePD2 = "";
  String NF074_Pieces_Det_Inc_DescriptionPD2 = "";
  int NF074_Pieces_Det_Inc_QtePD2 = 0;
  String NF074_Pieces_Det_Inc_CodeArticlePD3 = "";
  String NF074_Pieces_Det_Inc_DescriptionPD3 = "";
  int NF074_Pieces_Det_Inc_QtePD3 = 0;


  static NF074_Pieces_Det_IncInit() {
    return NF074_Pieces_Det_Inc(
      0,
      "",
      "",
      "",
      "",
      "",
      "",
      "",
      "",
      0,
      0,
      0,
      0,
      0,
      0,
      0,
      "",
      "",
      0,
      "",
      "",
      0,
      "",
      "",
      0,

    );
  }

  NF074_Pieces_Det_Inc(
    int NF074_Pieces_Det_IncId,
    String NF074_Pieces_Det_Inc_DESC,
    String NF074_Pieces_Det_Inc_FAB,
    String NF074_Pieces_Det_Inc_PRS,
    String NF074_Pieces_Det_Inc_CLF,
    String NF074_Pieces_Det_Inc_MOB,
    String NF074_Pieces_Det_Inc_PDT,
    String NF074_Pieces_Det_Inc_POIDS,
    String NF074_Pieces_Det_Inc_GAM,
    int NF074_Pieces_Det_Inc_Inst,
    int NF074_Pieces_Det_Inc_VerifAnn,
    int NF074_Pieces_Det_Inc_Rech,
    int NF074_Pieces_Det_Inc_MAA,
    int NF074_Pieces_Det_Inc_Charge,
    int NF074_Pieces_Det_Inc_RA,
    int NF074_Pieces_Det_Inc_RES,
    String NF074_Pieces_Det_Inc_CodeArticlePD1,
    String NF074_Pieces_Det_Inc_DescriptionPD1,
      int NF074_Pieces_Det_Inc_QtePD1,
    String NF074_Pieces_Det_Inc_CodeArticlePD2,
    String NF074_Pieces_Det_Inc_DescriptionPD2,
      int NF074_Pieces_Det_Inc_QtePD2,
    String NF074_Pieces_Det_Inc_CodeArticlePD3,
    String NF074_Pieces_Det_Inc_DescriptionPD3,
      int NF074_Pieces_Det_Inc_QtePD3,
  ) {
    this.NF074_Pieces_Det_IncId = NF074_Pieces_Det_IncId;

    this.NF074_Pieces_Det_Inc_DESC = NF074_Pieces_Det_Inc_DESC;
    this.NF074_Pieces_Det_Inc_FAB = NF074_Pieces_Det_Inc_FAB;
    this.NF074_Pieces_Det_Inc_PRS = NF074_Pieces_Det_Inc_PRS;
    this.NF074_Pieces_Det_Inc_CLF = NF074_Pieces_Det_Inc_CLF;
    this.NF074_Pieces_Det_Inc_MOB = NF074_Pieces_Det_Inc_MOB;
    this.NF074_Pieces_Det_Inc_PDT = NF074_Pieces_Det_Inc_PDT;
    this.NF074_Pieces_Det_Inc_POIDS = NF074_Pieces_Det_Inc_POIDS;
    this.NF074_Pieces_Det_Inc_GAM = NF074_Pieces_Det_Inc_GAM;
    this.NF074_Pieces_Det_Inc_Inst = NF074_Pieces_Det_Inc_Inst;
    this.NF074_Pieces_Det_Inc_VerifAnn = NF074_Pieces_Det_Inc_VerifAnn;
    this.NF074_Pieces_Det_Inc_Rech = NF074_Pieces_Det_Inc_Rech;
    this.NF074_Pieces_Det_Inc_MAA = NF074_Pieces_Det_Inc_MAA;
    this.NF074_Pieces_Det_Inc_Charge = NF074_Pieces_Det_Inc_Charge;
    this.NF074_Pieces_Det_Inc_RA = NF074_Pieces_Det_Inc_RA;
    this.NF074_Pieces_Det_Inc_RES = NF074_Pieces_Det_Inc_RES;
    this.NF074_Pieces_Det_Inc_CodeArticlePD1 = NF074_Pieces_Det_Inc_CodeArticlePD1;
    this.NF074_Pieces_Det_Inc_DescriptionPD1 = NF074_Pieces_Det_Inc_DescriptionPD1;
    this.NF074_Pieces_Det_Inc_QtePD1 = NF074_Pieces_Det_Inc_QtePD1;
    this.NF074_Pieces_Det_Inc_CodeArticlePD2 = NF074_Pieces_Det_Inc_CodeArticlePD2;
    this.NF074_Pieces_Det_Inc_DescriptionPD2 = NF074_Pieces_Det_Inc_DescriptionPD2;
    this.NF074_Pieces_Det_Inc_QtePD2 = NF074_Pieces_Det_Inc_QtePD2;
    this.NF074_Pieces_Det_Inc_CodeArticlePD3 = NF074_Pieces_Det_Inc_CodeArticlePD3;
    this.NF074_Pieces_Det_Inc_DescriptionPD3 = NF074_Pieces_Det_Inc_DescriptionPD3;
    this.NF074_Pieces_Det_Inc_QtePD3 = NF074_Pieces_Det_Inc_QtePD3;
  }

  factory NF074_Pieces_Det_Inc.fromJson(Map<String, dynamic> json) {
    NF074_Pieces_Det_Inc wNF074_Pieces_Det_Inc = NF074_Pieces_Det_Inc(
      int.parse(json['NF074_Pieces_Det_IncId']),
      json['NF074_Pieces_Det_Inc_DESC'],
      json['NF074_Pieces_Det_Inc_FAB'],
      json['NF074_Pieces_Det_Inc_PRS'],
      json['NF074_Pieces_Det_Inc_CLF'],
      json['NF074_Pieces_Det_Inc_MOB'],
      json['NF074_Pieces_Det_Inc_PDT'],
      json['NF074_Pieces_Det_Inc_POIDS'],
      json['NF074_Pieces_Det_Inc_GAM'],
      int.parse(json['NF074_Pieces_Det_Inc_Inst']),
      int.parse(json['NF074_Pieces_Det_Inc_VerifAnn']),
      int.parse(json['NF074_Pieces_Det_Inc_Rech']),
      int.parse(json['NF074_Pieces_Det_Inc_MAA']),
      int.parse(json['NF074_Pieces_Det_Inc_Charge']),
      int.parse(json['NF074_Pieces_Det_Inc_RA']),
      int.parse(json['NF074_Pieces_Det_Inc_RES']),
      json['NF074_Pieces_Det_Inc_Code_article_PD1'],
      json['NF074_Pieces_Det_Inc_Description_PD1'],
    int.parse(json['NF074_Pieces_Det_Inc_Qte_PD1']),
      json['NF074_Pieces_Det_Inc_Code_article_PD2'],
      json['NF074_Pieces_Det_Inc_Description_PD2'],
      int.parse(json['NF074_Pieces_Det_Inc_Qte_PD2']),
      json['NF074_Pieces_Det_Inc_Code_article_PD3'],
      json['NF074_Pieces_Det_Inc_Description_PD3'],
    int.parse(json['NF074_Pieces_Det_Inc_Qte_PD3']),
    );
    return wNF074_Pieces_Det_Inc;
  }
}

class NF074_Mixte_Produit {
  int NF074_Mixte_ProduitId = 0;
  String NF074_Mixte_Produit_DESC = "";
  String NF074_Mixte_Produit_POIDS = "";
  String NF074_Mixte_Produit_CLF = "";
  String NF074_Mixte_Produit_PDT = "";
  String NF074_Mixte_Produit_MOB = "";
  String NF074_Mixte_Produit_EMP = "";
  String NF074_Mixte_Produit_ZNE = "";
  int NF074_Mixte_Produit_Inst = 0;
  int NF074_Mixte_Produit_VerifAnn = 0;
  int NF074_Mixte_Produit_Rech = 0;
  int NF074_Mixte_Produit_MAA = 0;
  int NF074_Mixte_Produit_Charge = 0;
  int NF074_Mixte_Produit_RA = 0;
  int NF074_Mixte_Produit_RES = 0;
  String NF074_Mixte_Produit_Suggestion = "";
  String NF074_Mixte_Produit_CodeArticlePD1 = "";
  String NF074_Mixte_Produit_DescriptionPD1 = "";
  int NF074_Mixte_Produit_QtePD1 = 0;
  String NF074_Mixte_Produit_CodeArticlePD2 = "";
  String NF074_Mixte_Produit_DescriptionPD2 = "";
  int NF074_Mixte_Produit_QtePD2 = 0;
  String NF074_Mixte_Produit_CodeArticlePD3 = "";
  String NF074_Mixte_Produit_DescriptionPD3 = "";
  int NF074_Mixte_Produit_QtePD3 = 0;

  static NF074_Mixte_ProduitInit() {
    return NF074_Mixte_Produit(
      0,
      "",
      "",
      "",
      "",
      "",
      "",
      "",
      0,
      0,
      0,
      0,
      0,
      0,
      0,
      "",
      "",
      "",
      0,
      "",
      "",
      0,
      "",
      "",
      0,

    );
  }





  NF074_Mixte_Produit(
    int NF074_Mixte_ProduitId,
    String NF074_Mixte_Produit_DESC,
    String NF074_Mixte_Produit_POIDS,
    String NF074_Mixte_Produit_CLF,
    String NF074_Mixte_Produit_PDT,
    String NF074_Mixte_Produit_MOB,
    String NF074_Mixte_Produit_EMP,
    String NF074_Mixte_Produit_ZNE,
    int NF074_Mixte_Produit_Inst,
    int NF074_Mixte_Produit_VerifAnn,
    int NF074_Mixte_Produit_Rech,
    int NF074_Mixte_Produit_MAA,
    int NF074_Mixte_Produit_Charge,
    int NF074_Mixte_Produit_RA,
    int NF074_Mixte_Produit_RES,
    String NF074_Mixte_Produit_Suggestion,
    String NF074_Mixte_Produit_CodeArticlePD1,
    String NF074_Mixte_Produit_DescriptionPD1,
      int NF074_Mixte_Produit_QtePD1,
    String NF074_Mixte_Produit_CodeArticlePD2,
    String NF074_Mixte_Produit_DescriptionPD2,
      int NF074_Mixte_Produit_QtePD2,
    String NF074_Mixte_Produit_CodeArticlePD3,
    String NF074_Mixte_Produit_DescriptionPD3,
      int NF074_Mixte_Produit_QtePD3,
  ) {
    this.NF074_Mixte_ProduitId = NF074_Mixte_ProduitId;
    this.NF074_Mixte_Produit_DESC = NF074_Mixte_Produit_DESC;
    this.NF074_Mixte_Produit_POIDS = NF074_Mixte_Produit_POIDS;
    this.NF074_Mixte_Produit_CLF = NF074_Mixte_Produit_CLF;
    this.NF074_Mixte_Produit_PDT = NF074_Mixte_Produit_PDT;
    this.NF074_Mixte_Produit_MOB = NF074_Mixte_Produit_MOB;
    this.NF074_Mixte_Produit_EMP = NF074_Mixte_Produit_EMP;
    this.NF074_Mixte_Produit_ZNE = NF074_Mixte_Produit_ZNE;
    this.NF074_Mixte_Produit_Inst = NF074_Mixte_Produit_Inst;
    this.NF074_Mixte_Produit_VerifAnn = NF074_Mixte_Produit_VerifAnn;
    this.NF074_Mixte_Produit_Rech = NF074_Mixte_Produit_Rech;
    this.NF074_Mixte_Produit_MAA = NF074_Mixte_Produit_MAA;
    this.NF074_Mixte_Produit_Charge = NF074_Mixte_Produit_Charge;
    this.NF074_Mixte_Produit_RA = NF074_Mixte_Produit_RA;
    this.NF074_Mixte_Produit_RES = NF074_Mixte_Produit_RES;
    this.NF074_Mixte_Produit_Suggestion = NF074_Mixte_Produit_Suggestion;
    this.NF074_Mixte_Produit_CodeArticlePD1 = NF074_Mixte_Produit_CodeArticlePD1;
    this.NF074_Mixte_Produit_DescriptionPD1 = NF074_Mixte_Produit_DescriptionPD1;
    this.NF074_Mixte_Produit_QtePD1 = NF074_Mixte_Produit_QtePD1;
    this.NF074_Mixte_Produit_CodeArticlePD2 = NF074_Mixte_Produit_CodeArticlePD2;
    this.NF074_Mixte_Produit_DescriptionPD2 = NF074_Mixte_Produit_DescriptionPD2;
    this.NF074_Mixte_Produit_QtePD2 = NF074_Mixte_Produit_QtePD2;
    this.NF074_Mixte_Produit_CodeArticlePD3 = NF074_Mixte_Produit_CodeArticlePD3;
    this.NF074_Mixte_Produit_DescriptionPD3 = NF074_Mixte_Produit_DescriptionPD3;
    this.NF074_Mixte_Produit_QtePD3 = NF074_Mixte_Produit_QtePD3;
  }

  factory NF074_Mixte_Produit.fromJson(Map<String, dynamic> json) {
    NF074_Mixte_Produit wNF074_Mixte_Produit = NF074_Mixte_Produit(
      int.parse(json['NF074_Mixte_ProduitId']),
      json['NF074_Mixte_Produit_DESC'],
      json['NF074_Mixte_Produit_POIDS'],
      json['NF074_Mixte_Produit_CLF'],
      json['NF074_Mixte_Produit_PDT'],
      json['NF074_Mixte_Produit_MOB'],
      json['NF074_Mixte_Produit_EMP'],
      json['NF074_Mixte_Produit_ZNE'],
      int.parse(json['NF074_Mixte_Produit_Inst']),
      int.parse(json['NF074_Mixte_Produit_VerifAnn']),
      int.parse(json['NF074_Mixte_Produit_Rech']),
      int.parse(json['NF074_Mixte_Produit_MAA']),
      int.parse(json['NF074_Mixte_Produit_Charge']),
      int.parse(json['NF074_Mixte_Produit_RA']),
      int.parse(json['NF074_Mixte_Produit_RES']),
      json['NF074_Mixte_Produit_Suggestion'],
      json['NF074_Mixte_Produit_Code_article_PD1'],
      json['NF074_Mixte_Produit_Description_PD1'],
    int.parse(json['NF074_Mixte_Produit_Qte_PD1']),
      json['NF074_Mixte_Produit_Code_article_PD2'],
      json['NF074_Mixte_Produit_Description_PD2'],
    int.parse(json['NF074_Mixte_Produit_Qte_PD2']),
      json['NF074_Mixte_Produit_Code_article_PD3'],
      json['NF074_Mixte_Produit_Description_PD3'],
    int.parse(json['NF074_Mixte_Produit_Qte_PD3']),
    );
    return wNF074_Mixte_Produit;
  }
}

class NF074_Pieces_Actions {
  int NF074_Pieces_ActionsId = 0;
  String NF074_Pieces_Actions_DESC = "";
  String NF074_Pieces_Actions_PDT = "";
  String NF074_Pieces_Actions_POIDS = "";
  String NF074_Pieces_Actions_PRS = "";
  int NF074_Pieces_Actions_Inst = 0;
  int NF074_Pieces_Actions_VerifAnn = 0;
  int NF074_Pieces_Actions_Rech = 0;
  int NF074_Pieces_Actions_MAA = 0;
  int NF074_Pieces_Actions_Charge = 0;
  int NF074_Pieces_Actions_RA = 0;
  int NF074_Pieces_Actions_RES = 0;
  String NF074_Pieces_Actions_CodeArticlePD1 = "";
  String NF074_Pieces_Actions_DescriptionPD1 = "";
  int NF074_Pieces_Actions_QtePD1 = 0;
  String NF074_Pieces_Actions_CodeArticlePD2 = "";
  String NF074_Pieces_Actions_DescriptionPD2 = "";
  int NF074_Pieces_Actions_QtePD2 = 0;
  String NF074_Pieces_Actions_CodeArticlePD3 = "";
  String NF074_Pieces_Actions_DescriptionPD3 = "";
  int NF074_Pieces_Actions_QtePD3 = 0;

  static NF074_Pieces_ActionsInit() {
    return NF074_Pieces_Actions(
      0,
      "",
      "",
      "",
      "",
      0,
      0,
      0,
      0,
      0,
      0,
      0,
      "",
      "",
      0,
        "",
        "",
        0,
      "",
      "",
      0
    );
  }



  NF074_Pieces_Actions(
    int NF074_Pieces_ActionsId,
    String NF074_Pieces_Actions_DESC,
    String NF074_Pieces_Actions_PDT,
    String NF074_Pieces_Actions_POIDS,
    String NF074_Pieces_Actions_PRS,
    int NF074_Pieces_Actions_Inst,
    int NF074_Pieces_Actions_VerifAnn,
    int NF074_Pieces_Actions_Rech,
    int NF074_Pieces_Actions_MAA,
    int NF074_Pieces_Actions_Charge,
    int NF074_Pieces_Actions_RA,
    int NF074_Pieces_Actions_RES,
    String NF074_Pieces_Actions_CodeArticlePD1,
    String NF074_Pieces_Actions_DescriptionPD1,
    int NF074_Pieces_Actions_QtePD1,
    String NF074_Pieces_Actions_CodeArticlePD2,
    String NF074_Pieces_Actions_DescriptionPD2,
    int NF074_Pieces_Actions_QtePD2,
    String NF074_Pieces_Actions_CodeArticlePD3,
    String NF074_Pieces_Actions_DescriptionPD3,
    int NF074_Pieces_Actions_QtePD3,
  ) {
    this.NF074_Pieces_ActionsId = NF074_Pieces_ActionsId;
    this.NF074_Pieces_Actions_DESC = NF074_Pieces_Actions_DESC;
    this.NF074_Pieces_Actions_PDT = NF074_Pieces_Actions_PDT;
    this.NF074_Pieces_Actions_POIDS = NF074_Pieces_Actions_POIDS;
    this.NF074_Pieces_Actions_PRS = NF074_Pieces_Actions_PRS;
    this.NF074_Pieces_Actions_Inst = NF074_Pieces_Actions_Inst;
    this.NF074_Pieces_Actions_VerifAnn = NF074_Pieces_Actions_VerifAnn;
    this.NF074_Pieces_Actions_Rech = NF074_Pieces_Actions_Rech;
    this.NF074_Pieces_Actions_MAA = NF074_Pieces_Actions_MAA;
    this.NF074_Pieces_Actions_Charge = NF074_Pieces_Actions_Charge;
    this.NF074_Pieces_Actions_RA = NF074_Pieces_Actions_RA;
    this.NF074_Pieces_Actions_RES = NF074_Pieces_Actions_RES;
    this.NF074_Pieces_Actions_CodeArticlePD1 = NF074_Pieces_Actions_CodeArticlePD1;
    this.NF074_Pieces_Actions_DescriptionPD1 = NF074_Pieces_Actions_DescriptionPD1;
    this.NF074_Pieces_Actions_QtePD1 = NF074_Pieces_Actions_QtePD1;
    this.NF074_Pieces_Actions_CodeArticlePD2 = NF074_Pieces_Actions_CodeArticlePD2;
    this.NF074_Pieces_Actions_DescriptionPD2 = NF074_Pieces_Actions_DescriptionPD2;
    this.NF074_Pieces_Actions_QtePD2 = NF074_Pieces_Actions_QtePD2;
    this.NF074_Pieces_Actions_CodeArticlePD3 = NF074_Pieces_Actions_CodeArticlePD3;
    this.NF074_Pieces_Actions_DescriptionPD3 = NF074_Pieces_Actions_DescriptionPD3;
    this.NF074_Pieces_Actions_QtePD3 = NF074_Pieces_Actions_QtePD3;
  }

  factory NF074_Pieces_Actions.fromJson(Map<String, dynamic> json) {
    NF074_Pieces_Actions wNF074_Pieces_Actions = NF074_Pieces_Actions(
      int.parse(json['NF074_Pieces_ActionsId']),
      json['NF074_Pieces_Actions_DESC'],
      json['NF074_Pieces_Actions_PDT'],
      json['NF074_Pieces_Actions_POIDS'],
      json['NF074_Pieces_Actions_PRS'],
      int.parse(json['NF074_Pieces_Actions_Inst']),
      int.parse(json['NF074_Pieces_Actions_VerifAnn']),
      int.parse(json['NF074_Pieces_Actions_Rech']),
      int.parse(json['NF074_Pieces_Actions_MAA']),
      int.parse(json['NF074_Pieces_Actions_Charge']),
      int.parse(json['NF074_Pieces_Actions_RA']),
      int.parse(json['NF074_Pieces_Actions_RES']),
      json['NF074_Pieces_Actions_Code_article_PD1'],
      json['NF074_Pieces_Actions_Description_PD1'],
      int.parse(json['NF074_Pieces_Actions_Qte_PD1']),
      json['NF074_Pieces_Actions_Code_article_PD2'],
      json['NF074_Pieces_Actions_Description_PD2'],
      int.parse(json['NF074_Pieces_Actions_Qte_PD2']),
      json['NF074_Pieces_Actions_Code_article_PD3'],
      json['NF074_Pieces_Actions_Description_PD3'],
      int.parse(json['NF074_Pieces_Actions_Qte_PD3']),
    );
    return wNF074_Pieces_Actions;
  }
}
