int main (string [] args) {
	bool primo;
	int min = int.parse(args[1]);
	int max = int.parse(args[2]);
	for (int xx=min; xx<=max; xx++){
		primo =true;
		for (int xxx=2; xxx<xx; xxx++){
			if (xx%xxx==0){
				primo =false;
			}
		}
		if (primo == true) {
			stdout.printf(" %d ", xx);
		}
	}
	return 0;
}
