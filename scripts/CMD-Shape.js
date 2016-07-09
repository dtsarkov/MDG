shape main{
	//drawnativeshape();

	layoutType = "border";
	scalable = true;

	roundrect(0,0,100,100,35,35);
	addsubshape("title","N");
	
	shape title {
		preferredHeight = 35;
		layoutType = "border";
			
		//addsubshape("h_padding",0,0);
		addsubshape("type","W");
		addsubshape("nameCompartment","CENTER");
		addsubshape("h_padding", "E");

		shape type {
			preferredWidth = 35;
			h_Align = "center";
			v_Align = "center";
			//rectangle(0,0,100,100);
			//print("[CMD]");
		}
	
		shape nameCompartment {
			h_Align = "center";
			v_Align = "center";
			editableField = "name";

			//rectangle(0,0,100,100);
			setfontcolor(getUserFontColor());
			printwrapped("#Name#");
		}
		shape h_padding {
			preferredWidth = 20;
		}
	}
	
}
