class Validator {
  // Validación de Email
  static String? validateEmail(String? value, {bool isRequired = true}) {
    if (value == null || value.isEmpty) {
      return isRequired ? 'El email es requerido' : null;
    }

    final pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    final regex = RegExp(pattern);

    if (!regex.hasMatch(value)) {
      return 'Por favor, introduce un email válido';
    }

    return null;
  }

  // Validación de Contraseña
  static String? validatePassword(String? value, {bool isRequired = true}) {
    if (value == null || value.isEmpty) {
      return isRequired ? 'La contraseña es requerida' : null;
    }

    if (value.length < 8) {
      return 'La contraseña debe tener al menos 8 caracteres';
    }

    if (!value.contains(RegExp(r'[A-Z]'))) {
      return 'La contraseña debe contener al menos una mayúscula';
    }

    if (!value.contains(RegExp(r'[a-z]'))) {
      return 'La contraseña debe contener al menos una minúscula';
    }

    if (!value.contains(RegExp(r'[0-9]'))) {
      return 'La contraseña debe contener al menos un número';
    }

    if (!value.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) {
      return 'La contraseña debe contener al menos un carácter especial';
    }

    return null;
  }

  // Validación de Teléfono
  static String? validatePhone(String? value, {bool isRequired = true}) {
    if (value == null || value.isEmpty) {
      return isRequired ? 'El teléfono es requerido' : null;
    }

    // Eliminar espacios, guiones, paréntesis, etc.
    final cleanedValue = value.replaceAll(RegExp(r'[^\d+]'), '');

    // Validar formato internacional o local
    final pattern =
        r'^(\+?\d{1,4})?[\s\-]?\(?\d{1,4}\)?[\s\-]?\d{1,4}[\s\-]?\d{1,4}[\s\-]?\d{1,9}$';
    final regex = RegExp(pattern);

    if (!regex.hasMatch(cleanedValue)) {
      return 'Por favor, introduce un número de teléfono válido';
    }

    if (cleanedValue.length < 8) {
      return 'El teléfono debe tener al menos 8 dígitos';
    }

    return null;
  }

  // Validación de Nombre
  static String? validateName(String? value,
      {bool isRequired = true, int minLength = 2}) {
    if (value == null || value.isEmpty) {
      return isRequired ? 'El nombre es requerido' : null;
    }

    if (value.length < minLength) {
      return 'El nombre debe tener al menos $minLength caracteres';
    }

    if (value.contains(RegExp(r'[0-9]'))) {
      return 'El nombre no debe contener números';
    }

    if (value.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) {
      return 'El nombre no debe contener caracteres especiales';
    }

    return null;
  }

  // Validación de Texto General
  static String? validateText(String? value,
      {bool isRequired = true, int minLength = 1, int? maxLength}) {
    if (value == null || value.isEmpty) {
      return isRequired ? 'Este campo es requerido' : null;
    }

    if (value.length < minLength) {
      return 'Debe tener al menos $minLength caracteres';
    }

    if (maxLength != null && value.length > maxLength) {
      return 'No debe exceder $maxLength caracteres';
    }

    return null;
  }

  // Validación de Número
  static String? validateNumber(String? value,
      {bool isRequired = true, double? min, double? max}) {
    if (value == null || value.isEmpty) {
      return isRequired ? 'Este campo es requerido' : null;
    }

    final number = double.tryParse(value);
    if (number == null) {
      return 'Por favor, introduce un número válido';
    }

    if (min != null && number < min) {
      return 'El valor debe ser mayor o igual a $min';
    }

    if (max != null && number > max) {
      return 'El valor debe ser menor o igual a $max';
    }

    return null;
  }

  // Validación de URL
  static String? validateURL(String? value, {bool isRequired = true}) {
    if (value == null || value.isEmpty) {
      return isRequired ? 'La URL es requerida' : null;
    }

    final pattern =
        r'^(https?:\/\/)?([\da-z\.-]+)\.([a-z\.]{2,6})([\/\w \.-]*)*\/?$';
    final regex = RegExp(pattern);

    if (!regex.hasMatch(value)) {
      return 'Por favor, introduce una URL válida';
    }

    return null;
  }

  // Validación de Fecha
  static String? validateDate(String? value,
      {bool isRequired = true, DateTime? minDate, DateTime? maxDate}) {
    if (value == null || value.isEmpty) {
      return isRequired ? 'La fecha es requerida' : null;
    }

    try {
      final date = DateTime.parse(value);

      if (minDate != null && date.isBefore(minDate)) {
        return 'La fecha no puede ser anterior a ${minDate.toLocal().toString().split(' ')[0]}';
      }

      if (maxDate != null && date.isAfter(maxDate)) {
        return 'La fecha no puede ser posterior a ${maxDate.toLocal().toString().split(' ')[0]}';
      }
    } catch (e) {
      return 'Por favor, introduce una fecha válida (YYYY-MM-DD)';
    }

    return null;
  }

  // Validación de Código Postal
  static String? validatePostalCode(String? value,
      {bool isRequired = true, String countryCode = 'US'}) {
    if (value == null || value.isEmpty) {
      return isRequired ? 'El código postal es requerido' : null;
    }

    // Patrones por país (puedes expandir esta lista)
    final patterns = {
      'US': r'^\d{5}(-\d{4})?$',
      'ES': r'^\d{5}$', // España
      'MX': r'^\d{5}$', // México
      'AR': r'^\d{4}$', // Argentina
      'CO': r'^\d{6}$', // Colombia
      'BR': r'^\d{5}-\d{3}$', // Brasil
    };

    final pattern = patterns[countryCode] ?? r'^\d{4,10}$';
    final regex = RegExp(pattern);

    if (!regex.hasMatch(value)) {
      return 'Por favor, introduce un código postal válido';
    }

    return null;
  }

  // Validación de Tarjeta de Crédito
  static String? validateCreditCard(String? value, {bool isRequired = true}) {
    if (value == null || value.isEmpty) {
      return isRequired ? 'El número de tarjeta es requerido' : null;
    }

    // Eliminar espacios y guiones
    final cleanedValue = value.replaceAll(RegExp(r'[\s\-]'), '');

    if (cleanedValue.length < 13 || cleanedValue.length > 19) {
      return 'El número de tarjeta debe tener entre 13 y 19 dígitos';
    }

    // Validar usando el algoritmo de Luhn
    if (!_isValidLuhn(cleanedValue)) {
      return 'El número de tarjeta no es válido';
    }

    return null;
  }

  // Algoritmo de Luhn para validar tarjetas de crédito
  static bool _isValidLuhn(String number) {
    int sum = 0;
    bool isEven = false;

    for (int i = number.length - 1; i >= 0; i--) {
      int digit = int.parse(number[i]);

      if (isEven) {
        digit *= 2;
        if (digit > 9) {
          digit -= 9;
        }
      }

      sum += digit;
      isEven = !isEven;
    }

    return sum % 10 == 0;
  }
}
