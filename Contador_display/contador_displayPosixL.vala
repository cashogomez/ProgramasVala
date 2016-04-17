using Gtk;

public static string number_display[7];
public static int counter = 0;

namespace Rasp {
	public class Handlers {
		
		[CCode (instance_pos = -1)]
		public void on_button1_clicked (Button source) {
			//Empieza a contar
			counter = 0;
			Timeout.add_seconds(1, putNumber);			
		}	
		[CCode (instance_pos = -1)]
		public void on_button2_clicked (Button source) {
			Gtk.main_quit();
		}
		
	}
}

public static bool putNumber(){
	
	if (counter == 0){
		number_display = {"1","1","1","1","1","1","0"}; //null	
	}
	else if (counter == 1){
		number_display = {"0","1","1","0","0","0","0"}; //eins
	}
	else if (counter == 2){
		number_display = {"1","1","0","1","1","0","1"}; //zwei
	}
	else if (counter == 3){
		number_display = {"1","1","1","1","0","0","1"}; //drei
	}
	else if (counter == 4){
		number_display = {"0","1","1","0","0","1","1"}; //vier
	}
	else if (counter == 5){
		number_display = {"1","0","1","1","0","1","1"}; //funf
	}
	else if (counter == 6){
		number_display = {"1","0","1","1","1","1","1"}; //sechs
	}
	else if (counter == 7){
		number_display = {"1","1","1","0","0","0","0"}; //sieben
	}
	else if (counter == 8){
		number_display = {"1","1","1","1","1","1","1"}; //acht
	}
	else{
		number_display = {"1","1","1","0","0","1","1"}; //neun
	}
	
	setPin("17",number_display[0]);
	setPin("18",number_display[1]);
	setPin("27",number_display[2]);
	setPin("22",number_display[3]);
	setPin("23",number_display[4]);
	setPin("24",number_display[5]);
	setPin("25",number_display[6]);
	
	counter++;
	if (counter == 10){
		return false;
	}
	else{
		return true;
	}
}

public void setPin(string pin, string state){
	string posixValue = "/sys/class/gpio/gpio" + pin + "/value";
	FileStream stream = FileStream.open(posixValue,"w");
	assert(stream != null);
	stream.puts(state);
	stream.flush();
}
public void initPin(string pin){
	string posixExport = "sudo echo " + pin + " >/sys/class/gpio/export";
	Posix.system(posixExport);
	
	string posixDirection = "/sys/class/gpio/gpio" + pin + "/direction";
	FileStream stream = FileStream.open(posixDirection,"w");
	assert(stream != null);
	stream.puts("out");
	stream.flush();
}

int main (string[] args) {
	
	initPin("17");
	initPin("18");
	initPin("27");
	initPin("22");
	initPin("23");
	initPin("24");
	initPin("25");
	
	Gtk.init (ref args);
	
	try {
		var builder = new Builder ();
		builder.add_from_file ("blinking_ledGUI.glade");
		var hand = new Rasp.Handlers ();
		builder.connect_signals (hand);
		var window = builder.get_object ("window1") as Window;
		window.show_all ();
		Gtk.main ();
		
	} catch (Error e) {
		stderr.printf ("Couldn't load GUI: %s\n", e.message);
		return 1;
	}
	
	return 0;
}
