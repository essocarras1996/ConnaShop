class Productos{
  String nombre;
  String precio;
  String photo;
  String url_add;
  String id_producto;
  String descripcion;
  String token;
  String static_token;

  Productos(
      {required this.nombre,
        required this.precio,
        required this.photo,
        required this.url_add,
        required this.id_producto,
        required this.descripcion,
        required this.token,
        required this.static_token});
}