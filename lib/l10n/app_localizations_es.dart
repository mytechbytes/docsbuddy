// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get commonCancel => 'Cancelar';

  @override
  String get commonSave => 'Guardar';

  @override
  String get commonOn => 'Activado';

  @override
  String get commonOff => 'Desactivado';

  @override
  String get commonEmail => 'Correo electrónico';

  @override
  String get commonPassword => 'Contraseña';

  @override
  String get commonEmailHint => 'tu@ejemplo.com';

  @override
  String get commonSignIn => 'Iniciar sesión';

  @override
  String get commonSignOut => 'Cerrar sesión';

  @override
  String get commonSettings => 'Ajustes';

  @override
  String get commonFamily => 'Familia';

  @override
  String get commonNotifications => 'Notificaciones';

  @override
  String get commonChangePassword => 'Cambiar contraseña';

  @override
  String get commonForgotPassword => '¿Olvidaste tu contraseña?';

  @override
  String get navHome => 'Inicio';

  @override
  String get navRooms => 'Estancias';

  @override
  String get navAssets => 'Bienes';

  @override
  String get authSignInCta => 'Iniciar sesión';

  @override
  String get authNoAccountLead => '¿No tienes una cuenta? ';

  @override
  String get authSignUpAction => 'Regístrate';

  @override
  String get authOrContinueWith => 'o continúa con';

  @override
  String get authContinueWithGoogle => 'Continuar con Google';

  @override
  String get authContinueWithApple => 'Continuar con Apple';

  @override
  String get authFullName => 'Nombre completo';

  @override
  String get authFullNameHint => 'Tu nombre';

  @override
  String get authCreateAccountCta => 'Crear cuenta';

  @override
  String get authHaveAccountLead => '¿Ya tienes una cuenta? ';

  @override
  String get authTermsOfService => 'Términos del servicio';

  @override
  String get authPrivacyPolicy => 'Política de privacidad';

  @override
  String get authForgotSendCode => 'Enviar código de verificación';

  @override
  String get authRememberLead => '¿Lo recordaste? ';

  @override
  String get authBackToSignIn => 'Volver a iniciar sesión';

  @override
  String get authOtpTitle => 'Revisa tu bandeja de entrada';

  @override
  String authOtpSubtitle(String email) {
    return 'Enviamos un código de 6 dígitos a $email. Introdúcelo abajo para continuar.';
  }

  @override
  String get authOtpVerify => 'Verificar';

  @override
  String authOtpResendIn(String time) {
    return '¿No lo recibiste? Reenviar en $time';
  }

  @override
  String get authOtpNotReceivedLead => '¿No lo recibiste? ';

  @override
  String get authOtpResend => 'Reenviar código';

  @override
  String get authResetTitle => 'Crea una contraseña nueva';

  @override
  String get authNewPassword => 'Contraseña nueva';

  @override
  String get authConfirmPassword => 'Confirmar contraseña';

  @override
  String get authResetCta => 'Restablecer contraseña';

  @override
  String get authPasswordMustHave => 'La contraseña debe tener';

  @override
  String get authRuleLength => 'Al menos 8 caracteres';

  @override
  String get authRuleUpper => 'Una letra mayúscula';

  @override
  String get authRuleNumber => 'Un número';

  @override
  String get authRuleSpecial => 'Un carácter especial (!@#\$…)';

  @override
  String get authResetDone => 'Contraseña actualizada. Inicia sesión.';

  @override
  String get settingsSectionAccount => 'Cuenta';

  @override
  String get settingsPersonalInfo => 'Información personal';

  @override
  String get settingsSecurity => 'Seguridad y verificación en dos pasos';

  @override
  String get settingsPush => 'Notificaciones push';

  @override
  String get settingsEmailReminders => 'Recordatorios por correo';

  @override
  String get settingsWhatsappReminders => 'Recordatorios por WhatsApp';

  @override
  String get settingsDefaultOffsets => 'Antelación predeterminada';

  @override
  String get settingsQuietHours => 'Horas de silencio';

  @override
  String get settingsQuietHoursStart => 'Inicio de las horas de silencio';

  @override
  String get settingsQuietHoursEnd => 'Fin de las horas de silencio';

  @override
  String get settingsManageFamily => 'Gestionar familia';

  @override
  String get settingsSectionApp => 'Aplicación';

  @override
  String get settingsBackend => 'Servidor';

  @override
  String get settingsTestNotification => 'Enviar notificación de prueba';

  @override
  String get settingsTestNotificationSent =>
      'Se envió una notificación de prueba.';

  @override
  String get settingsNotificationsBlocked =>
      'Las notificaciones están bloqueadas en los ajustes del sistema.';

  @override
  String get settingsRoadmap => 'Hoja de ruta';

  @override
  String get settingsReplayOnboarding => 'Volver a ver la bienvenida';

  @override
  String get settingsOffsetsTitle =>
      'Antelación predeterminada de los recordatorios';

  @override
  String get settingsOffsetsSubtitle =>
      'Días antes del vencimiento para avisar; se usa en los recordatorios nuevos.';

  @override
  String settingsDaysBefore(int days) {
    return '$days d antes';
  }

  @override
  String get changePasswordTitle => 'Cambiar contraseña';

  @override
  String get changePasswordCurrent => 'Contraseña actual';

  @override
  String get changePasswordConfirm => 'Confirmar contraseña nueva';

  @override
  String get changePasswordCta => 'Actualizar contraseña';

  @override
  String get changePasswordDone => 'Contraseña actualizada.';

  @override
  String get authForgotSubtitle =>
      'No te preocupes. Escribe tu correo y te enviaremos un código de 6 dígitos para restablecerla.';

  @override
  String get authResetSubtitle =>
      'Elige una contraseña segura que no hayas usado antes aquí.';

  @override
  String get changePasswordNotice =>
      'Por tu seguridad, se cerrará la sesión en tus otros dispositivos al cambiar la contraseña.';

  @override
  String get errorNetwork =>
      'No se puede conectar con el servidor. Revisa tu conexión a internet.';

  @override
  String get errorUnknown => 'Algo salió mal. Inténtalo de nuevo.';

  @override
  String get errorNotSignedIn =>
      'Tu sesión está cerrada. Inicia sesión de nuevo.';

  @override
  String get errorNameRequired => 'Escribe un nombre.';

  @override
  String get errorRoomNameRequired => 'Ponle un nombre a la estancia.';

  @override
  String get errorFamilyNameRequired => 'Escribe un nombre de familia.';

  @override
  String get errorInviteCodeInvalid =>
      'Introduce un código de invitación válido.';

  @override
  String get errorOwnerRoleLocked =>
      'No se puede cambiar el rol del propietario.';

  @override
  String get errorOwnerNotRemovable => 'No se puede quitar al propietario.';

  @override
  String get errorNoActiveFamily => 'No hay ninguna familia activa.';

  @override
  String get errorFamilyRequired => 'Primero únete a una familia o crea una.';

  @override
  String get errorJoinedFamilyUnavailable =>
      'No se pudo cargar la familia a la que te uniste.';

  @override
  String get errorPhoneFormat =>
      'Usa el formato internacional, p. ej. +91 9812345678.';

  @override
  String get errorTermsRequired => 'Acepta los términos para continuar.';

  @override
  String get errorPasswordRequirements =>
      'La contraseña debe cumplir los requisitos.';

  @override
  String get errorPasswordMismatch => 'Las contraseñas no coinciden.';

  @override
  String get errorNewPasswordTooShort =>
      'La contraseña nueva debe tener al menos 8 caracteres.';

  @override
  String get errorCurrentPasswordIncorrect =>
      'La contraseña actual es incorrecta.';

  @override
  String get errorOffsetsRequired =>
      'Elige al menos una antelación para el recordatorio.';

  @override
  String get errorNoAuthenticator =>
      'No hay ninguna app de autenticación vinculada.';

  @override
  String get errorTotpUnavailable =>
      'La configuración del autenticador no está disponible ahora.';

  @override
  String get errorCodeLength => 'Introduce el código de 6 dígitos.';

  @override
  String errorUploadsFailed(int failed, int total) {
    return 'Fallaron $failed de $total subidas.';
  }

  @override
  String get errorFilesUnavailable =>
      'Conecta un servidor para abrir o compartir archivos.';

  @override
  String get errorAppOpenFailed => 'No se pudo abrir esa aplicación.';

  @override
  String get errorNotificationsBlocked =>
      'Las notificaciones están bloqueadas en los ajustes del sistema.';

  @override
  String get errorSignInIncomplete =>
      'No se completó el inicio de sesión. Inténtalo de nuevo.';

  @override
  String get commonAdd => 'Añadir';

  @override
  String get commonEdit => 'Editar';

  @override
  String get commonDelete => 'Eliminar';

  @override
  String get commonDone => 'Listo';

  @override
  String get commonNext => 'Siguiente';

  @override
  String get commonSkip => 'Omitir';

  @override
  String get commonOptional => 'opcional';

  @override
  String get commonNoMatches => 'Sin coincidencias.';

  @override
  String get commonCreate => 'Crear';

  @override
  String get commonRetry => 'Reintentar';

  @override
  String get commonView => 'Ver';

  @override
  String get commonShare => 'Compartir';

  @override
  String get commonApply => 'Aplicar';

  @override
  String get commonClear => 'Borrar';

  @override
  String durationDaysShort(int days) {
    return '$days d';
  }

  @override
  String get kindInsurance => 'Seguro';

  @override
  String get kindPollution => 'Emisiones';

  @override
  String get kindAmc => 'AMC';

  @override
  String get kindService => 'Servicio';

  @override
  String get kindTax => 'Impuesto';

  @override
  String get kindWarranty => 'Garantía';

  @override
  String get kindRegistration => 'Matrícula';

  @override
  String get kindFitness => 'Inspección';

  @override
  String get kindOther => 'Otro';

  @override
  String get groupVehicle => 'Vehículo';

  @override
  String get groupAppliance => 'Electrodoméstico';

  @override
  String get groupElectronics => 'Electrónica';

  @override
  String get groupDocument => 'Documento';

  @override
  String get groupOther => 'Otro';

  @override
  String get recurrenceNone => 'Ninguna';

  @override
  String get recurrenceNever => 'Nunca';

  @override
  String get recurrenceMonthly => 'Mensual';

  @override
  String get recurrenceQuarterly => 'Trimestral';

  @override
  String get recurrenceHalfYearly => 'Semestral';

  @override
  String get recurrenceYearly => 'Anual';

  @override
  String dueOverdueBy(int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: 'Vencido hace $days días',
      one: 'Vencido hace 1 día',
    );
    return '$_temp0';
  }

  @override
  String get dueToday => 'Vence hoy';

  @override
  String dueDaysLeft(int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: 'Quedan $days días',
      one: 'Queda 1 día',
    );
    return '$_temp0';
  }

  @override
  String relativeDaysAgo(int days) {
    return 'hace $days d';
  }

  @override
  String relativeInDays(int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: 'en $days días',
      one: 'en 1 día',
    );
    return '$_temp0';
  }

  @override
  String get pillOverdue => 'Vencido';

  @override
  String get pillToday => 'Hoy';

  @override
  String get catalogAddAsset => 'Añadir bien';

  @override
  String get catalogEditAsset => 'Editar bien';

  @override
  String get catalogDeleteAsset => 'Eliminar bien';

  @override
  String get catalogSaveChanges => 'Guardar cambios';

  @override
  String get catalogSaveAsset => 'Guardar bien';

  @override
  String get catalogCustomTypeTitle => 'Tipo de aparato personalizado';

  @override
  String get catalogCustomTypeHint => 'p. ej. lavavajillas, inversor, cámara…';

  @override
  String get catalogUseType => 'Usar tipo';

  @override
  String get catalogChooseCategory => 'Elige una categoría';

  @override
  String get catalogChooseCategorySubtitle => '¿Qué tipo de cosa vas a añadir?';

  @override
  String get catalogSelectAppliance => 'Elige tu aparato';

  @override
  String catalogNoPresetTypes(String group) {
    return 'No hay tipos predefinidos para $group: usa un tipo personalizado u omite este paso.';
  }

  @override
  String catalogTypesIn(String group) {
    return 'Tipos de $group; elige uno o añade el tuyo.';
  }

  @override
  String get catalogOthers => 'Otros';

  @override
  String get catalogDetails => 'Detalles';

  @override
  String get catalogOnlyNameRequired => 'Solo el nombre es obligatorio.';

  @override
  String get catalogName => 'Nombre';

  @override
  String get catalogNameHint => 'p. ej. Frigorífico Samsung 340 L';

  @override
  String get catalogRoomOptional => 'Estancia (opcional)';

  @override
  String get catalogNewRoomHint => 'Nombre de la estancia nueva, p. ej. Cocina';

  @override
  String get catalogBrand => 'Marca';

  @override
  String get catalogModelNumber => 'Número de modelo';

  @override
  String get catalogSerialNo => 'N.º de serie / matrícula';

  @override
  String get catalogSerialHint => 'p. ej. TN 01 AB 1234';

  @override
  String get catalogPurchaseDate => 'Fecha de compra';

  @override
  String get catalogPurchasePrice => 'Precio de compra';

  @override
  String get catalogPriceHint => 'p. ej. 42000';

  @override
  String get catalogStore => 'Tienda';

  @override
  String get catalogStoreHint => 'p. ej. Croma';

  @override
  String catalogDetailsFor(String name) {
    return 'Detalles de $name';
  }

  @override
  String get catalogThisAppliance => 'este aparato';

  @override
  String get catalogPropertyHint => 'p. ej. Color';

  @override
  String get catalogValueHint => 'valor';

  @override
  String get catalogAddProperty => 'Añadir propiedad';

  @override
  String get catalogAmcDate => 'Fecha del AMC';

  @override
  String get catalogInvoices => 'Facturas / recibos';

  @override
  String get catalogAttachInvoice =>
      'Adjuntar factura: cámara, galería o archivos';

  @override
  String catalogWillAutoAdd(String services) {
    return 'Se añadirá automáticamente: $services';
  }

  @override
  String get catalogSelectYourAppliance => 'Elige tu aparato';

  @override
  String get catalogSearchAppliance => 'Busca tu aparato';

  @override
  String get catalogNoMatchingAppliance =>
      'Ningún aparato coincide: usa «Otra cosa» más abajo.';

  @override
  String get catalogSomethingElse => 'Otra cosa';

  @override
  String catalogAllReminders(int count) {
    return 'Todos los recordatorios · $count';
  }

  @override
  String get catalogNoRemindersForAsset =>
      'Este bien aún no tiene recordatorios.';

  @override
  String get catalogMarkDoneTitle => '¿Marcar como hecho?';

  @override
  String catalogMarkDoneOneOff(String label) {
    return '«$label» se completará y desaparecerá de los próximos recordatorios.';
  }

  @override
  String catalogMarkDoneRecurring(String label, String recurrence) {
    return '«$label» se completará y se programará su próximo vencimiento ($recurrence).';
  }

  @override
  String get catalogMarkDone => 'Marcar como hecho';

  @override
  String catalogMarkedDone(String label) {
    return '$label marcado como hecho.';
  }

  @override
  String catalogDoneRescheduled(String label) {
    return '$label hecho: se programó el próximo vencimiento.';
  }

  @override
  String get catalogDeleteReminderTitle => '¿Eliminar el recordatorio?';

  @override
  String catalogDeleteReminderMessage(String label) {
    return 'Se eliminarán «$label» y sus notificaciones programadas.';
  }

  @override
  String get catalogDeleteAssetTitle => '¿Eliminar el bien?';

  @override
  String catalogDeleteAssetMessage(String name) {
    return 'Se eliminarán «$name» y todos sus recordatorios y documentos. Esta acción no se puede deshacer.';
  }

  @override
  String get catalogNoAssets => 'Aún no hay bienes. Toca «Añadir bien».';

  @override
  String get catalogRoomNotFound => 'No se encontró la estancia.';

  @override
  String get catalogAddRoomPhoto => 'Añadir una foto de la estancia';

  @override
  String catalogApplianceCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count aparatos',
      one: '1 aparato',
    );
    return '$_temp0';
  }

  @override
  String get catalogAppliances => 'Aparatos';

  @override
  String get catalogNothingRegistered => 'Aquí aún no hay nada registrado.';

  @override
  String get catalogAddHere => 'Añadir aquí';

  @override
  String get catalogRenameRoom => 'Cambiar nombre de la estancia';

  @override
  String catalogSince(String date) {
    return 'desde el $date';
  }

  @override
  String get catalogNoRemindersOnAppliance =>
      'Este aparato aún no tiene recordatorios.';

  @override
  String get catalogCreateRoom => 'Crear estancia';

  @override
  String get catalogNoRooms => 'Aún no hay estancias. Añade la primera arriba.';

  @override
  String get catalogAddRoomPhotoLong =>
      'Añadir una foto de la estancia: cámara o dispositivo';

  @override
  String get catalogRoomNameHint => 'Nombre de la estancia, p. ej. Cocina';

  @override
  String get catalogAddNewRoom => 'Añadir una estancia nueva';

  @override
  String catalogRegisteredCount(int count) {
    return '$count registrados';
  }

  @override
  String get catalogSearchHint => 'Busca bienes, servicios, números de póliza…';

  @override
  String get catalogSearchEmpty =>
      'Escribe para buscar tus bienes y recordatorios.';

  @override
  String get catalogReminders => 'Recordatorios';

  @override
  String get catalogDue => 'Vence';

  @override
  String get catalogOneOff => 'Una sola vez';

  @override
  String get catalogReminds => 'Avisa';

  @override
  String get catalogProvider => 'Proveedor';

  @override
  String get catalogPolicyContract => 'Póliza / contrato';

  @override
  String get catalogCost => 'Coste';

  @override
  String get catalogNotes => 'Notas';

  @override
  String get catalogServiceDocuments => 'DOCUMENTOS DE ESTE SERVICIO';

  @override
  String catalogRemindersTracked(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count recordatorios en seguimiento',
      one: '1 recordatorio en seguimiento',
    );
    return '$_temp0';
  }

  @override
  String get catalogHideDetails => 'Ocultar detalles';

  @override
  String get catalogShowDetails => 'Mostrar todos los detalles';

  @override
  String get catalogType => 'Tipo';

  @override
  String get catalogCategory => 'Categoría';

  @override
  String get catalogRoom => 'Estancia';

  @override
  String get catalogModel => 'Modelo';

  @override
  String get catalogSerialShort => 'N.º de serie / matrícula';

  @override
  String get catalogRemindersTrackedLabel => 'Recordatorios en seguimiento';

  @override
  String get catalogNextDue => 'PRÓXIMO VENCIMIENTO';

  @override
  String catalogRemindsOffsets(String offsets) {
    return 'Avisa $offsets';
  }

  @override
  String get catalogMarkAsDone => 'Marcar como hecho';

  @override
  String get catalogNoRoomHint => 'Sin estancia: puedes elegirla más tarde';

  @override
  String get catalogNoRoom => 'Sin estancia';

  @override
  String get catalogNewRoom => 'Estancia nueva…';

  @override
  String get catalogAddPhoto => 'Añadir foto';

  @override
  String get dashboardFilterByType => 'Filtrar por tipo';

  @override
  String get dashboardUpcoming => 'Próximos vencimientos';

  @override
  String get dashboardGroupBy => 'Agrupar por';

  @override
  String get dashboardGroupNone => 'Agrupar por: ninguno';

  @override
  String get dashboardGroupAsset => 'Agrupar por: bien';

  @override
  String get dashboardEmpty =>
      'Aún no hay recordatorios. Añade un bien para empezar.';

  @override
  String get dashboardNoMatches => 'Nada coincide con los tipos seleccionados.';

  @override
  String get dashboardAsset => 'Bien';

  @override
  String get dashboardTotalAppliances => 'Total de aparatos activos';

  @override
  String get filterActive => 'Servicios activos';

  @override
  String get filterSecured => 'Protegidos';

  @override
  String get filterSoon => 'Vencen pronto';

  @override
  String get filterExpired => 'Vencidos';

  @override
  String get docsTitle => 'DOCUMENTOS';

  @override
  String get docsAdd => '+ Añadir';

  @override
  String get docsEmpty =>
      'Aún no hay documentos. Adjunta facturas, garantías o fotos.';

  @override
  String get docsImageLoadFailed => 'No se pudo cargar la imagen';

  @override
  String get docKindInvoice => 'Factura';

  @override
  String get docKindWarranty => 'Garantía';

  @override
  String get docKindInsurance => 'Seguro';

  @override
  String get docKindManual => 'Manual';

  @override
  String get docKindPhoto => 'Foto';

  @override
  String get docKindOther => 'Otro';

  @override
  String get familyCreateTitle => 'Crear una familia';

  @override
  String get familyNameHint => 'p. ej. Familia Kumar';

  @override
  String get familyJoinTitle => 'Unirse a una familia';

  @override
  String get familyInviteCodeHint => 'Código de invitación (p. ej. AB12CD34)';

  @override
  String get familyJoin => 'Unirse';

  @override
  String get familyJoined =>
      '¡Listo! Las estancias, bienes y recordatorios de la familia se están sincronizando.';

  @override
  String familyChangeRoleTitle(String name) {
    return 'Cambiar rol: $name';
  }

  @override
  String get familyRoleAdminHint => 'Gestiona miembros, bienes e invitaciones';

  @override
  String get familyRoleViewerHint => 'Acceso de solo lectura';

  @override
  String get familyRoleMemberHint => 'Añade y gestiona sus propios bienes';

  @override
  String get familyRemoveTitle => '¿Quitar al miembro?';

  @override
  String familyRemoveMessage(String name) {
    return '$name perderá el acceso a los bienes y recordatorios de esta familia.';
  }

  @override
  String get familyRemove => 'Quitar';

  @override
  String get familyLeaveTitle => '¿Salir de la familia?';

  @override
  String get familyLeaveMessage =>
      'Dejarás de recibir los recordatorios de esta familia.';

  @override
  String get familyLeave => 'Salir';

  @override
  String get familyEmptyTitle => 'Aún no estás en ninguna familia';

  @override
  String get familyEmptyBody =>
      'Crea una familia para compartir bienes y recordatorios, o únete a una con un código de invitación.';

  @override
  String get familyJoinWithCode => 'Unirse con un código';

  @override
  String get familyMembers => 'MIEMBROS';

  @override
  String get familyInviteMember => 'Invitar a un miembro';

  @override
  String get familyLeaveFamily => 'Salir de la familia';

  @override
  String get familyCall => 'Llamar';

  @override
  String get familyWhatsapp => 'WhatsApp';

  @override
  String get familyChangeRole => 'Cambiar rol';

  @override
  String get familyRemoveFromFamily => 'Quitar de la familia';

  @override
  String get familyInviteTitle => 'Invitar a un miembro';

  @override
  String familyInviteBody(String role) {
    return 'Comparte este código. Podrá unirse como $role. Caduca en 7 días.';
  }

  @override
  String get familyCopyCode => 'Copiar código';

  @override
  String get familyCodeCopied => 'Código de invitación copiado';

  @override
  String get roleOwner => 'Propietario';

  @override
  String get roleAdmin => 'Administrador';

  @override
  String get roleMember => 'Miembro';

  @override
  String get roleViewer => 'Lector';

  @override
  String memberCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count miembros',
      one: '1 miembro',
    );
    return '$_temp0';
  }

  @override
  String get profileTitle => 'Perfil';

  @override
  String get profileVerified => 'Verificado';

  @override
  String get profileEditInfo => 'Editar información personal';

  @override
  String get profileNotificationPrefs => 'Preferencias de notificaciones';

  @override
  String get profileManagedInSettings => 'Se gestiona en Ajustes';

  @override
  String get profileDisplayName => 'Nombre visible';

  @override
  String get profilePhone => 'Teléfono (para recordatorios por WhatsApp)';

  @override
  String get profileDocuments => 'Documentos';

  @override
  String get profileInvite => 'Invitar';

  @override
  String get reminderAddTitle => 'Añadir recordatorio';

  @override
  String get reminderEditTitle => 'Editar recordatorio';

  @override
  String get reminderSaveChanges => 'Guardar cambios';

  @override
  String get reminderSave => 'Guardar recordatorio';

  @override
  String get reminderTypeTitle => 'Tipo de recordatorio';

  @override
  String get reminderTypeSubtitle => '¿Qué quieres controlar?';

  @override
  String reminderDetailsTitle(String kind) {
    return 'Detalles de $kind';
  }

  @override
  String get reminderDetailsSubtitle => '¿Cuándo vence?';

  @override
  String get reminderLabel => 'Etiqueta';

  @override
  String get reminderDueDate => 'Fecha de vencimiento';

  @override
  String get reminderRepeats => 'Se repite';

  @override
  String get reminderServiceDetails => 'Detalles del servicio (opcional)';

  @override
  String get reminderProviderHint => 'p. ej. Acko';

  @override
  String get reminderPolicyNo => 'N.º de póliza / contrato';

  @override
  String get reminderCostHint => 'p. ej. 4200';

  @override
  String get reminderNotifyTitle => 'Ajustes de notificaciones';

  @override
  String get reminderNotifySubtitle =>
      'Notificación push y recordatorio para todos los miembros de la familia.';

  @override
  String get reminderNotifyMe => 'Avisarme';

  @override
  String get reminderNoOffsets =>
      'No saltará ningún recordatorio para este servicio: elige al menos una antelación para recibir avisos.';

  @override
  String reminderOffsetsSummary(String offsets) {
    return 'Te lo recordaremos $offsets antes del vencimiento, en los canales que tengas activados (consulta Ajustes).';
  }

  @override
  String get reminderAttachTitle => 'Adjuntos';

  @override
  String get reminderAttachSubtitle =>
      'PDF de la póliza, recibo, fotos… adjúntalos ahora o más tarde desde la página del bien.';

  @override
  String get reminderAttachDocs =>
      'Adjuntar documentos: cámara, galería o archivos';

  @override
  String get remindersEmpty => 'Por ahora no hay nada aquí.';

  @override
  String get inboxAllCaughtUp => 'Estás al día 🎉';

  @override
  String get inboxOverdue => 'Vencidos';

  @override
  String get inboxComingUp => 'Próximamente';

  @override
  String inboxDueIn(int days, String date) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: 'Vence en $days días: $date',
      one: 'Vence en 1 día: $date',
    );
    return '$_temp0';
  }

  @override
  String get lockLocked => 'Bloqueado';

  @override
  String get lockTapToUnlock => 'Toca para desbloquear';

  @override
  String get mfaTitle => 'Verificación en dos pasos';

  @override
  String get mfaSubtitle =>
      'Introduce el código de 6 dígitos de tu app de autenticación.';

  @override
  String get mfaCodeLabel => 'Código de 6 dígitos';

  @override
  String get securityTitle => 'Seguridad';

  @override
  String get securityBiometricSection => 'Acceso biométrico';

  @override
  String get securityUnlockBiometrics => 'Desbloquear con biometría';

  @override
  String get securityNoBiometrics =>
      'Este dispositivo no tiene biometría disponible';

  @override
  String get securityTwoFactorSection => 'Verificación en dos pasos';

  @override
  String get security2faEnabled => 'La verificación en dos pasos está activada';

  @override
  String get securityEnable2fa => 'Activar verificación en dos pasos';

  @override
  String get securityAuthenticatorApp => 'App de autenticación';

  @override
  String securityAuthenticatorSince(String date) {
    return 'App de autenticación · desde el $date';
  }

  @override
  String get securityAuthenticatorHint =>
      'Usa Google Authenticator, Authy, 1Password, etc.';

  @override
  String get securityMoreSection => 'Más';

  @override
  String get securityAppLock => 'Bloqueo de la app';

  @override
  String get securityAppLockHint => 'Pedir desbloqueo al volver a abrir la app';

  @override
  String get securityAutoLock => 'Bloquear automáticamente tras';

  @override
  String securityMinutesShort(int minutes) {
    return '$minutes min';
  }

  @override
  String securityMinutes(int minutes) {
    String _temp0 = intl.Intl.pluralLogic(
      minutes,
      locale: localeName,
      other: '$minutes minutos',
      one: '1 minuto',
    );
    return '$_temp0';
  }

  @override
  String get securityActiveSessions => 'Sesiones activas';

  @override
  String get securityDisable2faTitle =>
      '¿Desactivar la verificación en dos pasos?';

  @override
  String get securityDisable2faMessage =>
      'Tu cuenta ya no pedirá un código del autenticador para iniciar sesión.';

  @override
  String get securityDisable => 'Desactivar';

  @override
  String get securityCurrentSession => 'Sesión actual';

  @override
  String securitySignedInAt(String date) {
    return 'Sesión iniciada el $date';
  }

  @override
  String get securityThisDevice => 'Este dispositivo';

  @override
  String get securitySignOutOthers => 'Cerrar sesión en los demás dispositivos';

  @override
  String get securityOthersSignedOut =>
      'Se cerró la sesión en los demás dispositivos.';

  @override
  String get securitySetupTitle => 'Configurar la app de autenticación';

  @override
  String get securitySetupBody =>
      'Escanea el QR con Google Authenticator, Authy, 1Password, etc. y luego introduce el código de 6 dígitos.';

  @override
  String get securityKeyCopied => 'Clave copiada.';

  @override
  String get securityCopyKey => 'Copiar clave';

  @override
  String get securityVerifyEnable => 'Verificar y activar';

  @override
  String securityAvailable(String kinds) {
    return 'Disponible: $kinds';
  }

  @override
  String get biometricFace => 'Face ID';

  @override
  String get biometricFingerprint => 'Huella dactilar';

  @override
  String get biometricDevice => 'Biometría del dispositivo';

  @override
  String get onboardingEyebrow1 => 'Te damos la bienvenida';

  @override
  String get onboardingTitle1 => 'No vuelvas a perder una renovación';

  @override
  String get onboardingBody1 =>
      'DocsBuddy controla garantías, seguros, facturas y fechas para que los plazos no te pillen por sorpresa.';

  @override
  String get onboardingEyebrow2 => 'Organiza';

  @override
  String get onboardingTitle2 => 'Todos tus bienes en un solo lugar';

  @override
  String get onboardingBody2 =>
      'Vehículos, electrodomésticos, electrónica e incluso documentos, organizados por estancia y categoría.';

  @override
  String get onboardingEyebrow3 => 'Anticípate';

  @override
  String get onboardingTitle3 =>
      'Recordatorios inteligentes, con semanas de antelación';

  @override
  String get onboardingBody3 =>
      'Configura avisos a 60 / 30 / 7 / 1 días. Push, correo o WhatsApp: tú eliges.';

  @override
  String get onboardingEyebrow4 => 'En familia';

  @override
  String get onboardingTitle4 => 'Mantén sincronizada a toda la familia';

  @override
  String get onboardingBody4 =>
      'Invita hasta 8 miembros. Todos reciben los avisos y cualquiera puede actualizar: sin depender de una sola persona.';

  @override
  String get onboardingGetStarted => 'Empezar';

  @override
  String get onboardingHaveAccount => 'Ya tengo una cuenta';

  @override
  String get onboardingAlreadyWithUs => '¿Ya eres de los nuestros? ';

  @override
  String get commonBack => 'Atrás';

  @override
  String get illoActiveInvoices => 'Facturas activas';

  @override
  String get illoKitchen => 'Cocina';

  @override
  String get illoSmartphone => 'Smartphone';

  @override
  String get illoVehicles => 'Vehículos';

  @override
  String get illoPollutionDue => 'Emisiones por vencer';

  @override
  String get illoSharedWithFamily => 'Compartido con la familia';

  @override
  String illoBikeSample(String date) {
    return '$date · Moto';
  }

  @override
  String get settingsAppearance => 'Apariencia';

  @override
  String get appearanceSystem => 'Sistema';

  @override
  String get appearanceLight => 'Claro';

  @override
  String get appearanceDark => 'Oscuro';

  @override
  String get authContinueWithMicrosoft => 'Continuar con Microsoft';

  @override
  String get startupStepServices => 'Iniciando DocsBuddy…';

  @override
  String get startupStepAccount => 'Conectando con tu cuenta…';

  @override
  String get startupStepPreferences => 'Cargando tus preferencias…';

  @override
  String startupStepCount(int step, int total) {
    return 'Paso $step de $total';
  }

  @override
  String get startupFailedTitle => 'No se pudo iniciar DocsBuddy';

  @override
  String get startupFailedBody =>
      'Algo salió mal al preparar todo. Inténtalo de nuevo. Si sigue ocurriendo, dile al soporte lo que dice la línea de abajo.';

  @override
  String get startupRetry => 'Reintentar';

  @override
  String get loadingSigningIn => 'Iniciando sesión…';

  @override
  String get loadingOpeningGoogle => 'Abriendo Google…';

  @override
  String get loadingOpeningApple => 'Abriendo Apple…';

  @override
  String get loadingOpeningMicrosoft => 'Abriendo Microsoft…';

  @override
  String get loadingCreatingAccount => 'Creando tu cuenta…';

  @override
  String get loadingSendingCode => 'Enviando tu código…';

  @override
  String get loadingSendingNewCode => 'Enviando un código nuevo…';

  @override
  String get loadingVerifyingCode => 'Verificando tu código…';

  @override
  String get loadingUpdatingPassword => 'Actualizando tu contraseña…';

  @override
  String get loadingSigningOut => 'Cerrando sesión…';

  @override
  String get loadingSavingAsset => 'Guardando tu bien…';

  @override
  String get loadingSavingReminder => 'Guardando tu recordatorio…';

  @override
  String get loadingDeletingAsset => 'Eliminando el bien…';

  @override
  String get loadingDeletingReminder => 'Eliminando el recordatorio…';

  @override
  String get loadingUploadingPhoto => 'Subiendo la foto…';

  @override
  String get loadingCreatingRoom => 'Creando la estancia…';

  @override
  String get loadingRenamingRoom => 'Cambiando el nombre de la estancia…';

  @override
  String get loadingSavingRoomOrder => 'Guardando el orden de las estancias…';

  @override
  String get loadingCreatingFamily => 'Creando tu familia…';

  @override
  String get loadingJoiningFamily => 'Uniéndote a la familia…';

  @override
  String get loadingCreatingInvite => 'Creando la invitación…';

  @override
  String get loadingUpdatingRole => 'Actualizando el rol…';

  @override
  String get loadingRemovingMember => 'Quitando al miembro…';

  @override
  String get loadingLeavingFamily => 'Saliendo de la familia…';

  @override
  String get loadingUploadingDocument => 'Subiendo el documento…';

  @override
  String get loadingOpeningDocument => 'Abriendo el documento…';

  @override
  String get loadingPreparingDocument =>
      'Preparando el documento para compartir…';

  @override
  String get loadingDeletingDocument => 'Eliminando el documento…';

  @override
  String get loadingSavingSettings => 'Guardando los ajustes…';

  @override
  String get loadingPreparingAuthenticator =>
      'Preparando la configuración del autenticador…';

  @override
  String get loadingTurningOffTwoStep =>
      'Desactivando la verificación en dos pasos…';

  @override
  String get loadingSigningOutOthers =>
      'Cerrando sesión en los demás dispositivos…';

  @override
  String get loadingMarkingDone => 'Marcando como hecho…';

  @override
  String get loadingSavingProfile => 'Guardando tu perfil…';

  @override
  String get loadingImage => 'Cargando la imagen…';

  @override
  String get loadingDashboard => 'Cargando tu panel…';

  @override
  String get loadingAssets => 'Cargando tus bienes…';

  @override
  String get loadingCategories => 'Cargando las categorías…';

  @override
  String get loadingRoom => 'Cargando la estancia…';

  @override
  String get loadingAsset => 'Cargando el bien…';

  @override
  String get loadingReminders => 'Cargando los recordatorios…';

  @override
  String get loadingDocuments => 'Cargando los documentos…';

  @override
  String get loadingRooms => 'Cargando las estancias…';

  @override
  String get loadingFamily => 'Cargando tu familia…';

  @override
  String get loadingProfile => 'Cargando tu perfil…';

  @override
  String get loadingNotifications => 'Cargando las notificaciones…';

  @override
  String get loadingSecurity => 'Comprobando los ajustes de seguridad…';

  @override
  String authTermsAgreement(String terms, String privacy) {
    return 'Acepto los $terms y la $privacy.';
  }

  @override
  String catalogRoomSummary(String appliances) {
    return 'El corazón de tu hogar, con $appliances.';
  }

  @override
  String reminderForAsset(String asset) {
    return 'Para $asset';
  }

  @override
  String get settingsLanguage => 'Idioma';

  @override
  String get languageAutomatic => 'Automático';

  @override
  String get languageAutomaticHint => 'Sigue el idioma de tu dispositivo';

  @override
  String get languageSheetTitle => 'Elige un idioma';

  @override
  String get errorInvalidCredentials => 'Correo o contraseña incorrectos.';

  @override
  String get errorEmailNotConfirmed =>
      'Confirma primero tu correo: revisa tu bandeja de entrada.';

  @override
  String get errorUserExists => 'Ya existe una cuenta con este correo.';

  @override
  String get errorWeakPassword =>
      'Esa contraseña es demasiado débil. Elige una más segura.';

  @override
  String get errorRateLimited =>
      'Demasiados intentos. Espera un momento e inténtalo de nuevo.';

  @override
  String get errorCodeInvalid => 'El código es incorrecto o ha caducado.';

  @override
  String get errorSamePassword =>
      'Elige una contraseña que no hayas usado antes.';

  @override
  String get notificationDueToday => 'Vence hoy';

  @override
  String notificationDueInDays(int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: 'Vence en $days días',
      one: 'Vence en 1 día',
    );
    return '$_temp0';
  }

  @override
  String commonStepOf(int step, int total) {
    return 'PASO $step DE $total';
  }
}
