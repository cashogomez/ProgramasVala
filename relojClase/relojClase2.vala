using Gtk ;

namespace Beagle {
  	public class Control:Object {
		
		[CCode ( instance_pos = -1) ]
		public void on_bReset_clicked ( Button BotonReset ) {
			BotonReset.label ="Reseteando....";
				
		}
		
		
		static int main ( string [] args ) {
			Gtk.init ( ref args ) ;
			try {
					// Cargar interfase glade
					var builder = new Builder () ;
					builder.add_from_file ( "relojClase.ui" );
					
					var window = builder.get_object ("window1") as   Window ;
					window.destroy.connect ( Gtk.main_quit ) ;
					window.border_width = 20;
					window.window_position = WindowPosition.CENTER ;
					
					var senales = new Beagle.Control() ;
					builder.connect_signals (senales) ; //conectar senales de los botones
					
					window.title = "Reloj" ;
					
					window.show_all();
					Gtk.main() ;					
				
			}catch ( Error e ) {
				stderr.printf ( "No se puede cargar el archivo UI:  %s \n " , e.message ) ;
				return 1;
			}//catch error
			
			return 0;
		}
	}
}
		
