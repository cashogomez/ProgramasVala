using Gtk;

public class SyncSample:Window{
	
	private SpinButton spin_box;
	private Scale slider;
	private Button enter;
	private double num;

	public SyncSample(){
		this.title="Suma";
		this.window_position=WindowPosition.CENTER;
		this.destroy.connect(Gtk.main_quit);
		set_default_size(500,40);

		spin_box=new SpinButton.with_range(0,100,0.5);
		slider=new Scale.with_range(Orientation.HORIZONTAL,0,100,0.5);
		enter=new Button.with_label("Sumar");
	enter.clicked.connect (()=>{
	num=spin_box.adjustment.value+slider.adjustment.value;
	enter.label="%.2f".printf(num);});
	

	spin_box.adjustment.value=50;
	slider.adjustment.value=50;
	
	var hbox=new Box (Orientation.HORIZONTAL,5);
	hbox.homogeneous=true;
	hbox.add(spin_box);
	hbox.add(slider);
	hbox.add(enter);
	add(hbox);
}

	public static int main (string[] args) {
	Gtk.init(ref args);
	
	var window=new SyncSample();
	window.show_all();

	Gtk.main();
	return 0;
	}
}
