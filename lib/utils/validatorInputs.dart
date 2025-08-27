class ValidatorInputs {
  String? validateEmail(String? value) {
    String pattern =
        r'^(([^<>()[\]\\.,;:\s@\”]+(\.[^<>()[\]\\.,;:\s@\”]+)*)|(\”.+\”))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';

    RegExp regex = RegExp(pattern);
    if (!regex.hasMatch(value!)) {
      return 'Ingrese un email valido.';
    } else {
      return null;
    }
  }

  String? validateMobile(String? value) {
    // Indian Mobile number are of 10 digit only
    if (value!.length < 9) {
      return 'El número de móvil debe tener 9 dígitos';
    } else {
      return null;
    }
  }

  String? validatePassword(String? value) {
    RegExp regex =
        RegExp(r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$');
    if (value!.isEmpty) {
      return 'Ingrese una contraseña';
    } else {
      if (!regex.hasMatch(value)) {
        return 'La contraseña no es valida.';
      } else {
        return null;
      }
    }
  }
}
