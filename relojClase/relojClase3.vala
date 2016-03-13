using Gtk ;

 namespace Beagle {
  	public class Control:Object {
		
	[CCode ( instance_pos = -1) ]
  	public void on_bReset_clicked ( Button BotonReset) {
		BotonReset.label="Reseteando....";
		stdout.printf("Hola Lola \n");
	}
		
		
		static int main ( string [] args ) {
			Gtk.init ( ref args );
			try {
					var builder = new Builder () ;
					builder.add_from_file ( "relojClase.ui" );
					var window = builder.get_object ("window1") as   Window;
					
					window.destroy.connect ( Gtk.main_quit );
					

					var senales = new Beagle.Control() ;
					builder.connect_signals (senales) ; //conectar senales de los botones
					
					window.show_all();
					Gtk.main() ;					
					
				}catch ( Error e ) {
					
				}
			return 0;
		}
		
	}
}
