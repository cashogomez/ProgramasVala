//VARIABLES GLOBALES
char _puerto [15];
int _npuerto = -2;
int _velocidad = -2;
int _fd = -2;
struct termios _oldtio, _newtio;
…
…
int Baudios (int vel)
{
speed_t baud;
//comprobamos que existe un descriptor de fichero valido
if (_fd < 0) return (-2);
// Leer atributos del puerto
if (tcgetattr(_fd,&_newtio)==-1) {
return -1;
}
switch(vel) {
case 300 : baud=B300; _velocidad=vel; break;
case 1200 : baud=B1200; _velocidad=vel; break;
case 2400 : baud=B2400; _velocidad=vel; break;
case 9600 : baud=B9600; _velocidad=vel; break;
case 19200 : baud=B19200; _velocidad=vel; break;
case 38400 : baud=B38400; _velocidad=vel; break;
case 57600 : baud=B57600; _velocidad=vel; break;
case 115200 : baud=B115200; _velocidad=115200; break;
default : return -1;
}
cfsetospeed(&_newtio,baud);
cfsetispeed(&_newtio,baud);
if (tcsetattr(_fd,TCSANOW,&_newtio)==-1)
return -1;
return _velocidad;
}
