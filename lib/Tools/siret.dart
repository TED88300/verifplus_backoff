class Siret {
  Header? header;
  Etablissement? etablissement;

  Siret({this.header, this.etablissement});

  Siret.fromJson(Map<dynamic, dynamic> json) {
    header =
    json['header'] != null ? new Header.fromJson(json['header']) : null;
    etablissement = json['etablissement'] != null
        ? new Etablissement.fromJson(json['etablissement'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.header != null) {
      data['header'] = this.header!.toJson();
    }
    if (this.etablissement != null) {
      data['etablissement'] = this.etablissement!.toJson();
    }
    return data;
  }
}

class Header {
  int? statut;
  String? message;

  Header({this.statut, this.message});

  Header.fromJson(Map<String, dynamic> json) {
    statut = json['statut'];
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['statut'] = this.statut;
    data['message'] = this.message;
    return data;
  }
}

class Etablissement {
  String? siren;
  String? nic;
  String? siret;
  String? statutDiffusionEtablissement;
  String? dateCreationEtablissement;
  String? trancheEffectifsEtablissement;
  String? anneeEffectifsEtablissement;
  String? activitePrincipaleRegistreMetiersEtablissement;
  String? dateDernierTraitementEtablissement;
  bool? etablissementSiege;
  int? nombrePeriodesEtablissement;
  UniteLegale? uniteLegale;
  AdresseEtablissement? adresseEtablissement;
  Adresse2Etablissement? adresse2Etablissement;
  List<PeriodesEtablissement>? periodesEtablissement;

  Etablissement(
      {this.siren,
        this.nic,
        this.siret,
        this.statutDiffusionEtablissement,
        this.dateCreationEtablissement,
        this.trancheEffectifsEtablissement,
        this.anneeEffectifsEtablissement,
        this.activitePrincipaleRegistreMetiersEtablissement,
        this.dateDernierTraitementEtablissement,
        this.etablissementSiege,
        this.nombrePeriodesEtablissement,
        this.uniteLegale,
        this.adresseEtablissement,
        this.adresse2Etablissement,
        this.periodesEtablissement});

  Etablissement.fromJson(Map<String, dynamic> json) {
    siren = json['siren'];
    nic = json['nic'];
    siret = json['siret'];
    statutDiffusionEtablissement = json['statutDiffusionEtablissement'];
    dateCreationEtablissement = json['dateCreationEtablissement'];
    trancheEffectifsEtablissement = json['trancheEffectifsEtablissement'];
    anneeEffectifsEtablissement = json['anneeEffectifsEtablissement'];
    activitePrincipaleRegistreMetiersEtablissement =
    json['activitePrincipaleRegistreMetiersEtablissement'];
    dateDernierTraitementEtablissement =
    json['dateDernierTraitementEtablissement'];
    etablissementSiege = json['etablissementSiege'];
    nombrePeriodesEtablissement = json['nombrePeriodesEtablissement'];
    uniteLegale = json['uniteLegale'] != null
        ? new UniteLegale.fromJson(json['uniteLegale'])
        : null;
    adresseEtablissement = json['adresseEtablissement'] != null
        ? new AdresseEtablissement.fromJson(json['adresseEtablissement'])
        : null;
    adresse2Etablissement = json['adresse2Etablissement'] != null
        ? new Adresse2Etablissement.fromJson(json['adresse2Etablissement'])
        : null;
    if (json['periodesEtablissement'] != null) {
      periodesEtablissement = <PeriodesEtablissement>[];
      json['periodesEtablissement'].forEach((v) {
        periodesEtablissement!.add(new PeriodesEtablissement.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['siren'] = this.siren;
    data['nic'] = this.nic;
    data['siret'] = this.siret;
    data['statutDiffusionEtablissement'] = this.statutDiffusionEtablissement;
    data['dateCreationEtablissement'] = this.dateCreationEtablissement;
    data['trancheEffectifsEtablissement'] = this.trancheEffectifsEtablissement;
    data['anneeEffectifsEtablissement'] = this.anneeEffectifsEtablissement;
    data['activitePrincipaleRegistreMetiersEtablissement'] =
        this.activitePrincipaleRegistreMetiersEtablissement;
    data['dateDernierTraitementEtablissement'] =
        this.dateDernierTraitementEtablissement;
    data['etablissementSiege'] = this.etablissementSiege;
    data['nombrePeriodesEtablissement'] = this.nombrePeriodesEtablissement;
    if (this.uniteLegale != null) {
      data['uniteLegale'] = this.uniteLegale!.toJson();
    }
    if (this.adresseEtablissement != null) {
      data['adresseEtablissement'] = this.adresseEtablissement!.toJson();
    }
    if (this.adresse2Etablissement != null) {
      data['adresse2Etablissement'] = this.adresse2Etablissement!.toJson();
    }
    if (this.periodesEtablissement != null) {
      data['periodesEtablissement'] =
          this.periodesEtablissement!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class UniteLegale {
  String? etatAdministratifUniteLegale;
  String? statutDiffusionUniteLegale;
  String? dateCreationUniteLegale;
  String? categorieJuridiqueUniteLegale;
  String? denominationUniteLegale;
  String? sigleUniteLegale;
  String? denominationUsuelle1UniteLegale;
  String? denominationUsuelle2UniteLegale;
  String? denominationUsuelle3UniteLegale;
  String? sexeUniteLegale;
  String? nomUniteLegale;
  String? nomUsageUniteLegale;
  String? prenom1UniteLegale;
  String? prenom2UniteLegale;
  String? prenom3UniteLegale;
  String? prenom4UniteLegale;
  String? prenomUsuelUniteLegale;
  String? pseudonymeUniteLegale;
  String? activitePrincipaleUniteLegale;
  String? nomenclatureActivitePrincipaleUniteLegale;
  String? identifiantAssociationUniteLegale;
  String? economieSocialeSolidaireUniteLegale;
  String? societeMissionUniteLegale;
  String? caractereEmployeurUniteLegale;
  String? trancheEffectifsUniteLegale;
  String? anneeEffectifsUniteLegale;
  String? nicSiegeUniteLegale;
  String? dateDernierTraitementUniteLegale;
  String? categorieEntreprise;
  String? anneeCategorieEntreprise;

  UniteLegale(
      {this.etatAdministratifUniteLegale,
        this.statutDiffusionUniteLegale,
        this.dateCreationUniteLegale,
        this.categorieJuridiqueUniteLegale,
        this.denominationUniteLegale,
        this.sigleUniteLegale,
        this.denominationUsuelle1UniteLegale,
        this.denominationUsuelle2UniteLegale,
        this.denominationUsuelle3UniteLegale,
        this.sexeUniteLegale,
        this.nomUniteLegale,
        this.nomUsageUniteLegale,
        this.prenom1UniteLegale,
        this.prenom2UniteLegale,
        this.prenom3UniteLegale,
        this.prenom4UniteLegale,
        this.prenomUsuelUniteLegale,
        this.pseudonymeUniteLegale,
        this.activitePrincipaleUniteLegale,
        this.nomenclatureActivitePrincipaleUniteLegale,
        this.identifiantAssociationUniteLegale,
        this.economieSocialeSolidaireUniteLegale,
        this.societeMissionUniteLegale,
        this.caractereEmployeurUniteLegale,
        this.trancheEffectifsUniteLegale,
        this.anneeEffectifsUniteLegale,
        this.nicSiegeUniteLegale,
        this.dateDernierTraitementUniteLegale,
        this.categorieEntreprise,
        this.anneeCategorieEntreprise});

  UniteLegale.fromJson(Map<String, dynamic> json) {
    etatAdministratifUniteLegale = json['etatAdministratifUniteLegale'];
    statutDiffusionUniteLegale = json['statutDiffusionUniteLegale'];
    dateCreationUniteLegale = json['dateCreationUniteLegale'];
    categorieJuridiqueUniteLegale = json['categorieJuridiqueUniteLegale'];
    denominationUniteLegale = json['denominationUniteLegale'];
    sigleUniteLegale = json['sigleUniteLegale'];
    denominationUsuelle1UniteLegale = json['denominationUsuelle1UniteLegale'];
    denominationUsuelle2UniteLegale = json['denominationUsuelle2UniteLegale'];
    denominationUsuelle3UniteLegale = json['denominationUsuelle3UniteLegale'];
    sexeUniteLegale = json['sexeUniteLegale'];
    nomUniteLegale = json['nomUniteLegale'];
    nomUsageUniteLegale = json['nomUsageUniteLegale'];
    prenom1UniteLegale = json['prenom1UniteLegale'];
    prenom2UniteLegale = json['prenom2UniteLegale'];
    prenom3UniteLegale = json['prenom3UniteLegale'];
    prenom4UniteLegale = json['prenom4UniteLegale'];
    prenomUsuelUniteLegale = json['prenomUsuelUniteLegale'];
    pseudonymeUniteLegale = json['pseudonymeUniteLegale'];
    activitePrincipaleUniteLegale = json['activitePrincipaleUniteLegale'];
    nomenclatureActivitePrincipaleUniteLegale =
    json['nomenclatureActivitePrincipaleUniteLegale'];
    identifiantAssociationUniteLegale =
    json['identifiantAssociationUniteLegale'];
    economieSocialeSolidaireUniteLegale =
    json['economieSocialeSolidaireUniteLegale'];
    societeMissionUniteLegale = json['societeMissionUniteLegale'];
    caractereEmployeurUniteLegale = json['caractereEmployeurUniteLegale'];
    trancheEffectifsUniteLegale = json['trancheEffectifsUniteLegale'];
    anneeEffectifsUniteLegale = json['anneeEffectifsUniteLegale'];
    nicSiegeUniteLegale = json['nicSiegeUniteLegale'];
    dateDernierTraitementUniteLegale = json['dateDernierTraitementUniteLegale'];
    categorieEntreprise = json['categorieEntreprise'];
    anneeCategorieEntreprise = json['anneeCategorieEntreprise'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['etatAdministratifUniteLegale'] = this.etatAdministratifUniteLegale;
    data['statutDiffusionUniteLegale'] = this.statutDiffusionUniteLegale;
    data['dateCreationUniteLegale'] = this.dateCreationUniteLegale;
    data['categorieJuridiqueUniteLegale'] = this.categorieJuridiqueUniteLegale;
    data['denominationUniteLegale'] = this.denominationUniteLegale;
    data['sigleUniteLegale'] = this.sigleUniteLegale;
    data['denominationUsuelle1UniteLegale'] =
        this.denominationUsuelle1UniteLegale;
    data['denominationUsuelle2UniteLegale'] =
        this.denominationUsuelle2UniteLegale;
    data['denominationUsuelle3UniteLegale'] =
        this.denominationUsuelle3UniteLegale;
    data['sexeUniteLegale'] = this.sexeUniteLegale;
    data['nomUniteLegale'] = this.nomUniteLegale;
    data['nomUsageUniteLegale'] = this.nomUsageUniteLegale;
    data['prenom1UniteLegale'] = this.prenom1UniteLegale;
    data['prenom2UniteLegale'] = this.prenom2UniteLegale;
    data['prenom3UniteLegale'] = this.prenom3UniteLegale;
    data['prenom4UniteLegale'] = this.prenom4UniteLegale;
    data['prenomUsuelUniteLegale'] = this.prenomUsuelUniteLegale;
    data['pseudonymeUniteLegale'] = this.pseudonymeUniteLegale;
    data['activitePrincipaleUniteLegale'] = this.activitePrincipaleUniteLegale;
    data['nomenclatureActivitePrincipaleUniteLegale'] =
        this.nomenclatureActivitePrincipaleUniteLegale;
    data['identifiantAssociationUniteLegale'] =
        this.identifiantAssociationUniteLegale;
    data['economieSocialeSolidaireUniteLegale'] =
        this.economieSocialeSolidaireUniteLegale;
    data['societeMissionUniteLegale'] = this.societeMissionUniteLegale;
    data['caractereEmployeurUniteLegale'] = this.caractereEmployeurUniteLegale;
    data['trancheEffectifsUniteLegale'] = this.trancheEffectifsUniteLegale;
    data['anneeEffectifsUniteLegale'] = this.anneeEffectifsUniteLegale;
    data['nicSiegeUniteLegale'] = this.nicSiegeUniteLegale;
    data['dateDernierTraitementUniteLegale'] =
        this.dateDernierTraitementUniteLegale;
    data['categorieEntreprise'] = this.categorieEntreprise;
    data['anneeCategorieEntreprise'] = this.anneeCategorieEntreprise;
    return data;
  }
}

class AdresseEtablissement {
  String? complementAdresseEtablissement;
  String? numeroVoieEtablissement;
  String? indiceRepetitionEtablissement;
  String? typeVoieEtablissement;
  String? libelleVoieEtablissement;
  String? codePostalEtablissement;
  String? libelleCommuneEtablissement;
  String? libelleCommuneEtrangerEtablissement;
  String? distributionSpecialeEtablissement;
  String? codeCommuneEtablissement;
  String? codeCedexEtablissement;
  String? libelleCedexEtablissement;
  String? codePaysEtrangerEtablissement;
  String? libellePaysEtrangerEtablissement;

  AdresseEtablissement(
      {this.complementAdresseEtablissement,
        this.numeroVoieEtablissement,
        this.indiceRepetitionEtablissement,
        this.typeVoieEtablissement,
        this.libelleVoieEtablissement,
        this.codePostalEtablissement,
        this.libelleCommuneEtablissement,
        this.libelleCommuneEtrangerEtablissement,
        this.distributionSpecialeEtablissement,
        this.codeCommuneEtablissement,
        this.codeCedexEtablissement,
        this.libelleCedexEtablissement,
        this.codePaysEtrangerEtablissement,
        this.libellePaysEtrangerEtablissement});

  AdresseEtablissement.fromJson(Map<String, dynamic> json) {
    complementAdresseEtablissement = json['complementAdresseEtablissement'];
    indiceRepetitionEtablissement = json['indiceRepetitionEtablissement'] != null ? json["indiceRepetitionEtablissement"] : "";
    numeroVoieEtablissement = json['numeroVoieEtablissement'] != null ? json["numeroVoieEtablissement"] : "";
    indiceRepetitionEtablissement = json['indiceRepetitionEtablissement'] != null ? json["indiceRepetitionEtablissement"] : "";
    typeVoieEtablissement = json['typeVoieEtablissement'] != null ? json["typeVoieEtablissement"] : "";
    libelleVoieEtablissement = json['libelleVoieEtablissement'] != null ? json["libelleVoieEtablissement"] : "";
    codePostalEtablissement         = json['codePostalEtablissement'];
    libelleCommuneEtablissement     = json['libelleCommuneEtablissement'];
    libelleCommuneEtrangerEtablissement =
    json['libelleCommuneEtrangerEtablissement'];
    distributionSpecialeEtablissement =
    json['distributionSpecialeEtablissement'];
    codeCommuneEtablissement = json['codeCommuneEtablissement'];
    codeCedexEtablissement = json['codeCedexEtablissement'];
    libelleCedexEtablissement = json['libelleCedexEtablissement'];
    codePaysEtrangerEtablissement = json['codePaysEtrangerEtablissement'];
    libellePaysEtrangerEtablissement = json['libellePaysEtrangerEtablissement'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['complementAdresseEtablissement'] =
        this.complementAdresseEtablissement;
    data['numeroVoieEtablissement'] = this.numeroVoieEtablissement;
    data['indiceRepetitionEtablissement'] = this.indiceRepetitionEtablissement;
    data['typeVoieEtablissement'] = this.typeVoieEtablissement;
    data['libelleVoieEtablissement'] = this.libelleVoieEtablissement;
    data['codePostalEtablissement'] = this.codePostalEtablissement;
    data['libelleCommuneEtablissement'] = this.libelleCommuneEtablissement;
    data['libelleCommuneEtrangerEtablissement'] =
        this.libelleCommuneEtrangerEtablissement;
    data['distributionSpecialeEtablissement'] =
        this.distributionSpecialeEtablissement;
    data['codeCommuneEtablissement'] = this.codeCommuneEtablissement;
    data['codeCedexEtablissement'] = this.codeCedexEtablissement;
    data['libelleCedexEtablissement'] = this.libelleCedexEtablissement;
    data['codePaysEtrangerEtablissement'] = this.codePaysEtrangerEtablissement;
    data['libellePaysEtrangerEtablissement'] =
        this.libellePaysEtrangerEtablissement;
    return data;
  }
}

class Adresse2Etablissement {
  String? complementAdresse2Etablissement;
  String? numeroVoie2Etablissement;
  String? indiceRepetition2Etablissement;
  String? typeVoie2Etablissement;
  String? libelleVoie2Etablissement;
  String? codePostal2Etablissement;
  String? libelleCommune2Etablissement;
  String? libelleCommuneEtranger2Etablissement;
  String? distributionSpeciale2Etablissement;
  String? codeCommune2Etablissement;
  String? codeCedex2Etablissement;
  String? libelleCedex2Etablissement;
  String? codePaysEtranger2Etablissement;
  String? libellePaysEtranger2Etablissement;

  Adresse2Etablissement(
      {this.complementAdresse2Etablissement,
        this.numeroVoie2Etablissement,
        this.indiceRepetition2Etablissement,
        this.typeVoie2Etablissement,
        this.libelleVoie2Etablissement,
        this.codePostal2Etablissement,
        this.libelleCommune2Etablissement,
        this.libelleCommuneEtranger2Etablissement,
        this.distributionSpeciale2Etablissement,
        this.codeCommune2Etablissement,
        this.codeCedex2Etablissement,
        this.libelleCedex2Etablissement,
        this.codePaysEtranger2Etablissement,
        this.libellePaysEtranger2Etablissement});

  Adresse2Etablissement.fromJson(Map<String, dynamic> json) {
    complementAdresse2Etablissement = json['complementAdresse2Etablissement'];
    numeroVoie2Etablissement = json['numeroVoie2Etablissement'];
    indiceRepetition2Etablissement = json['indiceRepetition2Etablissement'];
    typeVoie2Etablissement = json['typeVoie2Etablissement'];
    libelleVoie2Etablissement = json['libelleVoie2Etablissement'];
    codePostal2Etablissement = json['codePostal2Etablissement'];
    libelleCommune2Etablissement = json['libelleCommune2Etablissement'];
    libelleCommuneEtranger2Etablissement =
    json['libelleCommuneEtranger2Etablissement'];
    distributionSpeciale2Etablissement =
    json['distributionSpeciale2Etablissement'];
    codeCommune2Etablissement = json['codeCommune2Etablissement'];
    codeCedex2Etablissement = json['codeCedex2Etablissement'];
    libelleCedex2Etablissement = json['libelleCedex2Etablissement'];
    codePaysEtranger2Etablissement = json['codePaysEtranger2Etablissement'];
    libellePaysEtranger2Etablissement =
    json['libellePaysEtranger2Etablissement'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['complementAdresse2Etablissement'] =
        this.complementAdresse2Etablissement;
    data['numeroVoie2Etablissement'] = this.numeroVoie2Etablissement;
    data['indiceRepetition2Etablissement'] =
        this.indiceRepetition2Etablissement;
    data['typeVoie2Etablissement'] = this.typeVoie2Etablissement;
    data['libelleVoie2Etablissement'] = this.libelleVoie2Etablissement;
    data['codePostal2Etablissement'] = this.codePostal2Etablissement;
    data['libelleCommune2Etablissement'] = this.libelleCommune2Etablissement;
    data['libelleCommuneEtranger2Etablissement'] =
        this.libelleCommuneEtranger2Etablissement;
    data['distributionSpeciale2Etablissement'] =
        this.distributionSpeciale2Etablissement;
    data['codeCommune2Etablissement'] = this.codeCommune2Etablissement;
    data['codeCedex2Etablissement'] = this.codeCedex2Etablissement;
    data['libelleCedex2Etablissement'] = this.libelleCedex2Etablissement;
    data['codePaysEtranger2Etablissement'] =
        this.codePaysEtranger2Etablissement;
    data['libellePaysEtranger2Etablissement'] =
        this.libellePaysEtranger2Etablissement;
    return data;
  }
}

class PeriodesEtablissement {
  String? dateFin;
  String? dateDebut;
  String? etatAdministratifEtablissement;
  bool? changementEtatAdministratifEtablissement;
  String? enseigne1Etablissement;
  String? enseigne2Etablissement;
  String? enseigne3Etablissement;
  bool? changementEnseigneEtablissement;
  String? denominationUsuelleEtablissement;
  bool? changementDenominationUsuelleEtablissement;
  String? activitePrincipaleEtablissement;
  String? nomenclatureActivitePrincipaleEtablissement;
  bool? changementActivitePrincipaleEtablissement;
  String? caractereEmployeurEtablissement;
  bool? changementCaractereEmployeurEtablissement;

  PeriodesEtablissement(
      {this.dateFin,
        this.dateDebut,
        this.etatAdministratifEtablissement,
        this.changementEtatAdministratifEtablissement,
        this.enseigne1Etablissement,
        this.enseigne2Etablissement,
        this.enseigne3Etablissement,
        this.changementEnseigneEtablissement,
        this.denominationUsuelleEtablissement,
        this.changementDenominationUsuelleEtablissement,
        this.activitePrincipaleEtablissement,
        this.nomenclatureActivitePrincipaleEtablissement,
        this.changementActivitePrincipaleEtablissement,
        this.caractereEmployeurEtablissement,
        this.changementCaractereEmployeurEtablissement});

  PeriodesEtablissement.fromJson(Map<String, dynamic> json) {
    dateFin = json['dateFin'];
    dateDebut = json['dateDebut'];
    etatAdministratifEtablissement = json['etatAdministratifEtablissement'];
    changementEtatAdministratifEtablissement =
    json['changementEtatAdministratifEtablissement'];
    enseigne1Etablissement = json['enseigne1Etablissement'];
    enseigne2Etablissement = json['enseigne2Etablissement'];
    enseigne3Etablissement = json['enseigne3Etablissement'];
    changementEnseigneEtablissement = json['changementEnseigneEtablissement'];
    denominationUsuelleEtablissement = json['denominationUsuelleEtablissement'];
    changementDenominationUsuelleEtablissement =
    json['changementDenominationUsuelleEtablissement'];
    activitePrincipaleEtablissement = json['activitePrincipaleEtablissement'];
    nomenclatureActivitePrincipaleEtablissement =
    json['nomenclatureActivitePrincipaleEtablissement'];
    changementActivitePrincipaleEtablissement =
    json['changementActivitePrincipaleEtablissement'];
    caractereEmployeurEtablissement = json['caractereEmployeurEtablissement'];
    changementCaractereEmployeurEtablissement =
    json['changementCaractereEmployeurEtablissement'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['dateFin'] = this.dateFin;
    data['dateDebut'] = this.dateDebut;
    data['etatAdministratifEtablissement'] =
        this.etatAdministratifEtablissement;
    data['changementEtatAdministratifEtablissement'] =
        this.changementEtatAdministratifEtablissement;
    data['enseigne1Etablissement'] = this.enseigne1Etablissement;
    data['enseigne2Etablissement'] = this.enseigne2Etablissement;
    data['enseigne3Etablissement'] = this.enseigne3Etablissement;
    data['changementEnseigneEtablissement'] =
        this.changementEnseigneEtablissement;
    data['denominationUsuelleEtablissement'] =
        this.denominationUsuelleEtablissement;
    data['changementDenominationUsuelleEtablissement'] =
        this.changementDenominationUsuelleEtablissement;
    data['activitePrincipaleEtablissement'] =
        this.activitePrincipaleEtablissement;
    data['nomenclatureActivitePrincipaleEtablissement'] =
        this.nomenclatureActivitePrincipaleEtablissement;
    data['changementActivitePrincipaleEtablissement'] =
        this.changementActivitePrincipaleEtablissement;
    data['caractereEmployeurEtablissement'] =
        this.caractereEmployeurEtablissement;
    data['changementCaractereEmployeurEtablissement'] =
        this.changementCaractereEmployeurEtablissement;
    return data;
  }
}