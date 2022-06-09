const Map<String, String> esES = {
  //General
  'no': 'No',
  'yes': 'Sí',
  'cancel': 'Cancelar',
  'ok': 'Aceptar',
  //Splash
  'loading': 'Cargando...',
  //Log in
  'email': 'Correo',
  'password': 'Contraseña',
  'login': 'Iniciar sesión',
  'register': 'Registrarse',
  'forgottenPassword': '¿Has olvidado tu contraseña?',
  'wrongUserLogin':'Usuario o contraseñas incorrectos',
  //Recover password
  'recoverPassword': 'Recuperar contraseña',
  'passwordInstructions': 'Introduca su correo, le enviaremos un correo con las intrucciones necesarias para restaurar su contraseña',
  'putEmail': 'Introduce tu correo',
  'wrongUserRecoverPwd': 'Se ha producido un error al intentar recuperar su contraseña',
  //Set new password
  'setNewPassword': 'Actualizar la contraseña',
  'putPassword': 'Introduce tu contraseña',
  'setNewPasswordInstructions': 'Para recuperar su cuenta introduzca una nueva contraseña. Recuerde que la contraseña requiere un mínimo de 8 caracteres, una mayúscula, una minúscula y un caracter especial',
  'wrongNewPwd': 'No se ha podido cambiar la contraseña',
  //SignIn
  'signIn': 'Registro',
  'putUser': 'Introduce tu usuario',
  'signInInstructions': 'Recuerde que la contraseña requiere un mínimo de 8 caracteres, una mayúscula, una minúscula y un caracter especial',
  'putRepeatPassword': 'Repita la contraseña',
  'signInButton': 'Registrarse',
  'wrongUserSignIn': 'El usuario o la contraseña introducida no son válidos',
  'pwdNotMatch': 'Las contraseñas no coinciden',
  'incorrectPassword': 'La contraseña no cumple las condiciones de seguridad',
  'unknownError': 'Se ha producido un error desconocido',
  //Home
  'data': 'Datos',
  'schedule': 'Horario',
  'exam':'Exámenes',
  'setting': 'Ajustes',
  'noDataLoaded': 'No se encontraron datos',
  //Data
  'fillData': 'Completar datos',
  'degree': 'Titulaciones',
  'classroom': 'Aulas',
  'department': 'Departamentos',
  'subject': 'Asignaturas',
  'createDegree': 'Crear Titulación',
  'createClassroom': 'Crear aula',
  'createDepartment': 'Crear departamento',
  'createSubject': 'Crear asignatura',
  'createExam': 'Crear examen',
  'seeAll': 'Ver todos',
  'editDegree': 'Editar titulación',
  'editClassroom': 'Editar aula',
  'editDepartment': 'Editar departmento',
  'editSubject': 'Editar asignatura',
  'editExam': 'Editar exámen',
  'errorGetClassrooms':'Ha ocurrido un error intentando obtener las aulas',
  'errorGetDegrees':'Ha ocurrido un error intentando obtener los grados y másters',
  'errorGetDepartments':'Ha ocurrido un error intentando obtener los departamentos',
  'errorGetExams':'Ha ocurrido un error intentando obtener los exámenes',
  'errorGetSubjects':'Ha ocurrido un error intentando obtener las asignaturas',
  'errorGetSchedules': 'Ha ocurrido un error intentando obtener los horarios',
  'canNotCreateSubject': 'No se pueden crear asignaturas si no hay titulaciones, aulas o departamentos',
  'canNotCreateExam': 'No se pueden crear exámenes si no hay asignaturas',
  'morning': 'Mañana',
  'afternoon': 'Tarde',
  'january': 'Enero',
  'may': 'Mayo',
  'june': 'Junio',
  //List Degree
  'degreeSemesters':'Núm.semestres: @semester',
  'degreeYear':'Año: @year',
  'noDegree': 'No se han encontrado titulaciones',
  'noClassroom': 'No se han encontrado clases',
  'noDepartment': 'No se han encontrado departamentos',
  'noSubject': 'No se han encontrado asignaturas',
  'noSchedule': 'No se han encontrado horarios de asignaturas',
  'noExam': 'No se han encontrado exámenes',
  'noCalendar': 'No se han encontrado calendarios de exámenes',
  //List classroom
  'classroomPavilion': 'Pabellón: @pavilion',
  //List subjects
  'departmentAcronym': 'Departmento: @acronym',
  'classroomAcronym': 'Aula: @acronym',
  'groupAcronym': 'Grupo: @acronym',
  'subjectSemester': 'Semestre: @semester',
  'subjectLanguage': 'Idioma: @language',
  'subjectLaboratory': 'Laboratorio: @laboratory',
  'subjectSeminar': 'Seminario: @seminary',
  //List schedules
  'scheduleYear':'Año: @year',
  //List calendars
  'calendar': 'Calendario de exámenes',
  'datesError': 'La fecha de finalización debe ser mayor que la de inicio',
  'emptyDatesError': 'Debe seleccionar una fecha de inicio y una fecha de fin para continuar',
  //Degree dialog
  'name': 'Nombre',
  'year': 'Año',
  'semesters': 'Núm. Semestres',
  //Department dialog
  'acronym': 'Siglas',
  //Classroom dialog
  'telecommunication': 'Telecomunicaciones',
  'computing': 'Informática',
  'architecture': 'Arquitectura',
  'civil_work': 'Obras públicas',
  'central': 'Central',
  'pavilion': 'Pabellón',
  //Subject dialog
  'group':'Grupo',
  'time':'Tiempo(minutos)',
  'seminary': 'Seminario',
  'laboratory': 'Laboratorio',
  'semester': 'Semestre',
  'color': 'Color',
  'blue': 'Azul',
  'green': 'Verde',
  'red': 'Rojo',
  'yellow': 'Amarillo',
  'orange': 'Naranja',
  //Exam dialog
  'call':'Convocatoria',
  'turn':'Turno',
  //Schedule dialog
  'scheduleType':'Tipo de horario',
  //Calendar dialog
  'createCalendar': 'Crear calendario de exámenes',
  'startDate': 'Fecha de inicio',
  'endDate': 'Fecha de fin',
  'selectStartDate': 'Selecciona la fecha de inicio',
  'selectEndDate': 'Selecciona la fecha de fin',
  //File dialog
  'openDocumentSaved': 'Documento guardado con éxito. ¿Desea abrirlo?',
  'documentSaved': 'El documento se guardado como un documento excel en la ruta: @path',
  'canNotOpenDocument': 'No se ha podido abrir el archivo',
  //Setting
  'settings': 'Ajustes',
  'language': 'Idioma',
  'darkTheme': 'Modo oscuro',
  'version': 'Versión',
  'compilationNumber': 'Número de compilación',
  'selectLanguage': 'Seleccione el idioma',
  'logout': 'Cerrar sesión',
  'changePassword':'Cambiar contraseña',
  'deleteAccount': 'Eliminar cuenta',
  'errorDeletingAccount': 'Se ha producido un error al eliminar su cuenta',
  'errorChangingPassword': 'Se ha producido un error al cambiar su contraseña',
  //update password
  'updatePassword': 'Actualizar contraseña',
  'putOldPassword': 'Introduce tu antigua contraseña',
  'putNewPassword': 'Introduce tu nueva contraseña',
  //schedule
  'createSchedule': 'Crear horario',
  'editSchedule': 'Editar horario',
  'oneSubjectPerHour': 'Una asignatura por hora',
  'severalSubjectsPerHour': 'Muchas asignaturas por hora',
  'morningShift': 'Turno de mañana',
  'afternoonShift': 'Turno de tarde',
  'saveSchedule': 'Guardar',
  'downloadSchedule': 'Descargar',
  'empty': 'Vacio',
  'monday': 'Lunes',
  'tuesday': 'Martes',
  'wednesday': 'Miércoles',
  'thursday': 'Jueves',
  'friday': 'Viernes',
  //Calendar
  'editCalendar': 'Editar calendario de exámenes',
  'weekend': 'F.sem',
  'canNotCreateCalendar': 'No se pueden crear calendarios si no hay exámenes',
  'canNotCreateSchedule': 'No se pueden crear horarios si no hay asignaturas',
  'noExamAllowed': 'No se pueden poner exámenes en fin de semana',
  //Filters
  'filter': 'Filtrar',
  'filterSubject': 'Filtrar asignaturas',
  'filterExam': 'Filtrar exámenes',
};
