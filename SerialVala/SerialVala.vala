public static void main (string[] args) {
        int handle = Posix.open ("/dev/ttyUSB0", Posix.O_RDWR | Posix.O_NOCTTY | O_NDELAY);

        Posix.termios termios;

        Posix.fcntl (handle, Posix.F_SETFL, 0);

        Posix.tcgetattr (handle, out termios);


        termios.c_ispeed = 19200;
        termios.c_ospeed = 19200;

        /* Configure serialport */
        termios.c_cflag &= ~Posix.PARENB; 
        termios.c_cflag &= ~Posix.CSTOPB; 
        termios.c_cflag &= ~Posix.CSIZE; 
        termios.c_cflag |= Posix.CS8;
        termios.c_cflag |= (Posix.CLOCAL | Posix.CREAD);

        termios.c_lflag &= ~(Posix.ICANON | Posix.ECHO | Posix.ECHOE | Posix.ISIG);
        termios.c_oflag &= ~Posix.OPOST; 

        termios.c_cc[Posix.VMIN] = 0;
        termios.c_cc[Posix.VTIME] = 10;

        Posix.tcflush (handle, Posix.TCIOFLUSH);

        Posix.tcsetattr (handle, Posix.TCSAFLUSH, termios);

        Posix.fcntl (handle, Posix.F_SETFL, FNDELAY);
        Posix.fcntl (handle, Posix.F_SETFL, 0);

        /* Everything works fine, if I open it using tail -f /dev/ttyUSB0*/
        uint8[] data = new uint8[4];
        data[0] = 1;
        data[1] = 1;
        data[2] = 0;
        data[3] = data[0] ^ data[1] ^ data[2];

        int l = (int)Posix.write (handle, data, data.length);

        Thread.usleep (1000 * 1000);

        data[0] = make_array (2, true)[0];
        data[1] = make_array (2, true)[1];
        data[2] = make_array (2, true)[2];
        data[3] = data[0] ^ data[1] ^ data[2];

        l = (int)Posix.write (handle, data, data.length);
    }
    
