class Parc_Ent_Count {
  String ParamType = "";
  String ParamTypeOg = "";
  int ParamTypeOg_count = 0;
}


/*
ParcsId
Parcs_order
Parcs_InterventionId
Parcs_Type
Parcs_Date_Rev
Parcs_QRCode
Parcs_FREQ_Id
Parcs_FREQ_Label
Parcs_ANN_Id
Parcs_ANN_Label
Parcs_NIV_Id
Parcs_NIV_Label
Parcs_ZNE_Id
Parcs_ZNE_Label
Parcs_EMP_Id
Parcs_EMP_Label
Parcs_LOT_Id
Parcs_LOT_Label
Parcs_SERIE_Id
Parcs_SERIE_Label
Parcs_Audit_Note
Parcs_Verif_Note
Parcs_Intervention_Timer
Parcs_MaintPrev
Parcs_Install
Parcs_MaintCorrect
Parcs_Date_Desc


   */

  class Parc_Ent {
  int?    ParcsId = 0;
  int?    Parcs_order = 0;
  int?    Parcs_InterventionId = 0;
  String? Parcs_Type = "";
  String? Parcs_Date_Rev = "";
  String? Parcs_QRCode = "";
  String? Parcs_FREQ_Id = "";
  String? Parcs_FREQ_Label = "";
  String? Parcs_ANN_Id = "";
  String? Parcs_ANN_Label = "";
  String? Parcs_FAB_Id = "";
  String? Parcs_FAB_Label = "";
  String? Parcs_NIV_Id = "";
  String? Parcs_NIV_Label = "";
  String? Parcs_ZNE_Id = "";
  String? Parcs_ZNE_Label = "";
  String? Parcs_EMP_Id = "";
  String? Parcs_EMP_Label = "";
  String? Parcs_LOT_Id = "";
  String? Parcs_LOT_Label = "";
  String? Parcs_SERIE_Id = "";
  String? Parcs_SERIE_Label = "";
  String? Parcs_Audit_Note = "";
  String? Parcs_Verif_Note = "";
  int?    Parcs_Intervention_Timer = 0;
  String? Parcs_UUID          = "";
  String? Parcs_UUID_Parent   = "";
  String? Parcs_CodeArticle   = "";
  String? Parcs_CODF          = "";
  String? Parcs_NCERT         = "";
  String? Livr                = "";
  String? Devis               = "";
  String? Action              = "";


  bool?   Parcs_MaintPrev = true;
  bool?   Parcs_Install = true;
  bool?   Parcs_MaintCorrect = true;
  String? Parcs_Date_Desc = "";
  List<String?>? Parcs_Cols = [];

  Parc_Ent(
    this.ParcsId,
    this.Parcs_order,
    this.Parcs_InterventionId,
    this.Parcs_Type,
    this.Parcs_Date_Rev,
    this.Parcs_QRCode,
    this.Parcs_FREQ_Id,
    this.Parcs_FREQ_Label,
    this.Parcs_ANN_Id,
    this.Parcs_ANN_Label,
      this.Parcs_FAB_Id,
      this.Parcs_FAB_Label,
    this.Parcs_NIV_Id,
    this.Parcs_NIV_Label,
    this.Parcs_ZNE_Id,
    this.Parcs_ZNE_Label,
    this.Parcs_EMP_Id,
    this.Parcs_EMP_Label,
    this.Parcs_LOT_Id,
    this.Parcs_LOT_Label,
    this.Parcs_SERIE_Id,
    this.Parcs_SERIE_Label,
    this.Parcs_Audit_Note,
    this.Parcs_Verif_Note,
    this.Parcs_Intervention_Timer,

      this.Parcs_UUID,
      this.Parcs_UUID_Parent,
      this.Parcs_CodeArticle,
      this.Parcs_CODF,
      this.Parcs_NCERT,
      this.Livr,
      this.Devis,
      this.Action,


    this.Parcs_MaintPrev,
    this.Parcs_Install,
    this.Parcs_MaintCorrect,
    this.Parcs_Date_Desc,




  )
  {
    this.ParcsId  = ParcsId ;
    this.Parcs_order  = Parcs_order ;
    this.Parcs_InterventionId  = Parcs_InterventionId ;
    this.Parcs_Type  = Parcs_Type ;
    this.Parcs_Date_Rev  = Parcs_Date_Rev ;
    this.Parcs_QRCode  = Parcs_QRCode ;
    this.Parcs_FREQ_Id  = Parcs_FREQ_Id ;
    this.Parcs_FREQ_Label  = Parcs_FREQ_Label ;
    this.Parcs_ANN_Id  = Parcs_ANN_Id ;
    this.Parcs_ANN_Label  = Parcs_ANN_Label ;
    this.Parcs_FAB_Id  = Parcs_FAB_Id ;
    this.Parcs_FAB_Label  = Parcs_FAB_Label ;
    this.Parcs_NIV_Id  = Parcs_NIV_Id ;
    this.Parcs_NIV_Label  = Parcs_NIV_Label ;
    this.Parcs_ZNE_Id  = Parcs_ZNE_Id ;
    this.Parcs_ZNE_Label  = Parcs_ZNE_Label ;
    this.Parcs_EMP_Id  = Parcs_EMP_Id ;
    this.Parcs_EMP_Label  = Parcs_EMP_Label ;
    this.Parcs_LOT_Id  = Parcs_LOT_Id ;
    this.Parcs_LOT_Label  = Parcs_LOT_Label ;
    this.Parcs_SERIE_Id  = Parcs_SERIE_Id ;
    this.Parcs_SERIE_Label  = Parcs_SERIE_Label ;
    this.Parcs_Audit_Note  = Parcs_Audit_Note ;
    this.Parcs_Verif_Note  = Parcs_Verif_Note ;
    this.Parcs_Intervention_Timer  = Parcs_Intervention_Timer ;

    this.Parcs_UUID  = Parcs_UUID;
    this.Parcs_UUID_Parent  = Parcs_UUID_Parent;
    this.Parcs_CodeArticle  = Parcs_CodeArticle;
    this.Parcs_CODF  = Parcs_CODF;
    this.Parcs_NCERT  = Parcs_NCERT;
    this.Livr  = Livr;
    this.Devis  = Devis;
    this.Action  = Action;




    this.Parcs_MaintPrev  = Parcs_MaintPrev ;
    this.Parcs_Install  = Parcs_Install ;
    this.Parcs_MaintCorrect  = Parcs_MaintCorrect ;
    this.Parcs_Date_Desc  = Parcs_Date_Desc ;
  }

  static Parc_EntInit(int parcsInterventionid, String parcsType, int parcsOrder) {
    Parc_Ent wParc_Ent = Parc_Ent(0 , parcsOrder, parcsInterventionid, parcsType,"","","","","","","","","","","","","","","","","","","","",0,"","","","","","","","",false,false,false,"");
    return wParc_Ent;
  }

  Map<String, dynamic> toMap() {
    return {
      'ParcsId': ParcsId,
      'Parcs_order': Parcs_order,
      'Parcs_InterventionId': Parcs_InterventionId,
      'Parcs_Type': Parcs_Type,
      'Parcs_Date_Rev': Parcs_Date_Rev,
      'Parcs_QRCode': Parcs_QRCode,
      'Parcs_FREQ_Id':  Parcs_FREQ_Id,
      'Parcs_FREQ_Label':     Parcs_FREQ_Label,
      'Parcs_ANN_Id':  Parcs_ANN_Id,
      'Parcs_ANN_Label':     Parcs_ANN_Label,
      'Parcs_FAB_Id':  Parcs_FAB_Id,
      'Parcs_FAB_Label':     Parcs_FAB_Label,
      'Parcs_NIV_Id':  Parcs_NIV_Id,
      'Parcs_NIV_Label':     Parcs_NIV_Label,
      'Parcs_ZNE_Id':  Parcs_ZNE_Id,
      'Parcs_ZNE_Label':     Parcs_ZNE_Label,
      'Parcs_EMP_Id':  Parcs_EMP_Id,
      'Parcs_EMP_Label':     Parcs_EMP_Label,
      'Parcs_LOT_Id':  Parcs_LOT_Id,
      'Parcs_LOT_Label':     Parcs_LOT_Label,
      'Parcs_SERIE_Id':  Parcs_SERIE_Id,
      'Parcs_SERIE_Label':     Parcs_SERIE_Label,
      'Parcs_Audit_Note':     Parcs_Audit_Note,
      'Parcs_Verif_Note':     Parcs_Verif_Note,
      'Parcs_Intervention_Timer': 0,

      'Parcs_UUID': Parcs_UUID,
      'Parcs_UUID_Parent': Parcs_UUID_Parent,
      'Parcs_CodeArticle': Parcs_CodeArticle,
      'Parcs_CODF': Parcs_CODF,
      'Parcs_NCERT': Parcs_NCERT,
      'Livr': Livr,
      'Devis': Devis,
      'Action': Action,
      'Parcs_Date_Desc':     "",
      'Parcs_Install':     true,
      'Parcs_MaintCorrect':     true,
      'Parcs_MaintPrev':     true,

    };
  }

  factory Parc_Ent.fromJson(Map<String, dynamic> json) {
//    print("json $json");

    if (json['Parcs_Intervention_Timer'] == null) json['Parcs_Intervention_Timer'] ="0";


    Parc_Ent wTmp = Parc_Ent(
        int.parse(json['ParcsId']),
        int.parse(json['Parcs_order']),
        int.parse(json['Parcs_InterventionId']),
        json['Parcs_Type'],
        json['Parcs_Date_Rev'],
        json['Parcs_QRCode'],
        json['Parcs_FREQ_Id'],
        json['Parcs_FREQ_Label'],
        json['Parcs_ANN_Id'],
        json['Parcs_ANN_Label'],
        json['Parcs_ANN_Id'],
        json['Parcs_ANN_Label'],
        json['Parcs_NIV_Id'],
        json['Parcs_NIV_Label'],
        json['Parcs_ZNE_Id'],
        json['Parcs_ZNE_Label'],
        json['Parcs_EMP_Id'],
        json['Parcs_EMP_Label'],
        json['Parcs_LOT_Id'],
        json['Parcs_LOT_Label'],
        json['Parcs_SERIE_Id'],
        json['Parcs_SERIE_Label'],
        json['Parcs_Audit_Note'],
        json['Parcs_Verif_Note'],
        int.parse(json['Parcs_Intervention_Timer']),
        json['Parcs_UUID'],
        json['Parcs_UUID_Parent'],
        json['Parcs_CodeArticle'],
        json['Parcs_CODF'],
        json['Parcs_NCERT'],
        json['Livr'],
        json['Devis'],
        json['Action'],



        false,
        false,
        false,
        ""
    );

    return wTmp;
  }




  @override
  String toString() {
    return 'Parc_Ent {ParcsId: $ParcsId, Parcs_order $Parcs_order, Parcs_InterventionId : $Parcs_InterventionId, Parcs_QRCode $Parcs_QRCode, '
        'Parcs_FREQ_Id $Parcs_FREQ_Id, Parcs_FREQ_Label $Parcs_FREQ_Label, '
        'Parcs_ANN_Id $Parcs_ANN_Id, Parcs_ANN_Label $Parcs_ANN_Label, '
        'Parcs_FAB_Id $Parcs_FAB_Id, Parcs_FAB_Label $Parcs_FAB_Label, '
        'Parcs_NIV_Id $Parcs_NIV_Id, Parcs_NIV_Label $Parcs_NIV_Label, '
        'Parcs_ZNE_Id $Parcs_ZNE_Id, Parcs_ZNE_Label $Parcs_ZNE_Label, '
        'Parcs_EMP_Id $Parcs_EMP_Id, Parcs_EMP_Label $Parcs_EMP_Label, '
        'Parcs_LOT_Id $Parcs_LOT_Id, Parcs_LOT_Label $Parcs_LOT_Label, '
        'Parcs_SERIE_Id $Parcs_SERIE_Id, '
        'Parcs_SERIE_Label $Parcs_SERIE_Label, '
        'Parcs_Audit_Note $Parcs_Audit_Note, '
        'Parcs_Verif_Note $Parcs_Verif_Note, '

        'Parcs_UUID $Parcs_UUID, '
        'Parcs_UUID_Parent $Parcs_UUID_Parent, '
        'Parcs_CodeArticle $Parcs_CodeArticle, '
        'Parcs_CODF $Parcs_CODF, '
        'Parcs_NCERT $Parcs_NCERT, '
        'Livr $Livr, '
        'Devis $Devis, '
        'Action $Action, '


        'Parcs_Intervention_Timer $Parcs_Intervention_Timer, '
        '> Parcs_MaintPrev $Parcs_MaintPrev, '
        '> Parcs_Install $Parcs_Install, '
        '> Parcs_MaintCorrect $Parcs_MaintCorrect, '
        'Parcs_Date_Desc : $Parcs_Date_Desc, Parcs_Cols : $Parcs_Cols,}';
  }




}
