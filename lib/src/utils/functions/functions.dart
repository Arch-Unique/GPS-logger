import 'dart:math';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import '/src/utils/utils_barrel.dart';

///file for all #resusable functions
///Guideline: strongly type all variables and functions

abstract class UtilFunctions {
  static const pideg = 180 / pi;

  static PasswordStrength passwordStrengthChecker(String value) {
    value = value.trim();
    final bool passwordHasLetters = Regex.letterReg.hasMatch(value);
    final bool passwordHasNum = Regex.numReg.hasMatch(value);
    final bool passwordHasSpecialChar = Regex.specialCharReg.hasMatch(value);
    if (value.isEmpty) {
      return PasswordStrength.normal;
    } else if (passwordHasLetters && passwordHasNum && passwordHasSpecialChar) {
      return PasswordStrength.strong;
    } else if ((passwordHasLetters && passwordHasNum) ||
        (passwordHasSpecialChar && passwordHasNum) ||
        (passwordHasSpecialChar && passwordHasLetters)) {
      return PasswordStrength.okay;
    } else if (passwordHasLetters ^ passwordHasSpecialChar ^ passwordHasNum) {
      return PasswordStrength.weak;
    } else {
      return PasswordStrength.strong;
    }
  }

  static double deg(double a) => a / pideg;

  static clearTextEditingControllers(List<TextEditingController> conts) {
    for (var i = 0; i < conts.length; i++) {
      conts[i].clear();
    }
  }

  static String getShortCodeForFDL(String faculty, String dept, String level) {
    return "1101005";
  }

  static Map<String, List<String>> fdls = {
    "Agriculture": [
      "Animal Science",
      "Soil Science",
      "Agric. Economics",
      "Agric. Extension"
    ],
    "Arts": [
      "Mass Communication",
      "Archaeology & Tourism",
      "History & International Studies",
      "Fine & Applied Arts",
      "Performing Arts",
      "Music",
      "English & Literary Studies",
      "Foreign Languages",
      "Linguistics & Nigerian Languages"
    ],
    "Biological Sciences": [
      "Microbiology",
      "Biochemistry",
      "Plant Sciences",
      "Zoology"
    ],
    "Business Administration": [
      "Accountancy",
      "Marketing",
      "Business Administration",
      "Banking & Finance",
      "Management"
    ],
    "Education": [
      "Arts Education",
      "Science Education",
      "Adult Education",
      "Education Foundation",
      "Health & Physical Education",
      "Library Sciences Education",
      "Social Science Education",
      "Computer Education",
      "Home Economics",
      "Vocational Teacher Education"
    ],
    "Engineering": [
      "Civil Engineering",
      "Electronic Engineering",
      "Electrical Engineering",
      "Mechanical Engineering",
      "Agric. & Bioresources Engineering",
      "Materials & Metallurgical Engineering"
    ],
    "Dentistry": [
      "Child Dental Health",
      "Oral Maxillofacial Surgery",
      "Preventive Dentistry",
      "Restorative Dentistry"
    ],
    "Environmental Studies": [
      "Estate Management",
      "Urban & Regional Planning",
      "Architecture",
      "Surveying & Geodesy"
    ],
    "Health Science and technology": [
      "Medical Rehabilitation",
      "Nursing Sciences",
      "Medical Laboratory Technology"
    ],
    "Law": [
      "Public & Private Law",
      "International Law & Jurisprudence",
      "Property Law"
    ],
    "Pharmaceutical Sciences": [
      "Clinical Pharmacy",
      "Pharmaceutical and Medicinal Chemistry",
      "Pharmacology and Toxicology",
      "Pharmaceutics",
      "Pharmaceutical Technology",
      "Pharmacognosy",
      "Pharmacognosy and Environmental Medicines"
    ],
    "Physical Sciences": [
      "Statistics",
      "Physics & Astronomy",
      "Computer Science",
      "Geology",
      "Pure and Industrial Chemistry",
      "Mathematics"
    ],
    "Social Sciences": [
      "Philosophy",
      "Public Administration",
      "Psychology",
      "Economics",
      "Geography",
      "Sociology & Anthropology",
      "Religious and Cultural Studies",
      "Social Work"
    ],
    "Medical Sciences": [
      "Anaesthesia",
      "Anatomy",
      "Chemical Pathology",
      "Community Medicine",
      "Dermatology",
      "Haematology & Immunology",
      "Medical Biochemistry",
      "Medical Microbiology",
      "Morbid Anatomy",
      "Obstetrics & Gaenecology",
      "Ophthalmology",
      "Otolaringology",
      "Paediatrics",
      "Paediatric Surgery",
      "Pharmacology & Therapeutics",
      "Physiological Medicine",
      "Radiation Medicine",
      "Surgery"
    ],
    "Veterinary Medicine": [
      "Veterinary pathology and Microbiology",
      "Veterinary Obstetrics and Reproductive Diseases",
      "Veterinary Physiology and Pharmacology",
      "Veterinary Anatomy",
      "Veterinary Medicine",
      "Veterinary Surgery",
      "Veterinary Parasitology & Entomology",
      "Animal Health & Production",
      "Veterinary Public Health & Preventive Medicine",
      "Veterinary Teaching Hospital"
    ]
  };

  static List<String> levels() =>
      List.generate(10, (index) => "${(index + 1) * 100}");

  static List<String> faculties() {
    return fdls.keys.toList();
  }

  static List<String> departmentFor(String fac) {
    return fdls[fac]!;
  }

  static String getDioError(DioError e) {
    switch (e.type) {
      case DioErrorType.connectTimeout:
        return ErrorStrings.connectionTimeout;

      case DioErrorType.cancel:
        return ErrorStrings.requestCanceled;

      case DioErrorType.sendTimeout:
        return ErrorStrings.sendTimeout;

      case DioErrorType.receiveTimeout:
        return ErrorStrings.receiveTimeout;

      case DioErrorType.response:
        {
          return "Error ${e.response?.statusCode}: ${e.response?.data['msg']}";
        }
      case DioErrorType.other:
        return ErrorStrings.unknown;
    }
  }
}
