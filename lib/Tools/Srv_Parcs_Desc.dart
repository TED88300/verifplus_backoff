import 'package:verifplus_backoff/Tools/DbTools.dart';

class Parc_Desc {
  int? ParcsDescId = 0;
  int? ParcsDesc_ParcsId = 0;
  String? ParcsDesc_Type = "";
  String? ParcsDesc_Id = "";
  String? ParcsDesc_Lib = "";

  static Parc_DescInit(int wparcsdescParcsid, String wparcsdescType) {
    String parcsdescLib = "---";
    int parcsdescId = -1;

//    print("Parc_DescInit Parc_DescInit Parc_DescInit Parc_DescInit ${wParcsDesc_Type}");

    DbTools.getParam_Saisie_ParamMem(wparcsdescType);

    DbTools.ListParam_Saisie_Param.forEach((element) {
      if (element.Param_Saisie_Param_Init) {
        parcsdescLib = element.Param_Saisie_Param_Label;
        parcsdescId = element.Param_Saisie_ParamId;
//        print(">><<<<<<<<<>>>>>>><<<<<<<<<>>>>>>> Parc_DescInit ${element.Desc()}");

        return;
      }
    });
    Parc_Desc wparcDesc = Parc_Desc(0,0,"","","");
    wparcDesc.ParcsDescId = -1;
    wparcDesc.ParcsDesc_ParcsId = wparcsdescParcsid;
    wparcDesc.ParcsDesc_Type = wparcsdescType;
    wparcDesc.ParcsDesc_Id = "$parcsdescId";
    wparcDesc.ParcsDesc_Lib = parcsdescLib;
    return wparcDesc;
  }


  Parc_Desc(
      ParcsDescId,
      ParcsDesc_ParcsId,
      ParcsDesc_Type,
      ParcsDesc_Id,
      ParcsDesc_Lib,
      )
  {
    this.ParcsDescId  = ParcsDescId ;
    this.ParcsDesc_ParcsId  = ParcsDesc_ParcsId ;
    this.ParcsDesc_Type  = ParcsDesc_Type ;
    this.ParcsDesc_Id  = ParcsDesc_Id ;
    this.ParcsDesc_Lib  = ParcsDesc_Lib ;
  }





  Map<String, dynamic> toMap() {
    return {
      'ParcsDescId': ParcsDescId,
      'ParcsDesc_ParcsId': ParcsDesc_ParcsId,
      'ParcsDesc_Type': ParcsDesc_Type,
      'ParcsDesc_Id': ParcsDesc_Id,
      'ParcsDesc_Lib': ParcsDesc_Lib,
    };
  }

  factory Parc_Desc.fromJson(Map<String, dynamic> json) {
//    print("json $json");

    Parc_Desc wTmp = Parc_Desc(
        int.parse(json['ParcsDescId']),
        int.parse(json['ParcsDesc_ParcsId']),
        json['ParcsDesc_Type'],
        json['ParcsDesc_Id'],
        json['ParcsDesc_Lib'],
    );

    return wTmp;
  }


  @override
  String toString() {
    return 'Parc_Desc {ParcsDescId: $ParcsDescId, ParcsDesc_ParcsId: $ParcsDesc_ParcsId, ParcsDesc_Type $ParcsDesc_Type, ParcsDesc_Id : $ParcsDesc_Id,ParcsDesc_Lib : $ParcsDesc_Lib,}';
  }
}
