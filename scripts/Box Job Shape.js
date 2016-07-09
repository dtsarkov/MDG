shape main{
	layoutType = "border";
	noShadow = true;
	setlinestyle("dot");
	lineto(0,100);
	lineto(100,100);
	lineto(100,0);
	addsubshape ("title","N");
	
	shape title {
		layoutType = "border";
		preferredHeight = 35;
		setlinestyle("dot");
		rectangle(0,0,100,100);

		//addsubshape("type","W");
		addsubshape ("NameCompartment","CENTER");
		
		shape NameCompartment {
			editableField = "name";
			v_Align = "center";
			h_Align = "center";
			//rectangle(0,0,100,100);

			printwrapped("#Name#");
		}
		shape type {
			//preferredHeight = 30;
			v_Align = "center";
			h_Align = "center";
			preferredWidth  = 35;
			rectangle(0,0,100,100);
			print ("[BOX]");
		}
	}
	
}
/*
decoration Type {
	preferredHeight = 30;
	preferredWidth  = 30;
	orientation = "NW";
	print ("[BOX]");
}
*/
