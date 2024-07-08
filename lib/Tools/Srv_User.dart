
class UserH {
  String User_Nom = "";
  String User_Prenom = "";
  double H = 0;

  UserH(
  String User_Nom ,
  String User_Prenom ,
  double H) {
    this.User_Nom = User_Nom;
    this.User_Prenom = User_Prenom;
    this.H = H;
  }

  factory UserH.fromJson(Map<String, dynamic> json) {
    UserH wUserH = UserH(
      json['User_Nom'],
      json['User_Prenom'],
      double.parse(json['H']),
    );
    return wUserH;
  }


}

class User {
  int UserID = 0;

  bool User_Actif = true;
  String User_Token_FBM = "";
  String User_Matricule = "";
  String User_TypeUser = "";
  int User_NivHabID = 0;
  bool User_Niv_Isole = true;

  String User_NivHab = "";
      String User_Nom = "";
  String User_Prenom = "";
  String User_Adresse1 = "";
  String User_Adresse2 = "";
  String User_Cp = "";
  String User_Ville = "";
  String User_Tel = "";
  String User_Mail = "";
  String User_PassWord = "";
  String User_Service = "";
  String User_Fonction = "";
  String User_Famille = "";
  String User_Depot = "";


  static UserInit() {
    return User(0, false, "", "", "",0, "", false, "", "", "", "", "", "", "", "", "", "", "", "", "");
  }

  User(
    int UserID,
    bool User_Actif,
    String User_Token_FBM,
    String User_Matricule,
      String User_TypeUser,
      int User_NivHabID,
      String User_NivHab,
      bool User_Niv_Isole,
    String User_Nom,
    String User_Prenom,
    String User_Adresse1,
    String User_Adresse2,
    String User_Cp,
    String User_Ville,
    String User_Tel,
    String User_Mail,
    String User_PassWord,
    String User_Service,
    String User_Fonction,
    String User_Famille,
      String User_Depot,
  ) {
    this.UserID = UserID;
    this.User_Actif = User_Actif;
    this.User_Token_FBM = User_Token_FBM;
    this.User_Matricule = User_Matricule;
    this.User_TypeUser = User_TypeUser;
    this.User_NivHab = User_NivHab;
    this.User_NivHabID = User_NivHabID;
    this.User_Niv_Isole = User_Niv_Isole;
    this.User_Nom = User_Nom;
    this.User_Prenom = User_Prenom;
    this.User_Adresse1 = User_Adresse1;
    this.User_Adresse2 = User_Adresse2;
    this.User_Cp = User_Cp;
    this.User_Ville = User_Ville;
    this.User_Tel = User_Tel;
    this.User_Mail = User_Mail;
    this.User_PassWord = User_PassWord;
    this.User_Service = User_Service;
    this.User_Fonction = User_Fonction;
    this.User_Famille = User_Famille;
    this.User_Depot = User_Depot;
  }

  factory User.fromJson(Map<String, dynamic> json) {
    int iuserActif = int.parse(json['User_Actif']);
    bool buserActif = (iuserActif == 1);

    int iuserNivIsole = int.parse(json['User_Niv_Isole']);
    bool buserNivIsole = (iuserNivIsole == 1);


    User wUser = User(
      int.parse(json['UserID']),
      buserActif,
      json['User_Token_FBM'],
      json['User_Matricule'],
      json['User_TypeUser'],
      int.parse(json['User_NivHabID']),
      "",
      buserNivIsole,
      json['User_Nom'],
      json['User_Prenom'],
      json['User_Adresse1'],
      json['User_Adresse2'],
      json['User_Cp'],
      json['User_Ville'],
      json['User_Tel'],
      json['User_Mail'],
      json['User_PassWord'],
      json['User_Service'],
      json['User_Fonction'],
      json['User_Famille'],
      json['User_Depot'],
    );

    return wUser;
  }

  String Desc() {
    return '$UserID $User_Matricule $User_Nom $User_Prenom $User_Adresse1 $User_Adresse2 $User_Cp $User_Ville $User_Mail $User_Service $User_Fonction $User_Famille $User_Depot $User_NivHabID $User_TypeUser $User_Niv_Isole';
  }
}
