import 'package:flutter/material.dart';
import 'package:verifplus_backoff/Tools/DbTools.dart';
import 'package:verifplus_backoff/widgetTools/gColors.dart';
import 'package:verifplus_backoff/Tools/shared_Cookies.dart';
import 'package:verifplus_backoff/widgets/4-Menu.dart';




enum LoginError {
  PENDING,
  EMAIL_VALIDATE,
  WAITING_CONFIRMATION,
  DISABLE,
  ERROR_USER_NOT_FOUND,
  WRONG_PASSWORD
}

enum AuthStatus { NOT_LOG, SIGNED_IN_PRO, SIGNED_IN_PATIENT }

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  bool isChecked = false;
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  int cpthelp = 1;




  void initLib() async {}

  @override
  void initState() {
    super.initState();
    initLib();


    if (DbTools.gTED) {
      emailController.text = "daudiert2@wanadoo.fr";
      passwordController.text = "Zzt88300";
    }
  }

  @override
  Widget build(BuildContext context) {
    final email = TextField(
      keyboardType: TextInputType.emailAddress,
      controller: emailController,
      autofocus: false,
      decoration: InputDecoration(
        hintText: 'Mail',
        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
      ),
    );

    final password = TextField(
      controller: passwordController,
      autofocus: false,
      obscureText: true,
      decoration: InputDecoration(
        hintText: 'Mot de passe',
        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
      ),
    );



    final loginButton = Container(
      width: MediaQuery.of(context).size.width / 10,
      child: ElevatedButton(
        onPressed: () async {
          cpthelp = 0;

          if (await DbTools.getUserLogin(
              emailController.text, passwordController.text)) {
            CookieManager cm = CookieManager.getInstance();
              cm.addToCookie("emailLogin", emailController.text);
              cm.addToCookie("passwordLogin", passwordController.text);
              cm.addToCookie("IsRememberLogin", "X");


            Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => Menu()));

          }
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: gColors.secondarytxt,
          padding: const EdgeInsets.all(12.0),),
        child: Text('Login',
            style: TextStyle(
                fontSize: 16,
                color: Colors.white,
                fontWeight: FontWeight.bold)),
      ),
    );

    final DemoButtonTED = Container(
      width: MediaQuery.of(context).size.width / 10,
      child: ElevatedButton(
        onPressed: () async {
          emailController.text = "daudiert2@wanadoo.fr";
          passwordController.text = "Zzt88300";
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: gColors.secondarytxt,
          padding: const EdgeInsets.all(12.0),),
        child: Text('Démo Ted',
            style: TextStyle(
                fontSize: 16,
                color: Colors.white,
                fontWeight: FontWeight.bold)),
      ),
    );



    final DemoButtonGuillaume = Container(
      width: MediaQuery.of(context).size.width / 10,
      child: ElevatedButton(
        onPressed: () async {
          emailController.text = "g.deveza@mondialfeu.fr";
          passwordController.text = "";
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: gColors.secondarytxt,
          padding: const EdgeInsets.all(12.0),),
        child: Text('Démo Guillaume',
            style: TextStyle(
                fontSize: 16,
                color: Colors.white,
                fontWeight: FontWeight.bold)),
      ),
    );

    final DemoButtonUser = Container(
      width: MediaQuery.of(context).size.width / 10,
      child: ElevatedButton(
        onPressed: () async {
          emailController.text = "Asaf@gmail.com";
          passwordController.text = "Asaf";
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: gColors.secondarytxt,
          padding: const EdgeInsets.all(12.0),),
        child: Text('Démo User',
            style: TextStyle(
                fontSize: 16,
                color: Colors.white,
                fontWeight: FontWeight.bold)),
      ),
    );


    final DemoButtonClient = Container(
      width: MediaQuery.of(context).size.width / 10,
      child: ElevatedButton(
        onPressed: () async {
          emailController.text = "mm@gmail.com";
          passwordController.text = "mm13500";
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: gColors.secondarytxt,
          padding: const EdgeInsets.all(12.0),),
        child: Text('Démo Client',
            style: TextStyle(
                fontSize: 16,
                color: Colors.white,
                fontWeight: FontWeight.bold)),
      ),
    );





    return Scaffold(
      backgroundColor: gColors.primary,
      body: Container(
        padding: EdgeInsets.fromLTRB(80.0, 10.0, 80.0, 20.0),
        color: gColors.white,
        child: Column(
          children: <Widget>[

            SizedBox(height: 100.0),

            InkWell(
              child: Container(
                child:
                new Image.asset('assets/images/AppIco.png', height: 100,),
              ),
              onTap: () {
                cpthelp += 1;
              },
            ),



            SizedBox(height: 8.0),


            InkWell(
              child: Container(
                child:
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Outils de vérification ",
                      style: gColors.bodyTitle1_B_P,
                    ),
                    Text(
                      "Incendie",
                      style: gColors.bodyTitle1_B_tks.copyWith(fontSize: 32),
                    ),
                  ],
                ),
              ),
              onTap: () {
                if (cpthelp == 2)
                  {
                    DbTools.gTED = true;
                    setState(() {

                    });
                  }

              },
            ),



            Container(
              width: MediaQuery.of(context).size.width / 8,
              child:
//            Padding(padding: EdgeInsets.fromLTRB(180.0, 0.0, 180.0, 0.0),
//            child:
                  Column(
                children: [
                  SizedBox(height: 8.0),
                  email,
                  SizedBox(height: 8.0),
                  password,
                  SizedBox(height: 12.0),
                ],
              ),
            ),
            Row(

              children: [
                Spacer(),
                loginButton,
                Spacer(),
              ],
            ),
            SizedBox(height: 8.0),

            DbTools.gTED ? DemoButtonTED : Container(),
            SizedBox(height: 8.0),
            DbTools.gTED ? DemoButtonGuillaume : Container(),
            SizedBox(height: 8.0),
            DbTools.gTED ? DemoButtonUser : Container(),
            SizedBox(height: 8.0),
            DbTools.gTED ? DemoButtonClient : Container(),
            Spacer(),
            Text(DbTools.gVersion,
                style: TextStyle(
                  fontSize: 12,
                )),
          ],
        ),
      ),
    );
  }

}
