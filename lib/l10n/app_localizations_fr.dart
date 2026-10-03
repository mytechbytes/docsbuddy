// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get commonCancel => 'Annuler';

  @override
  String get commonSave => 'Enregistrer';

  @override
  String get commonOn => 'Activé';

  @override
  String get commonOff => 'Désactivé';

  @override
  String get commonEmail => 'E-mail';

  @override
  String get commonPassword => 'Mot de passe';

  @override
  String get commonEmailHint => 'vous@exemple.com';

  @override
  String get commonSignIn => 'Se connecter';

  @override
  String get commonSignOut => 'Se déconnecter';

  @override
  String get commonSettings => 'Réglages';

  @override
  String get commonFamily => 'Famille';

  @override
  String get commonNotifications => 'Notifications';

  @override
  String get commonChangePassword => 'Changer le mot de passe';

  @override
  String get commonForgotPassword => 'Mot de passe oublié ?';

  @override
  String get navHome => 'Accueil';

  @override
  String get navRooms => 'Pièces';

  @override
  String get navAssets => 'Biens';

  @override
  String get authSignInCta => 'Se connecter';

  @override
  String get authNoAccountLead => 'Pas encore de compte ? ';

  @override
  String get authSignUpAction => 'Créer un compte';

  @override
  String get authOrContinueWith => 'ou continuer avec';

  @override
  String get authContinueWithGoogle => 'Continuer avec Google';

  @override
  String get authContinueWithApple => 'Continuer avec Apple';

  @override
  String get authFullName => 'Nom complet';

  @override
  String get authFullNameHint => 'Votre nom';

  @override
  String get authCreateAccountCta => 'Créer un compte';

  @override
  String get authHaveAccountLead => 'Vous avez déjà un compte ? ';

  @override
  String get authTermsOfService => 'conditions d\'utilisation';

  @override
  String get authPrivacyPolicy => 'politique de confidentialité';

  @override
  String get authForgotSendCode => 'Envoyer le code de vérification';

  @override
  String get authRememberLead => 'Vous vous en souvenez ? ';

  @override
  String get authBackToSignIn => 'Retour à la connexion';

  @override
  String get authOtpTitle => 'Consultez votre boîte de réception';

  @override
  String authOtpSubtitle(String email) {
    return 'Nous avons envoyé un code à 6 chiffres à $email. Saisissez-le ci-dessous pour continuer.';
  }

  @override
  String get authOtpVerify => 'Vérifier';

  @override
  String authOtpResendIn(String time) {
    return 'Vous ne l\'avez pas reçu ? Renvoyer dans $time';
  }

  @override
  String get authOtpNotReceivedLead => 'Vous ne l\'avez pas reçu ? ';

  @override
  String get authOtpResend => 'Renvoyer le code';

  @override
  String get authResetTitle => 'Définir un nouveau mot de passe';

  @override
  String get authNewPassword => 'Nouveau mot de passe';

  @override
  String get authConfirmPassword => 'Confirmer le mot de passe';

  @override
  String get authResetCta => 'Réinitialiser le mot de passe';

  @override
  String get authPasswordMustHave => 'Le mot de passe doit contenir';

  @override
  String get authRuleLength => 'Au moins 8 caractères';

  @override
  String get authRuleUpper => 'Une lettre majuscule';

  @override
  String get authRuleNumber => 'Un chiffre';

  @override
  String get authRuleSpecial => 'Un caractère spécial (!@#\$…)';

  @override
  String get authResetDone =>
      'Mot de passe mis à jour. Veuillez vous connecter.';

  @override
  String get settingsSectionAccount => 'Compte';

  @override
  String get settingsPersonalInfo => 'Informations personnelles';

  @override
  String get settingsSecurity => 'Sécurité et double authentification';

  @override
  String get settingsPush => 'Notifications push';

  @override
  String get settingsEmailReminders => 'Rappels par e-mail';

  @override
  String get settingsWhatsappReminders => 'Rappels par WhatsApp';

  @override
  String get settingsDefaultOffsets => 'Délais par défaut';

  @override
  String get settingsQuietHours => 'Heures de silence';

  @override
  String get settingsQuietHoursStart => 'Début des heures de silence';

  @override
  String get settingsQuietHoursEnd => 'Fin des heures de silence';

  @override
  String get settingsManageFamily => 'Gérer la famille';

  @override
  String get settingsSectionApp => 'Application';

  @override
  String get settingsBackend => 'Serveur';

  @override
  String get settingsTestNotification => 'Envoyer une notification de test';

  @override
  String get settingsTestNotificationSent => 'Notification de test envoyée.';

  @override
  String get settingsNotificationsBlocked =>
      'Les notifications sont bloquées dans les réglages du système.';

  @override
  String get settingsRoadmap => 'Feuille de route';

  @override
  String get settingsReplayOnboarding => 'Revoir la présentation';

  @override
  String get settingsOffsetsTitle => 'Délais de rappel par défaut';

  @override
  String get settingsOffsetsSubtitle =>
      'Nombre de jours avant l\'échéance pour être prévenu ; utilisé pour les nouveaux rappels.';

  @override
  String settingsDaysBefore(int days) {
    return '$days j avant';
  }

  @override
  String get changePasswordTitle => 'Changer le mot de passe';

  @override
  String get changePasswordCurrent => 'Mot de passe actuel';

  @override
  String get changePasswordConfirm => 'Confirmer le nouveau mot de passe';

  @override
  String get changePasswordCta => 'Mettre à jour le mot de passe';

  @override
  String get changePasswordDone => 'Mot de passe mis à jour.';

  @override
  String get authForgotSubtitle =>
      'Pas d\'inquiétude. Saisissez votre e-mail et nous vous enverrons un code à 6 chiffres pour le réinitialiser.';

  @override
  String get authResetSubtitle =>
      'Choisissez un mot de passe solide que vous n\'avez jamais utilisé ici.';

  @override
  String get changePasswordNotice =>
      'Pour votre sécurité, vous serez déconnecté de vos autres appareils après le changement de mot de passe.';

  @override
  String get errorNetwork =>
      'Impossible de joindre le serveur. Vérifiez votre connexion internet.';

  @override
  String get errorUnknown => 'Une erreur est survenue. Veuillez réessayer.';

  @override
  String get errorNotSignedIn =>
      'Vous êtes déconnecté. Veuillez vous reconnecter.';

  @override
  String get errorNameRequired => 'Veuillez saisir un nom.';

  @override
  String get errorRoomNameRequired => 'Veuillez donner un nom à la pièce.';

  @override
  String get errorFamilyNameRequired => 'Veuillez saisir un nom de famille.';

  @override
  String get errorInviteCodeInvalid =>
      'Saisissez un code d\'invitation valide.';

  @override
  String get errorOwnerRoleLocked =>
      'Le rôle du propriétaire ne peut pas être modifié.';

  @override
  String get errorOwnerNotRemovable =>
      'Le propriétaire ne peut pas être retiré.';

  @override
  String get errorNoActiveFamily => 'Aucune famille active.';

  @override
  String get errorFamilyRequired => 'Rejoignez ou créez d\'abord une famille.';

  @override
  String get errorJoinedFamilyUnavailable =>
      'Impossible de charger la famille rejointe.';

  @override
  String get errorPhoneFormat =>
      'Utilisez le format international, p. ex. +91 9812345678.';

  @override
  String get errorTermsRequired =>
      'Veuillez accepter les conditions pour continuer.';

  @override
  String get errorPasswordRequirements =>
      'Le mot de passe doit respecter les exigences.';

  @override
  String get errorPasswordMismatch => 'Les mots de passe ne correspondent pas.';

  @override
  String get errorNewPasswordTooShort =>
      'Le nouveau mot de passe doit contenir au moins 8 caractères.';

  @override
  String get errorCurrentPasswordIncorrect =>
      'Le mot de passe actuel est incorrect.';

  @override
  String get errorOffsetsRequired => 'Choisissez au moins un délai de rappel.';

  @override
  String get errorNoAuthenticator =>
      'Aucune application d\'authentification n\'est associée.';

  @override
  String get errorTotpUnavailable =>
      'La configuration de l\'authentificateur est indisponible pour le moment.';

  @override
  String get errorCodeLength => 'Saisissez le code à 6 chiffres.';

  @override
  String errorUploadsFailed(int failed, int total) {
    return '$failed envois sur $total ont échoué.';
  }

  @override
  String get errorFilesUnavailable =>
      'Connectez un serveur pour ouvrir ou partager des fichiers.';

  @override
  String get errorAppOpenFailed => 'Impossible d\'ouvrir cette application.';

  @override
  String get errorNotificationsBlocked =>
      'Les notifications sont bloquées dans les réglages du système.';

  @override
  String get errorSignInIncomplete =>
      'La connexion n\'a pas abouti. Veuillez réessayer.';

  @override
  String get commonAdd => 'Ajouter';

  @override
  String get commonEdit => 'Modifier';

  @override
  String get commonDelete => 'Supprimer';

  @override
  String get commonDone => 'Terminé';

  @override
  String get commonNext => 'Suivant';

  @override
  String get commonSkip => 'Passer';

  @override
  String get commonOptional => 'facultatif';

  @override
  String get commonNoMatches => 'Aucun résultat.';

  @override
  String get commonCreate => 'Créer';

  @override
  String get commonRetry => 'Réessayer';

  @override
  String get commonView => 'Voir';

  @override
  String get commonShare => 'Partager';

  @override
  String get commonApply => 'Appliquer';

  @override
  String get commonClear => 'Effacer';

  @override
  String durationDaysShort(int days) {
    return '$days j';
  }

  @override
  String get kindInsurance => 'Assurance';

  @override
  String get kindPollution => 'Contrôle antipollution';

  @override
  String get kindAmc => 'AMC';

  @override
  String get kindService => 'Entretien';

  @override
  String get kindTax => 'Taxe';

  @override
  String get kindWarranty => 'Garantie';

  @override
  String get kindRegistration => 'Immatriculation';

  @override
  String get kindFitness => 'Contrôle technique';

  @override
  String get kindOther => 'Autre';

  @override
  String get groupVehicle => 'Véhicule';

  @override
  String get groupAppliance => 'Électroménager';

  @override
  String get groupElectronics => 'Électronique';

  @override
  String get groupDocument => 'Document';

  @override
  String get groupOther => 'Autre';

  @override
  String get recurrenceNone => 'Aucune';

  @override
  String get recurrenceNever => 'Jamais';

  @override
  String get recurrenceMonthly => 'Mensuelle';

  @override
  String get recurrenceQuarterly => 'Trimestrielle';

  @override
  String get recurrenceHalfYearly => 'Semestrielle';

  @override
  String get recurrenceYearly => 'Annuelle';

  @override
  String dueOverdueBy(int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: 'En retard de $days jours',
      one: 'En retard de $days jour',
    );
    return '$_temp0';
  }

  @override
  String get dueToday => 'Échéance aujourd\'hui';

  @override
  String dueDaysLeft(int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: '$days jours restants',
      one: '$days jour restant',
    );
    return '$_temp0';
  }

  @override
  String relativeDaysAgo(int days) {
    return 'il y a $days j';
  }

  @override
  String relativeInDays(int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: 'dans $days jours',
      one: 'dans $days jour',
    );
    return '$_temp0';
  }

  @override
  String get pillOverdue => 'En retard';

  @override
  String get pillToday => 'Aujourd\'hui';

  @override
  String get catalogAddAsset => 'Ajouter un bien';

  @override
  String get catalogEditAsset => 'Modifier le bien';

  @override
  String get catalogDeleteAsset => 'Supprimer le bien';

  @override
  String get catalogSaveChanges => 'Enregistrer les modifications';

  @override
  String get catalogSaveAsset => 'Enregistrer le bien';

  @override
  String get catalogCustomTypeTitle => 'Type d\'appareil personnalisé';

  @override
  String get catalogCustomTypeHint =>
      'p. ex. lave-vaisselle, onduleur, caméra…';

  @override
  String get catalogUseType => 'Utiliser ce type';

  @override
  String get catalogChooseCategory => 'Choisissez une catégorie';

  @override
  String get catalogChooseCategorySubtitle =>
      'Quel type d\'élément ajoutez-vous ?';

  @override
  String get catalogSelectAppliance => 'Sélectionnez votre appareil';

  @override
  String catalogNoPresetTypes(String group) {
    return 'Aucun type prédéfini pour $group : utilisez un type personnalisé ou passez.';
  }

  @override
  String catalogTypesIn(String group) {
    return 'Types de $group ; choisissez-en un ou ajoutez le vôtre.';
  }

  @override
  String get catalogOthers => 'Autres';

  @override
  String get catalogDetails => 'Détails';

  @override
  String get catalogOnlyNameRequired => 'Seul le nom est obligatoire.';

  @override
  String get catalogName => 'Nom';

  @override
  String get catalogNameHint => 'p. ex. Réfrigérateur Samsung 340 L';

  @override
  String get catalogRoomOptional => 'Pièce (facultatif)';

  @override
  String get catalogNewRoomHint => 'Nom de la nouvelle pièce, p. ex. Cuisine';

  @override
  String get catalogBrand => 'Marque';

  @override
  String get catalogModelNumber => 'Numéro de modèle';

  @override
  String get catalogSerialNo => 'N° de série / immatriculation';

  @override
  String get catalogSerialHint => 'p. ex. TN 01 AB 1234';

  @override
  String get catalogPurchaseDate => 'Date d\'achat';

  @override
  String get catalogPurchasePrice => 'Prix d\'achat';

  @override
  String get catalogPriceHint => 'p. ex. 42000';

  @override
  String get catalogStore => 'Magasin';

  @override
  String get catalogStoreHint => 'p. ex. Croma';

  @override
  String catalogDetailsFor(String name) {
    return 'Détails de $name';
  }

  @override
  String get catalogThisAppliance => 'cet appareil';

  @override
  String get catalogPropertyHint => 'p. ex. Couleur';

  @override
  String get catalogValueHint => 'valeur';

  @override
  String get catalogAddProperty => 'Ajouter une propriété';

  @override
  String get catalogAmcDate => 'Date de l\'AMC';

  @override
  String get catalogInvoices => 'Factures / reçus';

  @override
  String get catalogAttachInvoice =>
      'Joindre une facture : appareil photo, galerie ou fichiers';

  @override
  String catalogWillAutoAdd(String services) {
    return 'Sera ajouté automatiquement : $services';
  }

  @override
  String get catalogSelectYourAppliance => 'Sélectionnez votre appareil';

  @override
  String get catalogSearchAppliance => 'Recherchez votre appareil';

  @override
  String get catalogNoMatchingAppliance =>
      'Aucun appareil correspondant : utilisez « Autre chose » ci-dessous.';

  @override
  String get catalogSomethingElse => 'Autre chose';

  @override
  String catalogAllReminders(int count) {
    return 'Tous les rappels · $count';
  }

  @override
  String get catalogNoRemindersForAsset =>
      'Aucun rappel pour ce bien pour l\'instant.';

  @override
  String get catalogMarkDoneTitle => 'Marquer comme fait ?';

  @override
  String catalogMarkDoneOneOff(String label) {
    return '« $label » sera terminé et retiré des prochains rappels.';
  }

  @override
  String catalogMarkDoneRecurring(String label, String recurrence) {
    return '« $label » sera terminé et sa prochaine échéance sera planifiée ($recurrence).';
  }

  @override
  String get catalogMarkDone => 'Marquer comme fait';

  @override
  String catalogMarkedDone(String label) {
    return '$label marqué comme fait.';
  }

  @override
  String catalogDoneRescheduled(String label) {
    return '$label fait : prochaine échéance planifiée.';
  }

  @override
  String get catalogDeleteReminderTitle => 'Supprimer le rappel ?';

  @override
  String catalogDeleteReminderMessage(String label) {
    return '« $label » et ses notifications planifiées seront supprimés.';
  }

  @override
  String get catalogDeleteAssetTitle => 'Supprimer le bien ?';

  @override
  String catalogDeleteAssetMessage(String name) {
    return '« $name » ainsi que tous ses rappels et documents seront supprimés. Cette action est irréversible.';
  }

  @override
  String get catalogNoAssets =>
      'Aucun bien pour l\'instant. Touchez « Ajouter un bien ».';

  @override
  String get catalogRoomNotFound => 'Pièce introuvable.';

  @override
  String get catalogAddRoomPhoto => 'Ajouter une photo de la pièce';

  @override
  String catalogApplianceCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count appareils',
      one: '$count appareil',
    );
    return '$_temp0';
  }

  @override
  String get catalogAppliances => 'Appareils';

  @override
  String get catalogNothingRegistered =>
      'Rien d\'enregistré ici pour l\'instant.';

  @override
  String get catalogAddHere => 'Ajouter ici';

  @override
  String get catalogRenameRoom => 'Renommer la pièce';

  @override
  String catalogSince(String date) {
    return 'depuis le $date';
  }

  @override
  String get catalogNoRemindersOnAppliance =>
      'Aucun rappel pour cet appareil pour l\'instant.';

  @override
  String get catalogCreateRoom => 'Créer la pièce';

  @override
  String get catalogNoRooms =>
      'Aucune pièce pour l\'instant. Ajoutez la première ci-dessus.';

  @override
  String get catalogAddRoomPhotoLong =>
      'Ajouter une photo de la pièce : appareil photo ou appareil';

  @override
  String get catalogRoomNameHint => 'Nom de la pièce, p. ex. Cuisine';

  @override
  String get catalogAddNewRoom => 'Ajouter une pièce';

  @override
  String catalogRegisteredCount(int count) {
    return '$count enregistrés';
  }

  @override
  String get catalogSearchHint =>
      'Rechercher des biens, services, numéros de contrat…';

  @override
  String get catalogSearchEmpty =>
      'Saisissez pour rechercher vos biens et rappels.';

  @override
  String get catalogReminders => 'Rappels';

  @override
  String get catalogDue => 'Échéance';

  @override
  String get catalogOneOff => 'Ponctuel';

  @override
  String get catalogReminds => 'Rappel';

  @override
  String get catalogProvider => 'Prestataire';

  @override
  String get catalogPolicyContract => 'Contrat / police';

  @override
  String get catalogCost => 'Coût';

  @override
  String get catalogNotes => 'Notes';

  @override
  String get catalogServiceDocuments => 'DOCUMENTS DE CE SERVICE';

  @override
  String catalogRemindersTracked(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count rappels suivis',
      one: '$count rappel suivi',
    );
    return '$_temp0';
  }

  @override
  String get catalogHideDetails => 'Masquer les détails';

  @override
  String get catalogShowDetails => 'Afficher tous les détails';

  @override
  String get catalogType => 'Type';

  @override
  String get catalogCategory => 'Catégorie';

  @override
  String get catalogRoom => 'Pièce';

  @override
  String get catalogModel => 'Modèle';

  @override
  String get catalogSerialShort => 'N° de série / immat.';

  @override
  String get catalogRemindersTrackedLabel => 'Rappels suivis';

  @override
  String get catalogNextDue => 'PROCHAINE ÉCHÉANCE';

  @override
  String catalogRemindsOffsets(String offsets) {
    return 'Rappel $offsets';
  }

  @override
  String get catalogMarkAsDone => 'Marquer comme fait';

  @override
  String get catalogNoRoomHint =>
      'Aucune pièce : vous pourrez en choisir une plus tard';

  @override
  String get catalogNoRoom => 'Aucune pièce';

  @override
  String get catalogNewRoom => 'Nouvelle pièce…';

  @override
  String get catalogAddPhoto => 'Ajouter une photo';

  @override
  String get dashboardFilterByType => 'Filtrer par type';

  @override
  String get dashboardUpcoming => 'Prochaines échéances';

  @override
  String get dashboardGroupBy => 'Regrouper par';

  @override
  String get dashboardGroupNone => 'Regrouper par : aucun';

  @override
  String get dashboardGroupAsset => 'Regrouper par : bien';

  @override
  String get dashboardEmpty =>
      'Aucun rappel pour l\'instant. Ajoutez un bien pour commencer.';

  @override
  String get dashboardNoMatches => 'Rien ne correspond aux types sélectionnés.';

  @override
  String get dashboardAsset => 'Bien';

  @override
  String get dashboardTotalAppliances => 'Total des appareils actifs';

  @override
  String get filterActive => 'Services actifs';

  @override
  String get filterSecured => 'Protégés';

  @override
  String get filterSoon => 'Bientôt expirés';

  @override
  String get filterExpired => 'Expirés';

  @override
  String get docsTitle => 'DOCUMENTS';

  @override
  String get docsAdd => '+ Ajouter';

  @override
  String get docsEmpty =>
      'Aucun document pour l\'instant. Joignez des factures, garanties ou photos.';

  @override
  String get docsImageLoadFailed => 'Impossible de charger l\'image';

  @override
  String get docKindInvoice => 'Facture';

  @override
  String get docKindWarranty => 'Garantie';

  @override
  String get docKindInsurance => 'Assurance';

  @override
  String get docKindManual => 'Manuel';

  @override
  String get docKindPhoto => 'Photo';

  @override
  String get docKindOther => 'Autre';

  @override
  String get familyCreateTitle => 'Créer une famille';

  @override
  String get familyNameHint => 'p. ex. Famille Kumar';

  @override
  String get familyJoinTitle => 'Rejoindre une famille';

  @override
  String get familyInviteCodeHint => 'Code d\'invitation (p. ex. AB12CD34)';

  @override
  String get familyJoin => 'Rejoindre';

  @override
  String get familyJoined =>
      'C\'est fait ! Les pièces, biens et rappels de la famille se synchronisent.';

  @override
  String familyChangeRoleTitle(String name) {
    return 'Changer le rôle : $name';
  }

  @override
  String get familyRoleAdminHint =>
      'Gère les membres, les biens et les invitations';

  @override
  String get familyRoleViewerHint => 'Accès en lecture seule';

  @override
  String get familyRoleMemberHint => 'Ajoute et gère ses propres biens';

  @override
  String get familyRemoveTitle => 'Retirer ce membre ?';

  @override
  String familyRemoveMessage(String name) {
    return '$name perdra l\'accès aux biens et rappels de cette famille.';
  }

  @override
  String get familyRemove => 'Retirer';

  @override
  String get familyLeaveTitle => 'Quitter la famille ?';

  @override
  String get familyLeaveMessage =>
      'Vous ne recevrez plus les rappels de cette famille.';

  @override
  String get familyLeave => 'Quitter';

  @override
  String get familyEmptyTitle => 'Vous n\'êtes dans aucune famille';

  @override
  String get familyEmptyBody =>
      'Créez une famille pour partager biens et rappels, ou rejoignez-en une avec un code d\'invitation.';

  @override
  String get familyJoinWithCode => 'Rejoindre avec un code';

  @override
  String get familyMembers => 'MEMBRES';

  @override
  String get familyInviteMember => 'Inviter un membre';

  @override
  String get familyLeaveFamily => 'Quitter la famille';

  @override
  String get familyCall => 'Appeler';

  @override
  String get familyWhatsapp => 'WhatsApp';

  @override
  String get familyChangeRole => 'Changer le rôle';

  @override
  String get familyRemoveFromFamily => 'Retirer de la famille';

  @override
  String get familyInviteTitle => 'Inviter un membre';

  @override
  String familyInviteBody(String role) {
    return 'Partagez ce code. La personne pourra rejoindre en tant que $role. Expire dans 7 jours.';
  }

  @override
  String get familyCopyCode => 'Copier le code';

  @override
  String get familyCodeCopied => 'Code d\'invitation copié';

  @override
  String get roleOwner => 'Propriétaire';

  @override
  String get roleAdmin => 'Administrateur';

  @override
  String get roleMember => 'Membre';

  @override
  String get roleViewer => 'Lecteur';

  @override
  String memberCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count membres',
      one: '$count membre',
    );
    return '$_temp0';
  }

  @override
  String get profileTitle => 'Profil';

  @override
  String get profileVerified => 'Vérifié';

  @override
  String get profileEditInfo => 'Modifier les informations personnelles';

  @override
  String get profileNotificationPrefs => 'Préférences de notification';

  @override
  String get profileManagedInSettings => 'Géré dans les réglages';

  @override
  String get profileDisplayName => 'Nom affiché';

  @override
  String get profilePhone => 'Téléphone (pour les rappels WhatsApp)';

  @override
  String get profileDocuments => 'Documents';

  @override
  String get profileInvite => 'Inviter';

  @override
  String get reminderAddTitle => 'Ajouter un rappel';

  @override
  String get reminderEditTitle => 'Modifier le rappel';

  @override
  String get reminderSaveChanges => 'Enregistrer les modifications';

  @override
  String get reminderSave => 'Enregistrer le rappel';

  @override
  String get reminderTypeTitle => 'Type de rappel';

  @override
  String get reminderTypeSubtitle => 'Que faut-il suivre ?';

  @override
  String reminderDetailsTitle(String kind) {
    return 'Détails : $kind';
  }

  @override
  String get reminderDetailsSubtitle => 'Pour quand est l\'échéance ?';

  @override
  String get reminderLabel => 'Libellé';

  @override
  String get reminderDueDate => 'Date d\'échéance';

  @override
  String get reminderRepeats => 'Répétition';

  @override
  String get reminderServiceDetails => 'Détails du service (facultatif)';

  @override
  String get reminderProviderHint => 'p. ex. Acko';

  @override
  String get reminderPolicyNo => 'N° de contrat / police';

  @override
  String get reminderCostHint => 'p. ex. 4200';

  @override
  String get reminderNotifyTitle => 'Réglages de notification';

  @override
  String get reminderNotifySubtitle =>
      'Notification push et rappel pour tous les membres de la famille.';

  @override
  String get reminderNotifyMe => 'Me prévenir';

  @override
  String get reminderNoOffsets =>
      'Aucun rappel ne se déclenchera pour ce service : choisissez au moins un délai pour être prévenu.';

  @override
  String reminderOffsetsSummary(String offsets) {
    return 'Vous serez prévenu $offsets avant l\'échéance, sur les canaux activés (voir les réglages).';
  }

  @override
  String get reminderAttachTitle => 'Pièces jointes';

  @override
  String get reminderAttachSubtitle =>
      'PDF du contrat, reçu, photos… joignez-les maintenant ou plus tard depuis la page du bien.';

  @override
  String get reminderAttachDocs =>
      'Joindre des documents : appareil photo, galerie ou fichiers';

  @override
  String get remindersEmpty => 'Rien ici pour le moment.';

  @override
  String get inboxAllCaughtUp => 'Vous êtes à jour 🎉';

  @override
  String get inboxOverdue => 'En retard';

  @override
  String get inboxComingUp => 'À venir';

  @override
  String inboxDueIn(int days, String date) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: 'Échéance dans $days jours : $date',
      one: 'Échéance dans $days jour : $date',
    );
    return '$_temp0';
  }

  @override
  String get lockLocked => 'Verrouillé';

  @override
  String get lockTapToUnlock => 'Touchez pour déverrouiller';

  @override
  String get mfaTitle => 'Vérification en deux étapes';

  @override
  String get mfaSubtitle =>
      'Saisissez le code à 6 chiffres de votre application d\'authentification.';

  @override
  String get mfaCodeLabel => 'Code à 6 chiffres';

  @override
  String get securityTitle => 'Sécurité';

  @override
  String get securityBiometricSection => 'Verrouillage de l\'application';

  @override
  String get securityTwoFactorSection => 'Authentification à deux facteurs';

  @override
  String get security2faEnabled => 'La double authentification est activée';

  @override
  String get securityEnable2fa => 'Activer la double authentification';

  @override
  String get securityAuthenticatorApp => 'Application d\'authentification';

  @override
  String securityAuthenticatorSince(String date) {
    return 'Application d\'authentification · depuis le $date';
  }

  @override
  String get securityAuthenticatorHint =>
      'Utilisez Google Authenticator, Authy, 1Password, etc.';

  @override
  String get securityMoreSection => 'Plus';

  @override
  String get securityAppLockHint =>
      'Exiger le déverrouillage à la réouverture de l\'application';

  @override
  String get securityAutoLock => 'Verrouillage automatique après';

  @override
  String securityMinutesShort(int minutes) {
    return '$minutes min';
  }

  @override
  String securityMinutes(int minutes) {
    String _temp0 = intl.Intl.pluralLogic(
      minutes,
      locale: localeName,
      other: '$minutes minutes',
      one: '$minutes minute',
    );
    return '$_temp0';
  }

  @override
  String get securityActiveSessions => 'Sessions actives';

  @override
  String get securityDisable2faTitle =>
      'Désactiver la double authentification ?';

  @override
  String get securityDisable2faMessage =>
      'Votre compte n\'exigera plus de code d\'authentification pour se connecter.';

  @override
  String get securityDisable => 'Désactiver';

  @override
  String get securityCurrentSession => 'Session en cours';

  @override
  String securitySignedInAt(String date) {
    return 'Connecté le $date';
  }

  @override
  String get securityThisDevice => 'Cet appareil';

  @override
  String get securitySignOutOthers => 'Déconnecter les autres appareils';

  @override
  String get securityOthersSignedOut =>
      'Les autres appareils ont été déconnectés.';

  @override
  String get securitySetupTitle =>
      'Configurer l\'application d\'authentification';

  @override
  String get securitySetupBody =>
      'Scannez le QR code avec Google Authenticator, Authy, 1Password, etc., puis saisissez le code à 6 chiffres.';

  @override
  String get securityKeyCopied => 'Clé copiée.';

  @override
  String get securityCopyKey => 'Copier la clé';

  @override
  String get securityVerifyEnable => 'Vérifier et activer';

  @override
  String securityAvailable(String kinds) {
    return 'Disponible : $kinds';
  }

  @override
  String get biometricFace => 'Face ID';

  @override
  String get biometricFingerprint => 'Empreinte digitale';

  @override
  String get biometricDevice => 'Biométrie de l\'appareil';

  @override
  String get onboardingEyebrow1 => 'Bienvenue';

  @override
  String get onboardingTitle1 => 'Ne manquez plus jamais un renouvellement';

  @override
  String get onboardingBody1 =>
      'DocsBuddy suit vos garanties, assurances, factures et échéances pour que les dates limites ne vous surprennent plus.';

  @override
  String get onboardingEyebrow2 => 'Organisez';

  @override
  String get onboardingTitle2 => 'Tous vos biens au même endroit';

  @override
  String get onboardingBody2 =>
      'Véhicules, électroménager, électronique, et même documents : classés par pièce et par catégorie.';

  @override
  String get onboardingEyebrow3 => 'Gardez une longueur d\'avance';

  @override
  String get onboardingTitle3 =>
      'Des rappels intelligents, des semaines à l\'avance';

  @override
  String get onboardingBody3 =>
      'Configurez des alertes à 60 / 30 / 7 / 1 jours. Push, e-mail ou WhatsApp : à vous de choisir.';

  @override
  String get onboardingEyebrow4 => 'Ensemble';

  @override
  String get onboardingTitle4 => 'Gardez toute la famille synchronisée';

  @override
  String get onboardingBody4 =>
      'Invitez jusqu\'à 8 membres. Tout le monde est prévenu, chacun peut mettre à jour : plus de point de défaillance unique.';

  @override
  String get onboardingGetStarted => 'Commencer';

  @override
  String get onboardingHaveAccount => 'J\'ai déjà un compte';

  @override
  String get onboardingAlreadyWithUs => 'Déjà parmi nous ? ';

  @override
  String get commonBack => 'Retour';

  @override
  String get illoActiveInvoices => 'Factures actives';

  @override
  String get illoKitchen => 'Cuisine';

  @override
  String get illoSmartphone => 'Smartphone';

  @override
  String get illoVehicles => 'Véhicules';

  @override
  String get illoPollutionDue => 'Contrôle antipollution à venir';

  @override
  String get illoSharedWithFamily => 'Partagé avec la famille';

  @override
  String illoBikeSample(String date) {
    return '$date · Moto';
  }

  @override
  String get settingsAppearance => 'Apparence';

  @override
  String get appearanceSystem => 'Système';

  @override
  String get appearanceLight => 'Clair';

  @override
  String get appearanceDark => 'Sombre';

  @override
  String get authContinueWithMicrosoft => 'Continuer avec Microsoft';

  @override
  String get startupStepServices => 'Démarrage de DocsBuddy…';

  @override
  String get startupStepAccount => 'Connexion à votre compte…';

  @override
  String get startupStepPreferences => 'Chargement de vos préférences…';

  @override
  String startupStepCount(int step, int total) {
    return 'Étape $step sur $total';
  }

  @override
  String get startupFailedTitle => 'Impossible de démarrer DocsBuddy';

  @override
  String get startupFailedBody =>
      'Un problème est survenu pendant la préparation. Veuillez réessayer. Si cela persiste, indiquez au support ce que dit la ligne ci-dessous.';

  @override
  String get startupRetry => 'Réessayer';

  @override
  String get loadingSigningIn => 'Connexion en cours…';

  @override
  String get loadingOpeningGoogle => 'Ouverture de Google…';

  @override
  String get loadingOpeningApple => 'Ouverture d\'Apple…';

  @override
  String get loadingOpeningMicrosoft => 'Ouverture de Microsoft…';

  @override
  String get loadingCreatingAccount => 'Création de votre compte…';

  @override
  String get loadingSendingCode => 'Envoi de votre code…';

  @override
  String get loadingSendingNewCode => 'Envoi d\'un nouveau code…';

  @override
  String get loadingVerifyingCode => 'Vérification de votre code…';

  @override
  String get loadingUpdatingPassword => 'Mise à jour de votre mot de passe…';

  @override
  String get loadingSigningOut => 'Déconnexion…';

  @override
  String get loadingSavingAsset => 'Enregistrement de votre bien…';

  @override
  String get loadingSavingReminder => 'Enregistrement de votre rappel…';

  @override
  String get loadingDeletingAsset => 'Suppression du bien…';

  @override
  String get loadingDeletingReminder => 'Suppression du rappel…';

  @override
  String get loadingUploadingPhoto => 'Envoi de la photo…';

  @override
  String get loadingCreatingRoom => 'Création de la pièce…';

  @override
  String get loadingRenamingRoom => 'Renommage de la pièce…';

  @override
  String get loadingSavingRoomOrder => 'Enregistrement de l\'ordre des pièces…';

  @override
  String get loadingCreatingFamily => 'Création de votre famille…';

  @override
  String get loadingJoiningFamily => 'Adhésion à la famille…';

  @override
  String get loadingCreatingInvite => 'Création de l\'invitation…';

  @override
  String get loadingUpdatingRole => 'Mise à jour du rôle…';

  @override
  String get loadingRemovingMember => 'Retrait du membre…';

  @override
  String get loadingLeavingFamily => 'Départ de la famille…';

  @override
  String get loadingUploadingDocument => 'Envoi du document…';

  @override
  String get loadingOpeningDocument => 'Ouverture du document…';

  @override
  String get loadingPreparingDocument => 'Préparation du document à partager…';

  @override
  String get loadingDeletingDocument => 'Suppression du document…';

  @override
  String get loadingSavingSettings => 'Enregistrement des réglages…';

  @override
  String get loadingPreparingAuthenticator =>
      'Préparation de la configuration de l\'authentificateur…';

  @override
  String get loadingTurningOffTwoStep =>
      'Désactivation de la double authentification…';

  @override
  String get loadingSigningOutOthers => 'Déconnexion des autres appareils…';

  @override
  String get loadingMarkingDone => 'Marquage comme fait…';

  @override
  String get loadingSavingProfile => 'Enregistrement de votre profil…';

  @override
  String get loadingImage => 'Chargement de l\'image…';

  @override
  String get loadingDashboard => 'Chargement de votre tableau de bord…';

  @override
  String get loadingAssets => 'Chargement de vos biens…';

  @override
  String get loadingCategories => 'Chargement des catégories…';

  @override
  String get loadingRoom => 'Chargement de la pièce…';

  @override
  String get loadingAsset => 'Chargement du bien…';

  @override
  String get loadingReminders => 'Chargement des rappels…';

  @override
  String get loadingDocuments => 'Chargement des documents…';

  @override
  String get loadingRooms => 'Chargement des pièces…';

  @override
  String get loadingFamily => 'Chargement de votre famille…';

  @override
  String get loadingProfile => 'Chargement de votre profil…';

  @override
  String get loadingNotifications => 'Chargement des notifications…';

  @override
  String get loadingSecurity => 'Vérification des réglages de sécurité…';

  @override
  String authTermsAgreement(String terms, String privacy) {
    return 'J\'accepte les $terms et la $privacy.';
  }

  @override
  String catalogRoomSummary(String appliances) {
    return 'Le cœur de votre maison, avec $appliances.';
  }

  @override
  String reminderForAsset(String asset) {
    return 'Pour $asset';
  }

  @override
  String get settingsLanguage => 'Langue';

  @override
  String get languageAutomatic => 'Automatique';

  @override
  String get languageAutomaticHint => 'Suit la langue de votre appareil';

  @override
  String get languageSheetTitle => 'Choisissez une langue';

  @override
  String get errorInvalidCredentials => 'E-mail ou mot de passe incorrect.';

  @override
  String get errorEmailNotConfirmed =>
      'Veuillez d\'abord confirmer votre e-mail : consultez votre boîte de réception.';

  @override
  String get errorUserExists => 'Un compte existe déjà avec cet e-mail.';

  @override
  String get errorWeakPassword =>
      'Ce mot de passe est trop faible. Choisissez-en un plus solide.';

  @override
  String get errorRateLimited =>
      'Trop de tentatives. Patientez un instant puis réessayez.';

  @override
  String get errorCodeInvalid => 'Ce code est incorrect ou a expiré.';

  @override
  String get errorSamePassword =>
      'Choisissez un mot de passe que vous n\'avez jamais utilisé.';

  @override
  String get notificationDueToday => 'Échéance aujourd\'hui';

  @override
  String notificationDueInDays(int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: 'Échéance dans $days jours',
      one: 'Échéance dans $days jour',
    );
    return '$_temp0';
  }

  @override
  String commonStepOf(int step, int total) {
    return 'ÉTAPE $step SUR $total';
  }

  @override
  String get lockPromptUnlock => 'Déverrouiller DocsBuddy';

  @override
  String get lockPromptEnable =>
      'Confirmez pour activer le verrouillage de l\'application';

  @override
  String get lockToggleFace => 'Verrouiller avec Face ID';

  @override
  String get lockToggleFingerprint => 'Verrouiller avec l\'empreinte digitale';

  @override
  String get lockToggleFaceOrFingerprint =>
      'Verrouiller avec Face ID ou l\'empreinte';

  @override
  String get lockToggleBiometrics => 'Verrouiller avec la biométrie';

  @override
  String get lockToggleDevice => 'Verrouiller avec le verrouillage de l\'écran';

  @override
  String get lockNeedsScreenLock =>
      'Configurez un verrouillage d\'écran, une empreinte ou un visage sur cet appareil pour utiliser le verrouillage de l\'application.';

  @override
  String get lockFailed => 'Non reconnu. Veuillez réessayer.';

  @override
  String get lockTooManyAttempts =>
      'Trop de tentatives. Patientez un instant ou utilisez le code de votre appareil.';

  @override
  String get lockUnavailableBody =>
      'Cet appareil n\'a pas de verrouillage d\'écran configuré : l\'application ne peut pas être verrouillée.';

  @override
  String get lockTurnOff => 'Désactiver le verrouillage de l\'application';

  @override
  String get lockError =>
      'Impossible de vérifier votre identité. Veuillez réessayer.';

  @override
  String get featureComingSoon => 'Bientôt disponible';
}
