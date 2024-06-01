import 'package:client/views/auth/signin_view.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/signup_form_model.dart';
import '../../providers/auth_provider.dart';

class SignupView extends StatefulWidget {
  static const String routeName = '/signup'; // Définit un nom de route pour accéder à cette page

  const SignupView({super.key});

  @override
  State<SignupView> createState() => _SignupViewState();
}

class _SignupViewState extends State<SignupView> {
  final GlobalKey<FormState> key = GlobalKey<FormState>(); // Une clé pour identifier le formulaire
  late SignupForm signupForm; // Un objet pour stocker les données du formulaire
  FormState? get form => key.currentState; // Obtient l'état actuel du formulaire

  @override
  void initState() {
    signupForm = SignupForm(email: '', username: '', password: ''); // Initialise le formulaire avec des champs vides
    super.initState();
  }

  Future<void> submitForm() async {
    // Vérifie que le formulaire n'est pas vide et que tous les champs sont valides
    if (form != null && form!.validate()) {
      // Sauvegarde les valeurs des champs dans l'objet signupForm
      form!.save();

      // Envoie les données d'inscription à l'API pour créer un nouvel utilisateur
      final error = await Provider.of<AuthProvider>(context, listen: false)
          .signup(signupForm);

      // Si tout s'est bien passé (pas d'erreur) et que la page est toujours visible
      if (error == null && mounted) {
        // Va à la page de connexion
        Navigator.pushNamed(context, SigninView.routeName);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.only(top: 50, bottom: 20, left: 20, right: 20),
        alignment: Alignment.center,
        color: Colors.black,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Inscription', // Titre de la page
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
                      'Nom d\'utilisateur', // Etiquette pour le champ du nom d'utilisateur
                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
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
                          signupForm.username = newValue; // Sauvegarde le nom d'utilisateur
                        }
                      },
                    ),
                    const Padding(padding: EdgeInsets.symmetric(vertical: 10)),
                    const Text(
                      'Email', // Etiquette pour le champ de l'email
                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
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
                          signupForm.email = newValue; // Sauvegarde l'email
                        }
                      },
                    ),
                    const Padding(padding: EdgeInsets.symmetric(vertical: 10)),
                    const Text(
                      'Mot de passe', // Etiquette pour le champ du mot de passe
                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
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
                          signupForm.password = newValue; // Sauvegarde le mot de passe
                        }
                      },
                    ),
                    const Padding(padding: EdgeInsets.symmetric(vertical: 15)),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Theme.of(context).primaryColor),
                      onPressed: submitForm, // Appelle la fonction pour soumettre le formulaire
                      child: const Text(
                        "S'inscrire", // Texte du bouton pour s'inscrire
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
