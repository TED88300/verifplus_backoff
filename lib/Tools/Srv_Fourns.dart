class Fourn {
  int?    fournId ;
  String? fournCodeGC;
  String? fournNom;

  String?    Fourn_Statut ;
  int?    Fourn_F_SST ;




  String? fournSiret;
  String? fournNAF;
  String? fournTVA;
  String? fournAdr1;
  String? fournAdr2;
  String? fournAdr3;
  String? fournAdr4;
  String? fournCP;
  String? fournVille;
  String? fournPays;
  String? fournTel1;
  String? fournTel2;
  String? fournEMail;
  String? fournRem;

  static FournInit() {
    return Fourn(0, "", "", "", 0, "", "", "", "", "", "", "", "","", "", "", "", "", "");
  }


  Fourn(
  int?    fournId ,
  String? fournCodeGC,
  String? fournNom,
  String?    Fourn_Statut,
  int?    Fourn_F_SST,
  String? fournSiret,
  String? fournNAF,
  String? fournTVA,
  String? fournAdr1,
  String? fournAdr2,
  String? fournAdr3,
  String? fournAdr4,
  String? fournCP,
  String? fournVille,
  String? fournPays,
  String? fournTel1,
  String? fournTel2,
  String? fournEMail,
  String? fournRem,
      ) {
    this.fournId  = fournId ;
    this.fournCodeGC = fournCodeGC;
    this.fournNom = fournNom;
    this.Fourn_Statut = Fourn_Statut;
    this.Fourn_F_SST = Fourn_F_SST;
    this.fournSiret = fournSiret;
    this.fournNAF = fournNAF;
    this.fournTVA = fournTVA;
    this.fournAdr1 = fournAdr1;
    this.fournAdr2 = fournAdr2;
    this.fournAdr3 = fournAdr3;
    this.fournAdr4 = fournAdr4;
    this.fournCP = fournCP;
    this.fournVille = fournVille;
    this.fournPays = fournPays;
    this.fournTel1 = fournTel1;
    this.fournTel2 = fournTel2;
    this.fournEMail = fournEMail;
    this.fournRem = fournRem;
  }




  Fourn.fromJson(Map<String, dynamic> json) {
    fournId = int.parse(json['FournId']);
    fournCodeGC = json['Fourn_CodeGC'];
    fournNom = json['Fourn_Nom'];
    Fourn_Statut = json['Fourn_Statut'];
    Fourn_F_SST = int.parse(json['Fourn_F_SST']);
    fournSiret = json['Fourn_Siret'];
    fournNAF = json['Fourn_NAF'];
    fournTVA = json['Fourn_TVA'];
    fournAdr1 = json['Fourn_Adr1'];
    fournAdr2 = json['Fourn_Adr2'];
    fournAdr3 = json['Fourn_Adr3'];
    fournAdr4 = json['Fourn_Adr4'];
    fournCP = json['Fourn_CP'];
    fournVille = json['Fourn_Ville'];
    fournPays = json['Fourn_Pays'];
    fournTel1 = json['Fourn_Tel1'];
    fournTel2 = json['Fourn_Tel2'];
    fournEMail = json['Fourn_eMail'];
    fournRem = json['Fourn_Rem'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['FournId'] = this.fournId;

    data['Fourn_CodeGC'] = this.fournCodeGC;
    data['Fourn_Nom'] = this.fournNom;
    data['Fourn_Statut'] = this.Fourn_Statut;
    data['Fourn_F_SST'] = this.Fourn_F_SST;
    data['Fourn_Siret'] = this.fournSiret;
    data['Fourn_NAF'] = this.fournNAF;
    data['Fourn_TVA'] = this.fournTVA;
    data['Fourn_Adr1'] = this.fournAdr1;
    data['Fourn_Adr2'] = this.fournAdr2;
    data['Fourn_Adr3'] = this.fournAdr3;
    data['Fourn_Adr4'] = this.fournAdr4;
    data['Fourn_CP'] = this.fournCP;
    data['Fourn_Ville'] = this.fournVille;
    data['Fourn_Pays'] = this.fournPays;
    data['Fourn_Tel1'] = this.fournTel1;
    data['Fourn_Tel2'] = this.fournTel2;
    data['Fourn_eMail'] = this.fournEMail;
    data['Fourn_Rem'] = this.fournRem;
    return data;
  }

  String Desc() {
    return
              '$fournId , '
              '$fournCodeGC, '
              '$fournNom, '
              '$Fourn_Statut, '
              '$Fourn_F_SST, '
              '$fournSiret, '
              '$fournNAF, '
              '$fournTVA, '
              '$fournAdr1, '
              '$fournAdr2, '
              '$fournAdr3, '
              '$fournAdr4, '
              '$fournCP, '
              '$fournVille, '
              '$fournPays, '
              '$fournTel1, '
              '$fournTel2, '
              '$fournEMail, '
              '$fournRem, ';
  }

}
