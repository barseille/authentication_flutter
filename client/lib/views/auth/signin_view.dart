import 'package:client/models/user_model.dart';
import 'package:client/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/signin_form_model.dart';
import '../../providers/auth_provider.dart';
import '../profile_view.dart';

class SigninView extends StatefulWidget {
  static const String routeName =
      '/signin'; // Définit un nom de route pour accéder à cette page

  const SigninView({super.key});

  @override
  State<SigninView> createState() => _SigninViewState();
}

class _SigninViewState extends State<SigninView> {
  final GlobalKey<FormState> key =
      GlobalKey<FormState>(); // Une clé pour identifier le formulaire
  late SigninForm signinForm; // Un objet pour stocker les données du formulaire
  FormState? get form =>
      key.currentState; // Obtient l'état actuel du formulaire
  bool hidepassword = true;
  String? error;

  @override
  void initState() {
    signinForm = SigninForm(
        email: '',
        password: ''); // Initialise le formulaire avec des champs vides
    super.initState();
  }

  Future<void> submitForm() async {
    // Vérifie que le formulaire n'est pas vide et que tous les champs sont valides
    if (form != null && form!.validate()) {
      // Sauvegarde les valeurs des champs dans l'objet signupForm
      form!.save();
      final response = await Provider.of<AuthProvider>(context, listen: false)
          .signin(signinForm);

      if (response is User) {
        if (!mounted) return;
        Provider.of<UserProvider>(context, listen: false).updateUser(response);
        Navigator.pushNamed(context, ProfileView.routeName);
      } else {
        setState(() {
          error = response[error];
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding:
            const EdgeInsets.only(top: 50, bottom: 20, left: 20, right: 20),
        alignment: Alignment.center,
        color: Colors.black,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Connexion', // Titre de la page
              style: TextStyle(
                fontSize: 18,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Padding(padding: EdgeInsets.symmetric(vertical: 15)),
            Form(
                key: key, // Attribue la clé au formulaire
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Text(
                      'Email', // Etiquette pour le champ de l'email
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                    const Padding(padding: EdgeInsets.symmetric(vertical: 3)),
                    TextFormField(
                      decoration: InputDecoration(
                        fillColor: Colors.grey.shade900,
                        filled: true,
                      ),
                      style: const TextStyle(color: Colors.white),
                      onSaved: (newValue) {
                        if (newValue != null) {
                          signinForm.email = newValue; // Sauvegarde l'email
                        }
                      },
                    ),
                    const Padding(padding: EdgeInsets.symmetric(vertical: 10)),
                    const Text(
                      'Mot de passe', // Etiquette pour le champ du mot de passe
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                    const Padding(padding: EdgeInsets.symmetric(vertical: 3)),
                    TextFormField(
                      obscureText: hidepassword,
                      decoration: InputDecoration(
                          fillColor: Colors.grey.shade900,
                          filled: true,
                          suffixIcon: IconButton(
                            icon: hidepassword
                                ? const Icon(
                                    Icons.visibility,
                                    color: Colors.white,
                                  )
                                : const Icon(Icons.visibility_off,
                                    color: Colors.white),
                            onPressed: () {
                              setState(() {
                                hidepassword = !hidepassword;
                              });
                            },
                          )),
                      style: const TextStyle(color: Colors.white),
                      onSaved: (newValue) {
                        if (newValue != null) {
                          signinForm.password =
                              newValue; // Sauvegarde le mot de passe
                        }
                      },
                    ),
                    const Padding(padding: EdgeInsets.symmetric(vertical: 15)),
                    if (error != null)
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        child: Text(
                          error!,
                          style: const TextStyle(color: Colors.red),
                        ),
                      ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Theme.of(context).primaryColor),
                      onPressed:
                          submitForm, // Appelle la fonction pour soumettre le formulaire
                      child: const Text(
                        "Se connecter", // Texte du bouton pour s'inscrire
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                )),
          ],
        ),
      ),
    );
  }
}
