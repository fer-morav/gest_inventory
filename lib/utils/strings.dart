const app_name = "GestInventory";

////////////////Titles////////////////////////////////////////
const title_login_user = "Inicio de Sesión";
const title_inform = "Informe";
const title_report = "Registros";
const title_statistics = "Estadisticas";
const title_administrator = "Administrador";
const title_employees = "Empleados";
const title_user = "Perfil";
const title_edit_user = "Editar Usuario";
const title_register_user = "Registro de Usuario";
const title_update_data = "Actualizar Datos";
const title_reset_password = "Restablecer Contraseña";
const title_add_business = "Añadir Negocio";
const title_info_business = "Información del Negocio";
const title_edit_business = "Editar Negocio";
const title_product = "Producto";
const title_add_product = "Añadir Producto";
const title_edit_product = "Editar Producto";
const title_list_product = "Lista de Productos";
const title_search_product = "Buscar Producto";
const title_opSearch_product = "Busqueda de Productos";
const title_make_sale = "Realizar Venta";
const title_restock_product = "Actualizar Producto";
const title_sales_report = "Reporte de Ventas";
const title_incoming_report = "Reporte de Entradas";
const title_select_option = "Seleccione una opción";
const title_address = "Dirección";
const title_arent_signed_up_business = "No se encuentra registrado en algún negocio";
const title_select_user = "Seleccione un Usuario";
const title_confirm_delete = "Confirmar Eliminación";

////////////////Buttons///////////////////////////////////////
const button_login = "Iniciar Sesión";
const button_register = "Registrar";
const button_registry = "Registrarse";
const button_recover_password = "Restablecer Contraseña";
const button_accept = "Aceptar";
const button_cancel = "Cancelar";
const button_save = "Guardar";
const button_reset = "Reiniciar";
const button_delete = "Eliminar";
const button_report = "Registros";
const button_edit = "Editar";
const button_hoy = "Hoy";
const button_semana = "Semana";
const button_mes = "Mes";
const button_statistics = " Estadisticas";
const button_more_sales = "Más Vendidos";
const button_less_sales = "Menos Vendidos";
const button_sales = "Venta";
const button_stock = "Existencias";
const button_make_sale = "Realizar Venta";
const button_make_restock = "Realizar Entrada";
const button_generate_report = "Generar Reporte";
const button_restock = "Reabastecer Stock";
const button_administrator_stock = "Existencias";
const button_records = "Ver Registros";
const button_add_business = "Añadir Negocio";
const button_logout = "Cerrar Sesión";
const button_modify_profile = "Modificar Perfil";
const button_see_profile = "Ver Perfil";
const button_add_product = "Añadir Producto";
const button_list_product = "Ver Listas de Productos";
const button_allList_product = "Ver Todos Los Productos";
const button_nameList_product = "Buscar Producto Por Nombre";
const button_codeList_product = "Buscar Producto Por Código";
const button_search = "Buscar";
const button_getCode_product = "Ingresar Código";
const button_scanCode_product = "Escanear Código";
const button_search_product = "Buscar producto";
const button_addProduct_toCart = "Agregar al Carrito";
const button_removeProduct_fromCart = "Eliminar del Carrito";
const button_paying_products = "Pagar Productos";
const button_restock_product = "Registrar Entrada";
const button_specific_day = "Dia Específico";
const button_take_photo = "Tomar Foto";
const button_pick_picture = "Seleccionar Imagen";
const button_delete_photo = "Eliminar Foto";
const button_yes = "Si";
const button_no = "No";
const button_register_business = "Registre su negocio";

////////////////TextFields////////////////////////////////////
const textfield_label_email = "Correo Electronico";
const textfield_label_password = "Contraseña";
const textfield_label_confirm_password = "Confirmar Contraseña";
const textfield_label_id_business = "ID Negocio";
const textfield_label_name = "Nombre";
const textfield_label_last_name = "Apellidos";
const textfield_label_cargo = "Cargo";
const textfield_label_number_phone = "Teléfono";
const textfield_label_salary = "Salario";
const textfield_label_address = "Calle";
const textfield_label_owner = "Dueño";
const textfield_label_state = "Estado";
const textfield_label_city = "Ciudad";
const textfield_label_suburb = "Colonia";
const textfield_label_id = "Codigo de Producto";
const textfield_label_description = "Descripción";
const textfield_label_unit_price = "Precio";
const textfield_label_product = "Código de producto";
const textfield_label_wholesale = "Precio por mayoreo";
const textfield_label_unit = "Precio unitario";
const textfield_label_stock = "Cantidad";
const textfield_label_name_business = "Nombre del Negocio";
const textfield_label_name_product = "Nombre del Producto";
const textfield_label_cp = "Código Postal";
const textfield_label_number = "Numero";

const textfield_hint_one_option = "Seleccione solo una opción";
const textfield_hint_name = "Ingrese el nombre";
const textfield_hint_name_owner = "Ingrese el nombre del dueño";
const textfield_hint_state = "Ingrese el estado";
const textfield_hint_city = "Ingrese la ciudad";
const textfield_hint_suburb = "Ingrese la colonia";
const textfield_hint_address = "Ingrese la calle";
const textfield_hint_phone = "Ingrese el telefono";
const textfield_hint_email = "Ingrese el correo electronico";
const textfield_hint_password = "Ingrese la contraseña";
const textfield_hint_last_name = "Ingrese los apellidos";
const textfield_hint_cargo = "Seleccione el cargo";
const textfield_hint_salary = "Ingrese el salario";
const textfield_hint_id_business = "Ingrese el ID del negocio";
const textfield_hint_id = "Ingrese el codigo del producto";
const textfield_hint_product = "Ingrese el código del producto";
const textfield_hint_stock = "Ingrese la cantidad";
const textfield_hint_unit_price = "Ingrese el precio";
const textfield_hint_wholesale = "Ingrese el precio por mayoreo";
const textfield_hint_name_product = "Ingrese el nombre del producto";
const textfield_hint_cp = "Ingrese el código postal";
const textfield_hint_number = "Ingrese el numero";
const textfield_hint_description = "Ingrese la descripción";

const textfield_error_general = "Campo requerido";
const textfield_error_name = "Nombre requerido";
const textfield_error_phone_empty = "Teléfono requerido";
const textfield_error_cp_empty = "Código postal requerido";
const textfield_error_barcode = "Código de producto requerido";
const textfield_error_description = "Descripción requerida";
const textfield_error_price = "Precio requerido";
const textfield_error_quantity = "Cantidad requerida";
const textfield_error_phone = "Teléfono invalido";
const textfield_error_cp = "Código postal invalido";
const textfield_error_salary = "Salario requerido";
const textfield_error_email = "Correo electrónico invalido";
const textfield_error_email_empty = "Correo electrónico requerido";
const textfield_error_password_empty = "Contraseña requerida";
const textfield_error_password = "Contraseña invalida";
const textfield_error_confirm_password = "Las contraseñas no coinciden";
const textfield_sale_week = "Ventas a la Semana";
const textfield_sale_month = "Ventas al Mes";

const textfield_helper_password = "Minimo 6 caracteres";
const textfield_helper_required_admin = "solo puede ser editado por un administrador";
const textfield_helper_salary = "El salario";
const textfield_helper_position = "El cargo";

////////////////Labels////////////////////////////////////////

const text_havent_account = "¿Aún no esta esta registrado?";
const text_signup_business = "¿Desea registrar su negocio?";
const text_want_remove = "¿Desea eliminar a";
const text_as_employee = "como empleado?";
const text_forget_password = "¿Olvidaste tu Contraseña?";
const text_available = "Disponible";
const text_not_available = "No Disponible";
const text_product = "Producto:";
const text_unit_price = "Precio Unitario:";
const text_price = "Precio Mayoreo";
const text_stock = "Stock";
const text_available_in = "Disponible en:";
const text_sale_day = "Ventas de hoy:";
const text_sale_week = "Ventas de esta semana:";
const text_sale_month = "Ventas de este mes:";
const text_in_cart = "EN EL CARRITO:";
const text_empty_cart = "CARRITO VACÍO";
const text_removed_product = "Producto Eliminado del Carrito";
const text_added_product = "Producto Agregado al Carrito";
const text_product_not_avilable = "Producto No Disponible, Sin Existencias";
const text_unregistered_product = "Producto No Registrado";
const text_already_registered_product = "Producto ya registrado";
const text_registered_product = "Producto registrado";
const text_search_by_name = "Busqueda por Nombre";
const text_product_not_found = "Producto No Encontrado";
const text_total_sales = "Total de Ventas";
const text_total_units = "Total de Unidades";
const text_connection_error = "Error de Conexión";
const text_empty_list = "Lista Vacia";
const text_sort_by = "Ordenado por: ";
const text_more_sold = "Mas Vendidos";
const text_less_sold = "Menos Vendidos";
const text_paid_product = "Producto Pagado";
const text_year = "Año";
const text_month = "Mes";
const text_day = "Día";
const text_error_connection = "Error de Conexión";
const text_empty_history = "Historial Vacio";
const text_add_business_success = "Negocio registrado";
const text_add_business_not_success = "Negocio no registrado";
const text_add_user_success = "Usuario registrado";
const text_add_user_not_success = "Usuario no registrado";
const text_update_data = "Datos actualizados";
const text_add_product_success = "Producto registrado";
const text_add_product_not_success = "Producto no registrado";
const text_error_update_data = "Error al actualizar los datos";
const text_successful_delete = "Eliminacion Exitosa";
const text_employee_delete = "Empleado eliminado";
const text_products = "Productos";
const text_waiting_help = "Solicite a uno de los administradores del negocio al que desee unirse que lo registre con la opcion agregar en la pantalla de empleados, ";
const text_waiting_message = "permanezca en la pantalla durante el proceso.";
const text_or = "o";
const text_indications_add_user = "Los siguientes son usuarios que se encuentran disponibles para ser empleados. \n\nSolicite al usuario que desea registrar que permanezca en la sala de espera en la pantalla de informacion del negocio";


////////////////Alert////////////////////////////////////////
const alert_title_send_email = "Enlace enviado para restablecer contraseña";
const alert_title_error_not_registered = "Usuario no registrado";
const alert_title_error_general = "Ocurrido un error";
const alert_content_incomplete = "Informacion incompleta";
const alert_content_not_valid_data = "Verifique que su correo electrónico y contraseña sean correctos";
const alert_content_email = "Ingrese dirección de correo electrónico valida";
const alert_content_password = "Ingrese una contraseña valida";
const alert_content_error_general = "Vuelva a intentarlo mas tarde";
const alert_title = "Alerta";
const alert_error_load_image = "Error al cargar la foto de perfil";